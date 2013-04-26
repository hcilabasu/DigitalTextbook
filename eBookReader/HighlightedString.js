//
//  HighlightedString.js
//  eBookReader
//
//  Created by Shang Wang on 3/28/13.
//  Copyright (c) 2013 Andreea Danielescu. All rights reserved.
//
var selectedText = "";
function getHighlightedString() {
    var text        = window.getSelection();
   // selectedText=text;
    selectedText    = text.anchorNode.textContent.substr(text.anchorOffset, text.focusOffset - text.anchorOffset);

}

function removeSelection(){
    window.getSelection().removeAllRanges();
    window.getSelection().empty();
}

// mark selected text in yellow
function stylizeHighlightedString() {
    var sel = window.getSelection();
    if (!sel.isCollapsed) {
        var selRange = sel.getRangeAt(0);
        document.designMode = "on";
        sel.removeAllRanges();
        sel.addRange(selRange);
        document.execCommand("HiliteColor", false, "#ffffcc");
        sel.removeAllRanges();
        document.designMode = "off";
    }
}


// mark selected text in green
function stylizeHighlightedStringGreen() {  
    var sel = window.getSelection();
    if (!sel.isCollapsed) {
        var selRange = sel.getRangeAt(0);
        document.designMode = "on";
        sel.removeAllRanges();
        sel.addRange(selRange);
        document.execCommand("HiliteColor", false, "#C5FCD6");
        sel.removeAllRanges();
        document.designMode = "off";
    }
}



// mark selected text in blue
function stylizeHighlightedStringBlue() { 
    var sel = window.getSelection();
    if (!sel.isCollapsed) {
        var selRange = sel.getRangeAt(0);
        document.designMode = "on";
        sel.removeAllRanges();
        sel.addRange(selRange);
        document.execCommand("HiliteColor", false, "#C2E3FF");
        sel.removeAllRanges();
        document.designMode = "off";
    }
}


// mark selected text in purple
function stylizeHighlightedStringPurple() {  
    var sel = window.getSelection();
    if (!sel.isCollapsed) {
        var selRange = sel.getRangeAt(0);
        document.designMode = "on";
        sel.removeAllRanges();
        sel.addRange(selRange);
        document.execCommand("HiliteColor", false, "#E8CDFA");
        sel.removeAllRanges();
        document.designMode = "off";
    }
}

// mark selected text in red
function stylizeHighlightedStringRed() {  
    var sel = window.getSelection();
    if (!sel.isCollapsed) {
        var selRange = sel.getRangeAt(0);
        document.designMode = "on";
        sel.removeAllRanges();
        sel.addRange(selRange);
        document.execCommand("HiliteColor", false, "#FFBABA");
        sel.removeAllRanges();
        document.designMode = "off";
    }
}


// underline the seleced text
function underlineText() {
    var sel = window.getSelection();
    if (!sel.isCollapsed) {
        var selRange = sel.getRangeAt(0);
        document.designMode = "on";
        sel.removeAllRanges();
        sel.addRange(selRange);
        document.execCommand("underline", false, "#FFBABA");
        sel.removeAllRanges();
        document.designMode = "off";
    }
}

// clear the format
function clearFormat() {
    var sel = window.getSelection();
    if (!sel.isCollapsed) {
        var selRange = sel.getRangeAt(0);
        document.designMode = "on";
        sel.removeAllRanges();
        sel.addRange(selRange);
        document.execCommand("hiliteColor", false, "white");
        sel.removeAllRanges();
        document.designMode = "off";
    }
}



////////////////////////////////////////////////////////////////////////////////

// helper function, recursively removes the highlights in elements and their childs
function uiWebview_RemoveAllHighlightsForElement(element) {
    if (element) {
        if (element.nodeType == 1) {
            if (element.getAttribute("class") == "uiWebviewHighlight") {
                var text = element.removeChild(element.firstChild);
                element.parentNode.insertBefore(text,element);
                element.parentNode.removeChild(element);
                return true;
            } else {
                var normalize = false;
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    if (uiWebview_RemoveAllHighlightsForElement(element.childNodes[i])) {
                        normalize = true;
                    }
                }
                if (normalize) {
                    element.normalize();
                }
            }
        }
    }
    return false;
}


// the main entry point to remove the highlights
function uiWebview_RemoveAllHighlights() {
    selectedText = "";
    uiWebview_RemoveAllHighlightsForElement(document.body);
}