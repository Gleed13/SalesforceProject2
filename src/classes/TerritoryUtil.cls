/**
 * Created by Danil on 06.04.2018.
 */

public with sharing class TerritoryUtil {
    //cities and towns (Kiyv)
    private List<Territory__c> level3TerritoriesList = [SELECT Id, Parent_territory__c, Parent_territory__r.Parent_territory__c
                                                        FROM Territory__c
                                                        WHERE Parent_territory__c != NULL
                                                        AND Parent_territory__r.Parent_territory__c != NULL];
    private Map<Id, Territory__c> level3TerritoriesMap = new Map<Id, Territory__c>(level3TerritoriesList);

    //regions (Kiyvska obl.)
    private List<Territory__c> level2TerritoriesList = [SELECT Id, Parent_territory__c
                                                        FROM Territory__c
                                                        WHERE Parent_territory__c != NULL
                                                        AND Id NOT IN :level3TerritoriesList];
    private Map<Id, Territory__c> level2TerritoriesMap = new Map<Id, Territory__c>(level2TerritoriesList);

    //countries (Ukraine)
    private List<Territory__c> level1TerritoriesList = [SELECT Id
                                                        FROM Territory__c
                                                        WHERE Id NOT IN :level3TerritoriesList
                                                        AND Id NOT IN :level2TerritoriesList];
    private Map<Id, Territory__c> level1TerritoriesMap = new Map<Id, Territory__c>(level1TerritoriesList);


    public Map<Id, Territory__c> getLvl3TerritoryMap() {
        return level3TerritoriesMap;
    }

    public Map<Id, Territory__c> getLvl2TerritoryMap() {
        return level2TerritoriesMap;
    }

    public Map<Id, Territory__c> getLvl1TerritoryMap() {
        return level1TerritoriesMap;
    }


//    private TerritoryShare__c getNewTerritoryShare(Id parentId, Id userOrGroupId, Id terrUserShare) {
//        TerritoryShare__c territoryShare = new TerritoryShare__c();
//        territoryShare.ParentId__c = parentId;
//        territoryShare.UserOrGroupId__c = userOrGroupId;
//        territoryShare.TerrUserShare__c = terrUserShare;
//        return territoryShare;
//    }

//    private AccountShare getNewAccountShare(Id parentId, Id userOrGroupId) {
//        AccountShare accountShare = new AccountShare();
//        accountShare.AccountId = parentId;
//        accountShare.UserOrGroupId = userOrGroupId;
//        accountShare.AccountAccessLevel = 'Read';
//        accountShare.OpportunityAccessLevel = 'Read';
//        return accountShare;
//    }

//    public void insertTerritoryShareForEachTerrUser(List<TerrUserShare__c> listWithShares) {
//        List<TerritoryShare__c> listToInsert = new List<TerritoryShare__c>();
//
//        Map<Id, TerrUser__c> allTerrUsers = new Map<Id, TerrUser__c>([SELECT Territory__c FROM TerrUser__c]);
//
//        for (TerrUserShare__c tus : listWithShares) {
//            TerrUser__c terrUser = allTerrUsers.get(tus.ParentId__c);
//            if (terrUser.Territory__c == null) {continue;}
//            if (level1TerritoriesMap.containsKey(terrUser.Territory__c)) {
//                for (Territory__c territory : level2TerritoriesList) {
//                    if (territory.Parent_territory__c == terrUser.Territory__c) {
//                        TerritoryShare__c ts = getNewTerritoryShare(territory.Id, terrUser.User__c, tus.Id);
//                        listToInsert.add(ts);
//                    }
//                }
//                for (Territory__c territory : level3TerritoriesList) {
//                    if (territory.Parent_territory__r.Parent_territory__c == terrUser.Territory__c) {
//                        TerritoryShare__c ts = getNewTerritoryShare(territory.Id, terrUser.User__c, tus.Id);
//                        listToInsert.add(ts);
//                    }
//                }
//            }
//            else if (level2TerritoriesMap.containsKey(terrUser.Territory__c)) {
//                for (Territory__c territory : level3TerritoriesList) {
//                    if (territory.Parent_territory__c == terrUser.Territory__c) {
//                        TerritoryShare__c ts = getNewTerritoryShare(territory.Id, terrUser.User__c, tus.Id);
//                        listToInsert.add(ts);
//                    }
//                }
//            }
//            TerritoryShare__c territoryShare = getNewTerritoryShare(terrUser.Territory__c, terrUser.User__c, tus.Id);
//            listToInsert.add(territoryShare);
//        }
//        System.debug(listToInsert.size());
//
//        insert listToInsert;
//    }

//    public void createAccountShareForEachTerrUser(List<TerrUser__c> listTerrUsers) {
//        Map<Id, Account> allAccounts = new Map<Id, Account>([SELECT Id FROM Account]);
//
//        List<AccountShare> listAccountShare = new List<AccountShare>();
//
//        for (TerrUser__c terrUser : listTerrUsers) {
//            if (level1TerritoriesMap.containsKey(terrUser.Territory__c)) {
//                for (Territory__c territory : level2TerritoriesList) {
//                    if (territory.Parent_territory__c == terrUser.Territory__c) {
//                        AccountShare ts = getNewAccountShare(allAccounts.get(territory.Id).Id, terrUser.User__c);
//                        listAccountShare.add(ts);
//                    }
//                }
//                for (Territory__c territory : level3TerritoriesList) {
//                    if (territory.Parent_territory__r.Parent_territory__c == terrUser.Territory__c) {
//                        AccountShare ts = getNewAccountShare(allAccounts.get(territory.Id).Id, terrUser.User__c);
//                        listAccountShare.add(ts);
//                    }
//                }
//            }
//            else if (level2TerritoriesMap.containsKey(terrUser.Territory__c)) {
//                for (Territory__c territory : level3TerritoriesList) {
//                    if (territory.Parent_territory__c == terrUser.Territory__c) {
//                        AccountShare ts = getNewAccountShare(allAccounts.get(territory.Id).Id, terrUser.User__c);
//                        listAccountShare.add(ts);
//                    }
//                }
//            }
//            AccountShare territoryShare = getNewAccountShare(allAccounts.get(terrUser.Territory__c).Id, terrUser.User__c);
//            listAccountShare.add(territoryShare);
//        }
//
//        System.debug(listAccountShare.size());
//    }
}