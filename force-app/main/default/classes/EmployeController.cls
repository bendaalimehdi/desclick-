// EmployeeController
public with sharing class EmployeController {
    public String selectedRecordId { get; set; }
    public List<SelectOption> getEmployeeRecords() {
        List<SelectOption> options = new List<SelectOption>();
        for(Employe__c emp : [SELECT Id, Name FROM Employe__c]) {
            options.add(new SelectOption(emp.Id, emp.Name));
        }
        return options;
    }
}
