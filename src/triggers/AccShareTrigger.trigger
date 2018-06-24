/**
 * Created by Danil on 08.04.2018.
 */

trigger AccShareTrigger on AccShare__c (before delete, after insert) {

    AccShareTriggerHandler handler = new AccShareTriggerHandler();

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