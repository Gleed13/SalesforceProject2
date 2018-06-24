/**
 * Created by Danil on 07.04.2018.
 */

trigger TerrUserShareTrigger on TerrUserShare__c (after insert, before delete) {

    TerrUserShareTriggerHandler handler = new TerrUserShareTriggerHandler();

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handler.onAfterInsert(Trigger.new);
        }
    }
    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            handler.onBeforeDelete(Trigger.old);
        }
    }
}