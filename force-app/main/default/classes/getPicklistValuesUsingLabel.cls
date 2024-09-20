public class getPicklistValuesUsingLabel {
    public static String valuePick;
 
    // Class to hold the input from Flow
    public class Request {
        @InvocableVariable(required=true)
        public String recordId;  // Variable to hold the record ID
        @InvocableVariable(required=false)
        public String flowName;  // Variable to hold the flow name
    }
 
    @InvocableMethod
    public static void getValuesUsinglabelMethod(List<Request> requestList) {
        system.debug('requestList: ' + requestList);
 
        // Get Lead object describe information
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get('Lead');
        if (sObjectType == null) {
            throw new IllegalArgumentException('Invalid object name: Lead');
        }
 
        // Get the field describe information for the picklist
        Schema.DescribeFieldResult fieldDescribe = sObjectType.getDescribe().fields.getMap().get('Mav_Playbook__c').getDescribe();
        if (fieldDescribe == null || fieldDescribe.getType() != Schema.DisplayType.Picklist) {
            throw new IllegalArgumentException('Field Mav_Playbook__c is not a picklist field');
        }
 
        // Determine the label based on the flow name
        String labelToCheck = 'Insurance Outreach';  // Default label
        if (requestList != null && !requestList.isEmpty()) {
            String flowName = requestList[0].flowName;
            if (flowName == 'Update Aged Mav Playbook') {
                labelToCheck = 'Insurance Outreach (Aged)';  // Use different label for this flow
            }
        }
 
        // Get the picklist entries and find the value associated with the label
        List<Schema.PicklistEntry> picklistValues = fieldDescribe.getPicklistValues();
        for (Schema.PicklistEntry entry : picklistValues) {
            // Compare labels using equals() method
            if (entry.getLabel().equals(labelToCheck)) {
                valuePick = entry.getValue();  // Use value, not label, for updating
                system.debug('value: ' + entry.getValue());
                break;  // Exit loop once the correct value is found
            }
        }
 
        // Update the Lead records with the selected picklist value
        List<Lead> leadList = new List<Lead>();
        for (Request r : requestList) {
            system.debug(r.recordId);
            for (Lead l : [SELECT Id, Status FROM Lead WHERE Id = :r.recordId]) {
              
                l.Mav_Playbook__c = valuePick;
                leadList.add(l);
            }
        }
 
        // Perform the update
        if (!leadList.isEmpty()) {
            update leadList;
        }
    }
 }
 