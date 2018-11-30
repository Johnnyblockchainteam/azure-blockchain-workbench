pragma solidity ^0.4.25;
contract WorkbenchBase {
    event WorkbenchContractCreated(string applicationName, string workflowName, address originatingAddress);
    event WorkbenchContractUpdated(string applicationName, string workflowName, string action, address originatingAddress);

    string internal ApplicationName;
    string internal WorkflowName;

    constructor(string applicationName, string workflowName) internal {
        ApplicationName = applicationName;
        WorkflowName = workflowName;
    }

    function ContractCreated() internal {
        emit WorkbenchContractCreated(ApplicationName, WorkflowName, msg.sender);
    }

    function ContractUpdated(string action) internal {
        emit WorkbenchContractUpdated(ApplicationName, WorkflowName, action, msg.sender);
    }
}

contract ceidbc is WorkbenchBase('ceidbc', 'ceidbc')
{

    //Set of States
	enum StateType { Created, InProgress, Scrapped}
	
	//List of properties
	StateType public  State;
	address public  Tracker;
	string public  RegistrationPlate;
	string public  VIN;
	string public  EngineCode;
	uint public  Mileage;
	string public  InspectionDate;
	string public  Record;
	
	constructor(string registrationplate, string vin, string enginecode, uint256 mileage, string inspectiondate, string record) public
	{ 
		Tracker = msg.sender;
		RegistrationPlate = registrationplate;
		VIN = vin;
		EngineCode = enginecode;
		Mileage = mileage;
		InspectionDate = inspectiondate;
		Record = record;
		State = StateType.Created;
        ContractCreated();
    }

	function NewRecord(string registrationplate, string vin, string enginecode, uint256 mileage, string inspectiondate, string record) public
	{
        if (State == StateType.Scrapped)
        {
            revert();
        }

        if (State == StateType.Created)
        {
            State = StateType.InProgress;
        }

        Tracker = msg.sender;
		RegistrationPlate = registrationplate;
		VIN = vin;
		EngineCode = enginecode;
		Mileage = mileage;
		InspectionDate = inspectiondate;
		Record = record;
        ContractUpdated('NewRecord');
    }

	function Scrap() public
	{
	    if (State == StateType.Scrapped)
        {
            revert();
        }

        State = StateType.Scrapped;
        Tracker = msg.sender;
        ContractUpdated('Scrap');
    }

}
