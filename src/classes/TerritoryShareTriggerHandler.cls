/**
 * Created by Danil on 07.04.2018.
 */

public with sharing class TerritoryShareTriggerHandler {

    private void insertShares(List<TerritoryShare__c> listWithShares) {
        List<Territory__Share> listToInsert = new List<Territory__Share>();
        for (TerritoryShare__c t : listWithShares) {
            Territory__Share ts = new Territory__Share();
            ts.ParentId = t.ParentId__c;
            ts.UserOrGroupId = t.UserOrGroupId__c;
            ts.AccessLevel = t.AccessLevel__c;
            listToInsert.add(ts);
        }
        Database.insert(listToInsert, false);
    }

    private void deleteShares(List<TerritoryShare__c> listWithShares) {
        List<Territory__Share> listToDelete = [SELECT Id
                                               FROM Territory__Share
                                               WHERE ParentId IN
                                                   (SELECT ParentId__c
                                                    FROM TerritoryShare__c
                                                    WHERE Id IN :listWithShares)
                                               AND RowCause = 'Manual'
        ];
        delete listToDelete;
    }

    private void insertChildShares(List<TerritoryShare__c> listWithShares) {
        List<TerritoryShare__c> toInsertList = new List<TerritoryShare__c>();

        TerritoryUtil util = new TerritoryUtil();
        Map<Id, Territory__c> countries = util.getLvl1TerritoryMap();
        Map<Id, Territory__c> regions = util.getLvl2TerritoryMap();
        Map<Id, Territory__c> cities = util.getLvl3TerritoryMap();
        for (TerritoryShare__c ts : listWithShares) {
            if (countries.containsKey(ts.ParentId__c)) {
                for (Territory__c territory : regions.values()) {
                    if (territory.Parent_territory__c == ts.ParentId__c) {
                        TerritoryShare__c newShare = new TerritoryShare__c();
                        newShare.ParentId__c = territory.Id;
                        newShare.UserOrGroupId__c = ts.UserOrGroupId__c;
                        newShare.TerrUserShare__c = ts.TerrUserShare__c;
                        newShare.AccessLevel__c = ts.AccessLevel__c;
                        newShare.TerritoryShare__c = ts.Id;
                        toInsertList.add(newShare);
                    }
                }
            } else
            if (regions.containsKey(ts.ParentId__c)) {
                for (Territory__c territory : cities.values()) {
                    if (territory.Parent_territory__c == ts.ParentId__c) {
                        TerritoryShare__c newShare = new TerritoryShare__c();
                        newShare.ParentId__c = territory.Id;
                        newShare.UserOrGroupId__c = ts.UserOrGroupId__c;
                        newShare.TerrUserShare__c = ts.TerrUserShare__c;
                        newShare.AccessLevel__c = ts.AccessLevel__c;
                        newShare.TerritoryShare__c = ts.Id;
                        toInsertList.add(newShare);
                    }
                }
            }
        }

        if (toInsertList.size() > 0) {
            insert toInsertList;
        }
    }

    private void deleteChildShares(List<TerritoryShare__c> listWithShares) {
        List<TerritoryShare__c> grandChildren = [SELECT Id
                                                 FROM TerritoryShare__c
                                                 WHERE TerritoryShare__r.TerritoryShare__c
                                                 IN :listWithShares
        ];
        delete grandChildren;
        List<TerritoryShare__c> children = [SELECT Id
                                            FROM TerritoryShare__c
                                            WHERE TerritoryShare__c
                                            IN :listWithShares
        ];
        delete children;
    }

    private void insertAccShares(List<TerritoryShare__c> listWithShares) {
        List<AccShare__c> listToInsert = new List<AccShare__c>();
        List<Account> accountListWithTerritories = [SELECT Id, Name, Territory__c
                                                    FROM Account
                                                    WHERE Territory__c IN
                                                           (SELECT ParentId__c
                                                            FROM TerritoryShare__c
                                                            WHERE Id IN :listWithShares)
        ];
        for (TerritoryShare__c t : listWithShares) {
            for(Account a : accountListWithTerritories) {
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

    public void onAfterInsert(List<TerritoryShare__c> newList) {
        insertShares(newList);
        insertAccShares(newList);
        insertChildShares(newList);
    }

    public void onAfterUpdate(List<TerritoryShare__c> newList) {
        insertChildShares(newList);
    }

    public void onBeforeDelete(List<TerritoryShare__c> oldList) {
        deleteShares(oldList);
        deleteChildShares(oldList);
        ShareDeleter sd = new ShareDeleter();
        sd.deleteAllChildShares(oldList);
    }
}