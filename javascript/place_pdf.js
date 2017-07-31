/*
 *pdfをIndesignに配置するプログラム
 *date : 120220
 *author : 高広信之
 */

filename = File.openDialog("配置するPDFを選択してください。");

//条件を選択するダイアログ表示
//版サイズ
dialog = app.dialogs.add({ name:"Place PDF" });
exp1 = dialog.dialogColumns.add();
exp1.staticTexts.add({staticLabel:"ドキュメントの版サイズを指定してください。", minWidth:240 });
exp2 = exp1.radiobuttonGroups.add();
exp2on1 = exp2.radiobuttonControls.add({staticLabel:"A4",minWidth:120,checkedState:true});
exp2.radiobuttonControls.add({staticLabel:"B5",minWidth:120});  // ダイアログに表示させるだけ。
dialog.show();
if (exp2on1.checkedState == true){
  size = new Array(210,297);
} else {
  size = new Array(182,257);
}

//綴じ方向
dialog = app.dialogs.add({ name:"Place PDF" });
exp1 = dialog.dialogColumns.add();
exp1.staticTexts.add({staticLabel:"冊子の綴じ方向を指定してください。", minWidth:240 });
exp2 = exp1.radiobuttonGroups.add();
exp2on1 = exp2.radiobuttonControls.add({staticLabel:"左綴じ",minWidth:120,checkedState:true});
exp2.radiobuttonControls.add({staticLabel:"右綴じ",minWidth:120});  // ダイアログに表示させるだけ
dialog.show();

//pdfの開始ページと終了ページ
startNum = parseInt(prompt("開始ページ",1));
endNum = parseInt(prompt("終了ページ",16));

//処理の開始と残りの条件処理
docObj = app.documents.add();
docObj.documentPreferences.pageWidth = size[0]
docObj.documentPreferences.pageHeight = size[1]
docObj.documentPreferences.pageOrientation = PageOrientation.portrait;
docObj.viewPreferences.rulerOrigin = 1380143215;
if (exp2on1.checkedState == true){
  docObj.documentPreferences.pageBinding = PageBindingOptions.LEFT_TO_RIGHT;
} else {
  docObj.documentPreferences.pageBinding = PageBindingOptions.RIGHT_TO_LEFT;
}

var arr = [3, 2, 4, 1, 7, 6, 8, 5, 11, 10, 12, 9, 15, 14, 16, 13];
//1ページずつ増やしながら処理をくりかえす部分
for( i = 0; i < arr.length; i++){
  app.pdfPlacePreferences.pageNumber = arr[i];
  placeObj = docObj.textFrames.add();
  if( ( i % 2 ) != 0 ) {
    placeObj.visibleBounds = ["-3mm", "0mm" ,(size[1] + 3) + "mm" , (size[0] + 3) + "mm"];
  } else {
    placeObj.visibleBounds = ["-3mm", "-3mm" ,(size[1] + 3) + "mm" , size[0] + "mm"];
  }
  placeObj.place(filename);
  placeObj.fit(FitOptions.centerContent);
  docObj = app.activeDocument.pages.add();
}
app.activeDocument.pages.add(LocationOptions.AT_BEGINNING);
for( i = 2; i < endNum; i　+　4){
  var obj = app.activeDocument.pages.item(i).textFrames[0]
  obj.rotationAngle = 180;
}

// // origin
// //1ページずつ増やしながら処理をくりかえす部分
// for (i = startNum; i <= endNum; i++){
//     app.pdfPlacePreferences.pageNumber = i;  //　ページ数
//     placeObj = docObj.textFrames.add();
//     placeObj.visibleBounds = ["-3mm", "-3mm" ,(size[1] + "mm" , size[0] + "mm"];
//     placeObj.place(filename);
//     placeObj.fit(FitOptions.centerContent);
//     docObj = app.activeDocument.pages.add();
// }
