/**
 * @description     helper class for the TWFY App
 * @author          daniel@hyphen8.com
 * @date            25/04/2020
 * @groups          Helper
*/
public with sharing class TWFY_Helper {
    
    /**
     * @description     method to return the org wide or profile or user specific custom settings
     * @return          TheyWorkForYouAPI__c
    */
    public static TheyWorkForYouAPI__c getCustomSettings(){
        TheyWorkForYouAPI__c twfyCS;
        try {
            twfyCS = TheyWorkForYouAPI__c.getInstance(UserInfo.getUserId());
            return twfyCS;
        } catch (Exception usererror){
            system.debug('No User Custom Settings > ' + usererror.getMessage());
            try {
                twfyCS = TheyWorkForYouAPI__c.getInstance(UserInfo.getProfileId());
                return twfyCS;
            } catch (Exception profileerror){
                system.debug('No Profile Custom Settings > ' + profileerror.getMessage());
                try {
                    twfyCS = TheyWorkForYouAPI__c.getOrgDefaults();
                    return twfyCS;
                } catch (Exception orgerror){
                    system.debug('No Org Wide Custom Settings > ' + orgerror.getMessage());
                    return null;
                }
            }
        }
    }

    /**
     * @description simple helper to generate HTTP reponse
     * @param       string url
     * @return      
    */
    public static HttpResponse getHTTPResponse (string url){
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET');
        req.setEndPoint(url);
        HttpResponse resp = http.send(req);
        return resp;
    }


    /**
     * @description     error wrapper class generically used across all methods to output returned errors from API
    */
    public class ErrorWrapper {

        /**
         * @description     public string for storing the error in
        */
        @AuraEnabled public string error;
    }


    /**
     * @description     constituency wrapper used with the getConstituency API Callout
     */
    public class Constituency {
        
        /**
         * @description public string containing the name of the constituency
         */
        @AuraEnabled public string name;
    }


    /**
     * @description     mp wrapper used with the getMP API Callout
    */
    public class MP {
        @AuraEnabled public string error;
        @AuraEnabled public string constituency;
        @AuraEnabled public string party;
        @AuraEnabled public string entered_house;
        @AuraEnabled public string entered_reason;
        @AuraEnabled public string lastupdate;
        @AuraEnabled public string full_name;
        @AuraEnabled public string url;
        @AuraEnabled public string image;
        @AuraEnabled public string image_height;
        @AuraEnabled public string image_width;
        @AuraEnabled public Office[] office;
    }

    /**
     * @description     office wrapper
    */
    public class Office {
        @AuraEnabled public string position;
        @AuraEnabled public string from_date;
    }

    /**
     * @description     mla wrapper used with the getMLA API Callout
    */
    public class MLA {
        @AuraEnabled public string error;
        @AuraEnabled public string party;
        @AuraEnabled public string full_name;
    }
}