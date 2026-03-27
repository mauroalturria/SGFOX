****
** Busca nuevos vales de Nutricion
****

&& queda la Fecha Limite de INTERNADOS
*!*	Use In Select("mwkUfan") 
*!*	Do sp_busco_ultfechanut && mwkUfan
&& ------------------------------------

&& PARA HACER PRUEBAS
*!*	Select mwkUfan
*!*	Replace Fecha_UAct_Alim WITH Ctod("04/04/2011")

Dimension cf(100)
Store '' To cf
 *set step on
mfechabaja = sp_busco_fecha_srv2('DT')
mfechahoy = Ttod(mfechabaja)
fechalimite = mfechabaja - 3600*24*3 && LE RESTE dos dias
horalimite = Ctot( Dtoc(mfechahoy) + " 11:00:00")
mfechanull = Ctot("01/01/1900")

*!*	------------------------------------------------------------------------------------
*!*	Pacientes en transito
*!*	------------------------------------------------------------------------------------
mret = SQLExec(mcon1, "Select Guardia.*, GuardiaVale.NroVale " + ;
	"from Guardia " + ;
	"Inner Join GuardiaVale on GuardiaVale.Protocolo = Guardia.Protocolo " + ;
	"Inner Join tabtipoaltas on guardia.codestado = tabtipoaltas.id " + ;
	"Where codserv = 9400 and guardia.fechahoraing >= ?fechalimite "+;
	" and (tabtipoaltas.tipoest>0 or tabtipoaltas.sector = '1') "	, "mwkGuardia1")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DE CURSOR, AVISAR A SISTEMAS", 13,"VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif
*!*	------------------------------------------------------------------------------------

select min(fechahoraing) as fechavale from mwkGuardia1 into cursor mwkGuardiaf
mfechahval = iif(reccount("mwkGuardia1")>0,mwkGuardiaf.fechavale,mfechabaja)
mfechaval = ttod(mfechahval)

mret = SQLExec(mcon1, "select VAL_codsector, VAL_codadmision, VAL_fechasolicitud, " + ;
	"pia_cantsolicitada, pia_codprest, pia_secuen_carga, nombre, " + ;
	"VAL_fechacargasoli, VAL_horacargasolic, VAL_codvaleasist, " + ;
	"VAL_operadorcarga, VAL_medicosolicit, VAL_observaciones " + ;
	"from valesasist " + ;
	"left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist " + ;
	"left outer join prestadores on valesasist.VAL_prestador = prestadores.id " + ;
	"where VAL_fechasolicitud >= ?mfechaval and " + ;
	"VAL_codservvale = 9400 and VAL_codsector = 'GUA'", "mwktotval0x")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DE CURSOR, AVISAR A SISTEMAS", 13,"VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif
*!*	------------------------------------------------------------------------------------
*!*	QUEDAN SOLO LOS VALES DE PACIENTES EN TRANSITO
Select mwkGuardia1.Protocolo, mwktotval0x.* ;
	From mwktotval0x;
	Inner Join mwkGuardia1 On mwkGuardia1.NroVale = mwktotval0x.VAL_codvaleasist ;
	Into Cursor mwktotval01

mret = SQLExec(mcon1, "select tnd_nroVale from TabNutDetAmb "+;
	" where TND_FHoraCarga >= ?mfechahval ", "mwkvales")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DE CURSOR", 13,"VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif
*!*	------------------------------------------------------------------------------------
Select * From mwktotval01 ;
	where VAL_codvaleasist Not In (Select tnd_nroVale From mwkvales) ;
	into Cursor mwktotval1

*!*	------------------------------------------------------------------------------------
mret = 	SQLExec(mcon1, "select pre_codprest, pre_descriprest " + ;
	"from prestacions " + ;
	"where pre_codservicio = 9400 and PRE_fechapasiva is null " , "mwkpres")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DE CURSOR", 13,"VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif
*!*	------------------------------------------------------------------------------------
mret = 	SQLExec(mcon1, "select TNP_codPrest, TNP_codfactu, TNP_factura, TNP_Dieta "+;
	" from TabNutPrest " , "mwkTNprest")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DE CURSOR", 13,"VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif
*!*	------------------------------------------------------------------------------------

Select * ;
	From mwktotval1 ;
	Left Join mwkpres On pre_codprest = pia_codprest ;
	left Join mwkTNprest On pia_codprest = TNP_codPrest ;
	where Nvl(TNP_Dieta,0) < 9 ;
	order By VAL_codadmision, VAL_fechacargasoli, VAL_horacargasolic, ;
		VAL_codvaleasist, pia_secuen_carga ;
	into Cursor mwktotval

*!*		group By VAL_codadmision, VAL_fechacargasoli, pia_codprest ;
*!*		into Cursor mwktotval

Select mwktotval
Go Top
mfhora = sp_busco_fecha_serv('DT')
horaproceso = Hour(mfhora)*100 + Minute(mfhora)

*********************************************************************************************************************************
*********************************************************************************************************************************

Select mwktotval
Go Top
Do While !Eof('mwktotval')
	
*	mcodadm	= mwktotval.VAL_codadmision
	mtiposer = 0
	mcodvax	= mwkusuario.codigovax
	mproto = mwktotval.Protocolo
	*!*	------------------------------------------------------------------------------------

	mret = SQLExec(mcon1, "select * from TabNutPacAmb "+;
		"where TNP_protocolo = ?mproto and TNP_Fecha = ?mfechahoy "+;
		" and TNP_CodServ = ?mtiposer","mwkexistepac")
	
	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DE CURSOR", 13,"VALIDACION")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif
	*!*	------------------------------------------------------------------------------------

	If Reccount("mwkexistepac")>0
		mid = mwkexistepac.Id
		If Nvl(tnp_modi,0) = 1
			madapt = TNP_Observaciones
		Else
			madapt = ''
		Endif
		*!*	------------------------------------------------------------------------------------
		mret = SQLExec(mcon1, "update TabNutDetAmb set TND_fecBaja = ?mfechabaja "+;
			" where TND_idPaciente = ?mid and TND_fecBaja = ?mfechanull ")
		If mret < 0
			=Aerr(eros)
			Messagebox("ERROR EN LA GENERACION DE CURSOR", 13,"VALIDACION")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
		
		*!*	------------------------------------------------------------------------------------
		mret = SQLExec(mcon1, "Update TabNutPacAmb set TNP_CodFact = '' "+;
			", TNP_Observaciones = ?madapt where id = ?mid")
		If mret < 0
			=Aerr(eros)
			Messagebox("ERROR EN LA GENERACION DE CURSOR", 13,"VALIDACION")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
		*!*	------------------------------------------------------------------------------------
	Else
		mret = SQLExec(mcon1, "insert into TabNutPacAmb (TNP_protocolo"+;
			",TNP_Fecha,TNP_CodServ,TNP_CodFact,TNP_Observaciones,TNP_Usuario )"+;
			" values (?mProto,?mfechahoy,?mtiposer,'','',?mcodvax )")

		If mret < 0
			=Aerr(eros)
			Messagebox("ERROR EN LA GENERACION DE CURSOR", 13,"VALIDACION")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
		*!*	------------------------------------------------------------------------------------
		mret = SQLExec(mcon1, "select * from TabNutPacAmb "+;
			"where TNP_protocolo = ?mProto and TNP_Fecha = ?mfechahoy "+;
			" and TNP_CodServ = ?mtiposer","mwkexistepac")

		If mret < 0
			=Aerr(eros)
			Messagebox("ERROR EN LA GENERACION DE CURSOR", 13,"VALIDACION")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
		*!*	------------------------------------------------------------------------------------
		If Reccount("mwkexistepac")>0
			mid = mwkexistepac.Id
		Else
			Messagebox("esto esta mal")
			Messagebox("Proto= "+mProto+" Fecha="+Dtoc(mfechahoy)+" CS="+Str(mtiposer))
		Endif
	Endif

	*!*	------------------------------------------------------------------------------------

	Do While !Eof('mwktotval') And 	mproto = mwktotval.Protocolo

*!*		Do While !Eof('mwktotval') And 	mcodadm	= mwktotval.VAL_codadmision
		mfechacarga = Ctot(Dtoc(mwktotval.VAL_fechacargasoli)+" "+Left(Ttoc(mwktotval.VAL_horacargasolic,2),8))
		mpresta		= mwktotval.pia_codprest
		mvale 		= mwktotval.VAL_codvaleasist
		mobserva	= Nvl(mwktotval.VAL_observaciones,'')
		musu_carga 	= mwktotval.VAL_operadorcarga
		mmedico		= mwktotval.VAL_medicosolicit
		mcant 		= mwktotval.pia_cantsolicitada
		If mwktotval.TNP_Dieta # 6
			mcant = 1
		Endif
		horactr = Val(Left(Ttoc(mwktotval.VAL_horacargasolic,2),2))
		mth	= Iif( horactr<11,0,1)
		mtd = Nvl(mwktotval.TNP_Dieta,0)>0
		*endif
		*!*		if TNP_Dieta = 4
		*!*			mtiposer = iif( horactr>7 and horactr<16,6,5)
		*!*		endif
		*!*	------------------------------------------------------------------------------------
		mret = SQLExec(mcon1, "insert into TabNutDetAmb "+;
			"( TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga"+;
			",TND_observa, TND_fecbaja,TND_Cantidad, TND_Hora,TND_usuario )"+;
			" values (?mid, ?mpresta, ?mvale, ?mfechacarga, "+;
			"?mobserva,?mfechanull,?mcant,?horaproceso,?musu_carga )")

		If mret < 0
			=Aerr(eros)
			Messagebox("ERROR AL GUARDAR, AVISAR A SISTEMAS", 13,"VALIDACION")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
		*!*	------------------------------------------------------------------------------------

		Skip 1 In mwktotval
	Enddo
	*!*	------------------------------------------------------------------------------------
Enddo
*********************************************************************************************************************************
*********************************************************************************************************************************
Select Distinct Protocolo ;
	From mwktotval1 ;
	Into Cursor mwkauxi1

Select mwkauxi1
Go Top

Do While !Eof('mwkauxi1')
	mProto = Alltrim(mwkauxi1.Protocolo)
	mbusca = " and protocolo = '" + mProto + "' "

	Do sp_busco_dieta_amb With mfechahoy, 0, mbusca

	Select mwknutdieta.*, pre_descriprest ;
		from mwknutdieta ;
		Left Join mwkpres On pre_codprest = tnd_codprest ;
		into Cursor mwknutdieta1

	Select mwknutdieta1
	midpac = mwknutdieta1.TND_idPaciente
    
	mfhingreso = fechahoraing
	cmpres 	= ''
	mcodfac = ''
	ind_cf 	= 0
	Store '' To cf
	Do While !Eof('mwknutdieta1')
		mcodfac = Alltrim(mwknutdieta1.TNP_CodFactu)
		If !Empty(mcodfac) And Ascan(cf,mcodfac) = 0
			ind_cf 		= ind_cf +1
			cf(ind_cf)	= mcodfac
		Endif
		descriprest = Nvl( mwknutdieta1.pre_descriprest, '' )
		cmpres = cmpres + Iif(!Empty(cmpres ),"+",'') +;
			Iif(!Empty( descriprest), Proper(Iif(At("DIETA",descriprest)=1;
			,Alltrim(Strtran(descriprest,"DIETA ",""));
			,Alltrim(descriprest)));
			,'')
		Skip 1 In mwknutdieta1
	Enddo
	mcf = ''
	If ind_cf>0
		For ind = 1 To ind_cf
			mcf = mcf + Alltrim(cf(ind))+" "
		Next
	Endif

	Do sp_actualizo_tab_nut_pac_amb With 2, mProto, 0, cmpres, mcf, midpac

	mtiposer = 2
	*!*	------------------------------------------------------------------------------------
	mret = SQLExec(mcon1, "select * from TabNutPacAmb "+;
		"where TNP_protocolo = ?mProto and TNP_Fecha = ?mfechahoy "+;
		" and TNP_CodServ = ?mtiposer","mwkexistepac")

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DE CURSOR", 13,"VALIDACION")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif
	*!*	------------------------------------------------------------------------------------
	If Reccount("mwkexistepac")>0
		mid= mwkexistepac.Id
		If Nvl(tnp_modi,0)=1
			madapt = TNP_Observaciones
		Else
			madapt = ''
		Endif
		*!*	------------------------------------------------------------------------------------
		mret = SQLExec(mcon1, "Update TabNutPacAmb set TNP_CodFact = ?mcf "+;
			", TNP_Observaciones = ?madapt where id = ?mid")

		If mret < 0
			=Aerr(eros)
			Messagebox("ERROR EN LA ACTUALIZACION, AVISAR A SISTEMAS", 13,"VALIDACION")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
		*!*	------------------------------------------------------------------------------------
	Endif
	If horaproceso < 1100 Or (horaproceso < 1300 And mfhingreso >= horalimite )
		mtiposer = 1
		*!*	------------------------------------------------------------------------------------
		mret = SQLExec(mcon1, "select * from TabNutPacAmb "+;
			"where TNP_protocolo = ?mProto and TNP_Fecha = ?mfechahoy "+;
			" and TNP_CodServ = ?mtiposer","mwkexistepac")

		If mret < 0
			=Aerr(eros)
			Messagebox("ERROR EN LA GENERACION DE CURSOR", 13,"VALIDACION")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
		*!*	------------------------------------------------------------------------------------
		If Reccount("mwkexistepac")>0
			mid= mwkexistepac.Id
			If Nvl(tnp_modi,0)=1
				madapt = TNP_Observaciones
			Else
				madapt = ''
			Endif
			*!*	------------------------------------------------------------------------------------
			mret = SQLExec(mcon1, "Update TabNutPacAmb set TNP_CodFact = ?mcf "+;
				", TNP_Observaciones = ?madapt where id = ?mid")

			If mret < 0
				=Aerr(eros)
				Messagebox("ERROR EN LA GENERACION DE CURSOR", 13,"VALIDACION")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
			*!*	------------------------------------------------------------------------------------
		Endif
	Endif
	Skip 1 In mwkauxi1
Enddo

*********************************************************************************************************************************
*********************************************************************************************************************************

mtiposer = 0

mret = SQLExec(mcon1,"select * from TabNutPacAmb "+;
	"where TNP_Fecha = ?mfechahoy "+;
	" and TNP_CodServ = ?mtiposer ","mwkexistepac0")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DE CURSOR", 13,"VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif
*!*	------------------------------------------------------------------------------------
Select * ;
	From mwkexistepac0 ;
	Where Empty(TNP_Observaciones) ;
	Into Cursor mwkexistepac

If Reccount("mwkexistepac")>0

*********************************************************************************************************************************
*********************************************************************************************************************************

	Select mwkexistepac
	Do While !Eof('mwkexistepac')
		mProto = Alltrim(mwkexistepac.tnp_protocolo)
		mbusca= " and Protocolo = '" + mProto + "' "

		Do sp_busco_dieta_amb With mfechahoy, 0, mbusca

		Select mwknutdieta.*,pre_descriprest ;
			from mwknutdieta ;
			Left Join mwkpres On pre_codprest = tnd_codprest ;
			into Cursor mwknutdieta1

		Select mwknutdieta1
		midpac = mwknutdieta1.TND_idPaciente
		cmpres 	= ''
		mcodfac = ''
		ind_cf 	= 0
		Store '' To cf
		Do While !Eof('mwknutdieta1')
			mcodfac = Alltrim(mwknutdieta1.TNP_CodFactu)
			If !Empty(mcodfac) And Ascan(cf,mcodfac) = 0
				ind_cf 		= ind_cf +1
				cf(ind_cf)	= mcodfac
			Endif
			descriprest = Nvl( mwknutdieta1.pre_descriprest, '' )
			cmpres = cmpres + Iif(!Empty(cmpres ),"+",'') +;
				Iif(!Empty( descriprest), Proper(Iif(At("DIETA",descriprest)=1;
				,Alltrim(Strtran(descriprest,"DIETA ",""));
				,Alltrim(descriprest)));
				,'')
			Skip 1 In mwknutdieta1
		Enddo
		mcf = ''
		If ind_cf>0
			For ind = 1 To ind_cf
				mcf= mcf + Alltrim(cf(ind))+" "
			Next
		Endif
		
		Do sp_actualizo_tab_nut_pac_amb With 2,mProto,0,cmpres,mcf,midpac
		
		Select mwkexistepac
		Skip 1 In mwkexistepac
	Enddo
*********************************************************************************************************************************
*********************************************************************************************************************************
	
Endif
