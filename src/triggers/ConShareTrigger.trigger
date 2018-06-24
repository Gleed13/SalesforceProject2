/**
 * Created by Danil on 09.04.2018.
 */

trigger ConShareTrigger on ConShare__c (before delete, after insert) {

    ConShareTriggerHandler handler = new ConShareTriggerHandler();

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