****
** Busqueda de Protocolo
****
Parameter mnroadm, msec, msect, lsololectura

Local mFecPasiva
mnroadm = Alltrim(mnroadm)
lsololectura = Iif(Vartype(lsololectura)#"N",0,lsololectura)
lactualizoagrup = .F.
lnuevo = .F.
releo  = .F.
msechab = ''
mFecPasiva = Ctod("01/01/1900")
mhoy = sp_busco_fecha_serv("DD")
If mwkusuario.codigovax = 54035
	Set Step On
Endif
Do sp_busco_estados With 7,' and tipo = 40 ','mwkestsinsec'&& agrupaciones que no cambian de secuencia
If mwkestsinsec.estado = 1 &&or  mwkusuario.sector="SISTEMAS"
	Select mwkestsinsec
	msechab = ''
	Scan
		msechab = msechab + Alltrim(mwkestsinsec.Descrip) +","
	Endscan
	msechab = Left(msechab,Len(msechab)-2)
Endif
Select mwkestsinsec
Go Top
lsiguecontrol = .T.
If msec = 0

	mret = SQLExec(mcon1, "select pacinternad.*, Tabinthce.ID, IH_admision, IH_codcie, "+;
		" IH_codestado, IH_codmed, IH_codmedcie, IH_fechaHoraIng, IH_horaCierre,"+;
		" IH_motIngreso, IH_procedencia, IH_reingre, IH_secagrup, IH_secuencia, IH_usuario,EI_idevol, PAC_sectorinternac "+;
		" from pacinternad "+;
		" inner join pacientes on pin_codadmision  = PAC_codadmision  " + ;
		" left join TabintHCE on pin_codadmision  = tabintHCE.IH_admision " + ;
		" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
		" where pin_codadmision = ?mnroadm order by IH_secuencia" , "mwkinterna010")

	Select * From mwkinterna010 Where At(Alltrim(ih_secagrup),msechab)>0 Into Cursor mwkctrped
	Select mwkinterna010.*,SectorAgrup,mwksecagrup.descripcion  ;
		from mwkinterna010 ;
		left Join mwksecagrup On mwksecagrup.SectorAgrup = ih_secagrup ;
		into Cursor mwkinterna01a
	Go Bott
	Select mwkinterna010.*,SectorAgrup,mwksecagrupnew.descripcion  ;
		from mwkinterna010 ;
		left Join mwksecagrupnew On mwksecagrupnew.SectorAgrup = ih_secagrup ;
		into Cursor mwkinterna01b
	Go Bott
	midant = mwkinterna01a.Id

	If Isnull(mwkinterna01a.SectorAgrup)
		lnuevo = .T.
		lnogenero = .F.
	Else
		lnogenero = (mwkinterna01a.PAC_sectorinternac $ msechab ) Or Reccount('mwkctrped') >0
	Endif
**		Esto es para una nueva agrupacion
*!*			msecant = mwkinterna01A.SectorAgrup
*!*			select * from mwksecagrupnew where sectoragrup  in (select sectoragrup  from mwksecagrupnew where sectoragrup  = msect );
*!*				and sector = msecant into cursor mwkcontrolnew

*!*			if isnull(mwkinterna01b.SectorAgrup)
*!*				lactualizoagrup = .t.
*!*				select mwkinterna010.*,SectorAgrup,mwksecagrupnew.descripcion ;
*!*					from mwkinterna010 ;
*!*					left join mwksecagrupnew on mwksecagrupnew.Sector = PAC_sectorinternac ;
*!*					into cursor mwkinterna01b
*!*			endif
*!*			if lsololectura = 0
*!*				if 	mwkinterna01a.SectorAgrup # msect and mwkinterna01b.SectorAgrup # msect
*!*					lnuevo = .t.
*!*					midant = mwkinterna01a.id
*!*				else
*!*					if 	mwkinterna01a.SectorAgrup # msect and mwkinterna01b.SectorAgrup = msect and reccount('mwkcontrolnew')>0
*!*						lactualizoagrup = .t.
*!*					else
*!*						if 	mwkinterna01a.SectorAgrup = msect and mwkinterna01b.SectorAgrup # msect
*!*							lactualizoagrup = .t.
*!*						else
*!*							if 	mwkinterna01a.SectorAgrup # msect and reccount('mwkcontrolnew')= 0
*!*								lactualizoagrup = .f.
*!*								lnuevo = .t.
*!*								midant = mwkinterna01a.id
*!*							else
*!*								lnuevo = .f.
*!*								lactualizoagrup = .f.
*!*							endif
*!*						endif
*!*					endif
*!*				endif
*!*			endif
	msecant = mwkinterna01a.SectorAgrup
	Select * From mwksecagrupnew Where SectorAgrup  In (Select SectorAgrup  From mwksecagrupnew Where SectorAgrup  = msect );
		into Cursor mwkcontrolnew  &&and sector = msecant
	Select mwkinterna010
	Go Bottom
	misecactual = mwkinterna010.PAC_sectorinternac

	Select * From mwksecagrupnew Where sector = misecactual Into Cursor mwkcambio1
	Select mwkcambio1
	Go Bottom
	Select * From mwksecagrup Where sector = misecactual Into Cursor mwkcambio2
	If mwkcambio1.SectorAgrup # mwkcambio2.SectorAgrup And ;
			(mwkcambio2.SectorAgrup = mwkinterna010.ih_secagrup Or mwkcambio1.SectorAgrup = mwkinterna010.ih_secagrup)
		lactualizoagrup = .T.
		lnuevo = .F.
		Select mwkinterna010.*,SectorAgrup,mwksecagrupnew.descripcion ;
			from mwkinterna010 ;
			left Join mwksecagrupnew On mwksecagrupnew.sector = PAC_sectorinternac ;
			into Cursor mwkinterna01b
		msql_hab = ''
		miadm = Alltrim(mwkinterna010.IH_admision)
		Do sp_busco_camas_pac_sec With miadm ,msql_hab
		If Reccount('mwkcamas')=0
			Do sp_busco_camas_pac_sec With miadm ,msql_hab
		Endif
		Select mwkcamas.*,SectorAgrup ;
			from mwkcamas,mwksecagrupnew ;
			where mwksecagrupnew.sector = lug_codsector And Between(lug_fechaingreso,TSA_FechaDesde,TSA_FechaHasta ) ;
			order By lug_fechaingreso,lug_horaingreso ;
			into Cursor mwkcamas1

		Select mwkcamas1
		Go Bottom
		mnsec = mwkcamas1.lug_codsector
		If Reccount('mwkcamas1')>1
			Do While !Bof() And mwkcamas1.SectorAgrup = Nvl(mwkinterna010.ih_secagrup,'')
				Skip -1
			Enddo
			If Bof()
				Go Top
			Else
				Skip
			Endif
			If Eof()
				Skip -1
			Endif
		Endif
		If mwkcamas1.SectorAgrup # Nvl(mwkinterna010.ih_secagrup,'')
			Select mwkcamas1
			Go Bottom
			Skip -1
			If !Eof()
				If mnsec = mwkcamas1.lug_codsector
					lactualizoagrup = .F.
					lnuevo = .F.
					lsiguecontrol = .F.
				Else
					Go Bottom
				Endif
			Else
				Go Bottom
			Endif
		Endif
		If lsiguecontrol
			fhing = Ctot(Dtoc(mwkcamas1.lug_fechaingreso)+" "+Ttoc(mwkcamas1.lug_horaingreso,2))
			Select mwksecagrupnew
			Locate For sector = mnsec And TSA_FechaHasta>= fhing
			Select mwkcambio1
			Locate For sector = mnsec And TSA_FechaHasta>= fhing
			Select mwksecagrup
			Locate For mwksecagrup.sector = mnsec
			If ( mwksecagrupnew.SectorAgrup=Nvl(mwkinterna010.ih_secagrup,'') Or mwksecagrup.SectorAgrup=Nvl(mwkinterna010.ih_secagrup,'')) ;
					and  fhing = mwkinterna010.IH_fechaHoraIng &&(=)
				lactualizoagrup = .F.
				lnuevo = .F.
			Else
				If mwksecagrup.SectorAgrup#Nvl(mwkinterna010.ih_secagrup,'') Or fhing > mwkinterna010.IH_fechaHoraIng &&(=)
					lactualizoagrup = .F.
					lnuevo = .T.
********************* agregado 26/09/2017
					Select mwkcamas
					Go Bott
					musec = lug_codsector
					muhab = lug_habitacion
					mucam = lug_cama
					Select mwkcamas.*,SectorAgrup ;
						from mwkcamas,mwksecagrup ;
						where mwksecagrup.sector = lug_codsector And Between(lug_fechaingreso,TSA_FechaDesde,TSA_FechaHasta ) ;
						order By lug_fechaingreso,lug_horaingreso ;
						into Cursor mwkcamas1

					Select mwkcamas1
					Go Bottom
					If musec = lug_codsector And muhab = lug_habitacion And mucam = lug_cama

						mnsec = mwkcamas1.lug_codsector
						If Reccount('mwkcamas1')>1
							Do While !Bof() And mwkcamas1.SectorAgrup = Nvl(mwkinterna010.ih_secagrup,'')
								Skip -1
							Enddo
							If Bof()
								Go Top
							Else
								Skip
							Endif
							If Eof()
								Skip -1
							Endif
						Endif

*fhing = ctot(dtoc(mwkcamas1.lug_fechaingreso)+" "+ttoc(mwkcamas1.lug_horaingreso,2))
						Select mwksecagrupnew
						Locate For sector = mnsec And TSA_FechaHasta>= fhing
						Select mwkcambio1
						Locate For sector = mnsec And TSA_FechaHasta>= fhing
						Select mwksecagrup
						Locate For mwksecagrup.sector = mnsec
						If ( mwksecagrupnew.SectorAgrup=Nvl(mwkinterna010.ih_secagrup,'') Or mwksecagrup.SectorAgrup=Nvl(mwkinterna010.ih_secagrup,'')) ;
								and  fhing = mwkinterna010.IH_fechaHoraIng &&(=)
							lactualizoagrup = .F.
							lnuevo = .F.
						Else
							If mwksecagrup.SectorAgrup#Nvl(mwkinterna010.ih_secagrup,'') Or fhing > mwkinterna010.IH_fechaHoraIng &&(=)
								lactualizoagrup = .F.
								lnuevo = .T.
							Endif
						Endif
					Endif
				Endif
			Endif
		Endif
	Else
		If mwkcambio1.SectorAgrup # mwkcambio2.SectorAgrup And mwkcambio2.SectorAgrup # mwkinterna010.ih_secagrup
			lactualizoagrup = .F.
			lnuevo = .T.

			If mwkcambio1.SectorAgrup ='PED' And  mwkinterna010.ih_secagrup ='INT'
				lnuevo = .F.
			Endif
		Else
			If mwkcambio1.SectorAgrup = mwkcambio2.SectorAgrup And mwkcambio2.SectorAgrup # mwkinterna010.ih_secagrup
				lactualizoagrup = .F.
				lnuevo = .T.
				If mwkcambio1.SectorAgrup ='PED' And  mwkinterna010.ih_secagrup ='INT'
					lnuevo = .F.
				Endif
				If lnogenero
					lnogenero = (mwkinterna010.ih_secagrup $ msechab )

				Endif
			Endif
		Endif
	Endif
Else

	mret = SQLExec(mcon1, "select pacinternad.*, Tabinthce.ID, IH_admision, IH_codcie, "+;
		" IH_codestado, IH_codmed, IH_codmedcie, IH_fechaHoraIng, IH_horaCierre,"+;
		" IH_motIngreso, IH_procedencia, IH_reingre, IH_secagrup, IH_secuencia, IH_usuario,EI_idevol , PAC_sectorinternac "+;
		" from pacinternad "+;
		" inner join pacientes on pin_codadmision  = PAC_codadmision  " + ;
		" left join TabintHCE on pin_codadmision  = tabintHCE.IH_admision " + ;
		" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
		" where pin_codadmision = ?mnroadm and IH_secuencia = ?msec " , "mwkinterna010")
	Select * From mwkinterna010 Where At(Alltrim(ih_secagrup),msechab)>0 Into Cursor mwkctrped
	Select mwkinterna010.*,SectorAgrup,mwksecagrup.descripcion  ;
		from mwkinterna010 ;
		left Join mwksecagrup On mwksecagrup.SectorAgrup = ih_secagrup ;
		into Cursor mwkinterna01a
	Go Bott
	Select mwkinterna010.*,SectorAgrup,mwksecagrupnew.descripcion  ;
		from mwkinterna010 ;
		left Join mwksecagrupnew On mwksecagrupnew.SectorAgrup = ih_secagrup ;
		into Cursor mwkinterna01b
	Go Bott
	midant = mwkinterna01a.Id
	If Isnull(mwkinterna01a.SectorAgrup)
		lnuevo = .T.
	Else
		lnogenero = (mwkinterna01a.PAC_sectorinternac $ msechab )  Or Reccount('mwkctrped') >0

		mret = SQLExec(mcon1, "select pacinternad.*, Tabinthce.ID, IH_admision, IH_codcie, "+;
			" IH_codestado, IH_codmed, IH_codmedcie, IH_fechaHoraIng, IH_horaCierre,"+;
			" IH_motIngreso, IH_procedencia, IH_reingre, IH_secagrup, IH_secuencia, IH_usuario,EI_idevol , PAC_sectorinternac "+;
			" from pacinternad "+;
			" inner join pacientes on pin_codadmision  = PAC_codadmision  " + ;
			" left join TabintHCE on pin_codadmision  = tabintHCE.IH_admision " + ;
			" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
			" where pin_codadmision = ?mnroadm and IH_secuencia = ?msec " , "mwkinterna010")

		Select mwkinterna010.*,SectorAgrup,mwksecagrup.descripcion  ;
			from mwkinterna010 ;
			left Join mwksecagrup On mwksecagrup.SectorAgrup = ih_secagrup ;
			into Cursor mwkinterna01a
		Go Bott
		Select mwkinterna010.*,SectorAgrup,mwksecagrupnew.descripcion  ;
			from mwkinterna010 ;
			left Join mwksecagrupnew On mwksecagrupnew.SectorAgrup = ih_secagrup ;
			into Cursor mwkinterna01b
		Go Bott
		midant = mwkinterna01a.Id
		If Isnull(mwkinterna01a.SectorAgrup)
			lnuevo = .T.
		Else
			msecant = mwkinterna01a.SectorAgrup
			Select * From mwksecagrupnew Where SectorAgrup  In (Select SectorAgrup  From mwksecagrupnew Where SectorAgrup  = msect );
				and sector = msecant Into Cursor mwkcontrolnew
			If Isnull(mwkinterna01b.SectorAgrup)
				lactualizoagrup = .T.
				Select mwkinterna010.*,SectorAgrup,mwksecagrupnew.descripcion ;
					from mwkinterna010 ;
					left Join mwksecagrupnew On mwksecagrupnew.sector = PAC_sectorinternac ;
					into Cursor mwkinterna01b
			Endif
			If lsololectura = 0
				If 	mwkinterna01a.SectorAgrup # msect And mwkinterna01b.SectorAgrup # msect
					lnuevo = .T.
					midant = mwkinterna01a.Id
				Else
					If 	mwkinterna01a.SectorAgrup # msect And mwkinterna01b.SectorAgrup = msect And Reccount('mwkcontrolnew')>0
						lactualizoagrup = .T.
					Else
						If 	mwkinterna01a.SectorAgrup = msect And mwkinterna01b.SectorAgrup # msect
							lactualizoagrup = .T.
						Else
							If 	mwkinterna01a.SectorAgrup # msect And Reccount('mwkcontrolnew')= 0
								lactualizoagrup = .F.
								lnuevo = .T.
								midant = mwkinterna01a.Id
							Else
								lnuevo = .F.
								lactualizoagrup = .F.
							Endif
						Endif
					Endif
				Endif
			Endif
		Endif
	Endif
Endif

If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif
If lactualizoagrup
	msect = mwkinterna01b.SectorAgrup
	mret = SQLExec(mcon1, "update tabintHCE set IH_secagrup =?msect where id = ?midant")
	mret = SQLExec(mcon1, "select pacinternad.*, Tabinthce.ID, IH_admision, IH_codcie, "+;
		"IH_codestado, IH_codmed, IH_codmedcie, IH_fechaHoraIng, IH_horaCierre,"+;
		"IH_motIngreso, IH_procedencia, IH_reingre, IH_secagrup, IH_secuencia, IH_usuario,EI_idevol "+;
		" from pacinternad "+;
		" left join TabintHCE on pin_codadmision  = tabintHCE.IH_admision " + ;
		" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
		" where pin_codadmision = ?mnroadm " , "mwkinterna010")

	Select mwkinterna010.*,SectorAgrup,mwksecagrup.descripcion  ;
		from mwkinterna010 ;
		left Join mwksecagrup On mwksecagrup.SectorAgrup = ih_secagrup ;
		into Cursor mwkinterna01
Else
	Select * From mwkinterna01a Into Cursor mwkinterna01
Endif
Select mwkinterna01
Go Bott
mfecnul = Ctot("01/01/1900")

musu    = Iif(Used('mwkusuarios'),mwkusuarios.codigovax,mwkusuario.codigovax)
If lnuevo And lnogenero
	lnuevo = .F.
Endif
If (Isnull(mwkinterna01.IH_admision) Or lnuevo) And lsololectura = 0  &&& genero el registro inicial

	If msec<1
		msec = Nvl(mwkinterna01.IH_secuencia,0)+1
	Endif

	Do sp_busco_camas_pac_sec With mnroadm,''
	If Reccount('mwkcamas')=0
		Do sp_busco_camas_pac_sec With miadm ,msql_hab
	Endif

	Select mwkcamas.*,SectorAgrup ;
		from mwkcamas,mwksecagrupnew ;
		where mwksecagrupnew.sector = lug_codsector And Between(lug_fechaingreso,TSA_FechaDesde,TSA_FechaHasta ) ;
		order By lug_fechaingreso,lug_horaingreso ;
		into Cursor mwkcamas1

	Go Bottom

	mnsec = lug_codsector

	If Reccount('mwkcamas1')>1
		Do While !Bof() And mwkcamas1.SectorAgrup = Nvl(mwkinterna01.ih_secagrup,'')
			Skip -1
		Enddo
		If Bof()
			Go Top
		Else
			Skip
		Endif
		If Eof()
			Skip -1
		Endif
	Endif
	If 	SectorAgrup # msect
		lnuevo = .F.
	Endif
	msect = SectorAgrup
	mfecing = Ctot(Dtoc(lug_fechaingreso)+" "+Ttoc(lug_horaingreso,2))
*		skip -1
*	enddo
	lpedia = .F.
	releo = .T.
	If mwkpacact.PAC_edad <12  And !Inlist(mwkpacact.PAC_sectorinternac,"IQB")
		lpedia = .T.
	Else
		If 	mwkpacact.PAC_edad <16  And !Inlist(mwkpacact.PAC_sectorinternac,"IQB")
			lpedia = !Inlist( Nvl(mwkpacact.PAC_motivoadmision,0),5,6)
		Endif
	Endif
	If lpedia And !Inlist(msect,'NEO','PED','TEP')
		msect = 'PED'
	Endif
	If  mwkpacact.PAC_edad >16 And msect = 'PED'
		msect = 'INT'
	Endif
	mret = SQLExec(mcon1, "insert into tabintHCE (IH_admision ,IH_codcie,IH_codmed ,IH_codmedcie"+;
		",IH_codestado, IH_fechaHoraIng, IH_secuencia,IH_horaCierre,IH_secagrup , IH_usuario,"+;
		"IH_motIngreso, IH_procedencia) values (?mnroadm, 0,1,1,0,?mfecing,?msec ,?mfecnul,?msect,?musu,0,0)")

	mret = SQLExec(mcon1, "select pacinternad.*, Tabinthce.ID, IH_admision, IH_codcie, "+;
		"IH_codestado, IH_codmed, IH_codmedcie, IH_fechaHoraIng, IH_horaCierre,"+;
		"IH_motIngreso, IH_procedencia, IH_reingre, IH_secagrup, IH_secuencia, IH_usuario,EI_idevol "+;
		" from pacinternad "+;
		" left join TabintHCE on pin_codadmision  = tabintHCE.IH_admision " + ;
		" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
		" where pin_codadmision = ?mnroadm " , "mwkinterna010")

	Select mwkinterna010.*,SectorAgrup,mwksecagrup.descripcion  ;
		from mwkinterna010 ;
		left Join mwksecagrupnew On mwksecagrupnew.SectorAgrup = ih_secagrup  ;
		where TSA_FechaHasta >= mhoy ;
		into Cursor mwkinterna01
&& paso nutricion

	Do sp_busco_tabintnut With 2, " and IH_admision= '"+Alltrim(mnroadm)+"' order by IH_admision,ih_secuencia desc,TNP_Dieta   " ;
		,'mwkIntNutant'
	Select mwkIntNutant
	misec = mwkIntNutant.IH_secuencia
** -------- Nuevo Idevol
	Select Max(Id) As newid From  mwkinterna01 Into Cursor mwkctrlnut
	xmidevolhce = mwkctrlnut.newid
** ---------------------
	Select mwkIntNutant
	Scan
		If IH_secuencia=misec
			xmobser = mwkIntNutant.IN_observa
			xmobsernut = NVL(mwkIntNutant.IN_observanut,'')
			xlactualizo = 2
			xtadmision = mnroadm
			xmcprest = mwkIntNutant.IN_codprest
			xcodmed = mwkIntNutant.IN_codmed
			Do sp_grabo_evol_int_nut With xmidevolhce,xmobser,xlactualizo,,xtadmision,,xmcprest,xcodmed,misec+1,xmobsernut 

		Endif
	Endscan

** ----- Marcelo Torres, 29/09/2016
** ----- Pasamos la Prescripción Medica.
** TabIntPmSolu
** TabIntPmAgre
** TabIntPmPlan
** TabIntPmPRes - Ultima prescripcion
** TabIntPmVales - Vales despues de la ultima prescripcion.

	mret = SQLExec(mcon1,"select MAX(ps_idevol) as ps_idevol from TabIntPmSolu where ps_admision = ?mnroadm and ps_fecpasiva = ?mFecPasiva group by ps_idevol order by ps_idevol desc","mwkPmsAnte")

	mIdevolAnte = 0

	Select mwkPmsAnte
	Go Top

	If Reccount("mwkPmsAnte") > 0 And mwkPmsAnte.ps_idevol < xmidevolhce

		mIdevolAnte = mwkPmsAnte.ps_idevol

		mret = SQLExec(mcon1,"insert into TabIntPmSolu (PS_Observa,PS_admision,PS_baxter,PS_cantidad,PS_cantpres,PS_comentarios,PS_estadodia,PS_fechoraini," +;
			"PS_fechoralta,PS_fechormodif,PS_fecpasiva,PS_goteo,PS_goteogtsmin,PS_goteomacmic,PS_goteomlhr,PS_goteotmp,PS_goteotuni,PS_goteovol,PS_guia," +;
			"PS_idac,PS_idevol,PS_insumo,PS_motivo,PS_tipo,PS_trajopaciente,PS_unidad,PS_unidadvol,PS_unipres,PS_urgente,PS_usuarioalta,PS_usuariomodif,PS_via,PS_volumen) " + ;
			"select PS_Observa,PS_admision,PS_baxter,PS_cantidad,PS_cantpres,PS_comentarios,PS_estadodia,PS_fechoraini,PS_fechoralta,PS_fechormodif,PS_fecpasiva," + ;
			"PS_goteo,PS_goteogtsmin,PS_goteomacmic,PS_goteomlhr,PS_goteotmp,PS_goteotuni,PS_goteovol,PS_guia,PS_idac,?xmidevolhce,PS_insumo,PS_motivo,PS_tipo,PS_trajopaciente," + ;
			"PS_unidad,PS_unidadvol,PS_unipres,PS_urgente,PS_usuarioalta,PS_usuariomodif,PS_via,PS_volumen " + ;
			"from TabIntPmSolu where ps_idevol = ?mIdevolAnte and ps_fecpasiva = ?mFecPasiva" )

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE TABINTPMSOLU",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		mret = SQLExec(mcon1,"insert into TabIntPmAgre (PA_admision,PA_baxter,PA_cantidad,PA_cantpres,PA_comentarios,PA_dosis,PA_estadodia,PA_fechoralta,PA_fechormodif," + ;
			"PA_fecpasiva,PA_guia,PA_idac,PA_idevol,PA_insumo,PA_motivo,PA_tipo,PA_trajopaciente,PA_unidad,PA_unidadvol,PA_unipres,PA_usuarioalta,PA_usuariomodif) " + ;
			"select PA_admision,PA_baxter,PA_cantidad,PA_cantpres,PA_comentarios,PA_dosis,PA_estadodia,PA_fechoralta,PA_fechormodif," + ;
			"PA_fecpasiva,PA_guia,PA_idac,?xmidevolhce,PA_insumo,PA_motivo,PA_tipo,PA_trajopaciente,PA_unidad,PA_unidadvol,PA_unipres,PA_usuarioalta,PA_usuariomodif " + ;
			"from TabIntPmAgre where pa_idevol = ?mIdevolAnte and pa_fecpasiva = ?mFecPasiva" )

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE TABINTPMAGRE",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		mret = SQLExec(mcon1,"insert into TabIntPmPlan (PP_FecHorProxDosis,PP_admision,PP_baxter,PP_dosis,PP_estadodia,PP_fechoralta,PP_fechormodif," + ;
			"PP_fecpasiva,PP_frecuencia,PP_guia,PP_idevol,PP_idopt,PP_insumo,PP_motivo,PP_tipo,PP_unidadvol,PP_urgente,PP_usuarioalta,PP_usuariomodif,PP_valfrec) " + ;
			"select PP_FecHorProxDosis,PP_admision,PP_baxter,PP_dosis,PP_estadodia,PP_fechoralta,PP_fechormodif," + ;
			"PP_fecpasiva,PP_frecuencia,PP_guia,?xmidevolhce,PP_idopt,PP_insumo,PP_motivo,PP_tipo,PP_unidadvol,PP_urgente,PP_usuarioalta,PP_usuariomodif,PP_valfrec " + ;
			"from TabIntPmPlan where pp_idevol = ?mIdevolAnte and pp_fecpasiva = ?mFecPasiva" )

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE TABINTPMPLAN",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		mret = SQLExec(mcon1,"insert into TabIntPmPres (PPS_FecHora,PPS_idevol,PPS_usuariomodif) " + ;
			"select top 1 PPS_FecHora,?xmidevolhce,PPS_usuariomodif " + ;
			"from TabIntPmPres where PPS_idevol = ?mIdevolAnte and pps_FecHora = (select max(PPS_FecHora) from tabintpmpres where pps_idevol = ?mIdevolAnte)" )

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE TABINTPMPRES",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

** --------------- Obtengo los nros. de vale maximos para cada insumo
*!*			mret = SQLExec(mret,"select IPV_confirmado,IPV_fechormodif,IPV_idevol,IPV_idreginsumo,IPV_instipo,IPV_movimiento,IPV_usuariomodif,max(ipv_vale) as IPV_vale " + ;
*!*				"from TabIntPmVales where IPV_idevol = ?mIdevolAnte group by ipv_idreginsumo order by ipv_idreginsumo","mwkValesAnte")

		mret = SQLExec(mcon1,"select a.IPV_confirmado,a.IPV_fechormodif,a.IPV_idevol,a.IPV_idreginsumo,a.IPV_instipo,a.IPV_movimiento,a.IPV_usuariomodif,max(a.ipv_vale) as IPV_vale," + ;
			"b.ps_insumo as insumo,b.ps_guia as guia,c.id as idreg " + ;
			"from TabIntPmVales as a " + ;
			"inner join tabintpmsolu as b on a.ipv_idreginsumo = b.id and a.ipv_instipo = 'P' " + ;
			"inner join tabintpmsolu as c on b.ps_insumo = c.ps_insumo and b.ps_guia = c.ps_guia and c.ps_idevol = ?xmidevolhce and c.ps_fecpasiva = '1900-01-01' " +;
			"where a.IPV_idevol = ?mIdevolAnte and b.ps_fecpasiva = '1900-01-01' and " +;
			"ipv_fechormodif >= (select max(pps_fechora) from tabintpmpres where pps_idevol = ?xmidevolhce) " +;
			"group By a.ipv_idreginsumo Order By a.ipv_idreginsumo" ,"mwkValesAnteP" )

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE VALES P",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		mret = SQLExec(mcon1,"select a.IPV_confirmado,a.IPV_fechormodif,a.IPV_idevol,a.IPV_idreginsumo,a.IPV_instipo,a.IPV_movimiento,a.IPV_usuariomodif,max(a.ipv_vale) as IPV_vale," + ;
			"b.pa_insumo as insumo,b.pa_guia as guia,c.id as idreg " + ;
			"from TabIntPmVales as a " + ;
			"inner join tabintpmAgre as b on a.ipv_idreginsumo = b.id and a.ipv_instipo = 'A' " + ;
			"inner join tabintpmAgre as c on b.pa_insumo = c.pa_insumo and b.pa_guia = c.pa_guia and c.pa_idevol = ?xmidevolhce and c.pa_fecpasiva = '1900-01-01' " +;
			"where a.IPV_idevol = ?mIdevolAnte and b.pa_fecpasiva = '1900-01-01' and " +;
			"ipv_fechormodif >= (select max(pps_fechora) from tabintpmpres where pps_idevol = ?xmidevolhce) " +;
			"group by a.ipv_idreginsumo order by a.ipv_idreginsumo" ,"mwkValesAnteA" )

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE VALES A",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		Select * From mwkValesAnteA Union All Select * From mwkValesAnteP Into Cursor mwkValesAnte

** -- Insertamos los registros
		Dimension aVales(8)

		Select mwkValesAnte
		Go Top
		Scan All

			aVales[1] = mwkValesAnte.IPV_confirmado
			aVales[2] = mwkValesAnte.IPV_fechormodif
			aVales[3] = xmidevolhce
			aVales[4] = mwkValesAnte.idReg  &&el nuevo nro. de registro.
			aVales[5] = mwkValesAnte.IPV_instipo
			aVales[6] = mwkValesAnte.IPV_movimiento
			aVales[7] = mwkValesAnte.IPV_usuariomodif
			aVales[8] = mwkValesAnte.IPV_vale


			mret = SQLExec(mcon1,"insert into TabIntPmVales (IPV_confirmado,IPV_fechormodif,IPV_idevol,IPV_idreginsumo,IPV_instipo,IPV_movimiento,IPV_usuariomodif,IPV_vale) " + ;
				"values(" + ;
				"?aVales[1],?aVales[2],?aVales[3],?aVales[4],?aVales[5],?aVales[6],?aVales[7],?aVales[8])" )

			If mret<=0
				Messagebox("ERROR AL INSERTAR DATOS EN TABINTPMVALES",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Exit
			Endif
			Select mwkValesAnte

		Endscan

		Use In Select("mwkValesAnte")

	Endif

** ------------------------------------

Endif

Select * From mwkinterna01 ;
	group By IH_secuencia;
	order By IH_secuencia Desc Into Cursor mwkinterna

Return releo
