/**
 * @description     class to callout and get the MLA based on a given postcode or constituency name
 * @author          daniel@hyphen8.com
 * @date            25/04/2020
 * @group           Callout
*/
public with sharing class TWFY_getMLA {
    
    /**
     * @description     method for calling out the getMP API EndPoint
     * @param           constituency string
     * @return          List<TWFY_Helper.MP>
     */
    @AuraEnabled(Cacheable = true)
    public static List<TWFY_Helper.MLA> getMLA(string constituency, string postcode){

        postcode = postcode.replace(' ', '');
        constituency = constituency.replace(' ', '%20');
        List<TWFY_Helper.MLA> returnlist = new List<TWFY_Helper.MLA>();
        // get details from custom settings
        TheyWorkForYouAPI__c twfy = TWFY_Helper.getCustomSettings();
        if(twfy == null){
            TWFY_Helper.MLA returnmp = new TWFY_Helper.MLA();
            returnmp.error = 'You need to configure your custom settings to use this component';
            returnlist.add(returnmp);
        } else {
            // construct our url for callout
            string endpointurl = twfy.API_Endpoint_URL__c + 'api/getMLA?key=' + twfy.API_Key__c + '&postcode='+ postcode + '&constituency=' + constituency;
            system.debug('endpointurl > ' + endpointurl);
            // perform callout
            HttpResponse resp = TWFY_Helper.getHTTPResponse(endpointurl);
            // if we get a good response process the response else display error with API
            if (resp.getStatusCode() == 200) {
                // try and convert response into constiteuncy name if postcode does not exist display our error response
                try {
                    returnlist = (List<TWFY_Helper.MLA>)JSON.deserialize(resp.getBody(), List<TWFY_Helper.MLA>.class);
                } catch (Exception e){
                    TWFY_Helper.MLA returnmp = new TWFY_Helper.MLA();
                    TWFY_Helper.ErrorWrapper error = (TWFY_Helper.ErrorWrapper)JSON.deserialize(resp.getBody(), TWFY_Helper.ErrorWrapper.class);
                    returnmp.error = error.error;
                    returnlist.add(returnmp);
                }
            } else {
                TWFY_Helper.MLA returnmp = new TWFY_Helper.MLA();
                returnmp.error =  'Error connecting to TheyWorkForYouAPI please contact your administrator';
                returnlist.add(returnmp);
            }
        }
        return returnlist;
    }
}