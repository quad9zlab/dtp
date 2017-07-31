// var objs=app.activeDocument.allPageItems;
// alert(objs+"\n"+objs.length);
//
// var objs=app.activeDocument.pageItems;
// alert(objs+"\n"+objs.length);
// var objs=app.activeDocument.pageItems;
// $.writeln(objs.properties.toSource());

var obj = app.activeDocument.pageItems.item(0).TextFrames.item(0)

$.writeln(objs.properties.toSource());
