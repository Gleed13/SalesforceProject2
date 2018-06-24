/**
 * Created by Danil on 07.04.2018.
 */

public with sharing class TerrUserShareTriggerHandler {

    private void insertShares(List<TerrUserShare__c> listWithShares) {
        List<TerrUser__Share> listToInsert = new List<TerrUser__Share>();
        for (TerrUserShare__c t : listWithShares) {
            TerrUser__Share tus = new TerrUser__Share();
            tus.ParentId = t.ParentId__c;
            tus.UserOrGroupId = t.UserOrGroupId__c;
            tus.AccessLevel = t.AccessLevel__c;
            listToInsert.add(tus);
        }
        Database.insert(listToInsert, false);
    }

    private void deleteShares(List<TerrUserShare__c> listWithShares) {
        List<TerrUser__Share> listToDelete = [SELECT Id
                                              FROM TerrUser__Share
                                              WHERE ParentId IN
                                                  (SELECT ParentId__c
                                                   FROM TerrUserShare__c
                                                   WHERE Id IN :listWithShares)
                                              AND RowCause = 'Manual'
        ];
        delete listToDelete;
    }

    private void insertTerritoryShares(List<TerrUserShare__c> listWithShares) {
        List<TerritoryShare__c> listToInsert = new List<TerritoryShare__c>();
        Map<Id, TerrUser__c> terrUserMap = new Map<Id, TerrUser__c>([SELECT Territory__c, Territory__r.Name FROM TerrUser__c]);
        for (TerrUserShare__c t : listWithShares) {
            TerrUser__c terrUser = terrUserMap.get(t.ParentId__c);
            if (terrUser.Territory__c == null) {continue;}
            TerritoryShare__c ts = new TerritoryShare__c();
            ts.Name = terrUser.Territory__r.Name;
            ts.ParentId__c = terrUser.Territory__c;
            ts.UserOrGroupId__c = t.UserOrGroupId__c;
            ts.TerrUserShare__c = t.Id;
            ts.AccessLevel__c = t.AccessLevel__c;
            listToInsert.add(ts);
        }
        insert listToInsert;
    }

    public void onAfterInsert(List<TerrUserShare__c> newList) {
        insertShares(newList);
        insertTerritoryShares(newList);
    }

    public void onBeforeDelete(List<TerrUserShare__c> oldList) {
        deleteShares(oldList);
        ShareDeleter sd = new ShareDeleter();
        sd.deleteAllChildShares(oldList);
    }
}