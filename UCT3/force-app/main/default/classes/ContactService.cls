/**
 *
 * @author selhamraoui
 *
 * @date 2022
 */
public with sharing class ContactService {
    public static List<Contact> getContactsByAccounstId(Set<Id> accountIds){
        return [SELECT Id, Name, Email FROM Contact WHERE accountid IN :accountIds];
    }
}