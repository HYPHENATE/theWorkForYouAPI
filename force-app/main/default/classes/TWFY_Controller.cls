/**
 * @description     controller class for generic processes to support the loading of the lwc component on the account or contact
 * @author          daniel@hyphen8.com
 * @date            25/04/2020
 * @group           Controller
*/
public with sharing class TWFY_Controller {

    /**
     * @description     get address postcode
     * @param           string recordId
     * @param           string objectName
     * @return          string postcode
    */
    @AuraEnabled(Cacheable = true)
    public static string getPostCode(string recordId, string objectName){
        
        system.debug('recordId > ' + recordId);
        system.debug('objectName > ' + objectName);
        string postcodefield;
        if(objectName == 'Contact'){
            postcodefield = 'MailingPostalCode';
        } else {
            postcodefield = 'BillingPostalCode';
        }

        system.debug('postcodefield > ' + postcodefield);
        string query = 'SELECT ID, ' + postcodefield + ' FROM ' + objectName + ' WHERE ID=\'' + recordId + '\' LIMIT 1';
        system.debug(query);
        sObject[] currentrecord = Database.query(query);

        string postcode;
        if(objectName == 'Contact'){
            postcode = (string)currentrecord[0].get('MailingPostalCode');
        } else {
            postcode = (string)currentrecord[0].get('BillingPostalCode');
        }

        return postcode;
    }
}