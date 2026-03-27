****
** busco Datos para Monitor de vales
****
mfecnul = Ctod("01/01/1900")
If !Used('mwkpMed')
	Do sp_busco_phordatos
Endif

Use In Select("mwkserv")

mret = SQLExec(mcon1, "select ser_codserv, ser_descripserv,scv_mnemonico"+;
	" from servicios, servcargval" + ;
	" where ser_codserv = servcargval.scv_codservicio" + ;
	" and scv_mnemonico is not null and ser_fechapasiva is null"+;
	" order by ser_descripserv", "mwkserv")

If mret < 0
	aerror(eros)
	Messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 

If Used('mwkcodserv')
	If Reccount('mwkcodserv')>0

		Select * From mwkserv,mwkcodserv ;
			where mwkcodserv.scv_codservicio = mwkserv.ser_codserv Into Cursor mwkserv
	Else
		Select *,ser_codserv As scv_codservicio From mwkserv Into Cursor mwkserv
	Endif
Else
	Select *,ser_codserv As scv_codservicio From mwkserv Into Cursor mwkserv
Endif

mret = SQLExec(mcon1, "select fecpasiva,codent from entidexclu "+;
	"where tpopac='INT' and fecpasiva =?mfecnul  and tipoturno = 0","mwkentexc_int")

If mret < 0
	Messagebox("ERROR DE LECTURA", 48, "VALIDACION")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .f.
Endif
