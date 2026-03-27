** nCodent = Codigo de Entidad
** nEstado = Valor que identifica al Estado seleccionado.
** cOrigen = A=Ambulatorio - I=Internación
** nMedico = Codigo de Medico. Para buscar direccion de e-mail
** Marcelo Torres, revisado el 29/05/2018
** mPrestacion = la prestacion que dispara el e-mail (PRESTACIONS.PRE_CODPREST)
** mInsumo

Lparameters nCodent,nEstado,cOrigen,nMedico,mPrestacion,mInsumo

Local mCodAgrup
Local mEmail
Local nPos
Local cRowEntidad
Local cRowOrigen
Local cRowDescripcion

Dimension aDescrip(3)

mCodAgrup = 0
mEmail = ""
nPos = 0
cRowEntidad = ""
cRowOrigen = ""
cRowDescripcion = ""

If nEstado = 0
	Return ""
Endif

mPrestacion = Iif(Vartype(mPrestacion)<> "N",0,mPrestacion)
mInsumo = IIF(VARTYPE(mInsumo) <> "N",0,mInsumo)

** Buscamos primero el codigo agrupador
mret = SQLExec(mcon1,"select * from entidades where ent_codent = ?nCodEnt","mwkAgrupEnt")

If mret < 0
	Messagebox("Error al consultar Agrupación de Entidad.","Consulta")
	Return mEmail
Endif

mCodAgrup = mwkAgrupEnt.Ent_codAgrup

Use In Select("mwkAgrupEnt")

** Buscamos la ubicacion de los mails.
** SubEstado = 0 ->vigentes
mret = SQLExec(mcon1,"select * from tabestados where propietario = 4 and tipo = 37 and estado = ?nEstado and subestado = 0","mwkTabEstAgrup")

If mret < 0
	Messagebox("Error al consultar AGRUPADOR DE CORREOS de Envio.","Consulta")
	Return mEmail
Endif

** Verificamos si hay relación y buscamos según su ubicación
Select mwkTabEstAgrup
Go Top

If Reccount() > 0

	Scan All
** Armamos array con los valores de la descripcion
		cDescrip = Alltrim(mwkTabEstAgrup.Descrip)
		cRowEntidad = "E="+Alltrim(Str(mCodAgrup))
		cRowOrigen = "O="+Alltrim(cOrigen)    && 'A','I'
		cRowETodos = "E=999999"    &&Todas las entidades

** Buscamos si está habilitada la entidad o TODAS las entidades
		If (cRowOrigen $ cDescrip ) And ((cRowEntidad $ cDescrip) Or (cRowETodos $ cDescrip))

			nPos = At("U=",cDescrip)   &&Buscamos la ubicación

			If nPos > 0
				nPos = Val(Substr(cDescrip,nPos+2,Len(cDescrip)+nPos+2))   &&Obtenemos la ubicación
			Endif

			If ("D=N" $ cDescrip)      && No agregar DESCRIPCION en Asunto del mensaje.
				cRowDescripcion = " **"
			Endif

** Ahora buscamos las direcciones de mail.
			***If mPrestacion = 0
			***	mret = SQLExec(mcon1,"select * from TabEstados where propietario = 4 and tipo = 35 and Estado = ?nPos","mwkTabEstEnt")
			***Else
			DO CASE 
			CASE mPrestacion >= 0 AND mInsumo = 0
		         mret = SQLExec(mcon1,"select * from TabEstados where propietario = 4 and tipo = 35 and Estado = ?nPos and subestado = ?mPrestacion","mwkTabEstEnt")
		    CASE mInsumo > 0
		         mret = SQLExec(mcon1,"select * from TabEstados where propietario = 4 and tipo = 54 and Estado = ?nPos and subestado = ?mInsumo","mwkTabEstEnt")
		    ENDCASE  
			***Endif

			If mret < 0
				Messagebox("Error al consultar CORREOS de Envio.","Consulta")
				Return ""
			Endif

			Select mwkTabEstEnt
			Go Top

			Scan All
				If mwkTabEstEnt.Descrip = '%MEDSOLIC%'  &&Buscamos el e-mail del medico solicitante


				Else
					lcEmail = Alltrim(Descrip)
				Endif

				If !Empty(lcEmail)
					If At(lcEmail,mEmail) = 0
						mEmail = mEmail + lcEmail + ","
					Endif
				Endif
			Endscan

*!*				If !Empty(mEmail)
*!*					mEmail = Left(mEmail,Len(mEmail)-1)
*!*				Endif


			Use In Select("mwkTabEstEnt")
		Endif

	Endscan

Endif


** ---------------------------------------------- Codigo Nuevo - Marcelo Torres, 18/05/2018 - Revisado 24/09/2020
** ---------------------------------------------- Para adaptar al pedido de que todas las entidades puedan enviar e-mail
**If Empty(mEmail)
If mPrestacion = 0

	mret = SQLExec(mcon1,"select * from tabmail where TM_Entidad = ?nCodent and TM_Estado = ?nEstado and TM_especialidad = ?cOrigen ","mwkMailEnt1")

	If mret < 0
		Messagebox("Error al consultar tabla TABMAIL.","Consulta")
		Return ""
	Endif

	Select mwkMailEnt1
	Go Top

	Select * From mwkMailEnt1 Where Nvl(TM_fecpasiva, Ctod("01/01/1900")) = Ctod("01/01/1900") Into Cursor mwkMailEnt

	Select mwkMailEnt
	Go Top

	Scan All

		If At(Alltrim(mwkMailEnt.TM_email), mEmail) = 0
			mEmail = mEmail + Alltrim(mwkMailEnt.TM_email)+","
		Endif

	Endscan

** Indicamos si agregamos DESCRIPCION al asunto del email.	

Endif

If !Empty(mEmail)
	mEmail = Left(mEmail,Len(mEmail)-1)
**mEmail = mEmail + cRowDescripcion
ENDIF
	
Use In Select("mwkTabEstEnt")
Use In Select("mwkTabEstAgrup")
Use In Select("mwkAgrupEnt")
Use In Select("mwkMailEnt")
Use In Select("mwkMailEnt1")

Return mEmail
