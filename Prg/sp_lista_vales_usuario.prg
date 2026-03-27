****
** Listado de vales por usuario
****

Parameter mfecdes, mfechas, mbusco1,lsab
mselsab = ''
If Vartype(lsab)="N"
	mselsab = Iif(lsab = 1,''," and datepart(dw,VAL_fechasolicitud ) < 7 ")
Endif
If mxambito >1
	mcjoinvales = " inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "
	mbuscoval =  " and pac_codambito=?mxambito "
Else
	If mfecdes>=Ctod("05/09/2022")
		mcjoinvales = " inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "
		mbuscoval = " and PAC_CentroMedico = ?mxcentromedico"
	Else
		mbuscoval = ''
		mcjoinvales = ""
	Endif
Endif
mret =SQLExec(mcon1, "select VAL_operadorcarga, VAL_fechasolicitud , count (*) as cantidad " + ;
	"from valesasist "+mcjoinvales +;
	" where VAL_codsector ='AMB' and " +;
	" VAL_fechasolicitud >= ?mfecdes and VAL_fechasolicitud <= ?mfechas " + mbusco1 + mselsab+mbuscoval +;
	" group by VAL_operadorcarga,VAL_fechasolicitud ","mwktotval")
If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_lista_vales_usuario'
	Do prg_cancelo
Endif
