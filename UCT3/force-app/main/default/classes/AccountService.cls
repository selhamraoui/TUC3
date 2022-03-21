/**
 *
 * @author selhamraoui
 *
 * @date 2022
 */
public with sharing class AccountService {
    
    public static Account getAccountById(Id accId){
        return [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id = :accId LIMIT 1];
    }

    public static List<Account> getAccountsById(Id accId){
        return [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id = :accId];
    }
}