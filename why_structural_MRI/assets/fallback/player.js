function loc(a){return a}function static_url(a){return a}var currentEventTimeline=0;var currentNavigationEvent=0;var MAX_SLIDE=0;var delegate=null;var kPropertyName_currentSlide="currentSlide";var kSlideLabel=loc("Slide","Prefix label for 'Slide I/N' display");var showUrl="..";var isEmbedded=getUrlParameter("embed")=="1";function fallbackPlayerOnload(){var a=new Date();new Ajax.Request(("../kpf.json"),{method:"get",onSuccess:function(b){scriptDidDownload(b)},onFailure:function(b){scriptDidNotDownload(b)}})}function preloadImage(b){var a=new Image();a.src=b}function scriptDidDownload(transport){extractDelegateFromUrlParameter();this.showScript=eval("("+transport.responseText+")");MAX_SLIDE=showScript.navigatorEvents.length;document.observe("keydown",function(event){handleKeyDownEvent(event)});if(!isEmbedded){document.observe("mousedown",function(event){handleMouseDownEvent(event)})}else{$(playback).observe("click",function(event){handleMouseDownEvent(event)})}window.onresize=function(event){handleWindowResizeEvent(event,true)};this.hud=document.getElementById("hud");this.hud.onmouseover=function(event){self.handleMouseOverHUD(event)};$(this.hud).observe("mouseleave",function(event){self.handleMouseOutHUD(event)});Event.observe(document,"mousemove",function(event){self.handleMouseMove(event)});this.hudNextButton=document.getElementById("hudNextButton");this.hudPreviousButton=document.getElementById("hudPreviousButton");this.hudCloseButton=document.getElementById("hudCloseButton");$(this.hudNextButton).observe("click",function(event){handleHudNext()});$(this.hudPreviousButton).observe("click",function(event){handleHudPrevious()});$(this.hudCloseButton).observe("click",function(event){delegate.showExited()});if(isEmbedded){$(embeddedControls_Next).observe("click",function(event){handleHudNext()});$(embeddedControls_Previous).observe("click",function(event){handleHudPrevious()});$(embeddedControls_Restart).observe("click",function(event){setPlayheadByNavigationEvent(0);loadEventTimeline(currentEventTimeline,true)})}preloadImage(static_url("left_arrow_d.png"));preloadImage(static_url("left_arrow_n.png"));preloadImage(static_url("left_arrow_p.png"));preloadImage(static_url("right_arrow_d.png"));preloadImage(static_url("right_arrow_n.png"));preloadImage(static_url("right_arrow_p.png"));preloadImage(static_url("close_d.png"));preloadImage(static_url("close_n.png"));preloadImage(static_url("close_p.png"));handleWindowResizeEvent(null,false);var startingSlide=Math.max(getUrlParameter("currentSlide")-1,0);setPlayheadByNavigationEvent(startingSlide);loadEventTimeline(currentEventTimeline,true);if(delegate!=null){delegate.showDidLoad()}}function scriptDidNotDownload(a){}var kKeyCode_Space=32;var kKeyCode_Escape=27;var kKeyCode_LeftArrow=37;var kKeyCode_UpArrow=38;var kKeyCode_RightArrow=39;var kKeyCode_DownArrow=40;var kKeyCode_OpenBracket=219;var kKeyCode_CloseBracket=221;var kKeyCode_Home=36;var kKeyCode_End=35;var kKeyCode_PageUp=33;var kKeyCode_PageDown=34;var kKeyCode_Return=13;var kKeyCode_N=78;var kKeyCode_P=80;var kKeyCode_Delete=46;function handleKeyDownEvent(c){var b=c.charCode||c.keyCode;var a={altKey:!!c.altKey,ctrlKey:!!c.ctrlKey,shiftKey:!!c.shiftKey,metaKey:!!c.metaKey};if(a.metaKey){return}Event.stop(c);executeKeyDown(b,a)}function executeKeyDown(b,a){if(a.shiftKey){switch(b){case kKeyCode_DownArrow:case kKeyCode_RightArrow:b=kKeyCode_CloseBracket;break;case kKeyCode_UpArrow:case kKeyCode_LeftArrow:b=kKeyCode_OpenBracket;break}}switch(b){case kKeyCode_Space:case kKeyCode_DownArrow:case kKeyCode_RightArrow:case kKeyCode_N:setPlayheadByEventTimeline(currentEventTimeline+1,true);loadEventTimeline(currentEventTimeline,true);break;case kKeyCode_LeftArrow:case kKeyCode_UpArrow:case kKeyCode_P:goBackBySlide();break;case kKeyCode_CloseBracket:setPlayheadByNavigationEvent(currentNavigationEvent+1);loadEventTimeline(currentEventTimeline,true);break;case kKeyCode_OpenBracket:setPlayheadByEventTimeline(currentEventTimeline-1,true);loadEventTimeline(currentEventTimeline,true);break;case kKeyCode_Home:setPlayheadByNavigationEvent(0);loadEventTimeline(currentEventTimeline,true);break;case kKeyCode_End:setPlayheadByNavigationEvent(showScript.navigatorEvents.length-1);loadEventTimeline(currentEventTimeline,true);break;case kKeyCode_Escape:delegate.showExited();break}}function handleMouseDownEvent(a){if(a!=null){Event.stop(a)}if(inHyperlink){return}if(!mouseIsOverHUD){setPlayheadByEventTimeline(currentEventTimeline+1,true);loadEventTimeline(currentEventTimeline,true)}}function handleHudPrevious(a){goBackBySlide()}function handleHudNext(a){setPlayheadByEventTimeline(currentEventTimeline+1,true);loadEventTimeline(currentEventTimeline,true)}function goBackBySlide(){var a=showScript.navigatorEvents[currentNavigationEvent].eventIndex;if(a!=currentEventTimeline){setPlayheadByEventTimeline(a)}else{setPlayheadByNavigationEvent(Math.max(0,currentNavigationEvent-1))}loadEventTimeline(currentEventTimeline,true)}function handleURLClick(b,a){Event.stop(b);var c=a.substr(7);c--;setPlayheadByNavigationEvent(c);loadEventTimeline(currentEventTimeline,true);inHyperlink=false}var scaleFactor=1;var kEmbeddeControlBar_EndCapWidth=10;var kEmbeddeControlBar_GapBelowShow=1;var kEmbeddedControlBar_Height=30;var kEmbeddedControlBar_ButtonWidth=35;var kEmbeddedControlBar_iWorkLogoWidth=95;var kEmbeddedControlBar_LinkToPresentationWidth=250;var kEmbeddedControlBar_SlideCounterWidth=80;function handleWindowResizeEvent(v,B){var n=document.getElementById("playback");var m=showScript.slideWidth;var l=showScript.slideHeight;var b=window;var d=document;var o=0;var u=0;if(!window.innerWidth){if(!(document.documentElement.clientWidth==0)){o=document.documentElement.clientWidth;u=document.documentElement.clientHeight}else{o=document.body.clientWidth;u=document.body.clientHeight}}else{o=window.innerWidth;u=window.innerHeight}if(!isEmbedded){u=(u-(kHeightOfHUD+kMinGapBetweenStageAndHUD))}else{o-=2}if(!isEmbedded){scaleFactor=Math.min(o/m,u/l,1)}else{scaleFactor=o/m}if(scaleFactor<=0){scaleFactor=1}var i=(o/2)-(m*scaleFactor*0.5);n.style.top="0px";n.style.left=i+"px";n.style.width=m*scaleFactor+"px";n.style.height=l*scaleFactor+"px";n.style.position="absolute";n.style.overflow="hidden";n.style.display="block";if(isEmbedded){var j=l*scaleFactor;var z=o;var t=document.getElementById("embed_background");t.style.top="0px";t.style.left="0px";t.style.width=o+2+"px";t.style.height=u+"px";n.style.top="0px";n.style.left="0px";n.style.width=z+"px";n.style.height=j+"px";n.style.border="1px solid #000000";var y=document.getElementById("embeddedControlBar");var k=document.getElementById("embeddedControls_Previous");var f=document.getElementById("embeddedControls_Next");var c=document.getElementById("embeddedSlideCounterSection");y.style.top=j+kEmbeddeControlBar_GapBelowShow+"px";y.style.left="0px";y.style.width=z+2+"px";y.style.height=kEmbeddedControlBar_Height+"px";embeddedControlBarBezel_Filler.style.width=(z-2*kEmbeddeControlBar_EndCapWidth)+2+"px";embeddedControlBarBezel_RightEndCap.style.left=(z+2)-kEmbeddeControlBar_EndCapWidth+"px";var s=(z+2)/2;k.style.left=s-kEmbeddedControlBar_SlideCounterWidth/2-kEmbeddedControlBar_ButtonWidth+"px";f.style.left=s+kEmbeddedControlBar_SlideCounterWidth/2+"px";c.style.left=s-kEmbeddedControlBar_SlideCounterWidth/2+"px";y.style.display="block";t.style.display="block"}var r=document.getElementById("waitingIndicator");r.style.left=i+((m*scaleFactor/2)-55)+"px";r.style.top=(l*scaleFactor/2)-55+"px";if(!isEmbedded){var e=document.getElementById("hud");var h=(o-kWidthOfHUD)/2;var x=(l*scaleFactor)+kMinGapBetweenStageAndHUD;e.style.left=h+"px";e.style.top=x+"px"}if(B){var q=this.showScript.eventTimelines[currentEventTimeline].eventInitialStates;var w=q.length;for(var g=0;g<w;g++){var A=q[g];if(A.hidden==false&&A.opacity>0){var a=showUrl+"/"+this.showScript.textures[A.texture].url;var p=textureLoaderDictionary[A.texture];setTextureElementPosition(p,A)}}}}function handleLinkControl(){var a="http://public.iwork.com/document/?a="+getUrlParameter("a")+"&d="+getUrlParameter("d");window.open(a,"_top")}var gShowController={gotoSlide:function(a){setPlayheadByNavigationEvent(a-1);loadEventTimeline(currentEventTimeline,true)},getProperty:function(a){if(a=="currentSlide"){return currentNavigationEvent+1}},onKeyPress:function(b,a){executeKeyDown(b,a)},onMouseDown:function(a){handleMouseDownEvent(null)}};function setSpinnerVisibility(a){if(spinnerTimeoutID!=null){clearTimeout(spinnerTimeoutID);spinnerTimeoutID=null}if(a==false){document.getElementById("waitingIndicator").style.visibility="hidden";document.getElementById("waitingSpinner").style.visibility="hidden"}else{document.getElementById("waitingIndicator").style.visibility="visible";document.getElementById("waitingSpinner").style.visibility="visible"}}var spinnerTimeoutID=null;function showSpinnerIn(a){if(spinnerTimeoutID==null){spinnerTimeoutID=setTimeout(function(){setSpinnerVisibility(true)},a*1000)}}function hideSpinner(){setSpinnerVisibility(false)}function setPlayheadByEventTimeline(a,b){if(this.showScript.loopSlideshow==1&&a>=showScript.eventTimelines.length){a=0}if(a<0||a>=showScript.eventTimelines.length){trace("trying to access a timeline off the end [setPlayheadByEventTimeline]");return false}currentEventTimeline=a;if(b){setNavigationEventByEventTimeline(currentEventTimeline)}updateHUD();return true}function setPlayheadByNavigationEvent(b){if(this.showScript.loopSlideshow==1){if(b>=MAX_SLIDE){b=0}}if(b>=MAX_SLIDE){trace("trying to access a timeline off the end [setPlayheadByNavigationEvent]");return false}var a=showScript.navigatorEvents[b].eventIndex;if(setPlayheadByEventTimeline(a,false)){currentNavigationEvent=b;if(!isEmbedded){if(delegate!=null){delegate.propertyChanged(kPropertyName_currentSlide,currentNavigationEvent+1)}}updateHUD();return true}else{return false}}function setNavigationEventByEventTimeline(d){var c=showScript.navigatorEvents.length;var b=showScript.eventTimelines.length;var e=currentNavigationEvent;var g=1;if(d<showScript.navigatorEvents[e].eventIndex){g=-1}while(true){var a=showScript.navigatorEvents[e].eventIndex;var f=b;if((e+1)<c){f=showScript.navigatorEvents[e+1].eventIndex-1}if(a<=d&&d<=f){break}e+=g}if(currentNavigationEvent!=e){currentNavigationEvent=e;if(!isEmbedded){if(delegate!=null){delegate.propertyChanged(kPropertyName_currentSlide,currentNavigationEvent+1)}}}updateHUD()}function updateHUD_regular(){var c=document.getElementById("hudPreviousButton");var a=document.getElementById("hudNextButton");if(currentEventTimeline==0){if(c.hasClassName("hudPreviousButtonEnabled")){c.removeClassName("hudPreviousButtonEnabled")}c.addClassName("hudPreviousButtonDisabled")}else{if(c.hasClassName("hudPreviousButtonDisabled")){c.removeClassName("hudPreviousButtonDisabled")}c.addClassName("hudPreviousButtonEnabled")}if(currentEventTimeline==(showScript.eventTimelines.length-1)){if(a.hasClassName("hudNextButtonEnabled")){a.removeClassName("hudNextButtonEnabled")}a.addClassName("hudNextButtonDisabled")}else{if(a.hasClassName("hudNextButtonDisabled")){a.removeClassName("hudNextButtonDisabled")}a.addClassName("hudNextButtonEnabled")}var b=document.getElementById("hudSlideCounter");b.innerHTML="<font color='#FFFFFF'>"+kSlideLabel+" "+(currentNavigationEvent+1)+" / "+MAX_SLIDE+"</font>"}function updateHUD_embed(){var d=document.getElementById("embeddedControls_Restart");var b=document.getElementById("embeddedControls_Previous");var c=document.getElementById("embeddedControls_Next");if(currentEventTimeline==0){if(b.hasClassName("embeddedControls_Previous_Enabled")){b.removeClassName("embeddedControls_Previous_Enabled")}b.addClassName("embeddedControls_Previous_Disabled");if(d.hasClassName("embeddedControls_Restart_Enabled")){d.removeClassName("embeddedControls_Restart_Enabled")}d.addClassName("embeddedControls_Restart_Disabled")}else{if(b.hasClassName("embeddedControls_Previous_Disabled")){b.removeClassName("embeddedControls_Previous_Disabled")}b.addClassName("embeddedControls_Previous_Enabled");if(d.hasClassName("embeddedControls_Restart_Disabled")){d.removeClassName("embeddedControls_Restart_Disabled")}d.addClassName("embeddedControls_Restart_Enabled")}if(currentEventTimeline==(showScript.eventTimelines.length-1)){if(c.hasClassName("embeddedControls_Next_Enabled")){c.removeClassName("embeddedControls_Next_Enabled")}c.addClassName("embeddedControls_Next_Disabled")}else{if(c.hasClassName("embeddedControls_Next_Disabled")){c.removeClassName("embeddedControls_Next_Disabled")}c.addClassName("embeddedControls_Next_Enabled")}var a=document.getElementById("embeddedSlideCounter");a.innerHTML="<font color='#FFFFFF'>"+(currentNavigationEvent+1)+" / "+MAX_SLIDE+"</font>"}function updateHUD(){if(!isEmbedded){updateHUD_regular()}else{updateHUD_embed()}}var textureLoaderDictionary=new Array();var preloadingList=new Array();var preloadingListCount=0;var loading=false;var preloading=false;var loadingCount=0;function setLoading(a){loadingCount++;loading=a}function setPreloading(a){preloading=a}function scaledXValue(b,d,c){var a=(c[0]*b)+(c[2]*d)+c[4];a*=scaleFactor;return a}function scaledYValue(b,d,c){var a=(c[1]*b)+(c[3]*d)+c[5];a*=scaleFactor;return a}function setTextureElementPosition(j,g){if(this.showScript.textures[g.texture].movieUrl&&0==g.affineTransform[1]&&0==g.affineTransform[2]){var e=this.showScript.textures[g.texture].width;var o=this.showScript.textures[g.texture].height;var f=scaledXValue(-e/2,-o/2,g.affineTransform);var d=scaledXValue(e/2,-o/2,g.affineTransform);var b=scaledXValue(-e/2,o/2,g.affineTransform);var p=scaledXValue(e/2,o/2,g.affineTransform);var n=scaledYValue(-e/2,-o/2,g.affineTransform);var m=scaledYValue(e/2,-o/2,g.affineTransform);var l=scaledYValue(-e/2,o/2,g.affineTransform);var k=scaledYValue(e/2,o/2,g.affineTransform);var i=Math.min(f,d,b,p);var c=Math.max(f,d,b,p);var h=Math.min(n,m,l,k);var a=Math.max(n,m,l,k);j.style.left=i+(e*scaleFactor/2)+"px";j.style.top=h+(o*scaleFactor/2)+"px";j.style.width=c-i+"px";j.style.height=a-h+"px"}else{j.style.left=g.affineTransform[4]*scaleFactor+"px";j.style.top=g.affineTransform[5]*scaleFactor+"px";j.style.width=this.showScript.textures[g.texture].width*scaleFactor+"px";j.style.height=this.showScript.textures[g.texture].height*scaleFactor+"px"}}function loadEventTimeline(f,g){if(loading){return}setLoading(true);var h=this.showScript.eventTimelines[f].eventInitialStates;var c=h.length;preloadingList=new Array();preloadingListCount=0;setPreloading(true);if(g){showSpinnerIn(0.5)}for(var e=0;e<c;e++){var a=h[e];if(a.hidden==false&&a.opacity>0){var d=showUrl+"/"+this.showScript.textures[a.texture].url;if(textureLoaderDictionary[a.texture]==undefined){preloadingListCount++;preloadingList[preloadingListCount-1]=d;var b=document.createElement("img");b.onload=createOnLoadClosure(f,d,g);b.src=d+"?ts="+escape(this.showScript.timestamp);b.style.position="absolute";setTextureElementPosition(b,a);if(a.opacity<1){$(b).setOpacity(a.opacity)}textureLoaderDictionary[a.texture]=b}}}setPreloading(false);if(preloadingListCount==0){if(g){displayEventTimeline(f)}setLoading(false)}}var count=0;function textureLoaded(c,b,d){for(var a=0;a<preloadingListCount;a++){if(b==preloadingList[a]){preloadingList.splice(a,1);preloadingListCount--;break}}if(preloadingListCount==0&&preloading==false){if(d){displayEventTimeline(c)}setLoading(false)}}function displayEventTimeline(g){hideSpinner();var a=document.getElementById("playback");removeChildren(a);var d=this.showScript.eventTimelines[g].eventInitialStates;var i=d.length;for(var h=0;h<i;h++){var c=d[h];if(c.hidden==false&&c.opacity>0){var b=showUrl+"/"+this.showScript.textures[c.texture].url;var e=textureLoaderDictionary[c.texture];setTextureElementPosition(e,c);a.appendChild(e)}}if(this.showScript.eventTimelines[g].hyperlinks){var f=this.showScript.eventTimelines[g].hyperlinks;for(var h=0;h<f.length;h++){var e=document.createElement("a");e.style.position="absolute";e.style.left=f[h].targetRectangle.x*scaleFactor+"px";e.style.top=f[h].targetRectangle.y*scaleFactor+"px";e.style.width=f[h].targetRectangle.width*scaleFactor+"px";e.style.height=f[h].targetRectangle.height*scaleFactor+"px";e.href="#";a.appendChild(e);$(e).observe("mouseover",function(j){inHyperlink=true});$(e).observe("mouseout",function(j){inHyperlink=false});if(f[h].url.indexOf("http:")==0){e.href=f[h].url;e.target="_blank"}else{if(f[h].url.indexOf("mailto:")==0){e.href=f[h].url}else{createHyperlinkClosure($(e),f[h].url)}}}}}var inHyperlink=false;function getUrlParameter(b){b=b.replace(/[\[]/,"\\[").replace(/[\]]/,"\\]");var a="[\\?&]"+b+"=([^&#]*)";var c=new RegExp(a);var d=c.exec(window.location.href);if(d==null){return""}else{return d[1]}}function extractDelegateFromUrlParameter(){if(isEmbedded){this.delegeate=null;return}var a="";var d=getUrlParameter("delegate");if((d=="")||(d==null)||(typeof(d)=="undefined")){delegate=null;return}var c=d.indexOf(".");delegate=window;while(c!=-1){var b=d.substring(0,c);delegate=delegate[b];d=d.substring(c+1);c=d.indexOf(".")}delegate=delegate[d]}function removeChildren(a){if(!a){return false}if(typeof(a)=="string"){a=xGetElementById(a)}while(a.hasChildNodes()){a.removeChild(a.firstChild)}return true}function createOnLoadClosure(b,a,c){return function(){textureLoaded(b,a,c)}}function createHyperlinkClosure(b,a){b.observe("click",function(c){handleURLClick(c,a)})}function trace(a){if(window.console!=undefined){window.console.log(a)}}var kWidthOfHUD=360;var kHeightOfHUD=59;var kMinGapBetweenStageAndHUD=8;var kTimeoutValueForHUD=1000;var hudIsShowing=false;var mouseIsOverHUD=false;function showHUD(){if(isEmbedded){return}var a=document.getElementById("hud");a.style.visibility="visible";hudIsShowing=true;setTimeoutForHUD()}function hideHUD(){if(isEmbedded){return}var a=document.getElementById("hud");a.style.visibility="hidden";hudIsShowing=false}function setTimeoutForHUD(){if(this.hudTimeout){clearTimeout(this.hudTimeout)}var a=this;this.hudTimeout=setTimeout(function(){a.handleTimeoutForHUD()},kTimeoutValueForHUD)}function handleTimeoutForHUD(){if(!this.mouseIsOverHUD){hideHUD()}}function handleMouseOverHUD(a){this.mouseIsOverHUD=true}function handleMouseOutHUD(a){this.mouseIsOverHUD=false}var prevEvent=null;function handleMouseMove(a){if(prevEvent!=null){var b=Math.abs(Event.pointerX(a)-Event.pointerX(prevEvent))+Math.abs(Event.pointerY(a)-Event.pointerY(prevEvent));if(b>10){showHUD()}}prevEvent=a};
