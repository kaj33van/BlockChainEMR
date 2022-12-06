//SPDK-License_Identifier:  CC-BY-SA-4.0
//version of solidity complier
pragma solidity ^0.5.1;

//Contract Creation
contract Agent {
// struct patient holds patient record
    struct patient {
        //Used string type for name
        string name;
        //integer for age
        uint age;
        //address array to display multiple doctor list
        address[] doctorAccessList;
        //integer array for diagnosis from various doctors
        uint[] diagnosis;
        //string for the record related to disease
        string record;
    }
    

    // struct doctor holds patient doctor
    struct doctor {
        //String type to store doctor name
        string name;
        //int type for doctor age
        uint age;
        //address array to store multiple patients list
        address[] patientAccessList;
    }

    //creditPool used for checking moving transactions
    uint creditPool;


    //Address array type for storing multiple patients and doctors
    address[] public patientList;
    address[] public doctorList;


    //Storing patient Information in patient struct type under address
    mapping (address => patient) patientInfo;
    //Storing doctor information in doctor struct type under address
    mapping (address => doctor) doctorInfo;
    //Transfer of public key address to patient to doctor and vice versa for Empty.
    mapping (address => address) Empty;
    // To store patients medical records in string under address
    mapping (address => string) patientRecords;
    //Creating Event for every transaction  
    event TransferFees(address indexed sender, uint amount);
    
    /* 
    Adding Agent
    with designation 0 for patient
    with designation 1 for doctor
    returning name on creation
    */
    // Function for adding agents 
    function add_agent(string memory _name, uint _age, uint _designation, string memory _hash) public returns(string memory){
        //Creating Event to keep check on agent creation
        event Addagent(address indexed creator, string memory name);
        address addr = msg.sender;
        // O designation adds patient
        if(_designation == 0){
            patient memory p;
            //Information of the patient
            p.name = _name;
            p.age = _age;
            p.record = _hash;
            patientInfo[msg.sender] = p;
            patientList.push(addr)-1;
            //Triggering Event on Patient creation
            emit Addagent(addr,_name);
            return _name;            
        }
        // 1 designation adds doctor
       else if (_designation == 1){
           //Information of the Doctor
            doctorInfo[addr].name = _name;
            doctorInfo[addr].age = _age;
            doctorList.push(addr)-1;
            //Triggering Event on Doctor creation
            emit Addagent(addr,_name);
            return _name;
       }
       //revert the function if designation is not from selected
       else{
           revert();
       }
    }

    //Below function will fetch patient details that were stored before the agent
    function get_patient(address addr) view public returns (string memory , uint, uint[] memory , address, string memory ){
        // if(keccak256(patientInfo[addr].name) == keccak256(""))revert();
        return (patientInfo[addr].name, patientInfo[addr].age, patientInfo[addr].diagnosis, Empty[addr], patientInfo[addr].record);
    }
    //Fetching details of the doctors that exists before the agent
    function get_doctor(address addr) view public returns (string memory , uint){
        // if(keccak256(doctorInfo[addr].name)==keccak256(""))revert();
        return (doctorInfo[addr].name, doctorInfo[addr].age);
    }
    //Getting available doctor names such that patients can be diagnosed from them
    function get_patient_doctor_name(address paddr, address daddr) view public returns (string memory , string memory ){
        return (patientInfo[paddr].name,doctorInfo[daddr].name);
    }
    //Below function will allow doctors to access the patients information
    function permit_access(address addr) payable public {
        //It will cost them 2 ether as a fee
        require(msg.value == 2 ether);

        creditPool += 2;
        //Triggering event to record the transfer fees
        emit TransferFees(msg.sender,msg.value);
        //Adding available doctors to patients list
        doctorInfo[addr].patientAccessList.push(msg.sender)-1;
        //Patients that gave their information access to doctors will be added to the doctors list
        patientInfo[msg.sender].doctorAccessList.push(addr)-1;
        
    }


    //Only doctors can call this function
    function insurance_claim(address paddr, uint _diagnosis, string memory  _hash) public {
        bool patientFound = false;
        //Transferring 2 ether back on successfull diagnosis
        for(uint i = 0;i<doctorInfo[msg.sender].patientAccessList.length;i++){
            if(doctorInfo[msg.sender].patientAccessList[i]==paddr){
                msg.sender.transfer(2 ether);
                creditPool -= 2;
                //Triggering event to record the transfer fees
                emit TransferFees(msg.sender,msg.value);
                patientFound = true;
                
            }
            
        }
        if(patientFound==true){
            set_hash(paddr, _hash);
            remove_patient(paddr, msg.sender);
        }else {
            revert();
        }
        // Checking on Diagnosis for the patients
        bool DiagnosisFound = false;
        for(uint j = 0; j < patientInfo[paddr].diagnosis.length;j++){
            if(patientInfo[paddr].diagnosis[j] == _diagnosis)DiagnosisFound = true;
        }
    }
    //Creating function to remove the elements from the array of list
    function remove_element_in_array(address[] storage Array, address addr) internal returns(uint)
    {   
        //bool check to stop reEntry attack
        //setting default bool check to false
        bool check = false;
        uint del_index = 0;
        for(uint i = 0; i<Array.length; i++){
            if(Array[i] == addr){
                check = true;
                del_index = i;
            }
        }
        if(!check) revert();
        else{
            if(Array.length == 1){
                delete Array[del_index];
            }
            else {
                Array[del_index] = Array[Array.length - 1];
                //delete elements from array
                delete Array[Array.length - 1];

            }
            Array.length--; //Checking on length once elements are removed
        }
    }
     /*
    Using remove element in array function 
    To remove patient from doctor list on successful diagnosis
    To remove doctor from patient list on successful diagnosis
    */
    function remove_patient(address paddr, address daddr) public {
        remove_element_in_array(doctorInfo[daddr].patientAccessList, paddr);
        remove_element_in_array(patientInfo[paddr].doctorAccessList, daddr);
    }
    //Get the list of doctors who have accessed patients information
    function get_accessed_doctorlist_for_patient(address addr) public view returns (address[] memory )
    { 
        address[] storage doctoraddr = patientInfo[addr].doctorAccessList;
        return doctoraddr;
    }
    //Get the list of patients which have provided access to their information to the doctor
    function get_accessed_patientlist_for_doctor(address addr) public view returns (address[] memory )
    {
        return doctorInfo[addr].patientAccessList;
    }

    //Revoke access from the doctor on information on their (Patient) medical details
    function revoke_access(address daddr) public payable{
        remove_patient(msg.sender,daddr);
        msg.sender.transfer(2 ether);
        //reducing the creditpool which keeps check on the transfers
        creditPool -= 2;
        //Triggering event to record the transfer fees
        emit TransferFees(msg.sender,msg.value);
    }
        
    //List out the patients stored in the array of patientlist
    function get_patient_list() public view returns(address[] memory ){
        return patientList;
    }
    
    //List out the doctors available under the doctorlist
    function get_doctor_list() public view returns(address[] memory ){
        return doctorList;
    }
    
    //Get the publickey hash of the patients to access the record
    function get_hash(address paddr) public view returns(string memory ){
        return patientInfo[paddr].record;
    }
    
    //Generate the public key hash for accessing the patients record
    function set_hash(address paddr, string memory _hash) internal {
        patientInfo[paddr].record = _hash;
    }

}

