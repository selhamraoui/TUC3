/**
 *
 * @author selhamraoui
 *
 * @date 2022
 */
public class ContactCalloutService {

    public static HttpResponse initiateCallout(List<Contact> contacts){
        // TODO: 25/3/2022 Nice one
        Map<String, Object> payload = getContactsPayload(contacts);
        // TODO: 25/3/2022 Interesting UTIL class might be helpful to share it with the team
        CalloutUtils callout = new CalloutUtils();
        // TODO: 25/3/2022 I suggest using named credentials instead but still it does the job
        callout.endPoint(EventBooking_Utils.getEventBookingSettings().WS_URL__c)        	      
                .method('POST')            
                .addHeader('Content-Type', 'application/json;charset=UTF-8')
                .body(JSON.serialize(payload))
                // TODO: 25/3/2022 I LOVE THIS but refactor it into a constant (Magic number)
                .timeout(10000);
        // TODO: 25/3/2022 catch callout exception
        HttpResponse res = callout.send();
        return res;
    }

    public static Map<String, Object> getContactsPayload(List<Contact> contacts){
        Map<String, Object> result = new Map<String, Object>();
        for(Contact contact : contacts){
            result.put('name', contact.name +'-'+contact.email);
        }
        return result;
    }
}