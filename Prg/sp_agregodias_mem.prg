*****************************************************************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
******************************************************************************
* Modificado:18/06/2003
**********************************************
* hago un insert del registro de prestaciones
* al de medico -prestaciones
**********************************************
*do sp_conexion.prg
lparameters lnuevo,tfecha 
if vartype(lnuevo)#"N"
	lnuevo = 1
	fecaudi   = sp_busco_fecha_serv('DT')
ELSE
	fecaudi   = tfecha
endif

mfecpas = CTOD("01/01/1900")
if type('mthrdes') = 'N'
	mdhdesde1 	= ctot('01/01/1900 '+ strtran(transf(mthrdes*100,"99:99:99")," ","0") )
	mdhhasta1 	= ctot('01/01/1900 '+ strtran(transf(mthrhas*100,"99:99:99")," ","0") )
	hhmmD		= mthrdes
	hhmmH		= mthrhas
	mcthrdes	= strtran(transf(mthrdes*100,"99:99:99")," ","0")
	mcthrhas	= strtran(transf(mthrhas*100,"99:99:99")," ","0")

else
	mdhdesde1 	= ctot('01/01/1900 '+ mthrdes)
	mdhhasta1 	= ctot('01/01/1900 '+ mthrhas)
	hhmmD		= val(left(mthrdes,2)+substr(mthrdes,4,2))
	hhmmH		= val(left(mthrhas,2)+substr(mthrhas,4,2))
	mcthrdes	= mthrdes
	mcthrhas	= mthrhas
endif
mccampo = ''
mvcampo = ''
if mxambito >1
	mccampo = ", codambito "
	mvcampo = ", ?mxambito "
endif
do case
	case lnuevo  =1
		mret=sqlexec(mcon1," INSERT INTO TabMEMedpresta(MEP_codprest, MEP_fecVigend,MEP_fecVigenH, MEP_hhmmDes,MEP_hhmmHas, "+;
			" MEP_horadesde, MEP_horahasta, MEP_idFranja,MEP_fechagraba ,MEP_fecpasiva ,MEP_usuario &mccampo ) "+;
			" values (?mncodprest,?mfecvigend,?mfecvigenh, ?hhmmD, ?hhmmH, ?mdhdesde1,?mdhhasta1, "+;
			" ?midfranja , ?fecaudi,?mfecpas, ?midusu &mvcampo )")

	case lnuevo  = 2
		mret=sqlexec(mcon1," select id from TabMEMedpresta where MEP_codprest = ?mncodprest and MEP_idFranja = ?midfranja ","mwkctrmep")

		IF RECCOUNT("mwkctrmep") = 0
			mret=sqlexec(mcon1," INSERT INTO TabMEMedpresta(MEP_codprest, MEP_fecVigend,MEP_fecVigenH, MEP_hhmmDes,MEP_hhmmHas, "+;
				" MEP_horadesde, MEP_horahasta, MEP_idFranja,MEP_fechagraba,MEP_fecpasiva  ,MEP_usuario &mccampo ) "+;
				" values (?mncodprest,?mfecvigend,?mfecvigenh, ?hhmmD, ?hhmmH, ?mdhdesde1,?mdhhasta1, "+;
				" ?midfranja , ?fecaudi,?mfecpas, ?midusu &mvcampo )")
		ELSE
			mid = mwkctrmep.id
			mret=sqlexec(mcon1," update TabMEMedpresta set MEP_fecVigend = ?mfecvigend,MEP_fecVigenH = ?mfecvigenh , MEP_hhmmDes = ?hhmmD ,MEP_hhmmHas = ?hhmmH , "+;
				" MEP_horadesde = ?mdhdesde1 , MEP_horahasta = ?mdhhasta1 , MEP_fechagraba  = ?fecaudi ,MEP_usuario = ?midusu where id = ?mid ")
		endif
	case lnuevo  = 3 &&& borro los que no van
			mret=sqlexec(mcon1," update TabMEMedpresta set MEP_fecpasiva = ?fecaudi,MEP_fechagraba  = ?fecaudi  where MEP_idFranja = ?midfranja and MEP_fechagraba  < ?fecaudi ")


endcase
if mret < 0
	messagebox("Los datos No se pudieron Grabar",16, "Validacion")
	mret=0

else
	vr_ok_prest = .t.
*wait 'Los Datos Se guardaron Exitosamente!!!' window nowait timeout 120
endif
*endif

