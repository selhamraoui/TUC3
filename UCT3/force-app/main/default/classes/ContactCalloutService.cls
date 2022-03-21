/**
 *
 * @author selhamraoui
 *
 * @date 2022
 */
public class ContactCalloutService { 
    public static HttpResponse initiateCallout(List<Contact> contacts){
        Map<String, Object> payload = getContactsPayload(contacts);
        CalloutUtils callout = new CalloutUtils();
        callout.endPoint(EventBooking_Utils.getEventBookingSettings().WS_URL__c)        	      
                .method('POST')            
                .addHeader('Content-Type', 'application/json;charset=UTF-8')
                .body(JSON.serialize(payload))    
                .timeout(10000);

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