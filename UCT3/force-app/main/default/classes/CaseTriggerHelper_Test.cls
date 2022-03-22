@isTest
public class CaseTriggerHelper_Test { 
    @TestSetup
    static void makeData(){
        Account company = (Account) TestDataFactory
                                        .createSObject('Account', 
                                            new Map<String,Object>{'Name' => 'ACCOUNT1', 
                                                                    'Phone' => '00212669461496'}, true);
        Contact attendee = (Contact) TestDataFactory
                                        .createSObject('Contact', 
                                            new Map<String,Object>{'Name' => 'CONTACT1', 
                                                                    'Phone' => '00212669461496',
                                                                    'Email' => 'selhamraoui@salesforce.com',
                                                                    'AccountId' => company.Id}, true);

        Case resaRequest = (Case) TestDataFactory
                                        .createSObject('Case', 
                                            new Map<String,Object>{'Subject' => 'RESA1',
                                                                    'Status' => 'New',
                                                                    'Origin' => 'Phone',
                                                                    'AccountId' => company.Id}, true); 
    }  

    @isTest
    public static void createRequestWithoutAccount(){
        // GIVEN
        Case resaRequestWithoutAccount = (Case) TestDataFactory
                                                .createSObject('Case', 
                                                    new Map<String,Object>{'Subject' => 'RESA0',
                                                                            'Status' => 'New',
                                                                            'AccountId' => null,
                                                                            'Origin' => 'Phone'}, false);
        // WHEN
        Test.startTest();
        Database.SaveResult res = Database.insert(resaRequestWithoutAccount, false);
        Test.stopTest();

        // THEN
        System.assert(!res.isSuccess(), true);
        System.assert(res.getErrors().size() > 0, true);
        System.assertEquals('You cannot create a request without attaching an account', res.getErrors()[0].getMessage(), true);
    }
}