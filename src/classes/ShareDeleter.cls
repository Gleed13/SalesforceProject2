/**
 * Created by Danil on 08.04.2018.
 */

public with sharing class ShareDeleter {

    private void deleteTerritoryShares(List<TerritoryShare__c> territoryShares) {
        Set<Id> sParentId = new Set<Id>();
        Set<Id> sUserOrGroup = new Set<Id>();
        for (TerritoryShare__c t : territoryShares) {
            sParentId.add(t.ParentId__c);
            sUserOrGroup.add(t.UserOrGroupId__c);
        }
        delete [SELECT Id FROM Territory__Share
                WHERE ParentId IN :sParentId
                AND UserOrGroupId IN :sUserOrGroup
                AND RowCause='Manual'];
    }

    private void deleteAccShares(List<AccShare__c> accShares) {
        Set<Id> sParentId = new Set<Id>();
        Set<Id> sUserOrGroup = new Set<Id>();
        for (AccShare__c t : accShares) {
            sParentId.add(t.ParentId__c);
            sUserOrGroup.add(t.UserOrGroupId__c);
        }
        delete [SELECT Id FROM AccountShare
                WHERE AccountId IN :sParentId
                AND UserOrGroupId IN :sUserOrGroup
                AND RowCause='Manual'];
    }

    private void deleteConShares(List<ConShare__c> conShares) {
        Set<Id> sParentId = new Set<Id>();
        Set<Id> sUserOrGroup = new Set<Id>();
        for (ConShare__c t : conShares) {
            sParentId.add(t.ParentId__c);
            sUserOrGroup.add(t.UserOrGroupId__c);
        }
        delete [SELECT Id FROM ContactShare
                WHERE ContactId IN :sParentId
                AND UserOrGroupId IN :sUserOrGroup
                AND RowCause='Manual'];
    }

    public void deleteAllChildShares(List<TerrUserShare__c> terrUserShares) {
        List<TerritoryShare__c> listTerritoryShares = [SELECT Id, ParentId__c, UserOrGroupId__c
                                                       FROM TerritoryShare__c
                                                       WHERE TerrUserShare__c IN : terrUserShares];
        if (listTerritoryShares.size() > 0) {
            deleteTerritoryShares(listTerritoryShares);
            deleteAllChildShares(listTerritoryShares);
        }
    }

    public void deleteAllChildShares(List<TerritoryShare__c> territoryShares) {
        List<AccShare__c> listAccShares = [SELECT Id, ParentId__c, UserOrGroupId__c
                                           FROM AccShare__c
                                           WHERE TerritoryShare__c IN : territoryShares];
        if (listAccShares.size() > 0) {
            deleteAccShares(listAccShares);
            deleteAllChildShares(listAccShares);
        }
    }

    public void deleteAllChildShares(List<AccShare__c> accShares) {
        List<ConShare__c> listConShares = [SELECT Id, ParentId__c, UserOrGroupId__c
                                           FROM ConShare__c
                                           WHERE AccShare__c IN : accShares];
        if (listConShares.size() > 0) {
            deleteConShares(listConShares);
        }
    }
}