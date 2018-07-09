var inputHandler;

function CommHandler()
{
	return {
		onConnect: function (peerName) {
			inputHandler = registerHandler(Callback.onInput, this.onInput.bind(this), ConstInput.Input0);
			return true;
		},
		onDisconnect: function () {
			deregisterHandler(inputHandler);
		},
		onError: function (errorMsg) {
		},
		onExpectedData: function (inputString) {
			return false;
		},
		onUnexpectedData: function (inputString) {
			return false;
		},
		onTimer: function () {
		},
		onEncoder: function () {
		},
		onInput: function (inputs) {
			triggerOn = (inputs & ConstInput.Input0) ? true : false;
			
			if (!triggerOn) {
				dmccCommand("TRIGGER", false);
			}
		}
	};
}
