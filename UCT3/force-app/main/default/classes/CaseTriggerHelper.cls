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
        // TODO: 25/3/2022 We could probably use a meaningful name instead of resRequests
        Set<Id> accountsIds = getAccountsIdsSet(resRequests);
        // TODO : I like the service layer approach :D
        List<Account> accounts =  AccountService.getAccountsBySetIds(accountsIds);
        for(Case resRequest : resRequests){
            // TODO: 25/3/2022 Remove useless comments from the code like the one bellow
            // Testing if the content of case is null or not to avoid NPE ;)
            // TODO: 25/3/2022 resRequest Can never be null
            if(resRequest != null && resRequest.AccountId != null){
                // TODO: 25/3/2022 The bellow loop does not the job
                for(Account ac : accounts){
                    // TODO: 25/3/2022 Query Exception > 200 records
                    List<Contact> contacts = ac.Contacts;
                    Integer accountContacts = contacts.size();
                    resRequest = addRequestErrors(resRequest, accountContacts);
                }
            }else{
                // TODO: 25/3/2022 Could better if you refactor you messages as custom labels
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
            // TODO: 25/3/2022 This will fail => Expected type Boolean; found Id
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
        // TODO: 25/3/2022 why would you do this
        Case resRequest = cs;
        if(accountContacts == 0){
            resRequest.addError('You cannot create a request for accounts without contacts');
            Log.error('You cannot create a request for accounts without contacts');
        }else{
            // TODO: 25/3/2022 Switch statements should always end with when else
            switch on resRequest.Origin {
                // TODO: 25/3/2022 I love the fact that you have grouped all your picklist values in constants
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
        // TODO: 25/3/2022 this method does not require a return type void should be sufficient
        return resRequest;
    }
}
