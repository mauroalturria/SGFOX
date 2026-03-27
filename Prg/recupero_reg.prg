
mfecha = ctod('03/05/2002')

select * from c:\desaguemes\solokine ;
 where codmed = 299 and fechatur = mfecha ;
 order by codmed, fechatur into cursor mwkpp

go top

do while !eof('mwkpp')
	mafilia   = round(mwkpp.afiliado, 0)
	mreserva  = alltrim(mwkpp.codreserva)
	mncodmed  = mwkpp.codmed
	mdhoratur = mwkpp.horatur
	mdfechatur= mwkpp.fechatur
	mccodesp  = mwkpp.codesp
	mncodprest= mwkpp.codprest
	
	mret=sqlexec(mcon1,"SELECT * FROM turnos " + ;
						"WHERE codmed = ?mncodmed AND fechatur = ?mdfechatur AND " +;
						"horatur = ?mdhoratur AND codesp = ?mccodesp AND " + ;
						"codprest = ?mncodprest",'MWKReg')
	if mret < 1
		mret=0			 
	else
		do while !eof('mwkreg')
			if mwkreg.afiliado = 0
							
				mid = mwkreg.id
				mret=sqlexec(mcon1, "UPDATE turnos " + ;
						"SET afiliado = ?mafilia, codreserva = ?mreserva, tomado = 2 " + ;
						"WHERE codmed = ?mncodmed AND fechatur = ?mdfechatur AND " +;
						"codesp = ?mccodesp AND " + ;
						"codprest = ?mncodprest and id = ?mid ")
				
						
				if mret < 1
					mret=0
				endif
				skip 10 in mwkreg
			else
				skip 1 in mwkreg	
			endif
			
		enddo
	endif

	mafilia   = 0
	mreserva  = ''
	mncodmed  = 0
	mdfechatur= {  /  /    }
	mccodesp  = ''
	mncodprest= 0
	sele mwkpp
	skip 1 in mwkpp 
enddo