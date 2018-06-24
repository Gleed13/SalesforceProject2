/**
 * Created by Danil on 08.04.2018.
 */

public with sharing class AAA {
    public static void a() {
        List<TerritoryShare__c> l = [SELECT Name, Id FROM TerritoryShare__c];
        System.debug(l.size());
        delete l;
    }

    public static void b(Id i) {
        List<Account> accountListWithTerritories = [SELECT Territory__c
        FROM Account
        WHERE Territory__c IN
        (SELECT ParentId__c
        FROM TerritoryShare__c)
        ];
        Map<Id, Account> ma = new Map<Id, Account>(accountListWithTerritories);
        System.debug(ma.get(i).Territory__c);
    }

    public static void c() {
        List<AccShare__c> l = [SELECT Name FROM AccShare__c];
        for (AccShare__c a : l) {
            System.debug(a.Name);
        }
    }

    public static void d() {
        List<ConShare__c> l = [SELECT Name FROM ConShare__c];
        for (ConShare__c c : l) {
            System.debug(c.Name);
        }
    }
}