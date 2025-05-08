// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthcareRecords {
    address owner;
    
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

    function addRecord(uint256 patientID, string memory patientName, string memory diagnosis, string memory treatment) public onlyAuthorizedProvider {
        uint256 recordID = patientRecords[patientID].length + 1;
        patientRecords[patientID].push(Record(recordID, patientName, diagnosis, treatment, block.timestamp));
    }

    function getPatientRecords(uint256 patientID) public view onlyAuthorizedProvider returns (Record[] memory) {
        return patientRecords[patientID];
    }

    // 🚨 New function: Delete a record by its record ID
    function deleteRecord(uint256 patientID, uint256 recordID) public onlyAuthorizedProvider {
        Record[] storage records = patientRecords[patientID];
        uint256 length = records.length;
        bool found = false;

        for (uint256 i = 0; i < length; i++) {
            if (records[i].recordID == recordID) {
                // Swap and pop for efficient delete
                records[i] = records[length - 1];
                records.pop();
                found = true;
                break;
            }
        }

        require(found, "Record not found");
    }
}
