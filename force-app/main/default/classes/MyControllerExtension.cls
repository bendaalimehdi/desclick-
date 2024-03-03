public class MyControllerExtension {
    
    public String selectedEmployees { get; set;}

    public MyControllerExtension() {
        selectedEmployees = ApexPages.currentPage().getParameters().get('selectedEmployees');
    }
    
}
