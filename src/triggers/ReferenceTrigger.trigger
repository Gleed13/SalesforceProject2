/**
 * Created by Danil on 06.04.2018.
 */

trigger ReferenceTrigger on Reference__c (after insert, after update, before update, before delete) {

    ReferenceTriggerHandler handler = new ReferenceTriggerHandler();

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