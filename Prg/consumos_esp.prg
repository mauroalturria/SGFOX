public mcon1
*parameters mfecha1, mfecha2
mfecha1=ctod('01/01/2005')
mfecha2 =ctod('31/01/2005')
CESP = 'KINE'
do sp_conexion
wait 'Procesando datos .................' windows timeout 5
mret=sqlexec(mcon1, " SELECT codprest,pre_descriprest as prest, "+;
  				    " COUNT(CASE WHEN codent in (100,101,512,513) and confirmado=1 "+;
					" AND Afiliado >0 "+;
					" THEN afiliado END) as PresentesP, "+;
					" COUNT(CASE WHEN codent in (100,101,512,513) and confirmado=0 "+;
					" AND Afiliado >0 "+;
					" THEN afiliado END) as AusentesP,"+;
					" COUNT(CASE WHEN codent not in (100,101,512,513) and confirmado=1 "+;
					" AND Afiliado >0 "+;
					" THEN afiliado END) as PresentesO, "+;
					" COUNT(CASE WHEN codent not in (100,101,512,513) and confirmado=0 "+;
					" AND Afiliado >0"+;
					" THEN afiliado END) as AusentesO "+;
					" FROM turnos,prestacions "+;
					" WHERE turnos.codprest = prestacions.pre_codprest "+;
					" AND fechatur between ?mfecha1 AND ?mfecha2 AND Codesp=?CESP"+;
					" GROUP BY codprest,confirmado "+;
					" ORDER BY codprest,confirmado" ,"MWKConsumo")
					   
	if mret < 0
		messagebox('ERROR EN EL CURSOR DE CONSUMOS, AVISAR A SISTEMAS',64,'Validacion')
		mret = 0
		cancel
	endif
	
mret=sqlexec(mcon1, " SELECT  'TOTAL' as codprest,codesp,"+;
  				    " COUNT(CASE WHEN codent in (100,101,512,513) and confirmado=1 "+;
					" AND Afiliado >0 "+;
					" THEN afiliado END) as PresentesP, "+;
					" COUNT(CASE WHEN codent in (100,101,512,513) and confirmado=0 "+;
					" AND Afiliado >0 "+;
					" THEN afiliado END) as AusentesP,"+;
					" COUNT(CASE WHEN codent not in (100,101,512,513) and confirmado=1 "+;
					" AND Afiliado >0 "+;
					" THEN afiliado END) as PresentesO, "+;
					" COUNT(CASE WHEN codent not in (100,101,512,513) and confirmado=0 "+;
					" AND Afiliado >0"+;
					" THEN afiliado END) as AusentesO "+;
					" FROM turnos "+;
					" WHERE fechatur between ?mfecha1 AND ?mfecha2 AND Codesp= ?CESP"+;
					" GROUP BY confirmado "+;
					" ORDER BY confirmado" ,"MWKToTCons")
					   
	if mret < 0
		messagebox('ERROR EN EL CURSOR DE TOTAL DE CONSUMOS, AVISAR A SISTEMAS',64,'Validacion')
		mret = 0
		cancel
	endif	

mret=sqlexec(mcon1, " SELECT  COUNT(afiliado) as TotalPLanS "+;
					" FROM turnos "+;
					" WHERE fechatur between ?mfecha1 AND ?mfecha2 AND Codesp=?CESP "+;
					" AND codent in (100,101,512,513) AND Afiliado > 0 ","MWKToTPS")
					
					
					   
	if mret < 0
		messagebox('ERROR EN EL CURSOR DE TOTAL PS, AVISAR A SISTEMAS',64,'Validacion')
		mret = 0
		cancel
	endif
	
	mret=sqlexec(mcon1, " SELECT  COUNT(afiliado) as TotalPLanS "+;
					" FROM turnos "+;
					" WHERE fechatur between ?mfecha1 AND ?mfecha2 AND Codesp=?CESP "+;
					" AND codent not in (100,101,512,513) AND Afiliado >0 ","MWKToTOS")	
	if mret < 0
		messagebox('ERROR EN EL CURSOR DE TOTAL OS, AVISAR A SISTEMAS',64,'Validacion')
		mret = 0
		cancel
	endif	
   

	mret=sqlexec(mcon1, " SELECT "+;
  				    " COUNT(afiliado) as TotalPsic "+;
					" FROM turnos "+;
					" WHERE afiliado >0 AND fechatur between ?mfecha1 AND ?mfecha2 "+;
					" AND Codesp=?CESP ","MWKToTGral")
					
					   
	if mret < 0
		messagebox('ERROR EN EL CURSOR DE TOTALES, AVISAR A SISTEMAS',64,'Validacion')
		mret = 0
		cancel
	endif		
	
	mret=sqlexec(mcon1, " SELECT  COUNT(afiliado) as PacPLanS "+;
					" FROM turnos "+;
					" WHERE fechatur between ?mfecha1 AND ?mfecha2 AND Codesp=?CESP "+;
					" AND codent in (100,101,512,513) AND Afiliado > 0 "+;
					" GROUP BY AFILIADO ","MWKToPPS")		
					
					   
	if mret < 0
		messagebox('ERROR EN EL CURSOR DE TOTAL Pac PS, AVISAR A SISTEMAS',64,'Validacion')
		mret = 0
		cancel
	endif
	
	mret=sqlexec(mcon1, " SELECT  COUNT(afiliado) as PacOS "+;
					" FROM turnos "+;
					" WHERE fechatur between ?mfecha1 AND ?mfecha2 AND Codesp=?CESP "+;
					" AND codent not in (100,101,512,513) AND Afiliado >0 "+;
					" GROUP BY AFILIADO ","MWKToPOS")			
	if mret < 0
			messagebox('ERROR EN EL CURSOR DE TOTAL Pac OS, AVISAR A SISTEMAS',64,'Validacion')
			mret = 0
		cancel
	endif		
wait 'Fin del Procesamiento de datos, armando planilla .................' windows timeout 5	
	
oleapp = createobject("excel.application")
oleapp.workbooks.open("H:\qepd1a1\xlt\Consumos_Psic.xlt")

oleapp.cells(2,2).value = "Periodo del " + dtoc(mfecha1) + " al " + dtoc(mfecha2)
	i = 5
	oleapp.cells(i,2).value   	= 'CODIGO PRESTACION'
	oleapp.cells(i,3).value 	= 'DENOMINACION'
	oleapp.cells(i,4).value     = 'PRESENTES PS'
	oleapp.cells(i,5).value     = 'AUSENTES PS'
	oleapp.cells(i,6).value     = 'TOTAL PS'
	oleapp.cells(i,7).value     = 'PRESENTES OTRAS OS'
	oleapp.cells(i,8).value     = 'AUSENTES OTRAS OS'
	oleapp.cells(i,9).value     = 'TOTAL O.S.'
	oleapp.cells(i,10).value    = 'TOTAL GRAL'
	i=6
do while !eof("MwkConsumo")

	mcodprest_ant=MwkConsumo.codprest
	
	oleapp.cells(i,2).value   = MwkConsumo.codprest
	oleapp.cells(i,3).value   = MwkConsumo.prest
	oleapp.cells(i,4).value   = iif(isnull(MwkConsumo.presentesP),0,MwkConsumo.presentesP)
	oleapp.cells(i,5).value   = iif(isnull(MwkConsumo.AusentesP),0,MwkConsumo.AusentesP)
	oleapp.cells(i,6).value   = iif(isnull(MwkConsumo.presentesP),0,MwkConsumo.presentesP) + iif(isnull(MwkConsumo.AusentesP),0,MwkConsumo.AusentesP)
	oleapp.cells(i,7).value   = iif(isnull(MwkConsumo.presentesO),0,MwkConsumo.presentesO) 
	oleapp.cells(i,8).value   = iif(isnull(MwkConsumo.AusentesO),0,MwkConsumo.AusentesO)
	oleapp.cells(i,9).value   =  iif(isnull(MwkConsumo.AusentesO),0,MwkConsumo.AusentesO) + iif(isnull(MwkConsumo.presentesO),0,MwkConsumo.presentesO)
	oleapp.cells(i,10).value  =  oleapp.cells(i,6).value + oleapp.cells(i,9).value	

	sele MwkConsumo
	skip 1 in MwkConsumo
	if eof("MwkConsumo")
		exit
	else
		
		do while !eof("MwkConsumo")	
			if !(mcodprest_ant=MwkConsumo.codprest)
				i = i + 1
				exit
			else
			
				oleapp.cells(i,4).value   = oleapp.cells(i,4).value + iif(isnull(MwkConsumo.presentesP),0,MwkConsumo.presentesP)
				oleapp.cells(i,5).value   = oleapp.cells(i,5).value + iif(isnull(MwkConsumo.AusentesP),0,MwkConsumo.AusentesP)
				oleapp.cells(i,6).value   = oleapp.cells(i,4).value + oleapp.cells(i,5).value
				oleapp.cells(i,7).value   = oleapp.cells(i,7).value + iif(isnull(MwkConsumo.presentesO),0,MwkConsumo.presentesO)
				oleapp.cells(i,8).value   = oleapp.cells(i,8).value + iif(isnull(MwkConsumo.AusentesO),0,MwkConsumo.AusentesO)
				oleapp.cells(i,9).value   = oleapp.cells(i,8).value + oleapp.cells(i,7).value 
				oleapp.cells(i,10).value  = oleapp.cells(i,6).value + oleapp.cells(i,9).value	
				
				sele MwkConsumo
				skip 1 in MwkConsumo
				
				if eof()
					exit
				endif
			endif	
		enddo	
		
	endif	
enddo

i=15
sele MwkTotCons
go top

oleapp.cells(i,2).value   	= 'TOTAL   '
oleapp.cells(i,4).value   = iif(isnull(MwkTotCons.presentesP),0,MwkTotCons.presentesP)
oleapp.cells(i,5).value   = iif(isnull(MwkTotCons.AusentesP),0,MwkTotCons.AusentesP)
oleapp.cells(i,7).value   = iif(isnull(MwkTotCons.presentesO),0,MwkTotCons.presentesO)
oleapp.cells(i,8).value   = iif(isnull(MwkTotCons.AusentesO),0,MwkTotCons.AusentesO)

skip 1 in MwkTotCons
do while !eof('MwkTotCons')
	
	oleapp.cells(i,4).value   = oleapp.cells(i,4).value +;
								 iif(isnull(MwkTotCons.presentesP),0,MwkTotCons.presentesP)
	oleapp.cells(i,5).value   = oleapp.cells(i,5).value +;
								 iif(isnull(MwkTotCons.AusentesP),0,MwkTotCons.AusentesP)
	oleapp.cells(i,7).value   = oleapp.cells(i,7).value +;
								 iif(isnull(MwkTotCons.presentesO),0,MwkTotCons.presentesO)
	oleapp.cells(i,8).value   = oleapp.cells(i,8).value +;
								 iif(isnull(MwkTotCons.AusentesO),0,MwkTotCons.AusentesO)
	
	
	skip 1 in MwkTotCons
	if eof()
		exit
	endif	
enddo	

sele MWKToTPS
go top


if !eof('MWKToTPS')
	oleapp.cells(i,6).value   = iif(isnull(MWKToTPS.TotalPLanS),0,MWKToTPS.TotalPLanS)
endif	

sele MWKToTOS
go top

if !eof('MWKToTOS')
	oleapp.cells(i,9).value   = iif(isnull(MWKToTOS.TotalPLanS),0,MWKToTOS.TotalPLanS)
endif	
		


	sele MWKToTgral
	go top
	oleapp.cells(i,10).value   = iif(isnull(MWKToTgral.TotalPSic),0,MWKToTgral.TotalPSic)
	
	
	sele MWKToPPS
	go top
	oleapp.cells(22,3).value   = reccount()
	
	sele MWKToPOS
	go top
	oleapp.cells(23,3).value   = reccount()
	
	oleapp.cells(21,3).value   =oleapp.cells(23,3).value + oleapp.cells(22,3).value
	
	oleapp.visible = .t.
	
=sqldisconnect(mcon1)	