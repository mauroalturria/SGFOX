*************************************************************
* Datos medicos
**************************************
Parameters mcuit
mfecnul = Ctod("01/01/1900")
mxambAnt = mxambito
mret =SQLExec(mcon1,'SELECT Prestadores.*, Tabproffiltro.TPF_filtro FROM prestadores '+;
	' LEFT OUTER JOIN Tabproffiltro ON Tabproffiltro.TPF_codmed = Prestadores.ID '+;
	' WHERE Prestadores.cuil =?mcuit and (fecpasivap = ?mfecnul or fecpasivap > {fn curdate()} )'+;
	' and Prestadores.ID in (select codmed from medpresta where ' + ;
	"  medpresta.fecvigenh >={fn curdate()} and fecvigend<fecvigenh) " ,'MwkDatMedcuit')

If mret < 0
	Messagebox('ERROR DE CURSOR. Ingrese nuevamente',64,'VALIDACION')
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
If Reccount('MwkDatMedcuit')=0

	mret =SQLExec(mcon1,'SELECT Prestadores.*, Tabproffiltro.TPF_filtro FROM prestadores '+;
		' LEFT OUTER JOIN Tabproffiltro ON Tabproffiltro.TPF_codmed = Prestadores.ID '+;
		' WHERE Prestadores.cuil =?mcuit ' ,'MwkDatMedcuitSP')

	If mret < 0
		Messagebox('ERROR DE CURSOR. Ingrese nuevamente',64,'VALIDACION')
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif
Endif

mconaux = mcon1
If Vartype(mcon3)= "U"
	Public mcon3
	mcon3 = 0
Endif
If !Used("mwktabambito")
	Do sp_busco_tabla_id With 'tabambito', '  ','mwktabambito'
	Select mwktabambito
	Locate For Id = mxambito
Endif

Do sp_busco_estados With 126, '',"mwksuperamb"
mconaux  = mcon1
Select * From mwktabcfg Into Cursor mwktabcfgSG
Do sp_conexion_sa With "OTROAMBITO"
If mcon3>0
	mcon1 = mcon3
	mret =SQLExec(mcon1,'SELECT Prestadores.*, Tabproffiltro.TPF_filtro FROM prestadores '+;
		' LEFT OUTER JOIN Tabproffiltro ON Tabproffiltro.TPF_codmed = Prestadores.ID '+;
		' WHERE Prestadores.cuil =?mcuit and (fecpasivap = ?mfecnul or fecpasivap > {fn curdate()} )'+;
		' and Prestadores.ID in (select codmed from medpresta where ' + ;
		"  medpresta.fecvigenh >={fn curdate()} and fecvigend<fecvigenh) " ,'MwkDatMedcuitOA')

	If mret < 0
		Messagebox('ERROR DE CURSOR. Ingrese nuevamente',64,'VALIDACION')
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif
	If Reccount('MwkDatMedcuitOA')=0

		mret =SQLExec(mcon1,'SELECT Prestadores.*, Tabproffiltro.TPF_filtro FROM prestadores '+;
			' LEFT OUTER JOIN Tabproffiltro ON Tabproffiltro.TPF_codmed = Prestadores.ID '+;
			' WHERE Prestadores.cuil =?mcuit ' ,'MwkDatMedcuitOASP')

		If mret < 0
			Messagebox('ERROR DE CURSOR. Ingrese nuevamente',64,'VALIDACION')
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif
	Endif
	mcon1 = mconaux
	Select * From mwktabcfgSG Into Cursor mwktabcfgp
	Use In Select('mwktabcfg')
	Use Dbf('mwktabcfgp') In 0 Again Alias mwktabcfg
	Do sp_desconexion_sa With 'medicofamilia'


Endif

mxambito =mxambAnt 