import { LightningElement, api, track } from 'lwc';

import getConstituency from '@salesforce/apex/TWFY_getConstituency.getConstituency';
import getMP from '@salesforce/apex/TWFY_getMP.getMP';
import getPostCode from '@salesforce/apex/TWFY_Controller.getPostCode';
import getMLA from '@salesforce/apex/TWFY_getMLA.getMLA';

export default class TheyWorkForYouComponent extends LightningElement {

    // set api elements
    @api recordId;
    @api objectApiName;
    @api displayMPDetails;
    @api displayMLADetails;
    @api displayMSPDetails;

    @track constituencyName;
    @track postcode;
    @track displayComponent = true;
    @track mpDetails;
    @track mlaDetails;
    @track mspDetails;
    @track errors;
    @track loading = true;

    // intial call back get out data
    connectedCallback() {
        this.handleGetPostCode();        
    }

    // handle errors no output for it back handling anyway
    errorCallback(error) {
        this.errors = error;
    }

    // get the current record Postcode field
    handleGetPostCode(){
        getPostCode({
            recordId: this.recordId,
            objectName: this.objectApiName
        })
        .then((results) => {
            this.postcode = results;
            window.console.log('postcode > ' + this.postcode);
            if(results.length > 0){
                this.handleGetConstituency();
            } else {
                this.displayComponent = false;
                this.loading = false;
            }
            this.errors = undefined;  
        })
        .catch((error) => {
            this.errors = JSON.stringify(error);
            this.postcode = undefined;
            this.displayComponent = false;
            this.loading = false;
        });  
    }

    // handling getting the constituency - westminister parliment constitiuency
    handleGetConstituency(){
        getConstituency({
            postcode: this.postcode
        })
        .then((results) => {
            this.constituencyName = results;
            window.console.log('constituencyName > ' + this.constituencyName);
            if(results.length > 0){
                if(this.displayMPDetails){
                    this.handleGetMPDetails();
                } else {
                    this.displayComponent = true;
                    this.loading = false;
                }
                if(this.displayMLADetails){
                    this.handleGetMLADetails();
                }
            } else {
                this.displayComponent = false;
                this.loading = false;
            }
            this.errors = undefined;  
        })
        .catch((error) => {
            this.errors = JSON.stringify(error);
            this.constituencyName = undefined;
            this.displayComponent = false;
            this.loading = false;
        });

        
    }

    // handles getting the mp details
    handleGetMPDetails(){
        getMP({
            constituency: this.constituencyName,
            postcode: this.postcode
        })
        .then((results) => {
            this.mpDetails = results;
            window.console.log('mpDetails > ' + JSON.stringify(this.mpDetails));
            this.displayComponent = true;
            this.errors = undefined;  
            this.loading = false;
        })
        .catch((error) => {
            this.errors = JSON.stringify(error);
            this.mpDetails = undefined;
            this.displayComponent = false;
            this.loading = false;
        });
    }

    // handles getting the mp details
    handleGetMLADetails(){
        getMLA({
            constituency: this.constituencyName,
            postcode: this.postcode
        })
        .then((results) => {
            this.mlaDetails = results;
            window.console.log('mlaDetails > ' + JSON.stringify(this.mlaDetails));
            this.displayComponent = true;
            this.errors = undefined;  
            this.loading = false;
        })
        .catch((error) => {
            this.errors = JSON.stringify(error);
            this.mlaDetails = undefined;
            this.displayComponent = false;
            this.loading = false;
        });
    }



}