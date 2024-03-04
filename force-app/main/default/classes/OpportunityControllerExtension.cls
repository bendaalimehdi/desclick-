public with sharing class OpportunityControllerExtension {
    public Contact relatedContact { get; set; }
    
    public OpportunityControllerExtension(ApexPages.StandardController controller) {
        Opportunity opp = (Opportunity)controller.getRecord();
        // Fetch related contact
        relatedContact = [SELECT Id, LastName, FirstName FROM Contact WHERE Opportunity__r.Id = :opp.Id LIMIT 1];
    }
}
