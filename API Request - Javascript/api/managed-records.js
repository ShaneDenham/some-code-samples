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

// Check to see if the data object is empty
function isData(data) {
	return data != '' ? true : false;
}

// Set the page when not passed in by the request
function getPage(page) {
	return page != undefined && page != null ? page : 1
}

// Find the index offest based on the provided page number
function findOffset(page) {
	return page ? page * 10 - 10 : 0;
}

// Check to see if the color is a primary color
function isPrimary(color) {
	const primaryColors = ['red', 'yellow', 'blue']

	return primaryColors.indexOf(color) != -1 ? true : false;
}

// Set the value of isPrimary
function checkForPrimary(color) {
	if ( isPrimary(color) ) {
		return true;
	} else {
		return false;
	}
}

// Add the isPrimary key
function addIsPrimary(item) {
	item.isPrimary = checkForPrimary(item.color);
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
	return page > 1 && page <= 51 ? page - 1 : null;
}

function getNext(page, data) {
	return data && page <= 49 ? page + 1 : null;
}

function transformData(data) {

}

// Handle the response
// --------------------

function handleResponse(response) {
  return response.json()
    .then(json => {
      if (response.ok) {
        return json
      } else {
        return Promise.reject(json)
      }
    })
}

// Retrieve and process the requested data
// --------------------
function retrieve(options = {page: 1, colors: []}) {

	// Find the offset based on the requested page number
	const offset = findOffset(options.page);

	// Set the page number
	const page = getPage(options.page);

	// Build the request URL
	let url = URI(window.path + "?limit=10")
		.addSearch( "offset", offset)
	    .addSearch({"color[]": options.colors});

	// Request data from the records endpoint
	return fetch(url)
	    .then(handleResponse)
	    .then(data => {
	    	// Create the empty result object
	    	let result = {previousPage: null, nextPage: null, ids: [], open: [], closedPrimaryCount: 0};

	    	// Add transformed data to the result object
	    	result.previousPage = getPrevious(page);
	    	result.nextPage = getNext(page, isData(data));
		  	result.ids = data.map(getIDs);
		  	result.open = getOpen(data);
		  	result.closedPrimaryCount = getClosedPrimaryCount(data).length;

	  		return result;
	  	})
	    .catch(error => console.log('Something went wrong! The error was: ', error));
}

export default retrieve;
