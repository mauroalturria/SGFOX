*
* Prescripción Medica - Log
*
parameters midevol, midtipo, mhis,mvfecdes,mvfechas,morden

*Create Cursor mwkhpresmedA (fh T, detalle M)
*Create Cursor mwkhpresmedB (fh T, detalle M)
*msuspende = .T.

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
endif
if vartype(mhis) <> "N" && Default Actual
	mhis = 0
endif
if vartype(morden) <> "C" && Default Actual
	morden = " Desc "
endif
local mLeyendaEvol
local mLeyendaBaja

mLeyendaEvol = ''
mLeyendaBaja = ''

mlidguia    = ''
mdetalleins = ''

if vartype(midtipo) <> "N" && por default Endovenoso Continuo
	midtipo = 1
endif

do case
	case midtipo = 1
		mleye = "Endovenoso Continuo"
	case midtipo = 2
		mleye = "Endovenoso No continuo"
	case midtipo = 3
		mleye = "Medicación / Insumos"
endcase

*!*	1 Endovenoso Continuo      : PRINCIPAL c/VIAS + AGREGADOS
*!*	2 Endovenoso No Continuo   : PRINCIPAL c/VIAS + AGREGADOS + PLANIFICA
*!*	3 No Endovenoso            : PRINCIPAL c/VIAS + PLANIFICA

*!* xx_tipo  //  PS PA PP
*!* xx_estadodia // PS PA PP
*!* 1 Activo / 2 dias anteriores
*!* Fecha modificación
*!*	PS_fechormodif
*!*	PA_fechormodif
*!*	PP_fechormodif

use in select("mwksolprin")
use in select("mwkagregad")
use in select("mwkplanifi")
use in select("mwkpresd")

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
** ------------------------------------------------

mfiltro = ''
if xfecha
	mfiltro = " and PS_fechormodif >= ?mfecdes and PS_fechormodif <= ?mfechas "
endif
if mwkusuario.codigovax = 54035
*	MESSAGEBOX(mfiltro )
endif
do case
	case mhis = 1

*!*		mret = SQLExec(mcon1,"select * from TabIntPmSoluLg"+;
*!*			" where PS_idevol = ?midevol and PS_tipo = ?midtipo"+;
*!*			" order by PS_fechormodif desc","mwksolprin")
		mret = sqlexec(mcon1,"select TabIntPmSoluLg.*, insumos.INS_descriinsumo "+;
			" from TabIntPmSoluLg"+;
			" join insumos on INS_codinsumo = PS_Insumo"+;
			" where PS_idevol = ?midevol and PS_tipo = ?midtipo"+mfiltro +;
			" group by PS_fechormodif, PS_Insumo "+;
			" order by PS_fechormodif "+morden ,"mwksolprin")


	case mhis = 0

*!*		mret = SQLExec(mcon1,"select * from TabIntPmSolu"+;
*!*			" where PS_idevol = ?midevol and PS_tipo = ?midtipo"+;
*!*			" order by PS_fechormodif desc","mwksolprin")

		mret = sqlexec(mcon1,"select TabIntPmSolu.*, insumos.INS_descriinsumo "+;
			" from TabIntPmSolu"+;
			" join insumos on INS_codinsumo = PS_Insumo"+;
			" where PS_idevol = ?midevol and PS_tipo = ?midtipo"+mfiltro +;
			" order by PS_fechormodif "+morden ,"mwksolprin")

	case mhis = 2 && PARA la ultima evolucion de HCE

		mret = sqlexec(mcon1,"select TabIntPmSolu.*, insumos.INS_descriinsumo "+;
			" from TabIntPmSolu"+;
			" join insumos on INS_codinsumo = PS_Insumo"+;
			" where PS_idevol = ?midevol and PS_tipo = ?midtipo"+mfiltro +;
			" order by PS_fechormodif "+morden ,"mwksolprin")
		if reccount("mwksolprin")=0
			mret = sqlexec(mcon1,"select TabIntPmSolu.*, insumos.INS_descriinsumo "+;
				" from TabIntPmSolu"+;
				" join insumos on INS_codinsumo = PS_Insumo"+;
				" where PS_idevol = ?midevol and PS_tipo = ?midtipo"+;
				" order by PS_fechormodif "+morden ,"mwksolprin")
			if reccount("mwksolprin")>0
				if morden = " Desc "
					go top
				else
					go bott
				endif
				mfecdes = 	prg_dtoc(ttod(PS_fechormodif))
				mfiltro = " and PS_fechormodif >= ?mfecdes and PS_fechormodif <= ?mfechas "
				mret = sqlexec(mcon1,"select TabIntPmSolu.*, insumos.INS_descriinsumo "+;
					" from TabIntPmSolu"+;
					" join insumos on INS_codinsumo = PS_Insumo"+;
					" where PS_idevol = ?midevol and PS_tipo = ?midtipo"+mfiltro +;
					" order by PS_fechormodif "+morden ,"mwksolprin")

			endif
		endif
endcase

if mret < 0
	mltabla = "PRESCRIPCION MEDICA - SOLUCIONES PRINCIPALES - " + upper(mleye)
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("EN LA TABLA "+mltabla +chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	return .f.
endif

select mwksolprin.*, mwkguias.descrip as lguiadescrip;
	from mwksolprin ;
	left join mwkguias on mwkguias.estado = mwksolprin.PS_guia ;
	order by PS_fechormodif &morden ;
	into cursor mwksolprin

mfiltro = ''
if xfecha
	mfiltro = " and PA_fechoralta >= ?mfecdes and PA_fechoralta <= ?mfechas "
endif
if mwkusuario.codigovax = 54035
*	MESSAGEBOX(mfiltro )
endif

do case
	case  mhis = 1

*!*		mret = SQLExec(mcon1,"select * from TabIntPmAgreLg"+;
*!*			" where PA_idevol = ?midevol and PA_tipo = ?midtipo"+;
*!*			" order by PA_fechormodif desc","mwkagregad")

		mret = sqlexec(mcon1,"select TabIntPmAgreLg.*, insumos.INS_descriinsumo "+;
			" from TabIntPmAgreLg"+;
			" join insumos on INS_codinsumo = PA_Insumo"+;
			" where PA_idevol = ?midevol and PA_tipo = ?midtipo"+ mfiltro +;
			" group by PA_fechormodif,PA_Insumo " +;
			" order by PA_fechormodif "+ morden ,"mwkagregad")


	case  inlist(mhis,0,2)

*!*		mret = SQLExec(mcon1,"select * from TabIntPmAgre"+;
*!*			" where PA_idevol = ?midevol and PA_tipo = ?midtipo"+;
*!*			" order by PA_fechormodif desc","mwkagregad")

		mret = sqlexec(mcon1,"select TabIntPmAgre.*, insumos.INS_descriinsumo "+;
			" from TabIntPmAgre"+;
			" join insumos on INS_codinsumo = PA_Insumo"+;
			" where PA_idevol = ?midevol and PA_tipo = ?midtipo"+mfiltro +;
			" order by PA_fechormodif "+ morden,"mwkagregad")

endcase

if mret < 0
	mltabla = "PRESCRIPCION MEDICA - AGREGADOS - " + upper(mleye)
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("EN LA TABLA "+mltabla +chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	return .f.
endif
mfiltro = ''
if xfecha
	mfiltro = " and PP_fechoralta >= ?mfecdes and PP_fechoralta <= ?mfechas "
endif
if mwkusuario.codigovax = 54035
*	MESSAGEBOX(mfiltro )
endif

do case
	case  mhis = 1
		mret = sqlexec(mcon1,"select * from TabIntPmPlanLg"+;
			" where PP_idevol = ?midevol and PP_tipo = ?midtipo"+mfiltro +;
			" group by PP_fechormodif, PP_insumo "+;
			" order by PP_fechormodif "+ morden,"mwkplanifi")
	case   inlist(mhis,0,2)

		mret = sqlexec(mcon1,"select * from TabIntPmPlan"+;
			" where PP_idevol = ?midevol and PP_tipo = ?midtipo"+mfiltro +;
			" order by PP_fechormodif "+ morden,"mwkplanifi")
endcase

if mret < 0
	mltabla = "PRESCRIPCION MEDICA - PLANIFICACION - " + upper(mleye)
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("EN LA TABLA "+mltabla +chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	return .f.
endif

mLeyendaEvol = ""
mLeyendaBaja = ""
mfctrl       = dtot({//})

mctrline = 0

select mwksolprin
go top
scan all

	mPrincipal     = ""
	mPlanificacion = ""
	mAgregados     = ""
	mBajaPrinci    = ""
	mBajaAgre      = ""
	mBajaPlanif    = ""
	lBajaPrinci    = .f.
	mEvolPrinci    = ""

	if mwksolprin.PS_fechormodif <> mfctrl
** ------------ fecha de modificacion
		mfctrl = mwksolprin.PS_fechormodif
** ----------- usuario que cargo la modificacion
		mprofesional = alltrim(mwksolprin.PS_usuariomodif)
		select mwkusumed
		mmat = 0
		locate for idusuario = mprofesional
		if found()
			mmat = nvl(matriculas,0)
		endif

** ----------- Ultima inicialización del dia
		select mwkPresD
		locate for ttod(pps_fechora) = ttod(mfctrl)
		if found()
			mfpres = pps_fechora
		else
			mfpres = dtot({//})
		endif
** --------------------------------------
		select mwksolprin

		if mwksolprin.ps_fecpasiva = ctod("01/01/1900")
			mEvolPrinci = "mPrincipal"
			&mEvolPrinci. = &mEvolPrinci. + chr(13) + replicate("=",70) + chr(13)
			&mEvolPrinci. = &mEvolPrinci. + "TRATAMIENTOS, REGISTRADOS EL " + ttoc(mfctrl) + ' - ' + upper(mleye) + ' - ' + mprofesional+iif(mmat>0," M.N.:"+transform(mmat),'') +chr(13)
			&mEvolPrinci. = &mEvolPrinci. + "INICIALIZACION : " + ttoc(mfpres) + chr(13)
			&mEvolPrinci. = &mEvolPrinci. + replicate("=",70)+ chr(13)
		else
			mEvolPrinci = "mBajaPrinci"
			&mEvolPrinci. = &mEvolPrinci. + chr(13) + replicate("=",70) + chr(13)
			&mEvolPrinci. = &mEvolPrinci. + "TRATAMIENTOS, REGISTRADOS EL " + ttoc(mfctrl) + ' - ' + upper(mleye) + ' - ' + mprofesional+iif(mmat>0," M.N.:"+transform(mmat),'') +chr(13)
			&mEvolPrinci. = &mEvolPrinci. + replicate("=",70) + chr(13)
		endif
		mctrline = 0
	else
		if mwksolprin.ps_fecpasiva = ctod("01/01/1900")
			mEvolPrinci = "mPrincipal"
		else
			mEvolPrinci = "mBajaPrinci"
		endif
	endif

	if midtipo <> 3

		if mctrline > 0
			&mEvolPrinci. = &mEvolPrinci. + replicate("-",70)+ chr(13)
		endif

		mctrline = mctrline + 1

*	Select mwkguias
*	Go Top
*	Locate For mwkguias.estado = mwksolprin.PS_guia
*	If Found()
*		mlidguia = mwkguias.Descrip

		mlidguia = nvl(mwksolprin.lguiadescrip,space(50))
*	Endif
		&mEvolPrinci. = &mEvolPrinci. + chr(13)+ '>> GUIA: ' +  alltrim(mlidguia) + iif(!empty(nvl(mwksolprin.PS_baxter,""))," BAXTER : " + alltrim(mwksolprin.PS_baxter),"") + chr(13)
	endif

*!* 2015-02-20
	mpv2 = mwksolprin.PS_insumo

	if !empty(mpv2)

*Do sp_busco_insumo_codigo With mpv2,,,'T'
*If Used("mwkinsumo")
*	If Reccount("mwkinsumo")>0
*		mdetalleins = mwkinsumo.INS_descriinsumo
*	Endif
*Endif
		mdetalleins = mwksolprin.INS_descriinsumo

	else

		if alltrim(mlidguia) = 'BOLO EV'
			mdetalleins = mlidguia
		endif

	endif

**  Leyenda del grid principal (SOLUCION O MEDICACION.)

	select mwksolprin

	&mEvolPrinci. = &mEvolPrinci. + alltrim(mdetalleins) + ' ' + iif(midtipo<>3, alltrim(str(mwksolprin.PS_volumen)) + ' ML ', '' )

	if midtipo = 3   && solo si viene por NO ENDOVENOSO
		&mEvolPrinci. = &mEvolPrinci. +' '+ iif( mwksolprin.ps_cantidad > 0, alltrim(str(mwksolprin.ps_cantidad)) ,'') + ' ' + alltrim(mwksolprin.ps_unidad) + ' ' + iif(mwksolprin.ps_cantpres > 0 ,alltrim(str(mwksolprin.ps_cantpres)),'') + ' ' + alltrim(mwksolprin.ps_unipres)+ ' '+ alltrim(mwksolprin.ps_comentarios)
	endif

	if midtipo <> 3
		if mwksolprin.PS_goteo = 1
			&mEvolPrinci. = &mEvolPrinci. + '(GOTEO LIBRE) '
		else
			&mEvolPrinci. = &mEvolPrinci. + '(GOTEO) VOLUMEN: ' + alltrim(str(mwksolprin.PS_goteovol)) + ' ML' + ;
				', TIEMPO: ' + alltrim(str(mwksolprin.PS_goteotmp)) + iif(mwksolprin.PS_goteotuni = 1," HORAS"," MINUTOS") +;
				', '+alltrim(str(mwksolprin.PS_goteogtsmin)) + iif(mwksolprin.PS_goteomacmic = 1," MACROGOTAS"," MICROGOTAS") + " POR MINUTO"+;
				', '+alltrim(str(mwksolprin.PS_goteomlhr)) + ' MILILITROS POR HORA'
		endif
	endif

	&mEvolPrinci. = &mEvolPrinci. + chr(13)

	if midtipo <> 3
		select mwkIvias
		go top
		locate for mwkIvias._id = mwksolprin.PS_via
		mvia =  mwkIvias._via
	else
		select mwkIvias3
		go top
		locate for mwkIvias3._id = mwksolprin.PS_via
		mvia = mwkIvias3._via
	endif

	mfini = nvl(ttoc(mwksolprin.PS_fechoraini),'')

	&mEvolPrinci. = &mEvolPrinci. + 'VIA ' + mvia + iif( len(mfini) > 1, ', INICIO ' + mfini, '')  + iif(mwksolprin.PS_urgente=1, ' - URGENTE -', '') + chr(13)

**  Si esta dado de baja, mostramos a lo ultimo.

	if mwksolprin.ps_fecpasiva <> ctod("01/01/1900")
**&mEvolPrinci. = &mEvolPrinci. + 'BAJA ' + dtoc(mwksolprin.ps_fecpasiva) + ' ' + alltrim(mwksolprin.PS_motivo) + chr(13)
		&mEvolPrinci. = &mEvolPrinci. + 'BAJA ' + dtoc(mwksolprin.ps_fecpasiva)+" "+ttoc(mwksolprin.PS_fechormodif,2) + ' ' + alltrim(mwksolprin.PS_motivo) + chr(13)
		lBajaPrinci = .t.
	endif

	mb1 = mwksolprin.PS_guia
	mb2 = mwksolprin.PS_fechormodif
	mb3 = mwksolprin.PS_baxter

	if midtipo <> 3 && Agregados

		use in select("mwkagregad2")

		select * from mwkagregad;
			where mwkagregad.PA_guia = mb1 and mwkagregad.PA_baxter = mb3 and mwkagregad.PA_fechormodif = mb2;
			into cursor mwkagregad2

**			And pa_fecpasiva = Ctod("01/01/1900")

		mpasot = 0

		select mwkagregad2
		go top

		scan all

** 		    Tomamos en cuenta si el principal esta dado de baja.
			if !lBajaPrinci
				if mpasot = 0
**		            mleyendaEvol = mleyendaEvol + Chr(13) + "(AGREGADOS)" + Chr(13)
					mAgregados = mAgregados + chr(13) + "(AGREGADOS)" + chr(13)
					mpasot = 1
				endif
			endif
			if lBajaPrinci or mwkagregad2.pa_fecpasiva <> ctod("01/01/1900")
				if mpasot = 0 .or. empty(mBajaAgre)
**					mleyendaEvol = mleyendaEvol + Chr(13) + "(AGREGADOS)" + Chr(13)
					mBajaAgre = mBajaAgre + chr(13) + "(AGREGADOS)" + chr(13)
					mpasot = 1
				endif
			endif

			mdetalleins = ""
			mpv2 = mwkagregad2.PA_insumo

*			Do sp_busco_insumo_codigo With mpv2,,,'T'
*			If Used("mwkinsumo")
*				If Reccount("mwkinsumo")>0
*					mdetalleins = mwkinsumo.INS_descriinsumo
*				Endif
*			Endif

			mdetalleins = mwkagregad2.INS_descriinsumo

			if mwkagregad2.pa_fecpasiva <> ctod("01/01/1900") or lBajaPrinci
** 				va a lo ultimo.
				if empty(mBajaPrinci)
					mBajaPrinci = mPrincipal
				endif

				mBajaAgre = mBajaAgre + alltrim(mdetalleins) + ' ' + iif( mwkagregad2.PA_dosis > 0 , alltrim(str(mwkagregad2.PA_dosis)),'') + ' ' + alltrim(mwkagregad2.PA_unidadvol) ;
					+ ' ' + iif( mwkagregad2.PA_cantpres > 0 , alltrim(str(mwkagregad2.PA_cantpres)), '') + ' ' + alltrim(mwkagregad2.PA_unipres) + ' ' + alltrim(mwkagregad2.PA_comentarios) + chr(13)

				mBajaAgre = mBajaAgre + 'BAJA ' + dtoc(mwkagregad2.pa_fecpasiva) + ' ' + alltrim(mwkagregad2.PA_motivo) + chr(13)

			else
				mAgregados = mAgregados + alltrim(mdetalleins) + ' ' + iif( mwkagregad2.PA_dosis > 0 , alltrim(str(mwkagregad2.PA_dosis)),'') + ' ' + alltrim(mwkagregad2.PA_unidadvol) ;
					+ ' ' + iif( mwkagregad2.PA_cantpres > 0 , alltrim(str(mwkagregad2.PA_cantpres)), '') + ' ' + alltrim(mwkagregad2.PA_unipres) + ' ' + alltrim(mwkagregad2.PA_comentarios) + chr(13)
			endif

		endscan
		use in select("mwkagregad2")

		if mpasot = 1
			replicate("=",170)
		endif

	endif

	if midtipo > 1 && Planificacion

		use in select("mwkplanifi2")

*!*     2014-08-20
*		If midtipo <> 3

		select * from mwkplanifi ;
			where mwkplanifi.PP_guia = mb1 and mwkplanifi.PP_fechormodif = mb2;
			into cursor mwkplanifi2

*!*				Else
*!*					Select * From mwkplanifi ;
*!*						WHERE mwkplanifi.PP_guia = mb1 ;
*!*						INTO Cursor mwkplanifi2
*!*				Endif

		mpasot = 0

		select mwkplanifi2
		go top

		scan all
			if !lBajaPrinci
				if mpasot = 0
					mPlanificacion = mPlanificacion + " - (PLANIFICACION) - "
					mpasot = 1
				endif
			else
				if mpasot = 0
					mBajaPlanif = mBajaPlanif +" - (PLANIFICACION) - "
					mpasot = 1
				endif
			endif

			if mwkplanifi2.PP_fecpasiva <> ctod("01/01/1900") or lBajaPrinci

** 				Grabamos la cabecera por si esta no viene dada de Baja.

				if empty(mBajaPrinci)
					mBajaPrinci = mPrincipal
				endif

				mBajaPlanif = mBajaPlanif + alltrim(str(mwkplanifi2.PP_dosis)) + ' ' + alltrim(mwkplanifi2.PP_unidadvol) + ' '  + alltrim(mwkplanifi2.PP_frecuencia) + ' ' +	mwkplanifi2.PP_urgente + chr(13)
**              mBajaPlanif = mBajaPlanif + 'BAJA ' + Dtoc(mwkplanifi2.PP_fecpasiva) + ' ' + Alltrim(mwkplanifi2.PP_motivo) + Chr(13)

			else

				mPlanificacion = mPlanificacion + alltrim(str(mwkplanifi2.PP_dosis)) + ' ' + alltrim(mwkplanifi2.PP_unidadvol) + ' '  + alltrim(mwkplanifi2.PP_frecuencia) + ' ' + mwkplanifi2.PP_urgente + chr(13)

			endif

		endscan
		use in select("mwkplanifi2")

	endif

	if !empty(mPrincipal + mAgregados + mPlanificacion)

		mLeyendaEvol = mLeyendaEvol + mPrincipal + mAgregados + mPlanificacion + chr(13)

*!*		Insert Into mwkhpresmedA (fh, detalle) Values (mwksolprin.PS_fechormodif, mPrincipal + mAgregados + mPlanificacion)

	endif

	if !empty(mBajaPrinci + mBajaAgre + mBajaPlanif)

		mLeyendaBaja = mLeyendaBaja + mBajaPrinci + mBajaAgre + mBajaPlanif + chr(13)

*!*			If msuspende
*!*				msuspende = .F.
*!*				Insert Into mwkhpresmedB (fh, detalle) Values (mwksolprin.PS_fechormodif, " ELEMENTOS SUSPENDIDOS ")
*!*			Endif

*!*		Insert Into mwkhpresmedB (fh, detalle) Values (mwksolprin.PS_fechormodif, mBajaPrinci + mBajaAgre + mBajaPlanif)

	endif

	select mwksolprin

endscan

if !empty(mLeyendaBaja)
	mLeyendaBaja = chr(13) + replicate("=",70) + chr(13) + " ELEMENTOS SUSPENDIDOS " + chr(13) + replicate("=",70) + chr(13) + mLeyendaBaja
endif

use in select("mwksolprin")
use in select("mwkagregad")
use in select("mwkplanifi")

mdevolu = mLeyendaEvol + mLeyendaBaja

*Set Step On

*!*	If Lenc(mdevol) > 65000
*!*		Messagebox("OK")
*!*	Endif

return mdevolu



