public with sharing class PDFController {
    @AuraEnabled(cacheable=true)
    public static String generatePDFData(Id opportunityId, List<String> selectedEmployees) {
        try {
            // Fetch Opportunity and related Account details
            Opportunity opp = [SELECT Id, Name, AccountId, CloseDate, Account.Name FROM Opportunity WHERE Id = :opportunityId];
            
            // Fetch selected Employees' details
            List<Employe__c> selectedEmps = [SELECT Id, Name FROM Employe__c WHERE Id IN :selectedEmployees];
            
            // Generate PDF content
            String pdfContent = 'Opportunity Name: ' + opp.Name + '\n';
            pdfContent += 'Account Name: ' + opp.Account.Name + '\n';
            pdfContent += 'Close Date: ' + opp.CloseDate + '\n';
            pdfContent += 'Selected Employees:\n';
            for(Employe__c emp : selectedEmps) {
                pdfContent += ' - ' + emp.Name + '\n';
                // Add other employee fields as needed
            }
            
            // Store PDF content as file or any other storage mechanism (e.g., ContentVersion, Attachment)
            // For simplicity, let's just return the PDF content as a string here
            return pdfContent;
        } catch(Exception e) {
            // Handle exceptions
            system.debug('Error: ' + e.getMessage());
            return null;
        }
    }
}
