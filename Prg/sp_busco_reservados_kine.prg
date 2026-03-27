***********************************************
* AUTOR: Claudia Antoniow
* FECHA: 08/02/2002
* MODIFICADO POR ULT. VEZ:10/06/2002
***********************************************

fechatop=ctod('01/01/1900')
if mxambito >1
	mccpoamb = "  a.codambito = ?mxambito and b.codambito = ?mxambito and  "
else
	mccpoamb = ' b.id>5000 and '	
endif
mret=sqlexec(mcon1,"SELECT  B.DIASEM,B.CODMED,B.CODESP,B.INTERNADO,B.GUARDIA,A.HORADESDE,A.HORAHASTA,B.TIPOTURNO,c.grupo "+;
" FROM medpresta AS a,TABRESERVADO AS B,tabtipoturno as C "+;
" WHERE &mccpoamb centromedico = ?mxcentromedico and  A.CODMED=B.CODMED and B.TIPOTURNO=c.TIPOTURNO AND B.Diasem=?mddiasem AND generaagen >0 "+;
" AND A.Codesp=?mccodesp   And a.fecvigenh >={fn curdate()} "+;
" AND B.codmed IN (SELECT id FROM Prestadores WHERE (fecpasiva >?mdmasX  "+;
" OR fecpasiva=?fechatop) AND bloquedesde is null OR NOT "+;
" (bloquedesde <= ?mdmasX  AND bloquehasta >= ?mdmasX)) "+;
" AND fechaUltAgenda=?mdmasX "+;
" and A.horadesde is not null and b.fecvigenh <> b.fecvigend   And b.fecvigenh >={fn curdate()} "+;
" GROUP BY B.codmed,B.GUARDIA,B.INTERNADO,A.HORADESDE,A.HORAHASTA,B.TIPOTURNO "+;
" ORDER BY B.codmed","MWKResGuardiaInter")
	If mxambito = 1
		mccpoamb = ' '
	Endif

if mret < 0
	messagebox('ERROR DE CURSOR,Reservado Guardia-Internados, REINTENTE',16,'VALIDACION') 
	mret=0
endif	
&&&AND (B.guardia > 0 or B.internado >0 ) 