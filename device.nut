// create a global variable called relay, and assign pin9 to it
relay <- hardware.pin9

// configure relay to be a digital output
relay.configure(DIGITAL_OUT)

// create a global variable called button, and assign pin1 to it
button <- hardware.pin1

// variable to convert minutes to seconds
min2sec <- 60

// used to store how long the relay will stay on
onTime <- 0


// function to toggle relay from the switch
function toggleRelay() {
	if (button.read() == 1) { // button has been pressed
		while (button.read() == 1) {} // wait til button has been released
		imp.sleep(0.2) // delay by 200ms to prevent debounce
		relay.write(1 - relay.read()) // toggle the relay
		server.log("Set relay by button: " + relay.read())
	}
}

// function to turn relay on or off from website
function setRelay(relayState) {
	server.log("Set relay by website: " + relayState)
	relay.write(relayState)
	// also cancel timer from website if turning off
	if (relayState == 0){
		try {
			// cancel timer
			imp.cancelwakeup(timer)
		} catch (ex) {
			// timer hasn't been called yet
			server.log(ex)
		}
	}
}

// function to find out when the relay will turn off, then start timer
// and assign the button to stop timer
function setTimer(numberCups) {
	// convert numberCups to an amount of time in seconds
	onTime = (2.5 + numberCups) * min2sec
	server.log("Set relay timer for " + onTime/min2sec + " minutes")
	// configure button to turn off during timer
	button.configure(DIGITAL_IN_PULLDOWN, cancelTimerByButton)
	// turn relay on
	relay.write(1)
	// create timer
	timer <- imp.wakeup(onTime, turnOffRelay)
}

// function to turn off relay and cancel timer if button is pressed during timer
function cancelTimerByButton(){
	if (button.read() == 1) { // button has been pressed
		while (button.read() == 1) {} // wait til button has been released
		// cancel timer
		imp.cancelwakeup(timer)
		// turn off relay
		relay.write(0)
		server.log("Timer interrupted by button; relay is now off")
		// set button back to normal operation
		button.configure(DIGITAL_IN_PULLDOWN, toggleRelay)
	}
}

// function to turn off relay from timer function
function turnOffRelay() {
	// turn off relay
	relay.write(0)
	server.log("Timer is over; relay is now off")
	// set button back to normal operation
	button.configure(DIGITAL_IN_PULLDOWN, toggleRelay)
}

// configure button to be a digital input that is pulled down to ground
// and if it is pressed (and pulled up to 3.3V) go to function toggleRelay()
button.configure(DIGITAL_IN_PULLDOWN, toggleRelay)

// register a handler for "relay" messages from the agent
agent.on("relay", setRelay)

// register a handler for "cups" messages from the agent
agent.on("cups", setTimer)
