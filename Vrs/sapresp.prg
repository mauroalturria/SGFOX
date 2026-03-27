Modify View sap_respuestas
Select * From sap_respuestas Where At('no existe en IS-H',respuesta)>0
Select Substr(respuesta,At('no existe en IS-H',respuesta)-9,8) As hcli, * From sap_respuestas Where At('no existe en IS-H',respuesta)>0
Select Padr(Substr(respuesta,At('no existe en IS-H',respuesta)-9,10),10) As hcli, * From sap_respuestas Where At('no existe en IS-H',respuesta)>0
Select Padr(Substr(respuesta,At('no existe en IS-H',respuesta)-9,8),10) As hcli, * From sap_respuestas Where At('no existe en IS-H',respuesta)>0
Select Padr(Substr(respuesta,At('no existe en IS-H',respuesta)-9,8),10) As hcli From sap_respuestas Where At('no existe en IS-H',respuesta)>0 Into Cursor hclin

Select * From sap_respuestas Where At('</E_FALNR><E_PATNR>',respuesta)>0
Select Padr(Substr(respuesta,At('<MESSAGE>',respuesta)+9,250),250) As valor,*,Left(respuesta,250) As Resp ;
	FROM resp_real Where At('<MESSAGE>',respuesta)>0 Into Cursor errores
Select errores.*,texto From errores,sapaprocesar Where idproceso = sapaprocesar.Id Into Cursor errorescr

Browse Last
Copy To cuentassi
Select 4
Copy To pacno

Select * From resp_real Where At('9999999',texto)=0 Into Cursor cambiar
SELECT * FROM resp WHERE AT('fue desbloqueado',respuesta)>0 into CURSOR arreglo
SELECT * FROM arreglo,epibloq WHERE episodio = epi INTO CURSOR repro
SELECT LEFT(texto,8) as epi,* FROM resp WHERE AT('fue desbloqueado',respuesta)>0 into CURSOR arreglo
SELECT * FROM arreglo,epibloq WHERE episodio = epi INTO CURSOR repro
mcon1 = SQLConnect("conec01")
SELECT duplis
Scan
	mid = id 
	mret = SQLExec(mcon1,"update WS.APROCESAR set estado = 'Prueba' where id = ?mid")

Endscan
DO sp_desconexion

Select * From sap_respuestas Where At('contabilizar en los períodos',respuesta)>0 And  estado = 'Error' Into Cursor cambiar
Browse Last
Resume
Select * From sap_respuestas Where At('contabilizar en los períodos',respuesta)>0 And  estado = 'Error' Into Cursor cambiar
Browse Last
Modify Command c:\desaguemes\vrs\sapresp.prg
Do c:\desaguemes\prg\0seteos_quirof.prg
Do SP_DESCONEXION
Do c:\desaguemes\prg\0seteos_quirof.prg
Modify View sap_respuestas
Select * From sap_respuestas Where At('contabilizar en los períodos',respuesta)>0 And  estado = 'Error' Into Cursor cambiar
Select 23
Browse Last
Select * From aprocesar Where  estado = 'Pendiente' Into Cursor cambiar
Browse Last
Select * From sap_respuestas Where  At('aterial',respuesta)=0 And estado = 'Pendiente' Into Cursor cambiar
Browse Last
Do sp_conexion
Select resp_real_mio
Scan
	mid = Id
	mret = SQLExec(mcon1,"select * from WS.respuestas where id  = ?mid","respi")
	If mret<1 Or Reccount('respi')=0
		Set Step On
	Endif
Endscan


mret = SQLExec(mcon1,"delete  * from WS.respuestas where id  = 4066")
mican = 0
Select ok
Set Step On
Scan
	miepi = ok.episodio
	Select Distinct Id From resp_real_mio Where At(miepi,texto)>0 And At('homologacion',respuesta)>0 Into Cursor cambiar
	Select cambiar
	mican = mican +Reccount('cambiar')
*!*		Scan
*!*			mid = id
*!*			mret = SQLExec(mcon1,"update WS.APROCESAR set prioridad = 1 where id = ?mid")

*!*		Endscan
Endscan
Create Cursor controlhomo (esp c(4),Serv N(4))

Select  ubica
Scan
	Requery('vales_prestac')
	miesp = vales_prestac.PRE_especialidad
	miserv = vales_prestac.PRE_codservicio
	Insert Into controlhomo Values(miesp,miserv)
Endscan

Do sp_conexion
Select resp_real_mio
Scan
	mid = Id
	mret = SQLExec(mcon1,"update WS.APROCESAR set prioridad = 1, estado = 'Pendiente'  where id = ?mid")
Endscan
SELECT left(ALLTRIM(texto),8) As episodio,Int(Val(Substr(ALLTRIM(texto),At(',',ALLTRIM(texto))+1,8))) As VALE,*;
	 From resp_real  into Cursor silvia
	 
SELECT silvia.* FROM silvia,valesfa WHERE silvia.vale=valesfa.vale INTO CURSOR cambio
SELECT * FROM cambio GROUP BY vale INTO CURSOR cambiar
Browse Last
Select Iif(At("0008",tipoproceso)>0,Substr(texto,At(',',texto,4)+1,8),Substr(texto,At(',',texto,2)+1,8)) As episodio,Int(Val(Substr(texto,At(',',texto,4)+1,8))) As VALE,;
	Substr(respuesta,At('<NUMBER>',respuesta)+8,3)+Space(10) As Error ,* From resp_real   Into Cursor silvia
Select 55
Browse Last
Select Iif(At("0008",tipoproceso)>0,Substr(texto,At(',',texto,4)+1,8),Substr(texto,At(',',texto,2)+1,8)) As episodio,Int(Val(Substr(texto,At(',',texto,4)+1,8))) As VALE,;
	Substr(respuesta,At('<NUMBER>',respuesta)+8,3)+Space(10) As Error ,* From resp_real Where Left(tipoproceso,5)#"SI_PO"   Into Cursor silvia
Browse Last
Select Iif(At("0008",tipoproceso)>0,Substr(texto,At(',',texto,4)+1,8),Substr(texto,At(',',texto,2)+1,8)) As episodio,Int(Val(Substr(texto,At(',',texto,4)+1,8))) As VALE,;
	Substr(respuesta,At('<NUMBER>',respuesta)+8,3)+Space(10) As Error ,* From resp_real Where Left(tipoproceso,5)#"SI_PO" And Val(Error) = 54  Into Cursor silvia
Select Iif(At("0008",tipoproceso)>0,Substr(texto,At(',',texto,4)+1,8),Substr(texto,At(',',texto,2)+1,8)) As episodio,Int(Val(Substr(texto,At(',',texto,4)+1,8))) As VALE,;
	Substr(respuesta,At('<NUMBER>',respuesta)+8,3)+Space(10) As Error ,* From resp_real Where Left(tipoproceso,5)#"SI_PO"   Into Cursor silvia
Browse Last
Select Iif(At("0008",tipoproceso)>0,Substr(texto,At(',',texto,4)+1,8),Substr(texto,At(',',texto,2)+1,8)) As episodio,Int(Val(Substr(texto,At(',',texto,4)+1,8))) As VALE,;
	Substr(respuesta,At('<NUMBER>',respuesta)+8,3)+Space(10) As Error ,* From resp_real Where Left(tipoproceso,5)#"SI_PO"  Order 73 Into Cursor silvia
Select Iif(At("0008",tipoproceso)>0,Substr(texto,At(',',texto,4)+1,8),Substr(texto,At(',',texto,2)+1,8)) As episodio,Int(Val(Substr(texto,At(',',texto,4)+1,8))) As VALE,;
	Substr(respuesta,At('<NUMBER>',respuesta)+8,3)+Space(10) As Error ,* From resp_real Where Left(tipoproceso,5)#"SI_PO"  Order By Error Into Cursor silvia
Browse Last
Select Iif(At("0008",tipoproceso)>0,Substr(texto,At(',',texto,4)+1,8),Substr(texto,At(',',texto,2)+1,8)) As episodio,Int(Val(Substr(texto,At(',',texto,4)+1,8))) As VALE,;
	Substr(respuesta,At('<NUMBER>',respuesta)+8,3)+Space(10) As Error ,* From resp_real Where Left(tipoproceso,5)#"SI_PO" And estado = "Error" Order By Error Into Cursor silvia
Browse Last
Select * From silvia Where Error = '073'  Into Cursor controlvale
Select Iif(At("0006",tipoproceso)>0,Substr(texto,At(',',texto,4)+1,8),Substr(texto,At(',',texto,2)+1,8)) As episodio,Int(Val(Substr(texto,At(',',texto,4)+1,8))) As VALE,;
	Substr(respuesta,At('<NUMBER>',respuesta)+8,3) As Error ,* From resp_real_mio  Into Cursor bloqueos

Select Iif(At("ISHPM_15",tipoproceso)>0,Substr(texto,At(',',texto,3)+1,8),Left(texto,8)) As episodio,;
	IIF(At("ISHPM_15",tipoproceso)>0,Int(Val(Substr(texto,At(',',texto,4)+1,8))),Int(Val(Substr(texto,At(',',texto)+1,8)))) As VALE,;
	Substr(respuesta,At('<NUMBER>',respuesta)+8,3) As Error ,* From resp_real  Group By Id Into Cursor arreglo

Select Substr(texto,At(',',texto,3)+1,9)As hclin,Substr(texto,At(',',texto,4)+1,8) As epi,*;
	 From resp_real_mio  WHERE prioridad = 2 ORDER BY epi Into Cursor admision

Select * From resp_real_mio Where At('NUMBER>021',respuesta)>0 AND (At('AHTCONCE021',respuesta)>0 OR At('AMCFILTR011',respuesta)>0) GROUP BY id INTO CURSOR respu
Select VAL(Substr(respuesta,At('debajo de',respuesta)+9,2)) As unidades,Substr(respuesta,At('UN : ',respuesta)+4,11) As insu,*;
	 From respu Into Cursor stock
SELECT SUM(unidades) as total,insu FROM stock GROUP BY insu INTO CURSOR faltantes

	 
Select vemos
Set Step On
Scan
	mid = Id
	mihora = Alltrim(hora_b)
	ntexto = Alltrim(Left(texto,At(',',texto,7)))+Substr(texto,At(',',texto,7)+4,5)+":00"+Alltrim(Substr(texto,At(',',texto,8)))
	ntexto = Alltrim(Left(texto,At(',',texto,7)))+mihora+Alltrim(Substr(texto,At(',',texto,8)))
	mret = SQLExec(mcon1,"update WS.APROCESAR set prioridad = 1, texto = ?ntexto, horaprog = '14:40'  where id = ?mid")
Endscan


Select cambiar
Set Step On
Scan
	mid = Id
	mret = SQLExec(mcon1,"update WS.APROCESAR set estado = 'Pendiente'  where id = ?mid")
Endscan


Create Cursor controlhomo (cuenta c(8),esp c(4),Serv N(4),PRESTA N(10),CANTI N(3),VALE N(10),ENTI N(4))

Select  cuentas
Set Step On
Scan
	miepi=episodio
	miesp=''
	miserv=0
	Requery('vales_prestac')
	If Reccount('vales_prestac')>0
		If Month(vales_prestac.VAL_fechasolicitud)=7
			Select Sum(PIA_cantsolicitada) As CANTI From vales_prestac Into Cursor Control
			If Control.CANTI>0
				Select vales_prestac
				Scan
					MCant = vales_prestac.PIA_cantsolicitada
					mvale =vales_prestac.VAL_codvaleasist
					mprest=vales_prestac.PIA_codprest
					miesp = ''
					miserv = vales_prestac.VAL_codservvale
					Insert Into controlhomo Values(miepi,miesp,miserv,mprest,MCant,mvale  )

				Endscan
			Endif
		Endif
	Endif
	Select  cuentas

Endscan

Select cuentas
Scan
	miserv=0
	Requery('vales_prestac')
	If Reccount('vales_prestac')>0
		Replace ENTIDAD With vales_prestac.HIS_codentidad
	Endif
	Select  NOVALES

Endscan



Create Cursor controlhomo (cuenta c(8),esp c(4),Serv N(4),PRESTA N(10),CANTI N(3),VALE N(10),ENTI N(4))

Select  cuentas2
Set Step On
Scan
	miepi=episodio
	miesp=''
	miserv=0
	Requery('vales_prestac')
	If Reccount('vales_prestac')>0
*	Select Sum(PIA_cantsolicitada) As CANTI,* From vales_prestac Where HIS_codentidad In ( Select ent_codent  From ENTI) Into Cursor Control
		Select Sum(PIA_cantsolicitada) As CANTI,* From vales_prestac  Into Cursor Control
		If miepi='0I4425-A'
			Set Step On
		Endif
		If Control.CANTI>0

			Select Control
			MCant = Control.CANTI
			mvale =Control.VAL_codvaleasist
			mprest=Control.PIA_codprest
			miesp = Control.PRE_especialidad
			miserv = Control.VAL_codservvale
			MIENTI = Control.HIS_codentidad
			micta = Control.VAL_codadmision
			Insert Into controlhomo Values(micta ,miesp,miserv,mprest,MCant,mvale ,MIENTI )
			Select  cuentas2

			Replace ok With "SI"

		Else
			Select  cuentas2

			Replace ok With "NO"
		Endif
	Else
		Select  cuentas2

		Replace ok With "AN"

	Endif

	Select  cuentas2

Endscan




Create Cursor controlhomo (cuenta c(8),esp c(4),Serv N(4),PRESTA N(10),CANTI N(3),VALE N(10),ENTI N(4))

Select  vales
Set Step On
SCAN
	MIVALE = VALES.VALE
	Requery('vales_prestac')
	If Reccount('vales_prestac')>0
*	Select Sum(PIA_cantsolicitada) As CANTI,* From vales_prestac Where HIS_codentidad In ( Select ent_codent  From ENTI) Into Cursor Control
		MCant = vales_prestac.PIA_cantsolicitada
		mvale =vales_prestac.VAL_codvaleasist
		mprest=vales_prestac.PIA_codprest
		miesp = vales_prestac.PRE_especialidad
		miserv = vales_prestac.VAL_codservvale
		MIENTI = 0
		micta = vales_prestac.VAL_codadmision
		Insert Into controlhomo  Values(micta ,miesp,miserv,mprest,MCant,mvale ,MIENTI )
		Select  vales

	Endif

	Select  vales

Endscan



Create Cursor controlhomo (cuenta c(8),esp c(4),Serv N(4),PRESTA N(10),CANTI N(3),VALE N(10),ENTI N(4),hcli c(10),regis n(9),bono c(10))

Select  CUENTAS
Set Step On
SCAN
	MIVALE = CUENTAS.EPISODIO
	Requery('guardia_vales')
	If Reccount('guardia_vales')>0
*	Select Sum(PIA_cantsolicitada) As CANTI,* From vales_prestac Where HIS_codentidad In ( Select ent_codent  From ENTI) Into Cursor Control
		MCant =0
		mvale =guardia_vales.VAL_codvaleasist
		mprest=guardia_vales.PRE_codprest
		miesp = guardia_vales.PRE_especialidad
		miserv = guardia_vales.PRE_codservicio
		mihcli  = guardia_vales.reg_nrohclinica
		mireg = guardia_vales.nroregistrac
		MIENTI = 0
		mibono = NVL(guardia_vales.VAL_bono,'')
		micta = guardia_vales.VAL_codadmision
		Insert Into controlhomo  Values(micta ,miesp,miserv,mprest,MCant,mvale ,MIENTI,mihcli,mireg,mibono )
		Select  CUENTAS

	Endif

	Select  CUENTAS

Endscan


REQUERY('resp_real')
REQUERY('resp_real_mio')
Select left(texto,8) As epiblo,fecha as fecblo From resp_real_mio  Into Cursor bloque
Select left(texto,8) As episodio,Int(Val(Substr(texto,At(',',texto,4)+1,8))) As VALE,*;
	 From resp_real Into Cursor silvia
SELECT * FROM bloque,silvia  WHERE epiblo =episodio ORDER BY fecblo DESC 


SELECT * FROM aprocesar WHERE estado = 'Pendiente'
SELECT * FROM aprocesar WHERE estado = 'Pendiente' AND tipoproceso='SI_PO_0006_Alta_Paciente_Out' INTO CURSOR repro
SELECT  substr(texto,AT(',',texto,3)+1,9) as hc,substr(texto,AT(',',texto,4)+1,8) as epi,*;
 FROM aprocesar   WHERE estado = 'Pendiente' AND tipoproceso='SI_PO_0006_Alta_Paciente_Out' INTO CURSOR repro
BROWSE LAST
SELECT  substr(ALLTRIM(texto),1, 9) as hc  ,*;
 FROM aprocesar   WHERE estado = 'Pendiente' AND tipoproceso='SI_PO_0006_Alta_Paciente_Out' INTO CURSOR repro
SELECT  left(texto,AT(',',texto)-1) as hc,substr(texto,AT(',',texto,4)+1,8) as epi,*;
 FROM aprocesar   WHERE estado = 'Pendiente' AND tipoproceso='SI_PO_0006_Alta_Paciente_Out' INTO CURSOR repro
BROWSE LAST
SELECT  left(texto,AT(',',texto)-1) as hc,*;
 FROM aprocesar   WHERE estado = 'Pendiente' AND tipoproceso='SI_PO_0006_Alta_Paciente_Out' INTO CURSOR repro
SELECT * FROM repro group BY hc INTO CURSOR vale
DO c:\desaguemes\prg\0seteos_calen.prg
SELECT * FROM repro group BY hc INTO CURSOR vale
BROWSE LAST
SELECT * FROM repro WHERE id NOT in (SELECT id FROM vale) INTO CURSOR duplis

SELECT  substr(ALLTRIM(texto),1, 9) as hc  ,*;
 FROM aprocesar   WHERE estado = 'Pendiente' AND tipoproceso='SI_PO_0006_Alta_Paciente_Out' AND EMPTY(usuario) INTO CURSOR duplis
SELECT * FROM repro group BY hc INTO CURSOR vale
SELECT * FROM repro WHERE id NOT in (SELECT id FROM vale) INTO CURSOR duplis
mcon1 = SQLConnect("conec01")
SELECT duplis
Scan
	mid = id 
	mret = SQLExec(mcon1,"update WS.APROCESAR set estado = 'Prueba' where id = ?mid")

Endscan
DO sp_desconexion
SELECT  substr(ALLTRIM(texto),1, 9) as hc  ,*;
 FROM aprocesar   WHERE estado = 'Pendiente' AND tipoproceso='SI_PO_0006_Alta_Paciente_Out' AND EMPTY(usuario) INTO CURSOR duplis
mcon1 = SQLConnect("conec01")
SELECT duplis
Scan
	mid = id 
	mret = SQLExec(mcon1,"update WS.APROCESAR set estado = 'Prueba' where id = ?mid")

Endscan
DO sp_desconexion