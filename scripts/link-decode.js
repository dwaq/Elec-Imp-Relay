// http://stackoverflow.com/a/2880929
var urlParams;
(window.onpopstate = function () {
    var match,
        pl     = /\+/g,  // Regex for replacing addition symbol with a space
        search = /([^&=]+)=?([^&]*)/g,
        decode = function (s) { return decodeURIComponent(s.replace(pl, " ")); },
        query  = window.location.search.substring(1);

    urlParams = {};
    while (match = search.exec(query))
       urlParams[decode(match[1])] = decode(match[2]);
})();

// http://stackoverflow.com/a/6899293
function addOrUpdateUrlParam(name, value)
{
  var href = window.location.href;
  var regex = new RegExp("[&\\?]" + name + "=");
  if(regex.test(href))
  {
    regex = new RegExp("([&\\?])" + name + "=\\d+");
    window.location.href = href.replace(regex, "$1" + name + "=" + value);
  }
  else
  {
    if(href.indexOf("?") > -1)
      window.location.href = href + "&" + name + "=" + value;
    else
      window.location.href = href + "?" + name + "=" + value;
  }
}

function httpGet(theUrl)
    {
    var xmlHttp = null;

    xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "GET", theUrl, false );
    xmlHttp.send( null );
    return xmlHttp.responseText;
    }

function linkDecode(){
	if (urlParams["relay"] == 1){
        document.getElementById("alerts").innerHTML="<br>The relay is on<br><br>"
		httpGet("https://agent.electricimp.com/"+urlParams["agentURL"]+"?relay=1")
    }
	if (urlParams["relay"] == 0){
        document.getElementById("alerts").innerHTML="<br>The relay is off<br><br>"
		httpGet("https://agent.electricimp.com/"+urlParams["agentURL"]+"?relay=0")
    }
	if (urlParams["cups"] == 2){
        document.getElementById("alerts").innerHTML="<br>The coffee maker will make 2 cups<br><br>"
		httpGet("https://agent.electricimp.com/"+urlParams["agentURL"]+"?cups=2")
    }
	if (urlParams["cups"] == 3){
        document.getElementById("alerts").innerHTML="<br>The coffee maker will make 3 cups<br><br>"
		httpGet("https://agent.electricimp.com/"+urlParams["agentURL"]+"?cups=3")
    }
	if (urlParams["cups"] == 4){
        document.getElementById("alerts").innerHTML="<br>The coffee maker will make 4 cups<br><br>"
		httpGet("https://agent.electricimp.com/"+urlParams["agentURL"]+"?cups=4")
    }
}

function agentURLalert(){
	if (urlParams["agentURL"] == null){
		document.getElementById("alerts").innerHTML="<br>The agent URL parameter is missing.<br>Please update the link to include<br>?agentURL=xxxxxxxxxxxx<br><br>"
	}
}


