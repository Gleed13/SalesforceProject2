/**
 * Created by Danil on 05.04.2018.
 */

trigger ContactTrigger on Contact (before delete) {

    ContactTriggerHandler handler = new ContactTriggerHandler();

    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            handler.onBeforeDelete(Trigger.old);
        }
    }
}