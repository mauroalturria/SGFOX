** Pasamos el nro. de registracion.
** Cursor utilizado : MWKPACTELEF1
&& *?*?*?   cosas agregadas por Car 1703
Lparameters nRegistracion

Local dFecha
Local nReg
musu = mwkusuario.idusuario
midusunew  = mwkusuario.Id
If LEFT(mwkusuario.nomape,1)='*'
	musu = mwkusuarios.idusuario
	midusunew  = mwkusuarios.Id
 
ENDIF
mret = 0

dFecha = sp_busco_fecha_serv("DT")

Select mwkpactelef1
Go Top


lborrareg = .F.
Scan All

	nReg   = mwkpactelef1.numid

	nTelefono = Alltrim(mwkpactelef1.numero)
	nTipoTel  = mwkpactelef1.ntipo
**cObserva  = Alltrim(mwkpactelef1.observa)
	cObserva = mwkpactelef1.observa

	If mwkpactelef1.sit == "D"  &&borrar
		If mwkpactelef1.numid > 0
** Cambiamos la fecha de pasivacion.
			mret = SQLExec(mcon1,"update tabregtel set " +;
				"trt_pasiva = ?dFecha,UserDbUpd=?musu  where id = ?nReg")
		Else
			lborrareg = .T.
		Endif
	Else   &&Vemos si tenemos que editar o insertar.
		If !Empty(nTelefono )
			If Nvl(mwkpactelef1.numid,0) = 0 And  mwkpactelef1.sit<> "D"   &&Registro nuevo
				If nTipoTel  <>9 && *?*?*?
					mret = SQLExec(mcon1, "update registracio set reg_telefonos ='"+nTelefono +"' where reg_nroregistrac = ?nRegistracion ")
					lborrareg = .F.
				Endif
				mret = SQLExec(mcon1,"select id from tabregtel where trt_registracio = ?nRegistracion and "+;
					"trt_tipo = ?nTipoTel and trt_pasiva = '1900-01-01'","mwkctrlnewtel")
				nReg = mwkctrlnewtel.Id
				If Reccount("mwkctrlnewtel")>0
					mret = SQLExec(mcon1,"update tabregtel set " +;
						"trt_numero = ?nTelefono,trt_observacion = ?cObserva,trt_tipo = ?nTipoTel ,FecHorDbUpd= ?dFecha  "  +;
						",UserDbUpd=?musu where id = ?nReg")
				Else
					If myip = '172.16.1.7'
						Set Step On
					Endif
					mret = SQLExec(mcon1,"insert into tabregtel (trt_numero,trt_observacion,trt_pasiva,trt_registracio,trt_tipo,UserDbAdd) " +;
						"values (?nTelefono,?cObserva,'1900-01-01',?nRegistracion,?nTipoTel,?midusunew )")
				Endif
			Endif
			If mwkpactelef1.sit == "E" .And. mwkpactelef1.numid > 0   &&edicion
				mret = SQLExec(mcon1,"update tabregtel set " +;
					"trt_numero = ?nTelefono,trt_observacion = ?cObserva,trt_tipo = ?nTipoTel  ,FecHorDbUpd= ?dFecha "  +;
					",UserDbUpd=?musu where id = ?nReg")
			Endif
		Endif
	Endif
**Salimos si hay error.
	If mret<=0
		Exit
	Endif
Endscan
If lborrareg
	Select * From mwkpactelef1 Where sit<> "D" And !Empty(numero)And  nTipoTel  <>9  Into Cursor mwknuevotel  && *?*?*?
	Go Top
	If !Eof()  && *?*?*?
		nTelefono = Alltrim(mwknuevotel.numero)
		mret = SQLExec(mcon1, "update registracio set reg_telefonos ='"+nTelefono +"' where reg_nroregistrac = ?nRegistracion ")
	Endif
	Use In Select('mwknuevotel')
Endif
If mret<=0
	Messagebox("ERROR EN ACTUALIZACION DE LA TABLA DE TELEFONOS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Else
	Return .T.
Endif
