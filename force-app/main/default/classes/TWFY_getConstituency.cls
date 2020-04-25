/**
 * @description     getConstituency Callout
 * @author          daniel@hyphen8.com
 * @date            25/04/2020
 * @group           Callouts
*/
public with sharing class TWFY_getConstituency {

    /**
     * @description     method for calling out the getConstituency API EndPoint
     * @param           string postcode
     * @return          string
    */
    @AuraEnabled(Cacheable = true)
    public static string getConstituency(string postcode){

        postcode = postcode.replace(' ', '');

        // get details from custom settings
        TheyWorkForYouAPI__c twfy = TWFY_Helper.getCustomSettings();
        if(twfy == null){
            return 'You need to configure your custom settings to use this component';
        } else {
            // construct our url for callout
            string endpointurl = twfy.API_Endpoint_URL__c + 'api/getConstituency?key=' + twfy.API_Key__c + '&postcode='+postcode;
            // perform callout
            HttpResponse resp = TWFY_Helper.getHTTPResponse(endpointurl);
            // if we get a good response process the response else display error with API
            if (resp.getStatusCode() == 200) {
                // try and convert response into constiteuncy name if postcode does not exist display our error response
                try {
                    TWFY_Helper.Constituency constitency = (TWFY_Helper.Constituency)JSON.deserialize(resp.getBody(), TWFY_Helper.Constituency.class);
                    return constitency.name;
                } catch (Exception e){
                    TWFY_Helper.ErrorWrapper error = (TWFY_Helper.ErrorWrapper)JSON.deserialize(resp.getBody(), TWFY_Helper.ErrorWrapper.class);
                    return error.error;
                }
            } else {
                return 'Error connecting to TheyWorkForYouAPI please contact your administrator';
            }
        }
    }
}