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
    selectedText    = text.anchorNode.textContent.substr(text.anchorOffset, text.focusOffset - text.anchorOffset);

}

function removeSelection(){
    window.getSelection().removeAllRanges();
    window.getSelection().empty();
}

//use the document.execCommand method to edit the text.
function formatText(command, color_string) {
    var sel = window.getSelection();
    if (!sel.isCollapsed) {
        var selRange = sel.getRangeAt(0);
        document.designMode = "on";
        sel.removeAllRanges();
        sel.addRange(selRange);
        document.execCommand(command, false, color_string);
        sel.removeAllRanges();
        document.designMode = "off";
    }
}

// mark selected text in different colors
function highlightStringWithColor(color_string) {
    formatText("HiliteColor",color_string);
}


// underline the seleced text
function underlineText() {
    formatText("underline","#FFBABA");
}

// clear the format
function clearFormat() {
    formatText("HiliteColor","white");
}


// the main entry point to remove the highlights
function uiWebview_RemoveAllHighlights() {
    selectedText = "";
    uiWebview_RemoveAllHighlightsForElement(document.body);
}