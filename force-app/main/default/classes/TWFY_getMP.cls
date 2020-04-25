/**
 * @description     class to callout and get the MP based on a given postcode or constituency name
 * @author          daniel@hyphen8.com
 * @date            25/04/2020
 * @group           Callout
*/
public with sharing class TWFY_getMP {

    /**
     * @description     method for calling out the getMP API EndPoint
     * @param           constituency string
     * @return          List<TWFY_Helper.MP>
     */
    @AuraEnabled(Cacheable = true)
    public static List<TWFY_Helper.MP> getMP(string constituency, string postcode){

        postcode = postcode.replace(' ', '');
        constituency = constituency.replace(' ', '%20');
        List<TWFY_Helper.MP> returnlist = new List<TWFY_Helper.MP>();
        TWFY_Helper.MP returnmp = new TWFY_Helper.MP();
        // get details from custom settings
        TheyWorkForYouAPI__c twfy = TWFY_Helper.getCustomSettings();
        if(twfy == null){
            returnmp.error = 'You need to configure your custom settings to use this component';
        } else {
            // construct our url for callout
            string endpointurl = twfy.API_Endpoint_URL__c + 'api/getMP?key=' + twfy.API_Key__c + '&postcode='+ postcode + '&constituency=' + constituency;
            system.debug('endpointurl > ' + endpointurl);
            // perform callout
            HttpResponse resp = TWFY_Helper.getHTTPResponse(endpointurl);
            // if we get a good response process the response else display error with API
            if (resp.getStatusCode() == 200) {
                // try and convert response into constiteuncy name if postcode does not exist display our error response
                try {
                    returnmp = (TWFY_Helper.MP)JSON.deserialize(resp.getBody(), TWFY_Helper.MP.class);
                    returnmp.image = 'https://www.theyworkforyou.com/' + returnmp.image;
                    returnmp.url = 'https://www.theyworkforyou.com/' + returnmp.url;
                } catch (Exception e){
                    TWFY_Helper.ErrorWrapper error = (TWFY_Helper.ErrorWrapper)JSON.deserialize(resp.getBody(), TWFY_Helper.ErrorWrapper.class);
                    returnmp.error = error.error;
                }
            } else {
                returnmp.error =  'Error connecting to TheyWorkForYouAPI please contact your administrator';
            }
        }
        returnlist.add(returnmp);
        return returnlist;
    }
}