/** 
 *
 * @author selhamraoui
 *
 * @date 2022
 */
public class CaseTriggerHelper { 
    
    /**
    * Description : Validate reservation request / case before persisting in DB
    */
    public static void validateReservationRequest(List<Case> resRequests){
        Set<Id> accountsIds = getAccountsIdsSet(resRequests);
        List<Account> accounts =  AccountService.getAccountsBySetIds(accountsIds);
        for(Case resRequest : resRequests){
            // Testing if the content of case is null or not to avoid NPE ;) 
            if(resRequest != null && resRequest.AccountId != null){
                for(Account ac : accounts){
                    Integer accountContacts = ac.Contacts.size();
                    resRequest = addRequestErrors(resRequest, accountContacts);
                }
            }else{
                resRequest.addError('You cannot create a request without attaching an account');
            }
        }
    }

    /**
    * Description : register attendees/contacts before update
    */
    public static void registerAttendees(List<Case> resRequests){
        Set<Id> accounts = new Set<Id>();
        for(Case resRequest : resRequests){
            if(resRequest.Status == EventBooking_Utils.CLOSED_CASE){
                accounts.add(resRequest.AccountId);
            }
        }
        ExternalSystemService.registerAttendees(accounts);
    }

    /**
    * Description : Get Set of accounts ids from case/resa request list
    */
    public static Set<Id> getAccountsIdsSet(List<Case> resRequests){
        Set<Id> accounts = new Set<Id>();
        for(Case resRequest : resRequests){
            if(resRequest.AccountId){
                accounts.add(resRequest.AccountId);
            }
        }
        return accounts; 
    }

    /**
    * Description : Logic to prevent user from persisting wrong cases
    */
    public static Case addRequestErrors(Case cs, Integer accountContacts){
        Case resRequest = cs;
        if(accountContacts == 0){
            resRequest.addError('You cannot create a request for accounts without contacts');
            Log.error('You cannot create a request for accounts without contacts');
        }else{
            switch on resRequest.Origin {
                when EventBooking_Utils.WEB {
                    if(accountContacts >= 2 ){
                        resRequest.addError('Web request are only allowed to have one attendee');
                        Log.error('Web request are only allowed to have one attendee');
                    }
                }
                when EventBooking_Utils.PHONE {
                    if(accountContacts >= 4 ){
                        resRequest.addError('Phone request are only allowed to have three attendee');
                        Log.error('Phone request are only allowed to have three attendee');
                    }
                }
            }        
        }
        return resRequest;
    }
}
