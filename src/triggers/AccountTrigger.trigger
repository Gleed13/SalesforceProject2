/**
 * Created by Danil on 08.04.2018.
 */

trigger AccountTrigger on Account (before update, before delete, after insert, after update) {

    AccountTriggerHandler handler = new AccountTriggerHandler();

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