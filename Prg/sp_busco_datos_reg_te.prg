****
**  Busco los datos anexos del paciente
****

Parameter mnroregistra
If !Used("mwktipotel")
	mret = SQLExec(mcon1,"SELECT ID, TT_categoria, TT_descrTipo FROM Zabtipotel " + ;
		" where TT_fecpasiva ='1900-01-01' ", "mwktipotel")
Endif
Dimension mTiposTel[30,2]
Select mwktipotel
midv = 0
Scan
	midv = midv + 1
	mTiposTel[mwktipotel.id ,1 ] = mwktipotel.TT_descrTipo
	mTiposTel[mwktipotel.id ,2] = mwktipotel.Id
Endscan

mfecpas = Ctod("01/01/1900")
ctelef=''
mret = SQLExec(mcon1,"select id,TRT_Numero , TRT_Pasiva  , TRT_tipo, TRT_observacion " + ;
	"from TabRegTel " + ;
	"where TRT_Registracio = ?mnroregistra and trt_tipo<>9 and TRT_pasiva = ?mfecpas","mwkregtel")
If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
Else
	Select mwkregtel
	Scan
		ctelprov = Alltrim(mwkregtel.trt_numero)
		ctelprov = Iif(Left(ctelprov ,1)="0",Substr(ctelprov,2),ctelprov)
		*cNumTel = Alltrim(mTiposTel[IIF(mwkregtel.trt_tipo=0,1,mwkregtel.trt_tipo),1])+"-"+ctelprov
		
		xTipo = mTiposTel[IIF(mwkregtel.trt_tipo=0,1,mwkregtel.trt_tipo),1]
		IF VARTYPE(xTipo) = "C"
		   cNumTel = ALLTRIM(xTipo) + "-"+ctelprov
		ELSE
		   cNumtel = cTelprov
		ENDIF 
		
		
		
		If !Empty(Nvl(mwkregtel.trt_observacion,Space(50)))
			cNumTel = cNumTel + " ("+Alltrim(Left(Nvl(mwkregtel.trt_observacion,Space(50)),20))+")"
		Endif
		ctelef = ctelef +cNumTel +"  "
		Select mwkregtel
	Endscan
ENDIF
USE in SELECT('mwkregtel')
RETURN 	PADR(ctelef,250)