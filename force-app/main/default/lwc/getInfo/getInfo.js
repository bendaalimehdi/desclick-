import getEmployeeNames from '@salesforce/apex/Combobox.getEmployeeNames';
import { CurrentPageReference } from 'lightning/navigation';
import { LightningElement, wire } from 'lwc';

export default class MyComponent extends LightningElement {
    employeeOptions = [];
    error = '';
    recordId;

    // Wire the current page reference to get the Opportunity Id
    @wire(CurrentPageReference)
    wiredPageRef({data, error}) {
        if (data) {
            this.recordId = data.attributes.recordId;
            // Call the Apex method with the Opportunity Id
            getEmployeeNames({ opportunityId: this.recordId })
                .then(result => {
                    if (result && result.length > 0) {
                        this.employeeOptions = result.map(name => ({ label: name, value: name }));
                    } else {
                        this.error = 'No employee names found';
                    }
                })
                .catch(catchError => {
                    console.error('Error fetching employee names:', catchError);
                    this.error = catchError.body ? catchError.body.message : 'Unknown error';
                });
        } else if (error) {
            console.error('Error loading current page reference:', error);
            this.error = 'Error loading current page reference';
        }
    }
}
