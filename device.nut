// configure the imp (best practice)
imp.configure("Relay Swtr", [], []);

// create a global variable called relay, and assign pin9 to it
relay <- hardware.pin9;

// configure relay to be a digital output
relay.configure(DIGITAL_OUT);

// create a global variable called button, and assign pin1 to it
button <- hardware.pin1;

// function to  toggle relay from the switch
function toggleRelay() {
	if (button.read() == 1) { // button has been pressed
		while (button.read() == 1) {} // wait til button has been released
		imp.sleep(0.2); // delay by 200ms to prevent debounce
		relay.write(1 - relay.read()); // toggle the relay
		server.log("Set relay by button: " + relay.read()); // log what happened
	}
}

// function to turn relay on or off
function setRelay(relayState) {
	server.log("Set relay by website: " + relayState); // log what happened
	relay.write(relayState);
}

// configure relay to be a digital input that is pulled down to ground
// and if it is pressed (and pulled up to 3.3V) go to function toggleRelay()
button.configure(DIGITAL_IN_PULLDOWN, toggleRelay);

// register a handler for "relay" messages from the agent
agent.on("relay", setRelay);