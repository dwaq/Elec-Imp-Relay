// used to open all links inside the app
// http://stackoverflow.com/questions/2898740/iphone-safari-web-app-opens-links-in-new-window
var a=document.getElementsByTagName("a");
for(var i=0;i<a.length;i++)
{
    a[i].onclick=function()
    {
	window.location=this.getAttribute("href");
	return false
    }
}


