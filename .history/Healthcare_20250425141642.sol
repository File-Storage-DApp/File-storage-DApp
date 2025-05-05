// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthcareRecords {
    address owner;
    uint256 private nextPatientID = 1;

    struct Record {
        uint256 recordID;
        string patientName;
        string diagnosis;
        string treatment;
        uint256 timestamp;
    }

    mapping(uint256 => Record[]) private patientRecords;
    mapping(address => bool) private authorizedProviders;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this function");
        _;
    }

    modifier onlyAuthorizedProvider() {
        require(authorizedProviders[msg.sender], "Not an authorized provider");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function authorizeProvider(address provider) public onlyOwner {
        authorizedProviders[provider] = true;
    }

    // 🔥 Add a new patient record with auto-incremented patient ID
    function addNewPatient(string memory patientName, string memory diagnosis, string memory treatment) public onlyAuthorizedProvider returns (uint256) {
        uint256 patientID = nextPatientID;
        nextPatientID++;

        patientRecords[patientID].push(Record({
            recordID: 1,
            patientName: patientName,
            diagnosis: diagnosis,
            treatment: treatment,
            timestamp: block.timestamp
        }));

        return patientID;
    }

    // ➕ Add record to existing patient (if you want to support that)
    function addRecordToExistingPatient(uint256 patientID, string memory diagnosis, string memory treatment) public onlyAuthorizedProvider {
        require(patientRecords[patientID].length > 0, "Patient does not exist");

        string memory name = patientRecords[patientID][0].patientName;
        uint256 recordID = patientRecords[patientID].length + 1;

        patientRecords[patientID].push(Record({
            recordID: recordID,
            patientName: name,
            diagnosis: diagnosis,
            treatment: treatment,
            timestamp: block.timestamp
        }));
    }

    function getPatientRecords(uint256 patientID) public view onlyAuthorizedProvider returns (Record[] memory) {
        return patientRecords[patientID];
    }
}
