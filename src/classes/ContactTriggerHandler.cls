/**
 * Created by Danil on 05.04.2018.
 */

public with sharing class ContactTriggerHandler {

    private void deleteConShareForEachContact(List<Contact> listWithContacts) {
        List<ConShare__c> listToDelete = [SELECT Id FROM ConShare__c WHERE ParentId__c IN :listWithContacts];
        delete listToDelete;
    }

    public void onBeforeDelete(List<Contact> oldList) {
        deleteConShareForEachContact(oldList);
    }
}