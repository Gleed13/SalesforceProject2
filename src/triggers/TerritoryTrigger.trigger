/**
 * Created by Danil on 07.04.2018.
 */

trigger TerritoryTrigger on Territory__c (after insert, after update, before update, before delete) {

    TerritoryTriggerHandler handler = new TerritoryTriggerHandler();

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handler.onAfterInsert(Trigger.new);
        }

        if (Trigger.isUpdate) {
            handler.onAfterUpdate(Trigger.new);
        }
    }
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            handler.onBeforeUpdate(Trigger.old);
        }

        if (Trigger.isDelete) {
            handler.onBeforeDelete(Trigger.old);
        }
    }
}