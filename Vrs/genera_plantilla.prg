*#include msword.h
mcpathact = allt(sys(5))+sys(2003)
cd "C:\DESAGUEMES\xlt\"

create table plantillas (plantilla c(50), marcador c(50))

cantdot = adir(misdots,"*.dot")
for uu=1 to cantdot
	oWord = createobject("word.application")
	oWord.Documents.add(  alltrim(misdots(uu,1)) ) &&,,.t.)
	pnCountMarks = oWord.ActiveDocument.Bookmarks.Count
	*   Store bookmarks in an table
	FOR pnCount = 1 TO pnCountMarks
		insert into plantillas (plantilla , marcador ) ;
		values ( misdots(uu,1),oWord.ActiveDocument.Bookmarks(pnCount).Name )
	ENDFOR
	oWord.quit(0)
	release oWord
	*	
endfor

cd alltrim(mcpathact)
select plantillas 
scan
	mdot = strtran(Plantilla ,".DOT","")
	mpar = marcador 
	mret = sqlexec(mcon3,"insert into TabPDot ( Plantilla , Param , Variable ) "+;
			"values ( ?mdot, ?mpar, 'C' )")
endscan	