*****************************************************************************
* AUTOR:Claudia Antoniow
* FECHA:18/06/2003
******************************************************************************
* Modificado:18/06/2003
**********************************************
* hago un insert del registro de prestaciones
* al de medico -prestaciones
**********************************************
*Inserto franja memo
lparameters lnuevo,mnid
if vartype(lnuevo)#"N"
	lnuevo = 1
endif
fecaudi   = sp_busco_fecha_serv('DT')
mfecpas = ctod("01/01/1900")
mccampo = ''
mvcampo = ''
if vartype(midfranjareal )#"N"
	midfranjareal = 0
endif
if mxambito >1
	mccampo = ", codambito "
	mvcampo = ", ?mxambito "
endif
if type('mthrdes')='N'
	mdhdesde1 = ctot('01/01/1900 '+ strtran(transf(mthrdes*100,"99:99:99")," ","0"))
	mdhhasta1 = ctot('01/01/1900 ' + strtran(transf(mthrhas*100,"99:99:99")," ","0"))

	hhmmD		= mthrdes
	hhmmH		= mthrhas
else
	mdhdesde1 = ctot('01/01/1900 '+ mthrdes)
	mdhhasta1 = ctot('01/01/1900 ' + mthrhas)

	hhmmD		= val(left(mthrdes,2)+substr(mthrdes,4,2))
	hhmmH		= val(left(mthrhas,2)+substr(mthrhas,4,2))
endif
do case
	case lnuevo = 1

		mret = sqlexec(mcon1," INSERT INTO TabMEFranja( MEF_codmed,  MEF_diasem,  MEF_estructura," +;
			"  MEF_fechagraba, MEF_fecvigend, MEF_fecvigenh,  MEF_HoraDesde, MEF_HoraHasta,  " +;
			"  MEF_tiposervicio, MEF_usuario, MEF_tipoturno, MEF_hhmmDes, MEF_hhmmHas,"+;
			" MEF_duracion , MEF_idMemo , MEF_reservados , MEF_sala , MEF_tipoAgenda,MEF_fecpasiva,MEF_idFranjaActiva &mccampo )" +;
			"  values (?mncodmed, ?mndia, ?mctipostruc, ?fecaudi,        " +;
			"  ?mdfecVigenD, ?mdfecVigenh, ?mdhdesde1 , ?mdhhasta1, " +;
			"  ?mntipofranja, ?midusu, ?mntipotur, ?hhmmD, ?hhmmH, "+;
			" ?mtdura , ?mnidMemo , ?mnreservados , ?mcsala , ?mntipoAgenda, ?mfecpas ,?midfranjareal  &mvcampo )")
	case lnuevo = 2
		mret = sqlexec(mcon1," update TabMEFranja set MEF_diasem = ?mndia,  MEF_estructura = ?mctipostruc ," +;
			"  MEF_fechagraba = ?fecaudi , MEF_fecvigend = ?mdfecVigenD , MEF_fecvigenh = ?mdfecVigenh ,  MEF_HoraDesde = ?mdhdesde1 "+;
			" , MEF_HoraHasta = ?mdhhasta1 , MEF_tiposervicio = ?mntipofranja , MEF_usuario = ?midusu , MEF_tipoturno = ?mntipotur , "+;
			" MEF_hhmmDes = ?hhmmD , MEF_hhmmHas = ?hhmmH , MEF_duracion  = ?mtdura  , MEF_reservados  = ?mnreservados  , "+;
			" MEF_sala  = ?mcsala  , MEF_tipoAgenda = ?mntipoAgenda ,MEF_fecpasiva = ?mfecpas  ,MEF_idFranjaActiva = ?midfranjareal  where id = ?mnid ")
	case lnuevo = 99
		mfecpas = ttod(fecaudi)
		mret = sqlexec(mcon1," update TabMEFranja set  MEF_fechagraba = ?fecaudi ,MEF_fecpasiva = ?mfecpas where id = ?mnid ")
		midfranjaa = midfranja
		midfranja = mnid
		do sp_agregodias_mem with 3,fecaudi &&borro las prestaciones
		midfranja = midfranjaa
endcase
if mret < 0
	messagebox("Los datos No se pudieron Grabar en la franja, avisar a sistemas",16, "Validacion")
	mret=0
else
	mret = sqlexec(mcon1," select id from  TabMEFranja where MEF_codmed = ?mncodmed    and   MEF_diasem = ?mndia    and   MEF_hhmmDes = ?hhmmD   and " +;
		"  MEF_fecvigend = ?mdfecVigenD   and  MEF_usuario = ?midusu   and  MEF_tipoturno = ?mntipotur and MEF_fechagraba = ?fecaudi   " ,"mwkctrlfran")
*	wait 'Los Datos Se guardaron Exitosamente!!!' window nowait timeout 120
endif


