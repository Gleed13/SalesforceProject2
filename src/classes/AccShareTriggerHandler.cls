/**
 * Created by Danil on 08.04.2018.
 */


public with sharing class AccShareTriggerHandler {

    private void insertShares(List<AccShare__c> listWithShares) {
        List<AccountShare> listToInsert = new List<AccountShare>();
        for (AccShare__c a : listWithShares) {
            AccountShare ash = new AccountShare();
            ash.AccountId = a.ParentId__c;
            ash.UserOrGroupId = a.UserOrGroupId__c;
            ash.AccountAccessLevel = a.AccessLevel__c;
            ash.OpportunityAccessLevel = a.AccessLevel__c;
            listToInsert.add(ash);
        }
        Database.insert(listToInsert, false);
    }

    private void deleteShares(List<AccShare__c> listWithShares) {
        List<AccountShare> listToDelete = [SELECT Id
                                           FROM AccountShare
                                           WHERE AccountId IN
                                               (SELECT ParentId__c
                                                FROM AccShare__c
                                                WHERE Id IN :listWithShares)
                                           AND RowCause = 'Manual'
        ];
        delete listToDelete;
    }

    private void insertContactShares(List<AccShare__c> listWithShares) {
        List<ConShare__c> listToInsert = new List<ConShare__c>();
        List<Reference__c> references = [SELECT Account__c, Contact__c, Contact__r.Name
                                         FROM Reference__c
                                         WHERE Account__c IN
                                             (SELECT ParentId__c
                                              FROM AccShare__c
                                              WHERE Id IN :listWithShares)
        ];
        for (AccShare__c a : listWithShares) {
            for (Reference__c r : references) {
                if (r.Contact__c == null) {continue;}
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

    public void onAfterInsert(List<AccShare__c> newList) {
        insertShares(newList);
        insertContactShares(newList);
    }

    public void onBeforeDelete(List<AccShare__c> oldList) {
        deleteShares(oldList);
        ShareDeleter sd = new ShareDeleter();
        sd.deleteAllChildShares(oldList);
    }
}