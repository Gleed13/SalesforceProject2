/**
 * Created by Danil on 08.04.2018.
 */

public with sharing class AccountTriggerHandler {

    private void insertAccSharesForEachAccount(List<Account> listWithAccounts) {
        List<AccShare__c> listToInsert = new List<AccShare__c>();
        List<Territory__c> tmp = [SELECT Id
                                  FROM Territory__c
                                  WHERE Id IN
                                      (SELECT Territory__c
                                       FROM Account
                                       WHERE Id IN :listWithAccounts)
        ];
        List<TerritoryShare__c> territoryShareList = [SELECT Id, ParentId__c, UserOrGroupId__c, AccessLevel__c
                                                      FROM TerritoryShare__c
                                                      WHERE ParentId__c IN :tmp
        ];
        for (TerritoryShare__c t : territoryShareList) {
            for(Account a : listWithAccounts) {
                if (a.Territory__c == t.ParentId__c) {
                    AccShare__c newShare = new AccShare__c();
                    newShare.Name = a.Name;
                    newShare.ParentId__c = a.Id;
                    newShare.UserOrGroupId__c = t.UserOrGroupId__c;
                    newShare.AccessLevel__c = t.AccessLevel__c;
                    newShare.TerritoryShare__c = t.Id;
                    listToInsert.add(newShare);
                }
            }
        }
        insert listToInsert;
    }

    private void deleteAccSharesForEachAccount(List<Account> listWithAccounts) {
        List<AccShare__c> listToDelete = [SELECT Id FROM AccShare__c WHERE ParentId__c IN :listWithAccounts];
        delete listToDelete;
    }

    public void onAfterInsert(List<Account> newList) {
        insertAccSharesForEachAccount(newList);
    }

    public void onAfterUpdate(List<Account> newList) {
        insertAccSharesForEachAccount(newList);
    }

    public void onBeforeUpdate(List<Account> oldList) {
        deleteAccSharesForEachAccount(oldList);
    }

    public void onBeforeDelete(List<Account> oldList) {
        deleteAccSharesForEachAccount(oldList);
    }
}