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

var MyNodeCount=0;
var MyNodeCountFind=0;
var MyApp_SearchResultCount = 0;
var sel = window.getSelection();
var newHighlightRange;
var isCountReturn=0;
var enterChild=0
//var startElement=sel.getRangeAt(0).startContainer;
// We're using a global variable to store the number of occurrences




function myGetNodeCount(element,searchNode){

    
    MyNodeCount=0;
    enterChild=0;
    recurse(document.body,searchNode);
   // alert(enterChild);
    return MyNodeCountFind;
}

function recurse(element,m_searchNode) {
    enterChild++;
    //alert(element.nodeValue);
    if(element.nodeType == 3 &&element.nodeValue!=""){
        MyNodeCount++;
        if (element.isSameNode(m_searchNode))
        {
            MyNodeCountFind=MyNodeCount;
            return;
        }
    }else if (element.childNodes.length > 0) {
        for (var i = 0; i < element.childNodes.length ; i++) {
            recurse(element.childNodes[i],m_searchNode);
          
        }
    }
}


function findRecurse(element,startCount,endCount,startOffsetCound,endOffSetCount) {
    if(element.nodeType == 3 && element.nodeValue!=""){
        MyNodeCount++;
       
        if (MyNodeCount==startCount)
        {
            newHighlightRange.setStart(element, startOffsetCound);
        }
        if(MyNodeCount==endCount){
            newHighlightRange.setEnd(element, endOffSetCount);
        }
    }else if (element.childNodes.length > 0) {
        for (var i = 0; i < element.childNodes.length; i++) {
            findRecurse(element.childNodes[i],startCount,endCount,startOffsetCound,endOffSetCount);
        }
    }
    return;
}
////////////////////////////////////////////////////////////////////

function highlightRangeByOffset(element,startCount,startOffsetCound,endCount,endOffSetCount,color){
    
    
    newHighlightRange=document.createRange();
    isCountReturn=0;
    MyNodeCount=0;
    findRecurse(element,startCount,endCount,startOffsetCound,endOffSetCount);
    var nodes = getNodesInRange(newHighlightRange);

//    var sel = window.getSelection();
//    sel.removeAllRanges();
//     sel.addRange(newHighlightRange);
//     document.designMode = "on";
//    document.execCommand("HiliteColor", false, "#C2E3FF");
//    document.designMode = "off";
    for (i = 0; i < nodes.length; i++)
    {
        var span = document.createElement("span");
        var text =  document.createTextNode(nodes[i].nodeValue.substr(newHighlightRange.startOffset,newHighlightRange.endOffset-newHighlightRange.startOffset));
        span.setAttribute("class","MyLoadHighlightClass");
        if(color!="#000000"){

        span.style.backgroundColor=color;
        }
        span.appendChild(text);
        
        text1 = document.createTextNode(nodes[i].nodeValue.substr(0,newHighlightRange.startOffset));
        
        text = document.createTextNode(nodes[i].nodeValue.substr(newHighlightRange.endOffset));
        
        nodes[i].deleteData(0,nodes[i].nodeValue.length);
        var next = nodes[i].nextSibling;
        nodes[i].parentNode.insertBefore(text1, next);
        nodes[i].parentNode.insertBefore(span, next);
        nodes[i].parentNode.insertBefore(text, next);
    
    }
}






function getNodesInRange(range)
{
    var start = range.startContainer;
    var end = range.endContainer;
    var commonAncestor = range.commonAncestorContainer;
    var nodes = [];
    var node;
    
    // walk parent nodes from start to common ancestor
    for (node = start.parentNode; node; node = node.parentNode)
    {
        if (node.nodeType == 3) //modified to only add text nodes to the array
            nodes.push(node);
        if (node == commonAncestor)
            break;
    }
    nodes.reverse();
    
    // walk children and siblings from start until end is found
    for (node = start; node; node = getNextNode(node))
    {
        if (node.nodeType == 3) //modified to only add text nodes to the array
            nodes.push(node);
        if (node == end)
            break;
    }
    return nodes;
}

function getNextNode(node, end)
{
    if (node.firstChild)
        return node.firstChild;
    while (node)
    {
        if (node.nextSibling)
            return node.nextSibling;
        node = node.parentNode;
    }
}
//////////////////





// helper function, recursively searches in elements and their child nodes
function MyApp_HighlightAllOccurencesOfStringForElement(element,keyword,searchCount) {
    if (element) {
        if (element.nodeType == 3) {        // Text node
            while (true) {
        
                var value = element.nodeValue;  // Search for keyword in text node
                var idx = value.toLowerCase().indexOf(keyword);
                if (idx < 0) break;             // not found, abort
                
               // MyApp_SearchResultCount++;
                var span = document.createElement("span");
                var text = document.createTextNode(value.substr(idx,keyword.length));
                span.appendChild(text);
                span.setAttribute("class",MyApp_SearchResultCount);
               if(searchCount==(++MyApp_SearchResultCount)){
                     //alert(MyApp_SearchResultCount);
                    span.style.backgroundColor="#ffffcc";
                }
                else{
                   span.style.backgroundColor="#C5FCD6";
            }
                text = document.createTextNode(value.substr(idx+keyword.length));
                element.deleteData(idx, value.length - idx);
                var next = element.nextSibling;
                element.parentNode.insertBefore(span, next);
                element.parentNode.insertBefore(text, next);
                element = text;
            }//end of while
        }//end of if (element.nodeType == 3) 
        else if (element.nodeType == 1) { // Element node
            if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    MyApp_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword,searchCount);
                }
            }
        }
    }

}




//////////////////////////////////////
function findCount(){
    var sel = window.getSelection();
    MyApp_SearchResultCount=0;
    MyNodeCount=0;
    var startCtnr=window.getSelection().getRangeAt(0).startContainer;
    var startOffsetCount=window.getSelection().getRangeAt(0).startOffset;
    var keyword=window.getSelection().toString();
    findNodeCount(document.body,keyword,startOffsetCount,startCtnr);
    return MyNodeCount
}


function findNodeCount(element,keyword,offset,container) {
    if (element) {
        if (element.nodeType == 3) {        // Text node
            
            while (true) {
                
                var value = element.nodeValue;  // Search for keyword in text node
                var idx = value.toLowerCase().indexOf(keyword);
                if (idx < 0) break;             // not found, abort
                MyApp_SearchResultCount++;
                if(element.isSameNode(container)&&idx){
                    MyNodeCount=MyApp_SearchResultCount;
                }
                text = document.createTextNode(value.substr(idx+keyword.length));
                element = text;
            }//end of while
        }//end of if (element.nodeType == 3)
        else if (element.nodeType == 1) { // Element node
            if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    findNodeCount(element.childNodes[i],keyword,offset,container)
                }
            }
        }
    }
    
}
///////////////

function HilightSearchEmelemt(element,keyword,searchCount){
    MyApp_SearchResultCount=0;
    MyApp_HighlightAllOccurencesOfStringForElement(element,keyword,searchCount);
}

// the main entry point to start the search
function MyApp_HighlightAllOccurencesOfString(keyword) {
    //MyApp_RemoveAllHighlights();
    //MyApp_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase(),1);
    HilightSearchEmelemt(document.body, keyword.toLowerCase(),1);
}

// helper function, recursively removes the highlights in elements and their childs
function MyApp_RemoveAllHighlightsForElement(element) {
    if (element) {
        if (element.nodeType == 1) {
            if (element.getAttribute("class") == "MyAppHighlight") {
                var text = element.removeChild(element.firstChild);
                element.parentNode.insertBefore(text,element);
                element.parentNode.removeChild(element);
                return true;
            } else {
                var normalize = false;
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    if (MyApp_RemoveAllHighlightsForElement(element.childNodes[i])) {
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
function MyApp_RemoveAllHighlights() {
    MyApp_SearchResultCount = 0;
    MyApp_RemoveAllHighlightsForElement(document.body);
}


function getPos(el) {
    // yay readability
    for (var lx = 0, ly = 0; el != null; lx += el.offsetLeft, ly += el.offsetTop, el = el.offsetParent);
    return { x: lx, y: ly };
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
// We're using a global variable to store the number of occurrences
var eReader_SearchResultCount = 0;

// helper function, recursively searches in elements and their child nodes
function eReader_HighlightAllOccurencesOfStringForElement(element,keyword) {
    if (element) {
         alert(eReader_SearchResultCount);
        if (element.nodeType == 3) {        // Text node
            while (true) {
                var value = element.nodeValue;  // Search for keyword in text node
                var idx = value.toLowerCase().indexOf(keyword);
                
                if (idx < 0) break;             // not found, abort
                
                      alert(eReader_SearchResultCount);
                eReader_SearchResultCount++;
                //return 1;	// update the counter
            }
        } else if (element.nodeType == 1) { // Element node
            if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    eReader_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
                }
            }
        }
    }
}

// the main entry point to start the search
function eReader_HighlightAllOccurencesOfString(keyword) {
    eReader_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());
}
*/



