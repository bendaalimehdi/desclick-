public class Combobox {
   
    @AuraEnabled(cacheable=true)
    public static List<Contact> getEmployeeNames(String opportunityId){
        List<Contact> contacts = new List<Contact>();
        // Ensure opportunityId is not null before proceeding
        if (opportunityId != null) {
            // Retrieve the employee names related to the given opportunity

            Set<Id> accountIds = new Set<Id>();
            for(Opportunity opp : [SELECT AccountId FROM Opportunity WHERE Id = :opportunityId]){
                accountIds.add(opp.AccountId);
            }
            if (!accountIds.isEmpty()) {
                contacts = [SELECT Id, Name FROM Contact WHERE AccountId IN :accountIds];
            }
        }
        
        return contacts;
    }

    @AuraEnabled
    public static string generatePdf(List<String> employeeList, String recordId){
        System.debug('employeeList : ' + employeeList);
        Pagereference pdfPage = Page.convention;
        Attachment objAttachment = new Attachment();
        
        try {
            pdfPage.getParameters().put('selectedEmployees', generateEmployeeList(employeeList));

            Opportunity myOpportunity = [SELECT Id FROM Opportunity WHERE Id = :recordId LIMIT 1];
            ContentVersion contentVersionPDFToInsert = new ContentVersion(
                Title='Convention',
                PathOnClient ='Convention.pdf',
                VersionData = !Test.isRunningTest() ? pdfPage.getContentaspdf()  : Blob.valueOf('Fake content'),
                origin = 'H'
            );
            insert contentVersionPDFToInsert;
            ContentVersion contentVersionPDF = [SELECT Id, Title, ContentDocumentId
                            FROM ContentVersion WHERE Id = :contentVersionPDFToInsert.Id LIMIT 1];
            
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = myOpportunity.id;
            contentlink.contentdocumentid = contentVersionPDF.contentdocumentid;
            contentlink.ShareType = 'V';

            Database.SaveResult attachmentForInsert=Database.Insert(contentlink,false);
            System.debug('selectedEmployees : ' + pdfPage.getParameters().get('selectedEmployees'));
            if(attachmentForInsert.isSuccess()){
                return contentlink.contentdocumentid;
            }else{
                throw new AuraHandledException(attachmentForInsert.getErrors().get(0).getMessage());
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    public static String generateEmployeeList(List<String> contactList){
        String result = '';
        Integer count  = 1;
        for(Contact c : [SELECT FirstName, LastName, Fonction__c FROM Contact WHERE Id IN :contactList]){
            result += count + '- ' + c.FirstName + ' ' + c.LastName + ' -  ' + c.Fonction__c + '<br/>';
            count ++;
        }
        return result;
    }
}
