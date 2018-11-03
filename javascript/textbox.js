// // ドキュメントが無い状態から
// // 新規ドキュメントを作成して、テキストボックスを任意の位置とサイズで作成する。
// // 座標は、
// //   Y X Y+Depth X+width

// pageObj = app.documents.add();
// txtObj = pageObj.textFrames.add();
// txtObj.visibleBounds = ["10mm", "5mm", "50mm", "100mm"];  //Y X Y+Depth X+width
// txtObj.contentType = ContentType.textType;  // オブジェクトにタイプを教えなくても表示はできる。

// // ドキュメントを開いた状態で
// // ページを任意の位置に追加していく。
theDoc = app.activeDocument;
thePoint = theDoc.pages.item(6);  // 0 = page1, 1 = page2, 2 = page3
thePage = theDoc.pages.add(LocationOptions.AFTER, thePoint);
// thePage = theDoc.pages.add(LocationOptions.BEFORE, thePoint);
// thePage = theDoc.pages.add(LocationOptions.AT_BEGINNING);
// thePage = theDoc.pages.add(LocationOptions.AT_END);
// LocationOptions.AFTER         // 指定ページの後に追加
// LocationOptions.AT_BEGINNING  // ドキュメントの最初に追加
// LocationOptions.AT_END        // ドキュメントの最後のページに追加
// LocationOptions.BEFORE        // 指定ページの前に追加。ただし、単ページのドキュメントでしか正常に作動しない。
