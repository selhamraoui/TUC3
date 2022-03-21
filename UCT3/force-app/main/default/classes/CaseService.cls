/**
 *
 * @author selhamraoui
 *
 * @date 2022
 */
public with sharing class CaseService {
    public static Case getCaseById(Id caseId){
        return [SELECT AccountId, Status FROM Case WHERE Id = :caseId LIMIT 1];
    }

    public static List<Case> getCasesById(Id caseId){
        return [SELECT AccountId, Status FROM Case WHERE Id = :caseId];    
    }
}