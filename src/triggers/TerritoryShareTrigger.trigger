/**
 * Created by Danil on 07.04.2018.
 */

trigger TerritoryShareTrigger on TerritoryShare__c (after insert, after update, before delete) {

    TerritoryShareTriggerHandler handler = new TerritoryShareTriggerHandler();

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handler.onAfterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            handler.onAfterUpdate(Trigger.new);
        }
    }
    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            handler.onBeforeDelete(Trigger.old);
        }
    }
}