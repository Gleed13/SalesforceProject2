/**
 * Created by Danil on 09.04.2018.
 */

public with sharing class ConShareTriggerHandler {

    private void insertShares(List<ConShare__c> listWithShares) {
        List<ContactShare> listToInsert = new List<ContactShare>();
        for (ConShare__c c : listWithShares) {
            ContactShare csh = new ContactShare();
            csh.ContactId = c.ParentId__c;
            csh.UserOrGroupId = c.UserOrGroupId__c;
            csh.ContactAccessLevel = c.AccessLevel__c;
            listToInsert.add(csh);
        }
        Database.insert(listToInsert, false);
    }

    private void deleteShares(List<ConShare__c> listWithShares) {
        List<ContactShare> listToDelete = [SELECT Id
                                           FROM ContactShare
                                           WHERE ContactId IN
                                               (SELECT ParentId__c
                                                FROM ConShare__c
                                                WHERE Id IN :listWithShares)
                                                AND RowCause = 'Manual'
        ];
        delete listToDelete;
    }


    public void onAfterInsert(List<ConShare__c> newList) {
        insertShares(newList);
    }

    public void onBeforeDelete(List<ConShare__c> oldList) {
        deleteShares(oldList);
    }
}