/**
 *
 * @author selhamraoui
 *
 * @date 2022
 */
// Question : How many instances of Trigger Handler are there ? every time it the trigger is executed ?
public class CaseTriggerHandler extends TriggerHandler { 
    private List<Case> oldCaseList;
    private List<Case> newCaseList;
    private Map<Id, Case> oldCaseMap;
    private Map<Id, Case> newCaseMap;
  
    /**
    * Map triggers
    */
    public CaseTriggerHandler() {
        oldCaseList = (List<Case>) Trigger.old;
        newCaseList = (List<Case>) Trigger.new;
        oldCaseMap = (Map<Id, Case>) Trigger.oldMap;
        newCaseMap = (Map<Id, Case>) Trigger.newMap;
    }

    /**
    * Handle the before insert trigger
    */
    public override void beforeInsert(){
        CaseTriggerHelper.validateReservationRequest(newCaseList);
    }

    /**
    * Handle the before inseupdatert trigger
    */
    public override void beforeUpdate(){
        CaseTriggerHelper.registerAttendees(newCaseList);    
    }
}