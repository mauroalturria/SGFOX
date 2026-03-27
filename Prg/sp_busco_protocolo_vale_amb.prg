*****
** Busco Protocolo - desde vales
****

Parameter mvale ,mdiagno
If Vartype(mdiagno) # "N"
	mdiagno = 0
Endif

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif

mret = SQLExec(mcon1, "select tabambulatorio.*,PRE_codservicio "+;
	" from tabambulatorio, Prestacions " + ;
	" where  nrovale = ?mvale and demanda <> 8 and "+;
	" Tabambulatorio.codprest = Prestacions.PRE_codprest " + mccpoamb , "mwkvaleproto")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
	Do sp_desconexion With "sp_busco_protocolo_vale"
	Cancel
Endif
If Reccount( "mwkvaleproto")=0
	mret = SQLExec(mcon1, "select tabambulatorio.*,PRE_codservicio "+;
		" from tabambulatorioHIS AS tabambulatorio, Prestacions " + ;
		" where  nrovale = ?mvale and demanda <> 8 and "+;
		" Tabambulatorio.codprest = Prestacions.PRE_codprest " + mccpoamb , "mwkvaleproto")

	If mret < 0
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
		Do sp_desconexion With "sp_busco_protocolo_vale"
		Cancel
	Endif
Endif

If mdiagno = 1
	Do sp_busco_protoAMB_historia With mwkvaleproto.protocolo
	mcodmed = mwkveoproto.codmed
	mdiag = mwkveoproto.codcie9
	If mcodmed<=9999
		mret = SQLExec(mcon1, 'select matriculas,nombre from prestadores where id = ?mcodmed ', 'mwkveomat')
	Else
		mret = SQLExec(mcon1, 'select matricula ,nombre from TabMedExterno where id = ?mcodmed ', 'mwkveomat1')
		Select Transf(matricula,"9999999") As matriculas ,nombre From mwkveomat1 Into Cursor mwkveomat
		Use In mwkveomat1
	Endif
	If !Used('mwkCiap2e')
		Do sp_busco_cie10
	Endif
	Select mwkCiap2e
	Locate For Id= mwkveoproto.codcie9
	If Eof()
		Select mwkCiap2eA
		Locate For Id= mwkveoproto.codcie9
	Endif

Endif

