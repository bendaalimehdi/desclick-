public class OpportunityEmailHandler {
 
    public static boolean sendEmailWithPDFForIds(List<Id> opportunityIds) {
      
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

        // Query for opportunities and their related Account
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, Name, AccountId, Account.Email__c FROM Opportunity WHERE Id IN :opportunityIds]);

        for (Opportunity opp : oppMap.values()) {
           
            if (opp.Account.Email__c != null) {
                System.debug('Sending email for Opportunity: ' + opp.Name);
                PageReference pdfPage = Page.pdf; 
                pdfPage.getParameters().put('id', opp.Id);

                Blob pdfBlob;
            try {
                if (Test.isRunningTest()) {
                    // Use dummy data in test context
                    pdfBlob = Blob.valueOf('Test PDF content');
                } else {
                    // Generate PDF in non-test context
                    pdfBlob = pdfPage.getContentAsPDF();
                }
            } catch (Exception e) {
                // Handle exception
                System.debug('Error generating PDF: ' + e.getMessage());
                continue;
            }
            ContentVersion cv = new ContentVersion();
                cv.Title = opp.Name + ' Devis';
                cv.PathOnClient =  opp.Name +'.pdf'; // Name of the file
                cv.VersionData = pdfBlob;
                cv.FirstPublishLocationId = opp.Id; // Wherever you want to attach it
            insert cv;


                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setFileName('Quote.pdf');
                attach.setBody(pdfBlob);

                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setSubject('Devis');
                email.setToAddresses(new List<String>{opp.Account.Email__c});
                email.setPlainTextBody('Bonjour, voila votre devis');

                Id orgWideAddressId = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress LIMIT 1].Id;
                email.setOrgWideEmailAddressId(orgWideAddressId);

                email.setFileAttachments(new List<Messaging.EmailFileAttachment>{attach});
                emailList.add(email);
 				System.debug('Email List Size: ' + emailList.size());
                Opportunity oppToUpdate = new Opportunity(Id = opp.Id, Email_Sent__c = true);
                opportunitiesToUpdate.add(oppToUpdate);
                
            }
        }

        // Update opportunities to mark emails as sent
        if (!opportunitiesToUpdate.isEmpty()) {
            update opportunitiesToUpdate;
        }

        // Send emails
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        
        // Check email sending status
        for(Messaging.SendEmailResult result : results) {
            if(result.isSuccess()) {
                System.debug('Email envoyé avec succès.');
            } else {
                System.debug('Erreur lors de l\'envoi de l\'email: ' + result.getErrors()[0].getMessage());
                
            }
        }
        return results[0].isSuccess();
    }  
}