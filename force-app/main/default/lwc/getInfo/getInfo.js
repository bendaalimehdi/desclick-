import getEmployeeNames from '@salesforce/apex/Combobox.getEmployeeNames';
import OpportunityId from '@salesforce/schema/OpportunityId';
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import { LightningElement, api, wire } from 'lwc';
export default class MyComponent extends LightningElement {
    @api recordId;
    error;
    employeeOptions = []; 
    @wire(getRecord, { recordId: '$recordId', fields: [OpportunityId] })
    wiredRecord({ error, data }) {
        if (data) {
            this.OppId = getFieldValue(data, OpportunityId);
            getEmployeeNames({ opportunityId: this.OppId })
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
            console.error('Error loading record', error);
            this.error = 'Error loading record';
        }
    }
}
