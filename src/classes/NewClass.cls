/**
 * Created by Danil on 05.04.2018.
 */

public with sharing class NewClass {

    public static void newShare1() {
        AccountShare a = new AccountShare();
        a.AccountId = [SELECT Id FROM Account WHERE Name='Apple Kiyv'].Id;
        a.UserOrGroupId = [SELECT Id FROM User WHERE Name='test'].Id;
        a.AccountAccessLevel = 'Read';
        a.OpportunityAccessLevel = 'Read';
        insert a;
    }

    public static void newShare2() {
        ContactShare c = new ContactShare();
        c.ContactId = [SELECT Id FROM Contact WHERE Name='Contact2 Apple'].Id;
        c.UserOrGroupId = [SELECT Id FROM User WHERE Name='test'].Id;
        c.ContactAccessLevel = 'Read';
        insert c;
    }

    public static void newShare3() {
        Territory__Share t = new Territory__Share();
        t.ParentId = [SELECT Id FROM Territory__c WHERE Name='Zaporizhzhya'].Id;
        t.UserOrGroupId = [SELECT Id FROM User WHERE Name='test'].Id;
        t.AccessLevel = 'Read';
        insert t;
    }

    public static void newShare4() {
        TerrUser__Share t = new TerrUser__Share();
        t.ParentId = [SELECT Id FROM TerrUser__c WHERE Name='Zap test'].Id;
        t.UserOrGroupId = [SELECT Id FROM User WHERE Name='test'].Id;
        t.AccessLevel = 'Read';
        insert t;
    }

    public static void shareObjectCountLvl3() {
        TerritoryUtil util = new TerritoryUtil();
        List<TerritoryShare__c> l = [SELECT Id, Name FROM TerritoryShare__c WHERE ParentId__c IN
                :util.getLvl3TerritoryMap().values()];
        System.debug(l.size());
        for (TerritoryShare__c t : l) {
            System.debug(t.Name);
        }
    }

    public static void shareObjectCountLvl2() {
        TerritoryUtil util = new TerritoryUtil();
        List<TerritoryShare__c> l = [SELECT Id, Name FROM TerritoryShare__c WHERE ParentId__c IN
                :util.getLvl2TerritoryMap().values()];
        System.debug(l.size());
        for (TerritoryShare__c t : l) {
            System.debug(t.Name);
        }
    }

    public static void shareObjectCountLvl1() {
        TerritoryUtil util = new TerritoryUtil();
        List<TerritoryShare__c> l = [SELECT Id, Name FROM TerritoryShare__c WHERE ParentId__c IN
                :util.getLvl1TerritoryMap().values()];
        System.debug(l.size());
        for (TerritoryShare__c t : l) {
            System.debug(t.Name);
        }
    }

    public static void deleteShareObjectCountLvl1() {
        TerritoryUtil util = new TerritoryUtil();
        List<TerritoryShare__c> l = [SELECT Id, Name FROM TerritoryShare__c WHERE ParentId__c IN
                :util.getLvl1TerritoryMap().values()];
        System.debug(l.size());
        delete l;
    }

    public static void deleteShareObjectCountLvl2() {
        TerritoryUtil util = new TerritoryUtil();
        List<TerritoryShare__c> l = [SELECT Id, Name FROM TerritoryShare__c WHERE ParentId__c IN
                :util.getLvl2TerritoryMap().values()];
        System.debug(l.size());
        delete l;
    }

    public static void deleteShareObjectCountLvl3() {
        TerritoryUtil util = new TerritoryUtil();
        List<TerritoryShare__c> l = [SELECT Id, Name FROM TerritoryShare__c WHERE ParentId__c IN
                :util.getLvl3TerritoryMap().values()];
        System.debug(l.size());
        delete l;
    }

    public static void shareCount1() {
        List<AccountShare> l = [SELECT Id, RowCause, LastModifiedDate FROM AccountShare];
        System.debug(l.size());
        for (AccountShare a : l) {
            System.debug(a.RowCause + ' ' + a.LastModifiedDate);
        }
    }

    public static void shareCount2() {
        List<ContactShare> l = [SELECT Id, RowCause, LastModifiedDate FROM ContactShare];
        System.debug(l.size());
        for (ContactShare c : l) {
            System.debug(c.RowCause + ' ' + c.LastModifiedDate);
        }
    }

    public static void shareCount3() {
        List<Territory__Share> l = [SELECT Id, RowCause, LastModifiedDate FROM Territory__Share];
        System.debug(l.size());
        for (Territory__Share t : l) {
            System.debug(t.RowCause + ' ' + t.LastModifiedDate);
        }
    }

    public static void shareCount4() {
        List<TerrUser__Share> l = [SELECT Id, RowCause, LastModifiedDate FROM TerrUser__Share];
        System.debug(l.size());
        for (TerrUser__Share t : l) {
            System.debug(t.RowCause + ' ' + t.LastModifiedDate);
        }
    }

    public static void deleteShared1() {
        List<AccountShare> l = [SELECT Id FROM AccountShare WHERE RowCause='Manual'];
        System.debug(l.size());
        delete l;
    }

    public static void deleteShared2() {
        List<ContactShare> l = [SELECT Id FROM ContactShare WHERE RowCause='Manual'];
        System.debug(l.size());
        delete l;
    }

    public static void deleteShared3() {
        List<Territory__Share> l = [SELECT Id FROM Territory__Share WHERE RowCause='Manual'];
        System.debug(l.size());
        delete l;
    }

    public static void deleteShared4() {
        List<TerrUser__Share> l = [SELECT Id FROM TerrUser__Share WHERE RowCause='Manual'];
        System.debug(l.size());
        delete l;
    }

    public static void territory() {
        List<Territory__c> l3 = [SELECT Id, Parent_territory__c, Parent_territory__r.Parent_territory__c
                                 FROM Territory__c
                                 WHERE Parent_territory__c != NULL
                                 AND Parent_territory__r.Parent_territory__c != NULL];
        List<Territory__c> l2 = [SELECT Id, Parent_territory__c
                                 FROM Territory__c
                                 WHERE Parent_territory__c != NULL
                                 AND Id NOT IN :l3];
        List<Territory__c> l1 = [SELECT Id
                                 FROM Territory__c
                                 WHERE Id NOT IN :l3
                                 AND Id NOT IN :l2];
        System.debug(l3.size());
        System.debug(l2.size());
        System.debug(l1.size());
    }
}