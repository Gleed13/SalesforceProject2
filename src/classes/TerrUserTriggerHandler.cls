/**
 * Created by Danil on 06.04.2018.
 */

public with sharing class TerrUserTriggerHandler {


    //private methods
    private void insertTerrUserShareForEachTerrUser(List<TerrUser__c> listWithUsers) {
        List<TerrUserShare__c> listToInsert = new List<TerrUserShare__c>();
        for (TerrUser__c t : listWithUsers) {
            TerrUserShare__c newShare = new TerrUserShare__c();
            newShare.Name = t.Name;
            newShare.ParentId__c = t.Id;
            newShare.UserOrGroupId__c = t.User__c;
            newShare.AccessLevel__c = 'Read';
            listToInsert.add(newShare);
        }
        insert listToInsert;
    }

    private void deleteTerrUserShareForEachTerrUser(List<TerrUser__c> listWithUsers) {
        List<TerrUserShare__c> listToDelete = [SELECT Id FROM TerrUserShare__c WHERE ParentId__c IN :listWithUsers];
        delete listToDelete;
    }

    private List<TerrUser__c> getListWithUsers(List<TerrUser__c> listTerrUsers) {
        List<TerrUser__c> listWithUsers = new List<TerrUser__c>();
        for (TerrUser__c t : listTerrUsers) {
            if (t.User__c != null) {
                listWithUsers.add(t);
            }
        }
        return listWithUsers;
    }


    //public methods
    public void onAfterInsert(List<TerrUser__c> newList) {
        List<TerrUser__c> listWithUsers = getListWithUsers(newList);
        if (listWithUsers.size() > 0) {
            insertTerrUserShareForEachTerrUser(listWithUsers);
        }
    }

    public void onAfterUpdate(List<TerrUser__c> newList) {
        List<TerrUser__c> listWithUsers = getListWithUsers(newList);
        if (listWithUsers.size() > 0) {
            insertTerrUserShareForEachTerrUser(listWithUsers);
        }
    }

    public void onBeforeUpdate(List<TerrUser__c> oldList) {
        deleteTerrUserShareForEachTerrUser(oldList);
    }

    public void onBeforeDelete(List<TerrUser__c> oldList) {
        deleteTerrUserShareForEachTerrUser(oldList);
    }
}