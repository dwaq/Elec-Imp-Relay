function requestHandler(request, response) {
  try {
    // check if the user sent relay as a query parameter
    if ("relay" in request.query) {
      // if they did, and relay=1.. set our variable to 1
      if (request.query.relay == "1" || request.query.relay == "0") {
        // convert the relay query parameter to an integer
        local relayState = request.query.relay.tointeger();
        // send "relay" message to device, and send relayState as the data
        device.send("relay", relayState); 
      }
    }
    // check if the user sent cups as a query parameter
    if ("cups" in request.query) {
      // if they did, and cups=2.. set our variable to 2
      if (request.query.cups == "2" || request.query.cups == "3" || request.query.cups == "4") {
        // convert the cups query parameter to an integer
        local numberCups = request.query.cups.tointeger();
        // send "cups" message to device, and send numberCups as the data
        device.send("cups", numberCups); 
      }
    }
    // send a response back saying everything was OK.
    response.send(200, "OK");
  } catch (ex) {
    response.send(500, "Internal Server Error: " + ex);
  }
}
 
// register the HTTP handler
http.onrequest(requestHandler);