@IsTest
public class getPicklistValuesUsingLabelTest {

    @IsTest
    static void testGetValuesUsingLabelMethod_DefaultFlow() {
        // Create a lead record to be used in the test
        Lead leadRecord = new Lead(
            FirstName = 'Test', 
            LastName = 'Lead', 
            Company = 'Test Company',
            Status = 'New'
        );
        insert leadRecord;

        // Create a list of request objects to simulate flow input
        List<getPicklistValuesUsingLabel.Request> requestList = new List<getPicklistValuesUsingLabel.Request>();
        getPicklistValuesUsingLabel.Request request = new getPicklistValuesUsingLabel.Request();
        request.recordId = leadRecord.Id; // Assign the created lead's Id
        request.flowName = 'Any Flow Name'; // Default flow name, not 'Update Aged Mav Playbook'
        requestList.add(request);

        // Invoke the method with default flow name
        Test.startTest();
        getPicklistValuesUsingLabel.getValuesUsinglabelMethod(requestList);
        Test.stopTest();
    }

    @IsTest
    static void testGetValuesUsingLabelMethod_AgedFlow() {
        // Create a lead record to be used in the test
        Lead leadRecord = new Lead(
            FirstName = 'Test Aged', 
            LastName = 'Lead', 
            Company = 'Aged Company',
            Status = 'Open'
        );
        insert leadRecord;

        // Create a list of request objects to simulate flow input
        List<getPicklistValuesUsingLabel.Request> requestList = new List<getPicklistValuesUsingLabel.Request>();
        getPicklistValuesUsingLabel.Request request = new getPicklistValuesUsingLabel.Request();
        request.recordId = leadRecord.Id; // Assign the created lead's Id
        request.flowName = 'Update Aged Mav Playbook'; // This triggers the "Insurance Outreach (Aged)" label logic
        requestList.add(request);

        // Invoke the method with "Update Aged Mav Playbook" flow name
        Test.startTest();
        getPicklistValuesUsingLabel.getValuesUsinglabelMethod(requestList);
        Test.stopTest();
    }
}