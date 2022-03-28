/**
 *
 * @author selhamraoui
 *
 * @date 2022
 */
public with sharing class AccountService {
    // TODO: 25/3/2022 Remove useless methods
    public static Account getAccountById(Id accId){
        return [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id = :accId LIMIT 1];
    }

    // TODO: 25/3/2022 Remove useless methods
    public static List<Account> getAccountsById(Id accId){
        return [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id = :accId];
    }

    public static List<Account> getAccountsBySetIds(Set<Id> accIds){
        return [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id = :accIds WITH SECURITY_ENFORCED];
    }
}