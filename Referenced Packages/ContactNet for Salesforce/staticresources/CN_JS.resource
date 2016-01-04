function displayNextPageLoadingIcon(pageLoadImgId) {
	var ele = document.getElementById(pageLoadImgId);
	ele.style.display = "block";
}

function showHide(toShowEleId, toHideEleId) { 
	if (toShowEleId != '') {
		var toShowEle = document.getElementById(toShowEleId);
		if (toShowEle) {
	   		toShowEle.style.display = "";
	   	}
   	}
	
	if (toHideEleId != '') {
		var toHideEle = document.getElementById(toHideEleId);
		if (toHideEle) {
			toHideEle.style.display = "none";  
		}
	}
} 

function showHideAlt(toShowEleId, toHideEleId) {
	if (toShowEleId != '') {
		var toShowEle = document.getElementById(toShowEleId);
		if (toShowEle) {
	   		toShowEle.style.visibility = "visible";
	   	}
   	}
	
	if (toHideEleId != '') {
		var toHideEle = document.getElementById(toHideEleId);
		if (toHideEle) {
			toHideEle.style.visibility = "hidden";
		}
	}
} 

function showInnerTable(outerTableId, hiddenRowIndex, actionLinkEle, hiddenRelIconId, iconId) {
	if (actionLinkEle) actionLinkEle.style.display = "none";
				 
	var hiddenRelIconId = 'thePage:theForm:theBlock:' + outerTableId + ':' + (hiddenRowIndex-1) + ':' + hiddenRelIconId; 
	var hiddenRelIconEle = document.getElementById(hiddenRelIconId); 
	if (hiddenRelIconEle) {
		hiddenRelIconEle.style.display = "block";
	}
	
	var hiddenRowId = 'thePage:theForm:theBlock:' + outerTableId + ':' + hiddenRowIndex + ':hiddenRow'; //alert(hiddenRowId);
	var hiddenRowEle = document.getElementById(hiddenRowId); //alert(hiddenRowEle);
	if(hiddenRowEle.style.display == "none") {  
    	hiddenRowEle.style.display = "";   
  	}
	else { 
		hiddenRowEle.style.display = "none"; 
	}
	
	//change image title
	if (iconId != null) {
		var iconEleId = 'thePage:theForm:theBlock:' + outerTableId + ':' + (hiddenRowIndex-1) + ':' + iconId; 
		var iconEle = document.getElementById(iconEleId); 
		if (iconEle) {
			var iconTitle = iconEle.title;
			if (iconTitle.indexOf('Show') != -1) {
				iconTitle = iconTitle.replace('Show', 'Hide');
			}
			else {
				iconTitle = iconTitle.replace('Hide', 'Show');
			}
			iconEle.title = iconTitle;
		}
	}
}

function displayInnerTable(rowIndex, mainTableId, outerTempPanelId) {
	var outerDivEle = document.getElementById('thePage:theForm:theBlock:' + outerTempPanelId); //alert(outerDivEle);
	var innerHiddenRow = document.getElementById('thePage:theForm:theBlock:' + mainTableId + ':' + rowIndex + ':hiddenRow'); //alert(innerHiddenRow);
	if (outerDivEle && innerHiddenRow) {
		innerHiddenRow.innerHTML = outerDivEle.innerHTML; 
		innerHiddenRow.style.display = "";
	}
}


var colleagueRecentHeight = 0;
var contactRecentHeight = 0;

function resizeWindow(tabName) {
	try {
	    var thisWindow = window.name;
	    if(thisWindow && parent && parent.document){
	        var iframes = parent.document.getElementsByName(thisWindow);
	        if (iframes && iframes.length == 1) {
	            var height = document.body.scrollHeight;
				if (tabName == 'Colleague') {
		           	iframes[0].style.height = height + "px";
					colleagueRecentHeight = height;
				}
				else if (tabName == 'Contact') {
		           	iframes[0].style.height = height + "px";
					contactRecentHeight = height;
				}
	        }
	    }
    }
    catch (err) {
    	//do nothing as it could be related to cross site scripting error
    }
}
  
function resizeWindowToMostRecentHeight(tabName) {
	try {
		var heightToSet = 0;
		if (tabName == 'Colleague' && colleagueRecentHeight > 0) {
			heightToSet = colleagueRecentHeight;
		}
		else if (tabName == 'Contact' && contactRecentHeight > 0) {
			heightToSet = contactRecentHeight;
		}
		
	    var thisWindow = window.name;
	    if(thisWindow && parent && parent.document){ 
	        var iframes = parent.document.getElementsByName(thisWindow);
	        if (iframes && iframes.length == 1) {
	       		iframes[0].style.height = heightToSet + "px";
	        }  
	    }
    }
    catch (err) {
    	//do nothing as it could be related to cross site scripting error
    }
}

function makeCursorWait() {
	document.body.style.cursor = "wait";
}

function makeCursorAuto() {
	document.body.style.cursor = "auto";
}

