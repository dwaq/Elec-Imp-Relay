// RETURN_ON_ERROR tells the imp to continue running as normal
// when the WiFi connection is lost.
server.setsendtimeoutpolicy(RETURN_ON_ERROR);

// create a global variable called relay, and assign pin9 to it
relay <- hardware.pin9;

// configure relay to be a digital output
relay.configure(DIGITAL_OUT);

// create a global variable called button, and assign pin1 to it
button <- hardware.pin1;

// variables for delaying
// variable to convert minutes to milliseconds
min2millisec <- 1000 * 60;
// used to store amount of delay
timeCount <- 0;
// used to store time at beginning of loop
currentTime <- 0;
// used to store time at end of loop
stopTime <- 0;

// function to  toggle relay from the switch
function toggleRelay() {
	if (button.read() == 1) { // button has been pressed
		while (button.read() == 1) {} // wait til button has been released
		imp.sleep(0.2); // delay by 200ms to prevent debounce
		relay.write(1 - relay.read()); // toggle the relay
		server.log("Set relay by button: " + relay.read());
	}
}

// function to turn relay on or off
function setRelay(relayState) {
	server.log("Set relay by website: " + relayState);
	relay.write(relayState);
}

// function to find out when the relay will turn off, then start by turning on
// after time has passed or button is pressed, the relay is turned off
function setTime(numberCups) {
    // convert numberCups to an amount of time in milliseconds
    timeCount = (2.5 + numberCups) * min2millisec
    server.log("Set relay for " + timeCount/min2millisec + " minutes");
    // get current time to add to to find out when to turn off
    currentTime = hardware.millis();
    stopTime = currentTime + timeCount
    server.log("It is now " + currentTime + ". The relay will turn off at " + stopTime);
	relay.write(1); // turn relay on

    // loop until time to turn off
    // if longer than 1 min, 50 sec, will disconnect from WiFi
   while (hardware.millis() < stopTime){
		// every minute passes, send log
        if ((hardware.millis()-currentTime)%min2millisec == 0){
            server.log((hardware.millis()-currentTime)/min2millisec + " minutes have passed")
        }
        // let pressing the button cancel the timer
        if (button.read() == 1) { // button has been pressed
    		while (button.read() == 1) {} // wait til button has been released
    		imp.sleep(0.2); // delay by 200ms to prevent debounce
    		server.log("Timer interrupted by button");
    		break;
        }
    }

    // will turn off after delay or if button pressed
	relay.write(0); // turn relay off
}

// configure button to be a digital input that is pulled down to ground
// and if it is pressed (and pulled up to 3.3V) go to function toggleRelay()
button.configure(DIGITAL_IN_PULLDOWN, toggleRelay);

// register a handler for "relay" messages from the agent
agent.on("relay", setRelay);

// register a handler for "cups" messages from the agent
agent.on("cups", setTime);

// Define the disconnection handler
function disconnectHandler(reason){
    if (reason != SERVER_CONNECTED){
        // attempt to reconnect
        server.connect(disconnectHandler, 60)
    }
    else{
        // Server is connected
        server.log("Device connected")
    }
}

// Register the disconnection handler as the on unexpected disconnect callback
server.onunexpecteddisconnect(disconnectHandler)
