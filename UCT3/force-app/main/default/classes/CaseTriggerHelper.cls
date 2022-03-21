/**
 *
 * @author selhamraoui
 *
 * @date 2022
 */
public class CaseTriggerHelper { 
    
    public static void validateReservationRequest(List<Case> resRequests){
        Set<Id> accounts = getAccountsIdsSet(resRequests);
        for(Case resRequest : resRequests){
            // Testing if the content of case is null or not to avoid NPE ;) 
            if(resRequest != null && resRequest.AccountId != null){
                Account account =  AccountService.getAccountById(resRequest.AccountId);
                Integer allContacts = account.Contacts.size();
                resRequest = addRequestErrors(resRequest, allContacts);
            }else{
                resRequest.addError('You cannot create a request without attaching an account');
            }
        }
    }

    public static void registerAttendees(List<Case> resRequests){
        Set<Id> accounts = new Set<Id>();
        for(Case resRequest : resRequests){
            if(resRequest.Status == EventBooking_Utils.CLOSED_CASE){
                accounts.add(resRequest.AccountId);
            }
        }
        ExternalSystemService.registerAttendees(accounts);
    }

    public static Set<Id> getAccountsIdsSet(List<Case> resRequests){
        Set<Id> accounts = new Set<Id>();
        for(Case resRequest : resRequests){
            accounts.add(resRequest.AccountId);
        }
        return accounts; 
    }

    public static Case addRequestErrors(Case cs, Integer allContacts){
        Case resRequest = cs;
        if(allContacts == 0){
            resRequest.addError('You cannot create a request for accounts without contacts');
            Log.error('You cannot create a request for accounts without contacts');
        }else{
            switch on resRequest.Origin {
                when 'Web' {
                    if(allContacts >= 2 ){
                        resRequest.addError('Web request are only allowed to have one attendee');
                        Log.error('Web request are only allowed to have one attendee');
                    }
                }
                when 'Phone'{
                    if(allContacts >= 4 ){
                        resRequest.addError('Phone request are only allowed to have three attendee');
                        Log.error('Phone request are only allowed to have three attendee');
                    }
                }
            }        
        }
        return resRequest;
    }
}