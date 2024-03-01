import getEmployeeNames from '@salesforce/apex/Combobox.getEmployeeNames';
import OpportunityId from '@salesforce/schema/Opportunity.Id';
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import { LightningElement, api, track, wire } from 'lwc';

export default class MyComponent extends LightningElement {
    _selected = [];
    @api recordId;
    error;
   @track employeeOptions = []; 
   @api selectedEmployees = [];
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
    get selected() {
        return this._selected.length ? this._selected : 'none';
    }
   // handleChange(event) {
     //   this._selected = event.detail.value;
       // // Track selected employees
        t//his.selectedEmployees = this._selected.map(emp => ({ label: emp, value: emp }));

   // }
    handleSendDataToVF() {
        const event = new CustomEvent('senddatatovf', {
            detail: { selectedEmployees: this.selectedEmployees }
        });
        this.dispatchEvent(event);
    }

    
    sendDataToVFPage() {
        // Send selected employees to Visualforce page
        window.location.href = 'convention.page?selectedEmployees=' + JSON.stringify(this.selectedEmployees);
    }
    
}