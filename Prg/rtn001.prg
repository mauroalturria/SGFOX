
Activate Screen
Clear
Public mcon1 
mcon1 = Sqlconnect("TOTEM")

Public O AS RTN001 
*O = Newobject("RTN001")
O = Createobject("totemdll.RTN001")

? "VALIDANDO ENTIDAD"
?o.VLDENTHC("820225", "948",Dtoc(Date()))

? "VALIDANDO CONTRATO"
?o.VLDCON("948", "17948",Dtoc(Date()))


?"GENERAMOS ADMISION"
?o.ADMAMB("1","18/07/2015","18:37:11","820225","948","17948","55615")
?o.OLEVISM.P1



*!*	?ooo.VLDENTHC("820225", "945",Dtoc(Date()))

DEFINE CLASS RTN001 AS Cubito Of "c:\desaguemes\prg\prg_cubito.prg" Olepublic   

PROCEDURE Init
	
Endproc

*!*------------------------------------------------------------------------------------------------------------------------------
Procedure RTN001_VLDENTHC
Parameters mcnrocli, mccodent, mcfecha     
This.Conectar()
This.OleVisM.code = "D VLDENTHC^RTN001(" + mcnrocli + ',' + mccodent +',"'+ mcfecha+'")'
This.Ejecutar(1)
This.DesConectar()
Return (Empty(This.OLEVISM.P0) And Empty(This.OLEVISM.errorname))
Endproc 
*!*------------------------------------------------------------------------------------------------------------------------------
Procedure RTN001_VLDCON
Parameters mccodent, mccodcon , mcfecha     
This.Conectar()
This.OleVisM.code = "D VLDCON^RTN001(" + mccodent + ',' + mccodcon +',"'+ mcfecha+'")'
This.Ejecutar(1)
This.DesConectar()
Return (Empty(This.OLEVISM.P0) And Empty(This.OLEVISM.errorname))
Endproc 
*!*------------------------------------------------------------------------------------------------------------------------------
Procedure RTN001_ADMAMB
Parameters mgraba, mcfecha, mchora, mcnrocli, mccodent, mccodcon, mopera
This.Conectar()
This.OleVisM.code = "D ADMAMB^RTN001(" + mgraba + ',"'+ mcfecha+'","' + mchora+'",' ;
				+ mcnrocli + ',' + mccodent + ',' + mccodcon +',"","",'+mopera+',1,1)'
This.Ejecutar(1)
This.DesConectar()
Return (Empty(This.OLEVISM.P0) And Empty(This.OLEVISM.errorname))
*!*------------------------------------------------------------------------------------------------------------------------------

PROCEDURE Destroy

ENDPROC

PROCEDURE Error(nError, cMethod, nLine)
	?"ERROR " + Transform(nError)
	?"METODO " + cMethod
	?"LINEA " + Transform(nLine)	
ENDPROC

ENDDEFINE

