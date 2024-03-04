public with sharing class OpportunityExtensionController {
    public List<Employe__c> selectedEmployees { get; set; }

    public OpportunityExtensionController(ApexPages.StandardController stdController) {
        // Retrieve selected employees from the OpportunityExtensionController page parameter
        String selectedEmployeesJSON = ApexPages.currentPage().getParameters().get('selectedEmployees');
        if (!String.isEmpty(selectedEmployeesJSON)) {
            selectedEmployees = (List<Employe__c>) JSON.deserialize(selectedEmployeesJSON, List<Employe__c>.class);
        } else {
            selectedEmployees = new List<Employe__c>();
        }
    }
}
