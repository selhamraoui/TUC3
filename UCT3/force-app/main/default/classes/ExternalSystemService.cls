public with sharing class ExternalSystemService implements Database.AllowsCallouts{

    @future(callout=true)
    public static void registerAttendees(Set<Id> accounts){
        List<Contact> contacts = ContactService.getContactsByAccounstId(accounts);
        HttpResponse response = ContactCalloutService.initiateCallout(contacts);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
            response.getStatusCode() + ' ' + response.getStatus());
            Log.error('The status code returned was not expected: ' +
            response.getStatusCode() + ' ' + response.getStatus());
        } else {
            // Everything went as expected.
            notifyAttendeeByEmail(contacts);
        }
    } 

    public static void notifyAttendeeByEmail(List<Contact> contacts){
        insertTask(contacts[0]);
        sendEmail();
    } 

    /**
    * @return Boolean indicating sending status 
    */
    public static void sendEmail(){
        List<String> toAddress = new List<String>();
        toAddress.add(EventBooking_Utils.getEventBookingSettings().Email__c);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddress);
        mail.setSenderDisplayName('TRADE SHOW FRONTOFFICE');
        mail.setTargetObjectId(UserInfo.getUserId());
        mail.setSubject('Reservation for Trade Show 2022');
        mail.setPlainTextBody(EventBooking_Utils.getEventBookingSettings().TextBody__c);
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    public static void insertTask(Contact contact){
        Task task = new Task();
        task.Subject = 'Send Email To' + contact.name;
        task.Status = 'Open';
        task.Priority = 'Normal';
        //task.WhatId = contact.Id;
        if(Schema.sObjectType.Task.fields.Subject.isCreateable() &&
            Schema.sObjectType.Task.fields.Status.isCreateable() &&
            Schema.sObjectType.Task.fields.Priority.isCreateable() &&
            Schema.sObjectType.Task.fields.WhatId.isCreateable()){
            insert task;
        }
    }
}
