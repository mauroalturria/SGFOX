#include msword.h


oWord = createobject("word.application")
oWord.Documents.add("C:\DESAGUEMES\xlt\modulo1.dot",.t.)


pnCountMarks = oWord.ActiveDocument.Bookmarks.Count
*   Store bookmarks in an array
DIMENSION aMark[pnCountMarks]

FOR pnCount = 1 TO pnCountMarks
	aMark[pnCount] = oWord.ActiveDocument.Bookmarks(pnCount).Name
ENDFOR


oWord.Application.Visible = .F.
oWord.Application.windowstate = 1

*loWord.Application.WindowState = 1 && wdWindowStateMaximize

pnCountMarks = oWord.ActiveDocument.Bookmarks.Count
*   Store bookmarks in an array
DIMENSION aMark[pnCountMarks]

FOR pnCount = 1 TO pnCountMarks
	aMark[pnCount] = oWord.ActiveDocument.Bookmarks(pnCount).Name
ENDFOR


oWord.Application.Visible = .F.
oWord.Application.windowstate = 1

loSelection = oWord.Selection

FOR pnCount = 1 TO pnCountMarks
	pcMarkName = UPPER(aMark[pnCount])
	ctxt ="ThisForm.txt"+ alltrim(pcMarkName)
	if type(ctxt)#"O"
		ctxt ="ThisForm.edt"+ alltrim(pcMarkName)
	endif
	ctxt = ctxt +".value"
	ldet = alines(mdet,&ctxt)
*     Move to the next bookmark
	WITH oWord.ActiveDocument.Bookmarks(pcMarkName).Range
		oWord.ActiveDocument.Bookmarks(pcMarkName).Select
		oWord.Selection.insertafter(pcMarkName)
		loSelection.TypeText(mdet(1))
		for i= 2 to ldet
			if !empty(mdet(i)) or i<ldet
				loSelection.TypeText(CHR(13))
				loSelection.TypeText(mdet(i))
			endif
		next i

	ENDWITH
ENDFOR
with oWord.ActiveDocument
	oRange = .range()

	ldet = alines(mdet,ThisForm.edtcondiciones.value)
	oRange.find.text = '%condicion%'
	oRange.find.replacement.text = mdet(1)
	oRange.find.Wrap=1
	oRange.find.Execute( oRange.Find.Text, , , , , , , , .t., , 2)
	for i= 2 to ldet
		if !empty(mdet(i)) or i<ldet
			oRange.find.insertafter(CHR(13))
			oRange.find.insertafter(mdet(i))
		endif
*!*			oRange.TypeText(mdet(i))
*!*			oRange.TypeText(CHR(13))
	next i
ENDWITH
oWord.visible = .t.
oWord.Selection.WholeStory()
oWord.Selection.Copy() &&// put on clipboard
 
oWord1 = createobject("word.application")
oWord1.Documents.add("C:\DESAGUEMES\xlt\modulo2.dot",.t.)

oWord1.Selection.WholeStory() 
oWord1.ActiveDocument.Bookmarks("\startofdoc").Select
* wordApp.Selection.EndOf()
* wordApp.Selection.InsertAfter("")
* oWord1.Selection.InsertParagraph() 
 oWord1.Selection.Paste()


*!*	l1oSelection = oWord1.ActiveDocument.Range()
*!*	oWord1.Selection.paste()

oWord1.visible = .t.

*oWord.ActiveDocument.PrintPreview
messagebox("revise el documento")
oword.quit(0) 
oword1.quit(0) 
release oword,oword
*oWord.Printpreview


release orange, oWord

*!*	'Obra Social:'
*!*	'Afiliado N º:'


