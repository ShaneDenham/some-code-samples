
// Array for family member objects
var familyMembers = [];

// Incremental value for family member ID
var familyMemberID = 1

// DOM Elements
var theForm = document.forms[0];
var addButton =document.getElementsByClassName('add')[0]
var household = document.getElementsByClassName('household')[0];
var debug = document.getElementsByClassName('debug')[0];

// Helpers
//--------------------
function theRelationship() {
	var rel = theForm.elements["rel"];
	var relIndex = rel.selectedIndex;

	return rel.options[relIndex].value;
}

function isSmoker() {
	var smoker = theForm.elements["smoker"];
	if ( smoker.checked ) {
		return "Smoker";
	} else {
		return "Nonsmoker";
	}
}

function isOnlyNumbers(val) {
	return !isNaN(parseFloat(val)) && isFinite(val);
}

// Adding a member
//--------------------
function addNewMemberToList(age, rel, smokes) {

	var newMember = { ID: familyMemberID, Age: age, Relationship: rel, Smokes: smokes };

	// Add the new family member to the familyMembers array
	familyMembers.push( newMember );
}

function displayNewMember(age, rel, smokes) {

	// Create the list item
	var listItem = document.createElement("li");
	var listItemTextNode = document.createTextNode(age + "-year-old " + rel + ", " + smokes + ". ");
	listItem.appendChild(listItemTextNode);
	listItem.id = familyMemberID

	//Create the button and add it to the list item
	var newButton = document.createElement("button");
	var buttonTextNode = document.createTextNode("Remove");
	newButton.appendChild(buttonTextNode);
	newButton.onclick = function(){ removeFamilyMember(this.parentNode, listItem.id); };
	listItem.appendChild(newButton);

	// Add the list item to the ordered list
	household.appendChild(listItem);
}

function addFamilyMember(age, rel, smokes) {

	addNewMemberToList(age, rel, smokes);
	displayNewMember(age, rel, smokes);

	familyMemberID ++;
}

// Removing a member
//--------------------
function removeFamilyMember(familyMember, memberID) {

	// Remove the family member from the familyMembers array
	familyMembers = familyMembers.filter( function(el) {
		return el.ID != memberID;
	});

	// Remove the family member from the ordered list
	household.removeChild(familyMember);
}

// Handle events
//--------------------
function validateForm() {
	event.preventDefault();

	// Get the form data
	var age = theForm.elements["age"].value;
	var rel = theRelationship();
	var smokes = isSmoker();

    if ( age == "" || !isOnlyNumbers(age) || Number(age) <= 0 ) {
        alert("Please enter a valid age.");
        return false;
    } else if( rel == "" ) {
    	alert("Please select a relationship.");
        return false;
    } else {

    	addFamilyMember(age, rel, smokes);
    }
}

function handleForm(event) {
	event.preventDefault();

	var newJSON = JSON.stringify(familyMembers);
    debug.innerHTML = newJSON;

    alert("Sucess!");
}

// Events
//--------------------

// Validate and add new family member when the add button is clicked
addButton.addEventListener('click', validateForm);

// Process the familyMembers array and send it to the 'server'
theForm.addEventListener('submit', handleForm);


