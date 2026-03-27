****
** preparo el desayuno
****

Parameter mfecha,mtiposer,mrepro
Dimension cf(100)
Store '' To cf

If  Int(mtiposer/2)*2 <> mtiposer && =3
	mdiaant = mfecha - 1
	mtipoant = mtiposer + 1
Else
	mdiaant = mfecha
	mtipoant = mtiposer -1
Endif
mfechanull  = "1900-01-01 00:00:00"
mret =	sqlexec(mcon1, "select pre_codprest,PRE_descriprest" + ;
	" from prestacions " + ;
	" where pre_codservicio = 9400 and PRE_fechapasiva is null " , "mwkpres")
If mret<1
	=Aerr(eros)
	Messagebox(eros(2))
Endif
Do sp_busco_agrup
Do sp_busco_ingred
mfecpas = Ctod("01/01/1900")
Select  TNA_CodAgr,TNA_Descripcion ,Count(TN_CodAgr) As cantxgr ;
	from mwkTNIngr Left Join mwkTNagr On TNA_CodAgr=TN_CodAgr;
	group By TN_CodAgr Into Cursor mwktotgr

if used("mwkTNIngr")
	use in mwkTNIngr 
endif

mret = sqlexec(mcon1, "select hab_codhabitacion, hab_codcama,PAC_nombrepaciente " + ;
	", PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision, pin_codentidad,PAC_edad "+;
	", PAC_codadmision,PAC_fecnacimiento,PAC_codhci  "+;
	", sec_descripsec, entidexclu.fecpasiva ,TabNutPaciente.* ,TNP_codfactu,TNP_factura,TNP_dieta " + ;
	", TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga, TND_observa "+;
	" from pacinternad left join pacientes on pin_codadmision = PAC_codadmision " + ;
	" left join habitacions on hab_codpaciente = PAC_codadmision " + ;
	" left outer join sectores on sec_codsector = hab_sectores " + ;
	" left join TabNutPaciente on pin_codadmision = TNP_codadmision " + ;
	" left join TabNutDetalle on TND_idPaciente = TabNutPaciente.id " + ;
	" left join TabNutPrest on TNP_codPrest= TND_codPrest " + ;
	" left join  afiliacion on " +;
	"	PAC_codhci = registracio and " + ;
	"	pin_codentidad = AFI_codentidad " + ;
	" left join  entidexclu on pin_codentidad = entidexclu.codent and tpopac = 'INT'  " +;
	" where TNP_Fecha >= ?mfecha and TNP_CodServ=0 and tnd_fecbaja = ?mfechanull   " , "mwknutact1")
If mret<1
	=Aerr(eros)
	Messagebox (eros(2))
Endif

If mrepro = 1
	mret = sqlexec(mcon1, "select TabNutPaciente.* " + ;
		" from pacinternad left join pacientes on pin_codadmision = PAC_codadmision " + ;
		" left join TabNutPaciente on pin_codadmision = TNP_codadmision " + ;
		" where TNP_Fecha = ?mfecha and TNP_CodServ=?mtiposer " , "mwkdietanul")
	If mret<1
		=Aerr(eros)
		Messagebox (eros(2))
	Endif

	mret = sqlexec(mcon1, "delete from TabNutPaciente " + ;
		" where TNP_Fecha = ?mfecha and TNP_CodServ=?mtiposer ")
	If mret<1
		=Aerr(eros)
		Messagebox (eros(2))
	Endif
	Select mwkdietanul
	Scan
		Do sp_borra_dieta With Id
	Endscan
else
	mret = sqlexec(mcon1, "select TNP_codadmision " + ;
		" from TabNutPaciente  " + ;
		" where TNP_Fecha = ?mfecha and TNP_CodServ=?mtiposer " , "mwkdietaExis")

Endif
*** Desayunos generados

mret = sqlexec(mcon1, "select hab_codhabitacion, hab_codcama,PAC_nombrepaciente " + ;
	", PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision, pin_codentidad,PAC_edad "+;
	", PAC_codadmision,PAC_fecnacimiento,PAC_codhci,TN_Ingrediente,TN_CodAgr,TN_Tipo  "+;
	", sec_descripsec, entidexclu.fecpasiva ,TabNutPaciente.* " + ;
	", TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga, TND_observa "+;
	" from pacinternad left join pacientes on pin_codadmision = PAC_codadmision " + ;
	" left join habitacions on hab_codpaciente = PAC_codadmision " + ;
	" left outer join sectores on sec_codsector = hab_sectores " + ;
	" left join TabNutPaciente on pin_codadmision = TNP_codadmision " + ;
	" left join TabNutDetalle on TND_idPaciente = TabNutPaciente.id " + ;
	" left join TabNutIngr on TabNutIngr.id = TND_codPrest " + ;
	" left join  afiliacion on " +;
	"	PAC_codhci = registracio and " + ;
	"	pin_codentidad = AFI_codentidad " + ;
	" left join  entidexclu on pin_codentidad = entidexclu.codent and tpopac = 'INT'  " +;
	" where TNP_Fecha = ?mfecha and TNP_CodServ=?mtiposer and tnd_fecbaja = ?mfechanull   " , "mwkdietdes")
If mret<1
	=Aerr(eros)
	Messagebox (eros(2))
Endif

*** Nutricion anterior
mret = sqlexec(mcon1, "select *  from TabNutPaciente " + ;
	" where TNP_Fecha = ?mdiaant and  TNP_CodServ = ?mtipoant" , "mwknutant1")
If mret<1
	=Aerr(eros)
	Messagebox (eros(2))
Endif

If Used('mwkauxi')
	Use In mwkauxi
Endif

Select hab_codhabitacion+'-'+hab_codcama As habitac,PAC_nombrepaciente  ;
	, Proper(PAC_descripdiagn) As PAC_descripdiagn ;
	, Dtoc(PAC_fechaadmision)+" "+Ttoc(PAC_horaadmision,2) As PAC_fechaadmision;
	, pin_codentidad,PAC_codadmision ;
	, Iif(PAC_edad>0,Transf(PAC_edad,'999'),Transf(Round((mfecha-PAC_fecnacimiento)/30,0),'99')+"M") As anios ;
	, TNP_Fecha ,TNP_CodServ, TNP_CodFact, TNP_codfactu,TNP_factura, TNP_Observaciones;
	, TNP_Usuario,TND_observa, TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga,pre_descriprest ;
	,sec_descripsec, mwknutact1.fecpasiva, TNP_Observaciones As indicacion,Space(250) As Observaciones;
	from mwknutact1 ;
	left Join mwkpres On TND_codPrest = pre_codprest ;
	order By habitac, PAC_codadmision , TNP_CodServ,TND_NroVale  ;
	into Cursor mwknutcdact1
if used("mwkpres")
	use in mwkpres
endif

Wait Windows ("Generando Dieta... Aguarde") Nowait
select * from mwknutcdact1 ;
	group By habitac, PAC_codadmision , TNP_CodServ ;
	into cursor mwkauxi

** ahora vemos compatibilidades

mfecpas = Ctod("01/01/1900")
** indispensables
mret = sqlexec(mcon1, "select  TND_codPrest,TNP_codadmision, TND_idPaciente ,TabNutIngr.*,PAC_edad  " + ;
	" from pacinternad left join pacientes on pin_codadmision = PAC_codadmision " + ;
	" left join TabNutPaciente on pin_codadmision = TNP_codadmision " + ;
	" left join TabNutDetalle on TND_idPaciente = TabNutPaciente.id" + ;
	" left join TabNutComp on (TNC_codPrest= TND_codPrest and TNC_tipo=1 )"  + ;
	" left join TabNutIngr on TNC_idIngr = TabNutIngr.id" + ;
	" where TNP_Fecha >= ?mfecha and TNP_CodServ=0  and tnd_fecbaja = ?mfechanull  and TN_tipo <= 2 and TNC_fecpasiva = ?mfecpas "+;
	" and TNP_codadmision not in (select TNP_codadmision from TabNutPaciente "+;
	" 	where TNP_Fecha = ?mfecha and TNP_CodServ=?mtiposer )" +;
	" group by TNP_codadmision,TabNutIngr.id,TN_codagr ", "mwknutdesa1")

mret = sqlexec(mcon1, "select  TND_codPrest,TNP_codadmision, TND_idPaciente ,TabNutIngr.* ,PAC_edad " + ;
	" from pacinternad,TabNutDietaPrest" + ;
	" left join pacientes on pin_codadmision = PAC_codadmision " + ;
	" left join TabNutPaciente on pin_codadmision = TNP_codadmision " + ;
	" left join TabNutDetalle on TND_idPaciente = TabNutPaciente.id" + ;
	" left join TabNutIngr on TNDP_idIngr = TabNutIngr.id" + ;
	" where TNP_Fecha >= ?mfecha and TNP_CodServ=0  and TN_tipo <= 2 and TNDP_CodServ=?mtiposer  "+;
	" and TNDP_fecpasiva = ?mfecpas and TNDP_codPrest= TND_codPrest and TNDP_tipo=1 "  + ;
	" and tnd_fecbaja = ?mfechanull and pac_edad<= TNDP_edad and TNP_codadmision not in (select TNP_codadmision from TabNutPaciente "+;
	" 	where TNP_Fecha = ?mfecha and TNP_CodServ=?mtiposer )" +;
	" group by TNP_codadmision,TabNutIngr.id,TN_codagr ", "mwknutdesa11")

If mret<1
	=Aerr(eros)
	Messagebox (eros(3))
Endif
** Prohibidos
mret = sqlexec(mcon1, "select  * " + ;
	" from TabNutComp "  + ;
	" left join TabNutIngr on TNC_idIngr = TabNutIngr.id " + ;
	" where  TNC_tipo=2 and TN_tipo <= 2 and TNC_fecpasiva = ?mfecpas "+;
	" ", "mwknutdesa2")

If mret<1
	=Aerr(eros)
	Messagebox (eros(3))
Endif

** no compatibles
mfecpas = Ctod("01/01/1900")
mret = sqlexec(mcon1, "select  TND_codPrest,TNP_codadmision, TND_idPaciente, TabNutIngr.*,PAC_edad  " + ;
	" from pacinternad,TabNutIngr " + ;
	" left join pacientes on pin_codadmision = PAC_codadmision " + ;
	" left join TabNutPaciente on pin_codadmision = TNP_codadmision " + ;
	" left join TabNutDetalle on TND_idPaciente = TabNutPaciente.id" + ;
	" where TNP_Fecha >= ?mfecha and TNP_CodServ=0 and TN_tipo <= 2 and tnd_fecbaja = ?mfechanull   "+;
	" and TNP_codadmision not in (select TNP_codadmision from TabNutPaciente "+;
	" 	where TNP_Fecha = ?mfecha and TNP_CodServ=?mtiposer )" +;
	" order by TNP_codadmision,TND_codPrest ", "mwknutdesa01")
If mret<1
	=Aerr(eros)
	Messagebox (eros(3))
Endif
mret = sqlexec(mcon1, "select  TabNutComp.* " + ;
	" from TabNutIngr " + ;
	" left join TabNutComp on (TNC_idIngr = TabNutIngr.id and TNC_tipo = 0 ) "+;
	" where TN_tipo <= 2 and TNC_fecpasiva = ?mfecpas ", "mwknutdesa02")
If mret<1
	=Aerr(eros)
	Messagebox (eros(3))
Endif
mret = sqlexec(mcon1, "select  TabNutDietaPrest.* " + ;
	" from TabNutDietaPrest " + ;
	" left join TabNutIngr on TNDP_idIngr = TabNutIngr.id "+;
	" where TNDP_fecpasiva = ?mfecpas and TNDP_tipo = 2 and TNDP_CodServ=?mtiposer ", "mwknutDPnova")

Select mwknutdesa01
Do While !Eof()
	mprest = TND_codPrest
	mingre = Id
	mcoda  = TNP_codadmision
	mreg	= Recno()

	Select TNC_idIngr  From mwknutdesa02;
		where TNC_idIngr = mingre And TNC_codPrest= mprest Into Cursor mwkfiltro

	Select mwknutdesa01
	If Reccount('mwkfiltro')>0
		Go Top
		Delete From mwknutdesa01 Where Id = mingre  And TNP_codadmision = mcoda
		Go mreg
	Endif

	Skip
Enddo

If Used ('mwknutdesa')
	Use In mwknutdesa
Endif
Select * From mwknutdesa01 ;
	union Select * From mwknutdesa11 ;
		union Select * From mwknutdesa1 Where !Isnul(Id);
			into Cursor mwknutdesau
select * from mwknutdesau order by TNP_codadmision,TND_codPrest into cursor mwknutdesaufa
Use Dbf('mwknutdesaufa') In 0 Again Alias mwknutdesa

** Elimino Prohibidos
Select mwknutdesa
Do While !Eof()
	mprest = TND_codPrest
	mingre = Id
	mcoda  = TNP_codadmision
	mreg	= Recno()
	medad 	= PAC_edad
	select * from  mwknutdesa2;
		where TNC_codPrest in ( select TND_codPrest from mwknutdesa where TNP_codadmision = mcoda  );
		into cursor mwkprohib
	select * from  mwkprohib;
		where TNC_idIngr in ( select Id from mwknutdesa where TNP_codadmision = mcoda  );
		into cursor mwksesaca
	select mwksesaca
	if reccount('mwksesaca')>0
		scan 
			miding = TNC_idIngr
			Delete From mwknutdesa Where Id = miding  And TNP_codadmision = mcoda
		endscan		
	endif
	Select Id From mwknutDPnova;
		where TNDP_idIngr = mingre And TNDP_codPrest= mprest ;
		and medad <= TNDP_edad Into Cursor mwkfiltro2
	Select mwknutdesa
	If Reccount('mwkfiltro2')>0
		Go Top
		Delete From mwknutdesa Where Id = mingre  And TNP_codadmision = mcoda
	Endif
	Go mreg
	Skip
Enddo
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

Select mwknutdesa.*,mwktotgr.* ;
	from mwknutdesa;
	left Join mwktotgr On TN_CodAgr=TNA_CodAgr;
	order By mwknutdesa.TNP_codadmision,TN_CodAgr,tn_ingrediente;
	group By mwknutdesa.TNP_codadmision,TN_CodAgr,tn_ingrediente Into Cursor mwkdesayuno

Select Distinct TNP_codadmision From mwkdesayuno Into Cursor mwkctrl
If Used('auxidesa')
	Use In auxidesa
Endif
If mrepro = 1 Or Reccount("mwkdietdes") < Reccount("mwkctrl")

&&&  Genero los registros
	Select  mwkdesayuno
	mcodadm =''
	Go Top
	Do While !Eof('mwkdesayuno')
		mtipo = mtiposer
		mingr = Id
		msec = Iif(	mcodadm	= mwkdesayuno.TNP_codadmision,msec+1,1)
		mcodadm		= mwkdesayuno.TNP_codadmision
		mfechacarga = Dtot(mfecha)
		mpresta		= Id
		mvale 		= msec
		mobserva	= ""
		musu_carga 	= mwkusuario.codigovax
		mmedico		= 0
		mcodvax	= mwkusuario.codigovax
		lsigue = .T.
		If mrepro = 0
			Select PAC_codadmision from mwkdietdes where PAC_codadmision = mcodadm into cursor mwkexis
			lsigue = (reccount('mwkexis')=0)
			Select  mwkdesayuno
		Endif
		If lsigue
			Do sp_actualizo_tab_nut_pac With 1, mcodadm, mtiposer, '','','',mfecha

			mret =sqlexec(mcon1, "select id from TabNutPaciente "+;
				"where TNP_codadmision = ?mcodadm and TNP_Fecha = ?mfecha "+;
				" and TNP_CodServ = ?mtiposer","mwkexistepac")
			midpac= mwkexistepac.Id
			Do While !Eof('mwkdesayuno') And  mcodadm = mwkdesayuno.TNP_codadmision

				mtipo = mtiposer
				mingr = mwkdesayuno.Id
				msec = Iif(	mcodadm	= mwkdesayuno.TNP_codadmision,msec+1,1)
				mcodadm		= mwkdesayuno.TNP_codadmision
				mfechacarga = Dtot(mfecha)
				mpresta		= Id
				mvale 		= msec
				mobserva	= ""
				musu_carga 	= mwkusuario.codigovax
				mmedico		= 0
				mcodvax	= mwkusuario.codigovax
				Do sp_actualizo_tab_nut_det With 1, midpac, mingr, mvale,mfechacarga,mobserva
				Skip 1 in mwkdesayuno
			Enddo
		Else
			Do While !Eof('mwkdesayuno') And  mcodadm = mwkdesayuno.TNP_codadmision
				Skip 1 IN mwkdesayuno
			Enddo
		Endif
	Enddo
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

Create Cursor auxidesa (codadm c(8), desayuno c(250))
*!*	Select mwkdietdes.*,mwktotgr.* ;
*!*		from mwkdietdes;
*!*		left Join mwktotgr On TN_CodAgr=TNA_CodAgr;
*!*		order By mwkdietdes.TNP_codadmision,TN_CodAgr,tn_ingrediente;
*!*		group By mwkdietdes.TNP_codadmision,TN_CodAgr,tn_ingrediente Into Cursor mwkdesayuno
if used("mwktotgr")
	use in mwktotgr
endif
if used("mwkdietanul")
	use in mwkdietanul
endif
if used("mwkdietdes")
	use in mwkdietdes
endif


Select  mwkdesayuno
Go Top
Do While !Eof()
	mcod = TNP_codadmision
	magr = TN_CodAgr
	midpac = TND_idPaciente
	mingr = Nvl(Alltrim(Lower(tn_ingrediente)),'')
	mdesgr = Nvl(Alltrim(Lower(TNA_Descripcion)),'')
	lena = 0
	canxg = 1
	mcanxg = cantxgr
	Skip
	Do While !Eof() And mcod = TNP_codadmision
		If magr = TN_CodAgr And  magr > 0
			mingr = mingr + ' o ' + Nvl(Alltrim(Lower(tn_ingrediente)),'')
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
		magr = TN_CodAgr
		mdesgr = Nvl(Alltrim(Lower(TNA_Descripcion)),'')
		Skip
	Enddo
	If canxg = mcanxg And canxg > 1
		mingr = Iif(lena=0,'',Left(mingr,lena)+', ')+ mdesgr
	Endif
	Insert Into auxidesa (codadm, desayuno) Values (mcod,mingr)
	lsigue = .t.
	if mrepro=0
		select * from mwkdietaExis where TNP_codadmision = mcod  into cursor mwksigue
		lsigue = (reccount('mwksigue')=0)
	endif
	if lsigue
		do sp_actualizo_tab_nut_pac with 1, mcod, mtiposer, mingr,'','' ,mfecha
	endif
	Select  mwkdesayuno
Enddo

if used("mwkdesayuno")
	use in mwkdesayuno
endif
Select mwkauxi.*, mwknutant1.TNP_Observaciones As adnutant From mwkauxi ;
	left Join mwknutant1 On mwkauxi.pac_codadmision = mwknutant1.TNP_codadmision;
	group by mwkauxi.pac_codadmision Into Cursor mwkdesa1

Select * From mwkdesa1;
	Left Join auxidesa On PAC_codadmision=codadm ;
	order By habitac, PAC_codadmision Into Cursor mwkdesa

if used("mwkauxi")
	use in mwkauxi
endif
if used("mwkauxidesa")
	use in mwkauxidesa
endif