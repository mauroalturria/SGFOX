lparameters mIdevol, mHis,mvfecdes,mvfechas

mFiltro = ""
mOrden = ""
if !used('mwkusumed')
	if !used('mwkusuariosall')
		do sp_busco_usuarios_all
	endif
	if !used('mwkmedicointall')
		do sp_busco_med_pisos
		select  id, nombre,codesp,matricula as matriculas  from mwkmedicoint where 1=2 into cursor mwkMedicouno
		use in select("mwksinmed")
		use dbf('mwkMedicouno') in 0 again alias mwksinmed
		select mwksinmed
		insert into mwksinmed (id, nombre,codesp,matriculas  ) values (1,"MEDICO INTERNACION","",0)
		select  id, nombre,codesp,matricula as matriculas  from mwkmedicoint union all;
			select * from mwksinmed into cursor mwkMedicointall
		use in select("mwksinmed")
		use in select("mwkMedicouno")
	endif
	select idusuario,matriculas from mwkusuariosall,mwkmedicointall ;
		where idcodmed = mwkmedicointall.id into cursor mwkusumed
endif
xfecha = (vartype(mvfecdes)="D")
if xfecha
	mfecdes = prg_dtoc(mvfecdes)
	mfechas= prg_dtoc(mvfechas+1)
	mFiltro = " and PS_fechormodif >= ?mfecdes and PS_fechormodif <= ?mfechas "
endif

** ------------------------------Cursor que vamos a devolver
if !used("mwkPrescribe")
	create cursor mwkPrescribe (fecha t,medico C(30),Tipo n(1), estado C(1), Leyenda C(100), Informe M, ;
	FecHorBlan t null, MedicoBlan C(30) null, TipoM C(1), Guia I null , ;
	Baxter C(10) null, Insumo C(11), CodAdmision C(10), IdEvol I,inicio t, matriculas I null )
endif
** ------------ Traemos las fechas de planificacion
mret = sqlexec(mcon1,"select * from tabintpmpres where pps_idevol = ?midevol order by id desc","mwkpresd")
if mret < 0
	mltabla = "PRESCRIPCION MEDICA - INICIALIZACIONES - " + upper(mleye)
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("EN LA TABLA "+mltabla +chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	return .f.
endif

select mwkPresD
go top


** ------------------------------------Solucion principal
mOrden = ",a.ps_usuariomodif,a.ps_tipo "
mret = sqlexec(mcon1,"select a.ps_fechoralta,a.ps_fechormodif,a.ps_fecpasiva,ps_usuariomodif,a.ps_baxter,a.ps_insumo,a.ps_volumen,a.ps_cantidad,a.ps_unidad,a.ps_cantpres,a.ps_unipres," +;
	" a.ps_goteovol,a.ps_goteotmp,a.ps_goteotuni,a.ps_goteogtsmin,a.ps_goteomacmic,a.ps_goteomlhr,a.ps_tipo,a.ps_guia,a.ps_comentarios,a.ps_via,a.ps_fechoraini,a.ps_urgente,a.ps_goteo, " + ;
	" a.ps_admision, a.ps_idevol," +;
	" b.INS_descriinsumo "+;
	" from TabIntPmSoluLg as a"+;
	" join insumos as b on b.INS_codinsumo = a.PS_Insumo"+;
	" where a.PS_idevol = ?midevol " +mFiltro+;
	" group by a.PS_fechormodif, a.PS_Insumo "+;
	" order by a.PS_fechormodif "+mOrden ,"mwksolprin1")

mret = sqlexec(mcon1,"select a.ps_fechoralta,a.ps_fechormodif,a.ps_fecpasiva,ps_usuariomodif,a.ps_baxter,a.ps_insumo,a.ps_volumen,a.ps_cantidad,a.ps_unidad,a.ps_cantpres,a.ps_unipres," +;
	" a.ps_goteovol,a.ps_goteotmp,a.ps_goteotuni,a.ps_goteogtsmin,a.ps_goteomacmic,a.ps_goteomlhr,a.ps_tipo,a.ps_guia,a.ps_comentarios,a.ps_via,a.ps_fechoraini,a.ps_urgente,a.ps_goteo, " + ;
	" a.ps_admision, a.ps_idevol," +;
	" b.INS_descriinsumo "+;
	" from TabIntPmSolu as a"+;
	" join insumos as b on b.INS_codinsumo = a.PS_Insumo"+;
	" where a.PS_idevol = ?midevol " +mFiltro+;
	" order by a.PS_fechormodif "+mOrden ,"mwksolprin2")

*!*	Select * From mwksolprin1 ;
*!*		union All ;
*!*		select * From mwksolprin2 ;
*!*		into Cursor mwksolprin

*!*	Select * From mwksolprin ;
*!*		order By ps_fechormodif Into Cursor mwksolprin

if reccount('mwksolprin2')>0
	if reccount('mwksolprin1')>0
		select * from mwksolprin1 ;
			union all ;
			select * from mwksolprin2 ;
			into cursor mwksolprina

		select * from mwksolprina ;
			order by ps_fechormodif into cursor mwksolprin

	else
		select * from mwksolprin2 ;
			order by ps_fechormodif into cursor mwksolprin
	endif
else
	if reccount('mwksolprin1')>0
		select * from mwksolprin1 ;
			order by ps_fechormodif into cursor mwksolprin
	else
		select * from mwksolprin1 ;
			into cursor mwksolprin
	endif
endif

mFiltro = ''
if xfecha
	mFiltro = " and PA_fechoralta >= ?mfecdes and PA_fechoralta <= ?mfechas "
endif
** -----------------------------------Agregados
mOrden = ",a.pa_usuariomodif,a.pa_tipo "
mret = sqlexec(mcon1,"select a.ID,a.PA_ADMISION,a.PA_BAXTER,a.PA_CANTIDAD,a.PA_CANTPRES,a.PA_COMENTARIOS," +;
	"a.PA_DOSIS,a.PA_ESTADODIA,a.PA_FECHORALTA,a.PA_FECHORMODIF,a.PA_FECPASIVA,a.PA_GUIA,a.PA_IDAC,a.PA_IDEVOL," + ;
	"a.PA_INSUMO,a.PA_MOTIVO,a.PA_TIPO,a.PA_TRAJOPACIENTE,a.PA_UNIDAD,a.PA_UNIDADVOL,a.PA_UNIPRES,a.PA_USUARIOALTA," + ;
	"a.PA_USUARIOMODIF," + ;
	"b.INS_descriinsumo "+;
	" from TabIntPmAgreLg as a"+;
	" join insumos as b on b.INS_codinsumo = a.PA_Insumo"+;
	" where a.PA_idevol = ?midevol " +mFiltro+;
	" group by a.PA_fechormodif,a.PA_Insumo " +;
	" order by a.PA_fechormodif "+ mOrden ,"mwkagregad1")

mret = sqlexec(mcon1,"Select a.Id,a.PA_ADMISION,a.PA_BAXTER,a.PA_CANTIDAD,a.PA_CANTPRES,a.PA_COMENTARIOS," +;
	"a.PA_DOSIS,a.PA_ESTADODIA,a.PA_FECHORALTA,a.PA_FECHORMODIF,a.PA_FECPASIVA,a.PA_GUIA,a.PA_IDAC,a.PA_IDEVOL," + ;
	"a.PA_INSUMO,a.PA_MOTIVO,a.PA_TIPO,a.PA_TRAJOPACIENTE,a.PA_UNIDAD,a.PA_UNIDADVOL,a.PA_UNIPRES,a.PA_USUARIOALTA," + ;
	"a.PA_USUARIOMODIF," +;
	"b.INS_DESCRIINSUMO "+;
	" From TabIntPmAgre as a"+;
	" Join insumos as b On b.INS_codinsumo = a.PA_INSUMO"+;
	" Where a.PA_IDEVOL = ?mIdevol " +mFiltro+;
	" Group By a.PA_FECHORMODIF,a.PA_INSUMO " +;
	" Order By a.PA_FECHORMODIF "+ mOrden ,"mwkagregad2")

*!*	Select * From mwkagregad1 ;
*!*		union All ;
*!*		select * From mwkagregad2 ;
*!*		into Cursor mwkagregad Order By PA_FECHORMODIF

if reccount('mwkagregad2')>0
	if reccount('mwkagregad1')>0
		select * from mwkagregad1 ;
			union all ;
			select * from mwkagregad2 ;
			into cursor mwkagregada

		select * from mwkagregada ;
			order by pa_fechormodif into cursor mwkagregad

	else
		select * from mwkagregad2 ;
			order by pa_fechormodif into cursor mwkagregad
	endif
else
	if reccount('mwkagregad1')>0
		select * from mwkagregad1 ;
			order by pa_fechormodif into cursor mwkagregad
	else
		select * from mwkagregad1 ;
			into cursor mwkagregad
	endif
endif

**------------------------------------Planificacion

**Set Step On
mFiltro = ''
if xfecha
	mFiltro = " and PP_fechoralta >= ?mfecdes and PP_fechoralta <= ?mfechas "
endif
mOrden = ",pp_usuariomodif,pp_tipo "
mret = sqlexec(mcon1,"select ID,PP_FECHORPROXDOSIS,PP_ADMISION,PP_BAXTER,PP_DOSIS,PP_ESTADODIA,PP_FECHORALTA,PP_FECHORMODIF,PP_FECPASIVA," +;
	"PP_FRECUENCIA,PP_GUIA,PP_IDEVOL,PP_IDOPT,PP_INSUMO,PP_MOTIVO,PP_TIPO,PP_UNIDADVOL,PP_URGENTE,PP_USUARIOALTA,PP_USUARIOMODIF,PP_VALFREC " + ;
	" from TabIntPmPlanLg"+;
	" where PP_idevol = ?midevol " +mFiltro+;
	" group by PP_fechormodif, PP_insumo "+;
	" order by PP_fechormodif "+ mOrden,"mwkplanif1")

mret = sqlexec(mcon1,"select ID,PP_FECHORPROXDOSIS,PP_ADMISION,PP_BAXTER,PP_DOSIS,PP_ESTADODIA,PP_FECHORALTA,PP_FECHORMODIF,PP_FECPASIVA," +;
	"PP_FRECUENCIA,PP_GUIA,PP_IDEVOL,PP_IDOPT,PP_INSUMO,PP_MOTIVO,PP_TIPO,PP_UNIDADVOL,PP_URGENTE,PP_USUARIOALTA,PP_USUARIOMODIF,PP_VALFREC " + ;
	" from TabIntPmPlan"+;
	" where PP_idevol = ?midevol " +mFiltro+;
	" group by PP_fechormodif, PP_insumo "+;
	" order by PP_fechormodif "+ mOrden,"mwkplanif2")

*!*	Select * From mwkplanif1 ;
*!*		union All ;
*!*		select * From mwkplanif2 ;
*!*		order By pp_fechormodif Into Cursor mwkplanifi

if reccount('mwkplanif2')>0
	if reccount('mwkplanif1')>0
		select * from mwkplanif1 ;
			union all ;
			select id,PP_FECHORPROXDOSIS,PP_ADMISION,PP_BAXTER,PP_DOSIS,PP_ESTADODIA,PP_FECHORALTA,PP_FECHORMODIF,PP_FECPASIVA,;
			PP_FRECUENCIA,PP_GUIA,PP_IDEVOL,PP_IDOPT,PP_INSUMO,PP_MOTIVO,PP_TIPO,padr(PP_UNIDADVOL,10) as PP_UNIDADVOL,PP_URGENTE,;
			PP_USUARIOALTA,PP_USUARIOMODIF,PP_VALFREC from mwkplanif2;
			into cursor mwkplanifia

		select * from mwkplanifia ;
			order by PP_FECHORMODIF into cursor mwkplanifi

	else
		select * from mwkplanif2 ;
			order by PP_FECHORMODIF into cursor mwkplanifi
	endif
else
	if reccount('mwkplanif1')>0
		select * from mwkplanif1 ;
			order by PP_FECHORMODIF into cursor mwkplanifi
	else
		select * from mwkplanif1 ;
			into cursor mwkplanifi
	endif
endif


** ------------- Obtenemos las fechas de modificacion por medico
select ps_fechormodif,ps_usuariomodif from mwksolprin into cursor mwkpsfechas group by ps_fechormodif,ps_usuariomodif order by ps_fechormodif,ps_usuariomodif

** ------------- Iteramos sobre las fechas de modificacion + medico
mFecHora = ""
mUsuario = ""
mEvolPrinci = ""
mdetalleins = ""
mpv2 = ""

select mwkpsfechas
go top
scan all

	for mIdTipo = 1 to 3

		for mIdEstado = 1 to 2

			do case
				case mIdTipo = 1
					mleye = "Endovenoso Continuo"
				case mIdTipo = 2
					mleye = "Endovenoso No continuo"
				case mIdTipo = 3
					mleye = "Medicación / Insumos"
			endcase

			mFecHora = ps_fechormodif
			mUsuario = ps_usuariomodif
			mEvolPrinci = ""
			mdetalleins = ""
			mEvolPrinci = ""
			mAgregados  = ""
			mBajaAgre = ""
			mpv2 = ""
			mBajaPrinci = ""
			mPrincipal = ""
			mBajaPlanif = ""
			mPlanificacion = ""

** -------------- Solucion principal
			if mIdEstado = 1    && Activo
				select mwksolprin.*,mwkguias.descrip as lguiadescrip;
					from mwksolprin ;
					left join mwkguias on mwkguias.estado = mwksolprin.PS_guia ;
					where ps_fechormodif = mFecHora and ps_usuariomodif = mUsuario and ps_tipo = mIdTipo and ps_fecpasiva = ctod('01/01/1900') into cursor mwkPsSoluA
			else               && Pasivado
				select mwksolprin.*,mwkguias.descrip as lguiadescrip;
					from mwksolprin ;
					left join mwkguias on mwkguias.estado = mwksolprin.PS_guia ;
					where ps_fechormodif = mFecHora and ps_usuariomodif = mUsuario and ps_tipo = mIdTipo and ps_fecpasiva <> ctod('01/01/1900') into cursor mwkPsSoluA
			endif

			select mwkPsSoluA
			scan all

				mEvolPrinci = ""
				mdetalleins = ""

				if !empty(mEvolPrinci)
					mEvolPrinci = mEvolPrinci + chr(10)
				endif

				if mIdTipo <> 3
					mEvolPrinci = mEvolPrinci + '>> GUIA: ' +  alltrim(mwkPsSoluA.lguiadescrip) +", "+ iif(!empty(nvl(mwkPsSoluA.PS_baxter,"")),"BAXTER : " + alltrim(mwkPsSoluA.PS_baxter)+ ", ","")
				endif

				if !empty(mwkPsSoluA.PS_insumo)
					mdetalleins = alltrim(mwkPsSoluA.INS_descriinsumo) + ", "
				else

					if alltrim(mwkPsSoluA.lguiadescrip) = 'BOLO EV'
						mdetalleins = alltrim(mwkPsSoluA.lguiadescrip) + ", "
					endif

				endif


				select mwkPsSoluA

				mEvolPrinci = mEvolPrinci + alltrim(mdetalleins) + ' ' + iif(mIdTipo<>3, alltrim(str(mwkPsSoluA.PS_volumen)) + ' ML, ', '' )

				if mIdTipo = 3   && solo si viene por NO ENDOVENOSO
					mEvolPrinci = mEvolPrinci +' '+ iif( mwkPsSoluA.ps_cantidad > 0, alltrim(str(mwkPsSoluA.ps_cantidad))+ "," ,'') + ' ' + alltrim(mwkPsSoluA.ps_unidad) + ' ' + iif(mwkPsSoluA.ps_cantpres > 0 ,alltrim(str(mwkPsSoluA.ps_cantpres)),'') + ' ' + alltrim(mwkPsSoluA.ps_unipres)+ ' '+ alltrim(mwkPsSoluA.ps_comentarios) + " "
				endif

				if mIdTipo <> 3
					if mwkPsSoluA.PS_goteo = 1
						mEvolPrinci = mEvolPrinci + '(GOTEO LIBRE) '
					else
						mEvolPrinci = mEvolPrinci + '(GOTEO) VOLUMEN: ' + alltrim(str(mwkPsSoluA.PS_goteovol)) + ' ML' + ;
							', TIEMPO: ' + alltrim(str(mwkPsSoluA.PS_goteotmp)) + iif(mwkPsSoluA.PS_goteotuni = 1," HORAS"," MINUTOS") +;
							', '+alltrim(str(mwkPsSoluA.PS_goteogtsmin)) + iif(mwkPsSoluA.PS_goteomacmic = 1," MACROGOTAS"," MICROGOTAS") + " POR MINUTO"+;
							', '+alltrim(str(mwkPsSoluA.PS_goteomlhr)) + ' MILILITROS POR HORA'
					endif
				endif

				if mIdTipo <> 3
					select mwkIvias
					go top
					locate for mwkIvias._id = mwkPsSoluA.PS_via
					mvia =  alltrim(mwkIvias._via)
				else
					select mwkIvias3
					go top
					locate for mwkIvias3._id = mwkPsSoluA.PS_via
					mvia = alltrim(mwkIvias3._via)
				endif

**mfini = Nvl(Ttoc(mwkPsSoluA.PS_fechoraini),'')
				mfini = iif(mwkPsSoluA.PS_fechoraini <> null, mwkPsSoluA.PS_fechoraini, mwkPsSoluA.PS_fechoralta)
				mfinimed = mfini
				mfini = ttoc(mfini)


				mEvolPrinci = mEvolPrinci + ', VIA ' + mvia  + iif(mwkPsSoluA.PS_urgente=1, ' - URGENTE -', '')   &&+ Chr(13)

** ------------------------------------------------- Planificacion
				mb1 = mwkPsSoluA.PS_guia
				mb2 = mwkPsSoluA.ps_fechormodif
				mb3 = mwkPsSoluA.PS_baxter
				mb4 = mwkPsSoluA.PS_fechoralta

				if mIdTipo > 1 && La solapa 1 no lleva planificacion

					use in select("mwkplanifi2")

*!*						If mIdEstado = 1   && Activo
*!*							Select * From mwkplanifi ;
*!*								where mwkplanifi.PP_guia = mb1 And mwkplanifi.pp_fechormodif = mb2 And mwkplanifi.pp_fecpasiva = Ctod('01/01/1900');
*!*								into Cursor mwkplanifi2
*!*						ELSE          && Pasivado
*!*							Select * From mwkplanifi ;
*!*								where mwkplanifi.PP_guia = mb1 And mwkplanifi.pp_fechormodif = mb2 And mwkplanifi.pp_fecpasiva <> Ctod('01/01/1900');
*!*								into Cursor mwkplanifi2
*!*						Endif

					select * from mwkplanifi ;
						where mwkplanifi.PP_GUIA = mb1 and mwkplanifi.PP_FECHORMODIF = mb2 ;
						into cursor mwkplanifi2

					mpasot = 0
					lPlan = .f.

					select mwkplanifi2
					go top

					scan all
						mPlanificacion = ""

						mPlanificacion = mPlanificacion + alltrim(str(mwkplanifi2.PP_DOSIS)) + ' ' + alltrim(mwkplanifi2.PP_UNIDADVOL) + ' '  + alltrim(mwkplanifi2.PP_FRECUENCIA) + ' ' + mwkplanifi2.PP_URGENTE

						if !empty(mPlanificacion)  &&Incorporamos la planificacion al insumo.
							mEvolPrinci = mEvolPrinci + chr(10) + iif(lPlan = .f.,"Planificación : " ,"") + mPlanificacion
							lPlan = .t.
						endif

					endscan
					use in select("mwkplanifi2")
					lPlan = .f.

				endif

** -------------- Buscamos la fecha-hora de inicializacion para la FECHA.
**Set Step On

				select * from mwkPresD where ttod(pps_fechora) = ttod(mFecHora) into cursor mwkPresFec
				mFecHoraBlan = iif(empty(mwkPresFec.pps_fechora),mb4,mwkPresFec.pps_fechora)
				mMedicoBlan = iif(empty(nvl(mwkPresFec.pps_usuariomodif,"")),"SIN INICIALIZAR",mwkPresFec.pps_usuariomodif)

** -------------- Grabamos registro generado
				if !empty(mEvolPrinci) &&.Or. !Empty(mAgregados)
					insert into mwkPrescribe (fecha,medico,Tipo,estado,Leyenda,Informe,FecHorBlan, MedicoBlan,TipoM,Guia,Baxter,Insumo,CodAdmision,IdEvol,inicio) ;
						values(mFecHora,mUsuario,mIdTipo,iif(mIdEstado = 1,'A','S'),mleye,mEvolPrinci,mFecHoraBlan,mMedicoBlan,iif(mIdTipo = 3,"I","S"),mb1,mb3,;
						mwkPsSoluA.PS_insumo,mwkPsSoluA.ps_admision,mwkPsSoluA.ps_idevol,mfinimed)
				endif


** --------------- Agregados

				if mIdTipo <> 3 && La solapa 3 no tiene agregados

					use in select("mwkagregad2")
					if mIdEstado = 1  &&Activos
						select * from mwkagregad;
							where mwkagregad.PA_guia = mb1 and mwkagregad.PA_baxter = mb3 and mwkagregad.pa_fechormodif = mb2 and pa_fecpasiva = ctod('01/01/1900');
							into cursor mwkagregad2
					else   &&Pasivados
						select * from mwkagregad;
							where mwkagregad.PA_guia = mb1 and mwkagregad.PA_baxter = mb3 and mwkagregad.pa_fechormodif = mb2 and pa_fecpasiva <> ctod('01/01/1900');
							into cursor mwkagregad2
					endif

					mpasot = 0

					select mwkagregad2
					go top

					scan all

						mAgregados = ""
						mBajaAgre = ""
						mdetalleins = ""
						mpv2 = mwkagregad2.PA_insumo

						mdetalleins = mwkagregad2.INS_descriinsumo

						if mwkagregad2.pa_fecpasiva <> ctod("01/01/1900") or mwkPsSoluA.ps_fecpasiva <> ctod('01/01/1900')

							if empty(mBajaPrinci)
								mBajaPrinci = mPrincipal
							endif

							mBajaAgre = mBajaAgre + alltrim(mdetalleins) + ' ' + iif( mwkagregad2.PA_dosis > 0 , alltrim(str(mwkagregad2.PA_dosis)),'') + ' ' + alltrim(mwkagregad2.PA_unidadvol) ;
								+ ' ' + iif( mwkagregad2.PA_cantpres > 0 , alltrim(str(mwkagregad2.PA_cantpres)), '') + ' ' + alltrim(mwkagregad2.PA_unipres) + ' ' + alltrim(mwkagregad2.PA_comentarios) + chr(10)

							mBajaAgre = mBajaAgre + ' ' + alltrim(mwkagregad2.PA_motivo) + chr(10)

** ----------------- Grabamos registro de baja
							insert into mwkPrescribe (fecha,medico,Tipo,estado,Leyenda,Informe,TipoM,Guia,Baxter,Insumo,FecHorBlan,MedicoBlan,CodAdmision,IdEvol,inicio);
								values(mFecHora,mUsuario,mIdTipo,iif(mIdEstado = 1,'A','S'),mleye,mBajaAgre,"A",mb1,mb3,mpv2,mFecHoraBlan,mMedicoBlan,mwkagregad2.pa_admision,mwkagregad2.pa_idevol,mfinimed )

						else
							mAgregados = mAgregados + alltrim(mdetalleins) + ' ' + iif( mwkagregad2.PA_dosis > 0 , alltrim(str(mwkagregad2.PA_dosis)),'') + ' ' + alltrim(mwkagregad2.PA_unidadvol) ;
								+ ' ' + iif( mwkagregad2.PA_cantpres > 0 , alltrim(str(mwkagregad2.PA_cantpres)), '') + ' ' + alltrim(mwkagregad2.PA_unipres) + ' ' + alltrim(mwkagregad2.PA_comentarios) + chr(10)
** ----------------- Grabamos registro Agregado
							insert into mwkPrescribe (fecha,medico,Tipo,estado,Leyenda,Informe,TipoM,Guia,Baxter,Insumo,FecHorBlan,MedicoBlan,CodAdmision,IdEvol,inicio) ;
								values(mFecHora,mUsuario,mIdTipo,iif(mIdEstado = 1,'A','S'),mleye,mAgregados,"A",mb1,mb3,mpv2,mFecHoraBlan,mMedicoBlan,mwkagregad2.pa_admision,mwkagregad2.pa_idevol,mfinimed )

						endif

					endscan
					use in select("mwkagregad2")

				endif

				select mwkPsSoluA

			endscan

			select mwkpsfechas

		next mIdEstado

	next mIdTipo

	select mwkpsfechas

Endscan

Select mwkPrescribe.fecha, ;
	mwkPrescribe.medico, ;
	mwkPrescribe.Tipo, ;
	mwkPrescribe.estado,;
	mwkPrescribe.Leyenda,;
	mwkPrescribe.Informe,;
	mwkPrescribe.FecHorBlan, ;
	mwkPrescribe.MedicoBlan,;
	mwkPrescribe.TipoM,;
	mwkPrescribe.Guia,;
	mwkPrescribe.Baxter,;
	mwkPrescribe.Insumo,;
	mwkPrescribe.CodAdmision,;
	mwkPrescribe.IdEvol,;
	mwkPrescribe.inicio,;
	Iif( Nvl(mwkPrescribe.matriculas,0) = 0, Nvl( mwkusumed.matriculas,0) ,Nvl(mwkPrescribe.matriculas,0)) As matriculas ;
From mwkPrescribe ;
Left Join mwkusumed On medico = idusuario ;
Into Cursor mwkPrescribeaux

SELECT fecha,medico,Tipo,estado,Leyenda,Informe,FecHorBlan, MedicoBlan, ;
	TipoM,Guia,Baxter,Insumo,CodAdmision,IdEvol,inicio,NVL(matriculas,0) as matriculas ;
	FROM mwkPrescribeaux INTO CURSOR mwkPrescribeAux234

Use In Select("mwkPrescribe")

Use Dbf("mwkPrescribeAux234") Shared In 0 Alias "mwkPrescribe" again

	
	
	

