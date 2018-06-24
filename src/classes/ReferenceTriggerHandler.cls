/**
 * Created by Danil on 06.04.2018.
 */

public with sharing class ReferenceTriggerHandler {

    private void addAllContactsAccountToContactsWithReference(List<Reference__c> newList) {
        List<Contact> contactListToUpdate = [SELECT AccountId
                                             FROM Contact
                                             WHERE Id IN
                                                 (SELECT Contact__c
                                                  FROM Reference__c
                                                  WHERE Id IN :newList)
        ];
        System.debug('ReferenceTriggerHandler contactListToUpdate.size()' + contactListToUpdate.size());

        if (contactListToUpdate.size() > 0) {
            Account allContactsAccount = [SELECT Id
                                          FROM Account
                                          WHERE Name='All contacts'
                                          OR Project2_special_checkbox__c=true
            ];
            System.debug('ReferenceTriggerHandler Account allContactsAccount not null ' + allContactsAccount != null);

            for (Contact c : contactListToUpdate) {
                if (c.AccountId == null) {
                    try {
                        c.AccountId = allContactsAccount.Id;
                    } catch (DmlException e) {
                        c.addError(e);
                    }
                }
            }

            update contactListToUpdate;
        }

    }

    private void insertConShareForEachReference(List<Reference__c> listWithReferences) {
        List<ConShare__c> listToInsert = new List<ConShare__c>();
        List<Account> tmp = [SELECT Id
                             FROM Account
                             WHERE Id IN
                                 (SELECT Account__c
                                  FROM Reference__c
                                  WHERE Id IN :listWithReferences)
        ];
        List<AccShare__c> accShareList = [SELECT Id, ParentId__c, UserOrGroupId__c, AccessLevel__c FROM AccShare__c WHERE ParentId__c IN :tmp];
        for (Reference__c r : listWithReferences) {
            if (r.Contact__c == null) {continue;}
            for (AccShare__c a : accShareList) {
                if (r.Account__c == a.ParentId__c) {
                    ConShare__c newShare = new ConShare__c();
                    newShare.Name = r.Contact__r.Name;
                    newShare.ParentId__c = r.Contact__c;
                    newShare.UserOrGroupId__c = a.UserOrGroupId__c;
                    newShare.AccessLevel__c = a.AccessLevel__c;
                    newShare.AccShare__c = a.Id;
                    listToInsert.add(newShare);
                }
            }
        }
        insert listToInsert;
    }

    private void deleteConShareForEachReference(List<Reference__c> listWithReferences) {
        List<ConShare__c> listToDelete = [SELECT Id
                                          FROM ConShare__c
                                          WHERE ParentId__c IN
                                              (SELECT Contact__c
                                               FROM Reference__c
                                               WHERE Id IN :listWithReferences)
        ];
        delete listToDelete;
    }

    public void onAfterInsert(List<Reference__c> newList) {
        addAllContactsAccountToContactsWithReference(newList);
        insertConShareForEachReference(newList);
    }

    public void onAfterUpdate(List<Reference__c> newList) {
        addAllContactsAccountToContactsWithReference(newList);
        insertConShareForEachReference(newList);
    }

    public void onBeforeUpdate(List<Reference__c> oldList) {
        deleteConShareForEachReference(oldList);
    }

    public void onBeforeDelete(List<Reference__c> oldList) {
        deleteConShareForEachReference(oldList);
    }
}