/**
 * Created by Danil on 07.04.2018.
 */

public with sharing class TerritoryTriggerHandler {


    private void updateTerritoryShareForEachTerritory(List<Territory__c> listWithTerritories) {
        List<TerritoryShare__c> listToUpdate = [SELECT Id FROM TerritoryShare__c
                                                WHERE ParentId__c IN
                                                    (SELECT Parent_territory__c
                                                     FROM Territory__c
                                                     WHERE Id IN :listWithTerritories)
        ];
        update listToUpdate;
    }

    private void deleteTerritoryShareForEachTerritory(List<Territory__c> listWithTerritories) {
        List<TerritoryShare__c> listToDelete = [SELECT Id FROM TerritoryShare__c
                                                WHERE ParentId__c IN :listWithTerritories
        ];
        delete listToDelete;
    }


    public void onAfterInsert(List<Territory__c> newList) {
        updateTerritoryShareForEachTerritory(newList);
    }

    public void onAfterUpdate(List<Territory__c> newList) {
        updateTerritoryShareForEachTerritory(newList);
    }

    public void onBeforeUpdate(List<Territory__c> oldList) {
        deleteTerritoryShareForEachTerritory(oldList);
    }

    public void onBeforeDelete(List<Territory__c> oldList) {
        deleteTerritoryShareForEachTerritory(oldList);
    }
}