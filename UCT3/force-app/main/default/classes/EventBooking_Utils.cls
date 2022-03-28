/**
 * Utility methods for EventBooking Project
 *
 * @author selhamraoui
 *
 * @date 2022
 */
public with sharing class EventBooking_Utils {

    public static String CLOSED_CASE = 'Closed';
    public static String WEB = 'Web';
    public static String PHONE = 'Phone';

    // TODO: 25/3/2022 I suggest creating Util / helper classes as follow
    private EventBooking_Utils() {
        throw new UnsupportedOperationException('You are not allowed to instantiate Util classes');
    }

    /**
     * Method used to get event booking project settings
     * @param	label
     * @return	Event_Booking__mdt
     */
    // TODO: 25/3/2022 SEPARATE THE CONSTANT CLASSES FROM UTIL CLASSES
    public static Event_Booking__mdt getEventBookingSettings() {
        Event_Booking__mdt eventBookingSettings = [SELECT Id, MasterLabel, DeveloperName, WS_URL__c, Email__c, TextBody__c
                                                   FROM Event_Booking__mdt
                                                   WHERE MasterLabel = 'TRADE SHOW BOOKINGS'];
        return eventBookingSettings;
    }
}