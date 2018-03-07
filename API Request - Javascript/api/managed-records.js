import fetch from "../util/fetch-fill";
import URI from "urijs";

// /records endpoint
window.path = "http://localhost:3000/records";

// Filters
// --------------------

// Grab the items with a primary color
function extractPrimary(item) {
	return isPrimary(item.color);
}

// Remove the items with a disposition of closed
function removeClosed(item) {
	return item.disposition != 'closed';
}

// Remove the items with a disposition of open
function removeOpen(item) {
	return item.disposition != 'open';
}


// Helpers
// --------------------

// find the index offest based on the provided page number
function findOffset(page) {
	if ( page ) {
		return page * 10 - 10;
	}
	return 0;
}

// Check to see if the color is a primary color
function isPrimary(color) {
	var primaryColors = ['red', 'yellow', 'blue']

	if ( primaryColors.indexOf(color) != -1 ) {
		return true;
	}
	return false;
}

// Add the isPrimary key
function addIsPrimary(item) {
	item.isPrimary = isPrimary(item.color);
	return item;
}


// Transform the data
// --------------------

// Map item IDs into an array
function getIDs(item) {
	return item.id
}

// Map open items to an array and add isPrimary
function getOpen(data) {
	var open = data.filter(removeClosed);
	return open.map(addIsPrimary);
}

// Map closed primary items to an array
function getClosedPrimaryCount(data) {
	var closed = data.filter(removeOpen);
	return closed.filter(extractPrimary)
}

function getPrevious(page) {
	var previous = page - 1;

	if ( previous >= 1 ) {
		return previous;
	}
	return null;
}

function getNext(page) {
	var next = page + 1;

	if ( next <= 50 ) {
		return next;
	}
	return null;
}


// Retrieve and process the requested data
// --------------------
function retrieve(options = {page: 1, colors: []}) {

	// Find the offset based on the requested page number
	var offset = findOffset(options.page);

	// Build the request URL
	var url = URI(window.path + "?limit=10")
		.addSearch("offset", offset)
	    .addSearch({ color: options.colors });

	// Request data from the records endpoint
	var result = fetch(url)
	    .then(response => {
		    if (response.ok) {
		    	return response.json()
		    } else {
		      	return Promise.reject('Something went wrong!')
		    }
		})
	    .then(data => {
	  		result.ids = data.map(getIDs);
	  		result.open = getOpen(data);
	  		result.closedPrimaryCount = getClosedPrimaryCount(data).length;
	  		result.previousPage = getPrevious(options.page);
	  		result.nextPage = getNext(options.page);
	  	})
	    .catch(error => console.log('Something went wrong! The error was: ', error));

	return result;
}

export default retrieve;
