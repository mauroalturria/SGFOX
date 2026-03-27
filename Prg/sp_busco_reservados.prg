***********************************************
* AUTOR: Claudia Antoniow
* FECHA: 08/02/2002
* MODIFICADO POR ULT. VEZ:10/06/2002
***********************************************

fechatop=ctod('01/01/1900')
if mxambito >1
	mccpoamb = "  a.codambito = ?mxambito and b.codambito = ?mxambito and "
else
	mccpoamb = ' b.id>5000 and '	
endif
mret=sqlexec(mcon1,"SELECT  B.DIASEM,B.CODMED,B.CODESP,B.INTERNADO,B.GUARDIA,A.HORADESDE,"+;
	" A.HORAHASTA,B.TIPOTURNO "+;
	" FROM medpresta AS a,TABRESERVADO AS B "+;
	" WHERE &mccpoamb centromedico = ?mxcentromedico and A.CODMED=B.CODMED AND B.Diasem=?mddiasem AND a.Diasem=?mddiasem AND generaagen >0 "+;
	" AND A.Codesp<>'KINE' "+;
	" AND B.codmed IN (SELECT id FROM Prestadores WHERE (fecpasiva >?mdmasX "+;
	" OR fecpasiva=?fechatop) AND bloquedesde is null OR NOT "+;
	" (bloquedesde <= ?mdmasX  AND bloquehasta >= ?mdmasX)) "+;
	" AND a.horadesde is not null "+;
	" and b.fecvigenh >= ?mdmasx and a.fecvigenh >= ?mdmasx and b.fecvigenh <> b.fecvigend " + ;
	" GROUP BY B.codmed,B.GUARDIA,B.INTERNADO,A.HORADESDE,A.HORAHASTA,B.TIPOTURNO "+;
	" ORDER BY B.codmed","MWKResGuardiaInter")

**" AND fechaUltAgenda=?mdmasX "+ (b.guardia > 0 or b.internado >0 ) and 

if mret <0
	messagebox('ERROR DE CURSOR,Reservado Guardia-Internados, REINTENTE',16,'VALIDACION')
	mret=0
endif
	If mxambito = 1
		mccpoamb = ' '
	Endif

