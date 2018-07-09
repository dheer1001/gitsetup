var triggerOn = false;

function onResult (decodeResults, readerProperties, output) {
	if (decodeResults[0].decoded) {
		output.content = decodeResults[0].content;
	}
	
	if (triggerOn) {
		dmccCommand("TRIGGER", true);
	}
}
