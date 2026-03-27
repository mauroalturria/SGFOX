*
* Cuidados Domiciliarios, cambios de Estado // Estado 1 - 2 - 3 (Activo, Finalizado, Pasivado)
*
Lparameters msel, mlid, mfec

If msel=2 Or msel=4 Or msel=5
	mfechoyb = mfec
Else
	mfechoyb = sp_busco_fecha_serv('DD')
ENDIF

mfechoy = sp_busco_fecha_serv('DT')
muser   = mwkusuario.idusuario

mret = SQLExec(mcon1,"Update TabCuiDomSoli set"+;
	" TCS_estado = ?msel   ,"+;
	" TCS_fecmov = ?mfechoy ,"+;
	" TCS_fecest = ?mfechoyb,"+;
	" TCS_usuario = ?muser  "+;
	" where id = ?mlid")

If mret < 0
	MTABLA = "CUIDADOS DOMICILIARIOS SOLICITUD"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
