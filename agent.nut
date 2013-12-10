// Log the URLs we need to do the switching
server.log("Turn Relay On: " + http.agenturl() + "?relay=1");
server.log("Turn Relay Off: " + http.agenturl() + "?relay=0");
 
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
    // send a response back saying everything was OK.
    response.send(200, "OK");
  } catch (ex) {
    response.send(500, "Internal Server Error: " + ex);
  }
}
 
// register the HTTP handler
http.onrequest(requestHandler);