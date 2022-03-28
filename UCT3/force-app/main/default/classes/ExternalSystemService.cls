public with sharing class ExternalSystemService implements Database.AllowsCallouts{

    /**
    * Callout to external service
    */
    @future(callout=true)
    public static void registerAttendees(Set<Id> accounts){
        // TODO: 25/3/2022 Fix typo
        List<Contact> contacts = ContactService.getContactsByAccounstId(accounts);
        HttpResponse response = ContactCalloutService.initiateCallout(contacts);
        Map<String, Object> results = new Map<String, Object>();

        if (response.getStatusCode() != 201) {
            // TODO: 25/3/2022 REMOVE System.debug from your production code
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
            Log.error('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            // Parse the JSON response // Why ?
            // TODO: 25/3/2022 Expected type Boolean; found String
            if(response.getBody()){
                results = parseJsonResponse(response);
            }
            // TODO: 25/3/2022 Call out may fail but in most cases does it make sense to send email when a record is not added in the external system
            if(!contacts.isEmpty()){
                notifyAttendeeByEmail(contacts);
            }
        }
    } 

    /**
    * json string parser into map of String, Object
    */
    public static Map<String, Object> parseJsonResponse(String json){
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(json);
        List<Object> animals = (List<Object>) results.get('animals');
        // TODO: 25/3/2022 nice addition but no need
        for (Object animal : animals) {
            System.debug(animal);
        }
        return results;
    }

    /**
    * handle attendee notification (both task/email creation)
    */
    public static void notifyAttendeeByEmail(List<Contact> contacts){
        // what comes first task or email ?
        insertTask(contacts);

        // TODO: 25/3/2022 Could be bulkified
        for(Contact contact : contacts){
            sendEmail(contact);
        }
    } 

    /**
    * Send email to every contact/attendee
    */
    public static void sendEmail(Contact attendee){
        List<String> toAddress = new List<String>();
        // set primary email address
        toAddress.add(EventBooking_Utils.getEventBookingSettings().Email__c);
        if(attendee.Email && ''!= attendee.Email){
            toAddress.add(attendee.Email);
        }
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddress);
            mail.setSenderDisplayName('TRADE SHOW FRONTOFFICE');
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setSubject('Reservation for Trade Show 2022 _ '+ attendee.Name);
            mail.setPlainTextBody(EventBooking_Utils.getEventBookingSettings().TextBody__c);
            mail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            Log.error('The following exception has occurred: ' + e.getMessage());
        }
    }

    /**
    * insert task for every contact/attendee
    */
    public static void insertTask(List<Contact> contacts){
        List<Task> tasksQueue = new List<Task>(); 
        for(Contact contact : contacts){
            Task task = new Task();
            task.Subject = 'Send Email To' + contact.name;
            task.Status = 'Open';
            task.Priority = 'Normal';
            // this field is a problem, please advise on why it is a problem
            // TODO: 25/3/2022 answer :  whatId is a polymorphic ID field which accepts a couple of references in this case (Contact, Account ...)
            //task.WhatId = contact.Id; 
            tasksQueue.add(task);
        }
        
        if(Schema.sObjectType.Task.fields.Subject.isCreateable() &&
            Schema.sObjectType.Task.fields.Status.isCreateable() &&
            Schema.sObjectType.Task.fields.Priority.isCreateable() &&
            Schema.sObjectType.Task.fields.WhatId.isCreateable()){
                try {
                    insert tasksQueue;
                } catch(DmlException e) {
                        System.debug('The following exception has occurred: ' + e.getMessage());
                        Log.error('The following exception has occurred: ' + e.getMessage());
                    }
        }
    }
}
