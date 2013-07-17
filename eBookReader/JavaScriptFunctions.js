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
        //sel.removeAllRanges();
        sel.addRange(selRange);
        document.execCommand(command, false, color_string);
        //sel.removeAllRanges();
        document.designMode = "off";
    }
}

function removeRange(){
    var selection = window.getSelection();
    selection.removeAllRanges();
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


function initListener() {
    var node,
    range,
    offset,
    clientX,
    clientY;
    document.addEventListener("DOMContentLoaded", function() {
                              document.body.addEventListener("touchstart", function(event) {
                                                             var selection = window.getSelection();
                                                             selection.removeAllRanges();
                                                            clientX = event.touches[0].clientX;
                                                             clientY = event.touches[0].clientY;
                                                             
                                                             range = document.caretRangeFromPoint(clientX, clientY);
                                                             node = range.startContainer;
                                                             offset = range.startOffset;
                                                             
                                                             document.body.contentEditable = "true";
                                                             event.preventDefault();
                                                             });
                              document.body.addEventListener("touchmove", function(event) {
                                                             var selection = window.getSelection(),
                                                             range = document.caretRangeFromPoint(event.touches[0].clientX, event.touches[0].clientY),
                                                             newRange = document.createRange();
                                                             
                                                             if(clientY < event.touches[0].clientY) {
                                                             newRange.setStart(node, offset);
                                                             newRange.setEnd(range.startContainer, range.startOffset);
                                                             }
                                                             else {
                                                             newRange.setStart(range.startContainer, range.startOffset);
                                                             newRange.setEnd(node, offset);
                                                             }
                                                             
                                                             selection.removeAllRanges();
                                                             selection.addRange(newRange);
                                                             
                                                             event.preventDefault();
                                                             });
                              document.body.addEventListener("touchend", function(event) {
                                                             document.body.contentEditable = "false";
                                                             event.preventDefault();
                                                             });
                              });
}






