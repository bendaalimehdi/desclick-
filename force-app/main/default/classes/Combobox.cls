public class Combobox {
   
    @AuraEnabled(cacheable=true)
    public static List<String> getEmployeeNames(String opportunityId){
        List<String> employeeNames = new List<String>();
        
        // Ensure opportunityId is not null before proceeding
        if (opportunityId != null) {
            // Retrieve the employee names related to the given opportunity
            List<Employe__c> employees = [SELECT Name FROM Employe__c WHERE Opportunity__c = :opportunityId LIMIT 10];
            for(Employe__c emp : employees) {
                employeeNames.add(emp.Name);
            }
        }
        
        return employeeNames;
    }
}
