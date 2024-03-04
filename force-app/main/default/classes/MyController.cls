public with sharing class MyController {
    public class SelectOptionWrapper {
        @AuraEnabled
        public String value { get; set; }
        @AuraEnabled
        public String label { get; set; }

        public SelectOptionWrapper(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }

    public String selectedOpportunity { get; set; }
    public String selectedFormateur { get; set; }
    public List<String> selectedEmployees { get; set; }
    public String opportunityId { get; set; }

    public MyController(ApexPages.StandardController controller) {
        Opportunity opp = (Opportunity)controller.getRecord();
        opportunityId = opp.Id;
        selectedEmployees = new List<String>(); // Initialize selectedEmployees list
    }
    
    // Method to retrieve all formateurs
    @AuraEnabled(cacheable=true)
    public static List<SelectOptionWrapper> getFormateurs() {
    List<MyController.SelectOptionWrapper> options = new List<MyController.SelectOptionWrapper>();
    for (Formateur__c formateur : [SELECT Id, Name FROM Formateur__c]) {
        options.add(new MyController.SelectOptionWrapper(formateur.Id, formateur.Name));
    }
    return options;
    }
    
    // Method to retrieve employees linked to an account associated with a selected opportunity
    @AuraEnabled(cacheable=true)
    public static List<SelectOptionWrapper> getEmployees(String opportunityId) {
        List<SelectOptionWrapper> options = new List<SelectOptionWrapper>();
        for (Employe__c emp : [SELECT Id, Name FROM Employe__c WHERE Account__c IN (SELECT AccountId FROM Opportunity WHERE Id = :opportunityId)]) {
            options.add(new SelectOptionWrapper(emp.Id, emp.Name));
        }
        System.debug('Employees: ' + options);
        return options;
    }
}
