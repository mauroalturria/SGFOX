*!*	---------------------------------------------------------------------------<
*!*	Preparo el desayuno
*!*	  
*!*	EL REPORCESO ES SOLO PARA EL DIA DE LA FECHA
*!*	
*!*	do sp_genero_desayuno with DATE(), 2+ 1, 1
*!*	do sp_genero_desayuno with DATE(), 2+ 2, 1
*!*	--------------------------------------------------------------------------- 
Parameter mfecha, mtiposer, mrepro

if vartype(mfecha)#"D"
	mfecha = sp_busco_fecha_serv("DD")
endif
if vartype(mtiposer)#"N"
	mtiposer = 3
endif
if vartype(mrepro)#"N"
	mrepro = 0
endif


Dimension cf(100)
Store '' To cf

If  Int(mtiposer/2)*2 <> mtiposer && =3
	mdiaant  = mfecha - 1
	mtipoant = mtiposer + 1
Else
	mdiaant  = mfecha
	mtipoant = mtiposer -1
Endif

mfechanull  = "1900-01-01 00:00:00"

If used("mwktaltas")
	Use in mwktaltas
Endif
mret = sqlexec(mcon1,"select descrip, id as idalta, sector,tipoest from tabtipoaltas " + ;
	"where ambito<=2 and tipoest>0 " + ;
	"order by descrip", "mwktnoaltas")
	
do sp_busco_prestacion_gua   &&& mwkprestgua.pre_codprest, PRE_descriprest 
*---------------------------------------------------------------------------------
*!*	9400 - ALIMENTACION

mret =	sqlexec(mcon1, "select pre_codprest, PRE_descriprest " + ;
	"from prestacions " + ;
	"where pre_codservicio = 9400 and PRE_fechapasiva is null " , "mwkpres")

If mret<1
	=Aerr(eros)
	Messagebox(eros(2))
Endif
*---------------------------------------------------------------------------------
Do sp_busco_agrup && Obtiene mwkTNagr && Agrupamientos
Do sp_busco_ingred && Obtiene mwkTNIngr && Ingredientes

mfecpas = Ctod("01/01/1900")

&& Agrupamientos y cantidad de ingredientes que agrupa
Select  TNA_CodAgr, TNA_Descripcion, Count(TN_CodAgr) As cantxgr ;
	from mwkTNIngr ;
	Left Join mwkTNagr On TNA_CodAgr = TN_CodAgr ;
	group By TN_CodAgr ;
	Into Cursor mwktotgr

if used("mwkTNIngr")
	use in mwkTNIngr 
endif

*---------------------------------------------------------------------------------------------

mret = SQLExec(mcon1, "select " + ;
	" REG_nombrepac, Reg_nrohclinica, Reg_numdocumento, REG_fecnacimiento, " + ;
	" TabNutPacAmb.*, Guardia.fechahoraing, Guardia.codprest, Guardia.codestado, " + ;
	" TabNutDetAmb.ID, TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, " + ;
	" TND_observa, TND_fecBaja, TND_usuario, TND_Cantidad, TND_Hora as  horas, " + ;
	" TNP_codfactu, TNP_factura, TNP_dieta, entidexclu.fecpasiva, Guardia.CodEnt " + ;
	" from TabNutPacAmb" + ;
	" left join Guardia on TabNutPacAmb.TNP_protocolo = Protocolo " + ;
	" left join registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
	" left join TabNutDetAmb on TabNutDetAmb.TND_idPaciente = TabNutPacAmb.id " + ;
	" left join TabNutPrest on TabNutPrest.TNP_codPrest = TabNutDetAmb.TND_codPrest " + ;
	" left join entidexclu on guardia.codent = entidexclu.codent and entidexclu.tpopac = 'GUA' " +;
	" where TNP_Fecha = ?mfecha and " + ;
	" TNP_CodServ = 0 and tnd_fecbaja = ?mfechanull and TNP_dieta <> 6 " , "mwknutact1")
If mret<1
	=Aerr(eros)
	Messagebox (eros(2))
Endif
*---------------------------------------------------------------------------------------------
mfechacarga = sp_busco_fecha_srv2('DT')

If mrepro = 1 and mfecha = ttod(mfechacarga)

*---------------------------------------------------------------------------------------------
	mret = sqlexec(mcon1, "select TabNutPacAmb.* " + ;
		"from TabNutPacAmb "+;
		"where TNP_Fecha = ?mfecha and TNP_CodServ = ?mtiposer "+;
		"and TNP_fecimp is null " , "mwkdietanul")

	If mret < 1
		=Aerr(eros)
		Messagebox (eros(2))
	Endif
*---------------------------------------------------------------------------------------------
	Select mwkdietanul
*!*		Scan
*!*			Do sp_borra_dieta With Id
*!*		Endscan

else
*---------------------------------------------------------------------------------------------	
	mret = sqlexec(mcon1, "select TNP_protocolo " + ;
		" from TabNutPacAmb  " + ;
		" where TNP_Fecha = ?mfecha and TNP_CodServ=?mtiposer " , "mwkdietaExis")

	If mret<1
		=Aerr(eros)
		Messagebox (eros(2))
	Endif
*---------------------------------------------------------------------------------------------	
Endif
*** Desayunos generados

*---------------------------------------------------------------------------------------------	
mret = SQLExec(mcon1, "select " + ;
	" REG_nombrepac, Reg_nrohclinica, Reg_numdocumento, REG_fecnacimiento, " + ;
	" TabNutPacAmb.*, Guardia.fechahoraing,TN_Ingrediente, TN_CodAgr, TN_Tipo,  " + ;
	" TabNutDetAmb.ID, TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, " + ;
	" TND_observa, TND_fecBaja, TND_usuario, TND_Cantidad, TND_Hora as  horas, " + ;
	" TNP_codfactu, TNP_factura, TNP_dieta, Guardia.CodEnt,codestado " + ;
	" from TabNutPacAmb" + ;
	" left join Guardia on TabNutPacAmb.TNP_protocolo = Protocolo " + ;
	" left join registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
	" left join TabNutDetAmb on TabNutDetAmb.TND_idPaciente = TabNutPacAmb.id " + ;
	" left join TabNutPrest on TabNutPrest.TNP_codPrest = TabNutDetAmb.TND_codPrest " + ;
	" left join TabNutIngr on TabNutIngr.id = TND_codPrest " + ;
	" left join  entidexclu on guardia.codent = entidexclu.codent and entidexclu.tpopac = 'GUA' " + ;
	" where TNP_Fecha = ?mfecha and TNP_CodServ = ?mtiposer " + ;
	" and tnd_fecbaja = ?mfechanull" , "mwkdietdes")

If mret<1
	=Aerr(eros)
	Messagebox (eros(2))
Endif
*---------------------------------------------------------------------------------------------	

Select Distinct TNP_protocolo ;
	From mwkdietdes where codestado in (select idalta from mwktnoaltas);
	Into Cursor mwkctrldesmer

Select Distinct TNP_protocolo ;
	From mwknutact1 where codestado in (select idalta from mwktnoaltas);
	Into Cursor mwkctrldietas

*** Nutricion anterior
*---------------------------------------------------------------------------------------------	
mret = sqlexec(mcon1, "select *  from TabNutPacAmb " + ;
	" where TNP_Fecha = ?mdiaant and  TNP_CodServ = ?mtipoant" , "mwknutant1")

If mret<1
	=Aerr(eros)
	Messagebox (eros(2))
Endif
*---------------------------------------------------------------------------------------------	

If (mrepro = 1 Or Reccount("mwkctrldesmer") < Reccount("mwkctrldietas")) and mfecha = ttod(mfechacarga )

	If Used("mwkdietanul")
		Select mwkdietanul
		Scan All 
			Do sp_borra_dieta With Id
			Select mwkdietanul
		Endscan
	Endif 	

	If Used('mwkauxi')
		Use In mwkauxi
	Endif

*	" REG_nombrepac, Reg_nrohclinica, Reg_numdocumento, REG_fecnacimiento, " + ;

Select "GUARDIA" habitac, REG_nombrepac as PAC_nombrepaciente,  ;
		Proper(nvl(mwkprestgua.PRE_descriprest,'')) As PAC_descripdiagn, ;
		ttoc(fechahoraing) as PAC_fechaadmision, ;
		codent as pin_codentidad, TNP_protocolo as PAC_codadmision, ;
		prg_edad(REG_fecnacimiento) As anios, ;
		TNP_Fecha, TNP_CodServ, TNP_CodFact, TNP_codfactu, TNP_factura, TNP_Observaciones, ;
		TNP_Usuario, TND_observa, TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, mwkpres.pre_descriprest, ;
		"GUARDIA" as sec_descripsec, mwknutact1.fecpasiva, TNP_Observaciones As indicacion, Space(250) As Observaciones ;
		from mwknutact1 ;
		left Join mwkpres On TND_codPrest = pre_codprest ;
		left join mwkprestgua on codprest = mwkprestgua.pre_codprest;
		inner join mwktnoaltas on codestado = mwktnoaltas.idalta;
		order By habitac, PAC_codadmision, TNP_CodServ, TND_NroVale ;
		into Cursor mwknutcdact1

	Wait Windows ("Generando Dieta... Aguarde") Nowait

	select * ;
		from mwknutcdact1 ;
		group By habitac, PAC_codadmision, TNP_CodServ ;
		into cursor mwkauxi

	select * ;
		from mwknutcdact1 ;
		group By PAC_codadmision, TND_codPrest ;
		into cursor mwkauxiprest

	** ahora vemos compatibilidades

	mfecpas = Ctod("01/01/1900")
	** indispensables

*---------------------------------------------------------------------------------------------	
	

	mret = sqlexec(mcon1, "select TND_codPrest, TNP_protocolo, TND_idPaciente,TND_observa, TabNutIngr.*, REG_fecnacimiento " + ;
		" from TabNutPacAmb" + ;
		" left join Guardia on TabNutPacAmb.TNP_protocolo = Protocolo " + ;
	" left join registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
		" left join TabNutDetAmb on TabNutDetAmb.TND_idPaciente = TabNutPacAmb.id " + ;
		" left join TabNutComp on (TabNutComp.TNC_codPrest= TND_codPrest and TabNutComp.TNC_tipo=1 ) " + ;
		" left join TabNutIngr on TabNutComp.TNC_idIngr = TabNutIngr.id " + ;
		" where TNP_Fecha >= ?mfecha and TNP_CodServ=0  and tnd_fecbaja = ?mfechanull and " +;
		" TN_tipo <= 2 and TNC_fecpasiva = ?mfecpas " + ;
		" and TNP_protocolo not in (select TNP_protocolo " + ;
		" from TabNutPacAmb " + ;
		" where TNP_Fecha = ?mfecha and TNP_CodServ = ?mtiposer )" + ;
		" group by TNP_protocolo, TabNutIngr.id, TN_codagr ", "mwknutdesa1")
	If mret<1
		=Aerr(eros)
		Messagebox (eros(3))
	Endif
		
*---------------------------------------------------------------------------------------------	
*!*	
*!*	ESTA CONSULTA SE MODIFICO POR EL CAMBIO DE VERSION DE CACHE 2009

mret = sqlexec(mcon1, "select TND_codPrest, TNP_protocolo, TND_idPaciente,TND_observa, " + ;
	" elid as Id, TN_Ingrediente, TN_CodAgr, TN_Tipo , REG_fecnacimiento " + ;
	" from TabNutPacAmb " + ;
	" left join Guardia on TabNutPacAmb.TNP_protocolo = Protocolo " + ;
	" left join registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
	" left join TabNutDetAmb on TabNutDetAmb.TND_idPaciente = TabNutPacAmb.id " + ;
	    "inner join (Select TabNutDietaPrest.*, TabNutIngr.*, TabNutIngr.Id as elid from TabNutDietaPrest " + ;
	    "inner join TabNutIngr on TabNutDietaPrest.TNDP_idIngr  = TabNutIngr.id and TN_tipo <= 2 " + ;
	    "where TNDP_fecpasiva = ?mfechanull and TNDP_tipo = 1 and TNDP_CodServ = 3  ) on TNDP_codPrest = TND_codPrest " + ;
	" where TNP_Fecha >= ?mfecha and TNP_CodServ = 0 and tnd_fecbaja = ?mfechanull and 14 <= TNDP_edad " + ;
	" and TNP_protocolo not in (select TNP_protocolo from TabNutPacAmb " + ;
	" where TNP_Fecha = ?mfecha and TNP_CodServ = 3) " + ;
	" group by TNP_protocolo, elid, TN_codagr ", "mwknutdesa11")	
	
	If mret<1
		=Aerr(eros)
		Messagebox (eros(3))
	Endif

*---------------------------------------------------------------------------------------------	
	** Prohibidos

	mret = sqlexec(mcon1, "select * " + ;
		"from TabNutComp " + ;
		"left join TabNutIngr on TabNutComp.TNC_idIngr = TabNutIngr.id " + ;
		"where TNC_tipo=2 and TN_tipo <= 2 and TNC_fecpasiva = ?mfecpas " + ;
		" ", "mwknutdesa2")

	If mret<1
		=Aerr(eros)
		Messagebox (eros(3))
	Endif
*---------------------------------------------------------------------------------------------	

	select PAC_codadmision, TNC_idIngr ;
		from mwkauxiprest ;
		left join mwknutdesa2 on TND_codPrest = TNC_codPrest ;
		group By PAC_codadmision, TNC_idIngr ;
		having TNC_idIngr > 0 ;
		into cursor mwkingproh

	** no compatibles
	mfecpas = Ctod("01/01/1900")
*---------------------------------------------------------------------------------------------	

	mret = sqlexec(mcon1, "select  TND_codPrest, TNP_protocolo, TND_idPaciente, TND_observa,TabNutIngr.*, REG_fecnacimiento " + ;
		" from TabNutIngr,TabNutPacAmb,guardia,registracio,tabtipoaltas " + ;
		" left join TabNutDetAmb on TabNutDetAmb.TND_idPaciente = TabNutPacAmb.id " + ;
		" left join TabNutPrest on TabNutPrest.TNP_codPrest= TabNutDetAmb.TND_codPrest " + ;
		" where codestado = tabtipoaltas.id and tipoest>0 and TabNutPacAmb.TNP_protocolo = Protocolo  and nroregistrac = reg_nroregistrac and "+;
		" TNP_Fecha >= ?mfecha and TNP_CodServ=0 and TN_tipo <= 2 and tnd_fecbaja = ?mfechanull " + ;
		" and TNP_dieta <> 6 and TNP_protocolo not in (select TNP_protocolo from TabNutPacAmb " + ;
		" where TNP_Fecha = ?mfecha and TNP_CodServ=?mtiposer ) " + ;
		"order by TNP_protocolo, TND_codPrest ", "mwknutdesa01")
	If mret<1
		=Aerr(eros)
		Messagebox (eros(3))
	Endif
*---------------------------------------------------------------------------------------------	

	mret = sqlexec(mcon1, "select TabNutComp.* " + ;
		" from TabNutIngr " + ;
		" left join TabNutComp on (TabNutComp.TNC_idIngr = TabNutIngr.id and TabNutComp.TNC_tipo = 0 ) "+;
		" where TN_tipo <= 2 and TNC_fecpasiva = ?mfecpas ", "mwknutdesa02")

	If mret<1
		=Aerr(eros)
		Messagebox (eros(3))
	Endif
*---------------------------------------------------------------------------------------------	
	select PAC_codadmision, TNC_idIngr ;
		from mwkauxiprest ;
		left join mwknutdesa02 on TND_codPrest = TNC_codPrest ;
		group By PAC_codadmision, TNC_idIngr having TNC_idIngr > 0 ;
		into cursor mwkingNoComp
		
	mret = sqlexec(mcon1, "select TabNutDietaPrest.* " + ;
		" from TabNutDietaPrest " + ;
		" left join TabNutIngr on TabNutDietaPrest.TNDP_idIngr = TabNutIngr.id "+;
			" where TNDP_fecpasiva = ?mfecpas and TNDP_tipo = 2 and TNDP_CodServ = ?mtiposer ", "mwknutDPnova")

	If mret<1
		=Aerr(eros)
		Messagebox (eros(3))
	Endif
*---------------------------------------------------------------------------------------------	

select mwknutdesa01.* ;
		From mwknutdesa01 ;
		Where alltrim(TNP_protocolo )+transf(id,"999999");
		not in (select alltrim(PAC_codadmision )+transf(TNC_idIngr,"999999") from mwkingNoComp) ;
		into cursor mwknutdesa01a

			
	Select * ;
		From mwknutdesa01a ;
		union ;
	Select * ;
		From mwknutdesa11 ;
		union ;
	Select * ;
		From mwknutdesa1 ;
		Where !Isnul(Id);
		into Cursor mwknutdesau

	select * ;
		From mwknutdesau ;
		Where alltrim(TNP_protocolo ) + transf(id,"999999");
	 	not in (select alltrim(PAC_codadmision ) + transf(TNC_idIngr,"999999") from mwkingproh ) ;
		into cursor mwknutdesa01b

	Select * ;
		from mwknutdesa01b ;
		left join mwknutDPnova on (TND_codPrest = TNDP_codPrest  ;
		and TNDP_idIngr = mwknutdesa01b.id ) ;
		into cursor mwknutsdpedad

	select * ;
		from mwknutsdpedad ;
		where isnull(TNDP_edad) or (TNDP_edad < 17 and TNDP_CodServ = mtiposer) ;
		into cursor mwknutdesa01c

	if used("mwkfiltro")
		use in mwkfiltro
	endif
	if used("mwkfiltro2")
		use in mwkfiltro2
	endif
	if used("mwkprohib")
		use in mwkprohib
	endif
	if used("mwksesaca")
		use in mwksesaca
	endif

	Select mwknutdesa01c.*, mwktotgr.* ;
		from mwknutdesa01c ;
		left Join mwktotgr On TN_CodAgr=TNA_CodAgr ;
		order By mwknutdesa01c.TNP_protocolo, TN_CodAgr, tn_ingrediente ;
		group By mwknutdesa01c.TNP_protocolo, TN_CodAgr, tn_ingrediente ;
		Into Cursor mwkdesayunos

	If Used('auxidesa')
		Use In auxidesa
	Endif

	select *, id_a as id ;
		from mwkdesayunos ;
		Into Cursor mwkdesayuno
	if !used("mwkusuario")
		create cursor mwkusuario (idusuario c(20),codigovax n(7),password c(10),id n(2),nivel n(2),sector c(30),nomape c(30))
		insert into mwkusuario values ("CFUNES",54035,'',146,1,'SISTEMAS',"Carmencita")
	endif

&&&  Genero los registros
	Select  mwkdesayuno
	mcodadm =''
	select mwkdesayuno
	Go Top
	Do While !Eof('mwkdesayuno')
		mtipo = mtiposer
		mingr = mwkdesayuno.Id
		msec = Iif(	mcodadm	= mwkdesayuno.TNP_protocolo,msec+1,1)
		mcodadm		= mwkdesayuno.TNP_protocolo
		mpresta		= mwkdesayuno.Id
		mvale 		= msec
		mobserva	= mwkdesayuno.TND_observa
		musu_carga 	= mwkusuario.codigovax
		mmedico		= 0
		mcodvax	= mwkusuario.codigovax
		lsigue = .T.
*	If mrepro = 0
		Select TNP_protocolo from mwkdietdes where TNP_protocolo = mcodadm into cursor mwkexis
		lsigue = (reccount('mwkexis')=0)
		Select  mwkdesayuno
*	Endif
		If lsigue
		
			Do sp_actualizo_tab_nut_pac_amb With 1, mcodadm, mtiposer, '','','',mfecha

			mret =sqlexec(mcon1, "select id from TabNutPacAmb "+;
				"where TNP_protocolo = ?mcodadm and TNP_Fecha = ?mfecha "+;
				" and TNP_CodServ = ?mtiposer","mwkexistepac")
			midpac= mwkexistepac.Id
			Do While !Eof('mwkdesayuno') And  mcodadm = mwkdesayuno.TNP_protocolo

				mtipo = mtiposer
				mingr = mwkdesayuno.Id
				msec = Iif(	mcodadm	= mwkdesayuno.TNP_protocolo,msec+1,1)
				mcodadm		= mwkdesayuno.TNP_protocolo
				mpresta		= mwkdesayuno.Id
				mvale 		= msec
				mobserva	= ""
				musu_carga 	= mwkusuario.codigovax
				mmedico		= 0
				mcodvax	= mwkusuario.codigovax
				
				Do sp_actualizo_tab_nut_det_amb With 1, midpac, mingr, mvale,mfechacarga,mobserva
				
				Skip 1 in mwkdesayuno
			Enddo
		Else
			Do While !Eof('mwkdesayuno') And  mcodadm = mwkdesayuno.TNP_protocolo
				Skip 1 IN mwkdesayuno
			Enddo
		Endif
	Enddo

	Create Cursor auxidesa (codadm c(8), desayuno c(250))

	if used("mwktotgr")
		use in mwktotgr
	endif
	if used("mwkdietanul")
		use in mwkdietanul
	endif
	if used("mwkdietdes")
		use in mwkdietdes
	endif


	select * from mwkdesayuno order by TNP_protocolo,tna_codagr,id into cursor mwkdesayunos
	select  mwkdesayunos
	go top

	Do While !Eof()
		mcod = TNP_protocolo
		magr = TN_CodAgr
		midpac = TND_idPaciente
		mingr = Nvl(Alltrim(Lower(tn_ingrediente)),'')
		mdesgr = Nvl(Alltrim(Lower(TNA_Descripcion)),'')
		mdes = ''
		lena = 0
		canxg = 1
		mcanxg = cantxgr
		Skip
		Do While !Eof() And mcod = TNP_protocolo
		Do While !Eof() And mcod = TNP_protocolo and magr = TN_CodAgr
			If magr > 0
				mingr = mingr +iif(len(mingr)>0,' o ','') + Nvl(Alltrim(Lower(tn_ingrediente)),'')
				canxg = canxg + 1
			Else
				If canxg = mcanxg And canxg > 1
					mingr = Iif(lena=0,'',Left(mingr,lena)+', ')+ mdesgr
				Endif
				lena = Len(mingr)
				mingr = mingr + ', ' + Nvl(Alltrim(Lower(tn_ingrediente)),'')
				canxg = 1
				mcanxg = cantxgr
			Endif
			Skip
		Enddo
			mdes = iif(len(mdes)=0,'',mdes+', ')+ iif(canxg >= mcanxg,mdesgr,mingr)
			mingr = ''
			canxg = 1
			mdesgr = nvl(alltrim(lower(TNA_Descripcion)),'')
			magr = TN_CodAgr
		enddo

		Insert Into auxidesa (codadm, desayuno) Values (mcod,mdes)
		lsigue = .t.
		if mrepro=0
			select * from mwkdietaExis where TNP_protocolo = mcod  into cursor mwksigue
			lsigue = (reccount('mwksigue')=0)
		endif
		if lsigue
			do sp_actualizo_tab_nut_pac_amb with 1, mcod, mtiposer, mdes, '', '', mfecha
		endif
		Select  mwkdesayuno
	Enddo
		
	if mtiposer = 3
*		do sp_cargo_colaciones with mfecha	
	endif
Endif

if used("mwknutdesa1")
	use in mwknutdesa1
endif
if used("mwknutdesa11")
	use in mwknutdesa11
endif
if used("mwknutdesa2")
	use in mwknutdesa2
endif
if used("mwknutdesa01")
	use in mwknutdesa01
endif
if used("mwknutdesa02")
	use in mwknutdesa02
endif
if used("mwknutDPnova")
	use in mwknutDPnova
endif
if used("mwktotgr")
	use in mwktotgr
endif
if used("mwkdietanul")
	use in mwkdietanul
endif
if used("mwkdietdes")
	use in mwkdietdes
endif
if used("mwkpres")
	use in mwkpres
endif

do sp_busco_dieta_amb with mfecha, mtiposer, , 1

*!*	REG_nombrepac, Reg_nrohclinica, Reg_numdocumento, Reg_telefonos, Reg_domicilio, REG_fecnacimiento

	*!*	PAC_habitacion + '-' + PAC_cama As habitac, PAC_nombrepaciente, ;
	*!*			Proper(PAC_descripdiagn) As PAC_descripdiagn, ;
	*!*			PAC_fechaadmision, PAC_horaadmision , cob_codentidad As pin_codentidad, PAC_codadmision, ;
	*!*			Iif(PAC_edad > 0, Transf(PAC_edad,'999'),Transf(Round((mfecdia - PAC_fecnacimiento)/30,0),'99') + "M") As anios, ;


Select mwkdieta.*, ;
	mwkdieta.TNP_Observaciones as desayuno, ;
	Reg_NombrePac as PAC_nombrepaciente, prg_edad(REG_fecnacimiento) as anios, 'GUA' as Habitac, '' as PE ;
	,'' as mobsam;
	From mwkdieta ;
	order By TNP_protocolo ;
	group by mwkdieta.TNP_protocolo  ;
	Into Cursor mwkdesa
	