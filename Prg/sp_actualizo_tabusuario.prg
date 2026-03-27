****
** graba en tabusuarios
****

Parameter musua, mdesc, mcodv, midus, mpass, mfecp, mabm, mid, midCodMed,mlegajo,memail,mpasscrip,mnrodocumento

mfexp = sp_busco_fecha_serv('DD') + 5
mdiasaviso= Ctod('01/01/2100')
mfecpas = Ctod('01/01/1900')
If Vartype(mpasscrip ) # "C"
	mpasscrip = ""
Endif
If Used('mwkusuarios')
	Select mwkusuarios
Else
	Select mwkusuario
Endif
Scatter Memvar
mcrip = ''
mccrip = ''
mvcrip = ''
If Vartype(m.passcrip)="C"
	mcrip = ',passcrip = ?mpasscrip '
	mccrip = ',passcrip '
	mvcrip = ',?mpasscrip '

Endif

If Vartype(mcrip) # "C"
	mccrip = ""
Endif
If Vartype(midCodMed) # "N"
	midCodMed = Null
Endif

Do Case
Case mabm = 1		&& Alta

	mfeci = sp_busco_fecha_serv('DD')

	mret = SQLExec(mcon1,"insert into tabusuario(codigovax, descrip, fecingreso, " + ;
		"fecexpira, fecpasiva, idusuario, nomape, password,diasaviso, IdCodMed,LEG_id,email,nrodocumento &mccrip  ) " + ;
		"values(?mcodv, ?mdesc, ?mfeci, " + ;
		"?mfexp, ?mfecpas, ?midus, ?musua, ?mpass,?mdiasaviso, ?midCodMed,?mlegajo,?memail,?mnrodocumento &mvcrip  )")

Case mabm = 2
	mret = SQLExec(mcon1, "update tabusuario set nomape = ?musua, descrip = ?mdesc, " + ;
		"codigovax = ?mcodv, idusuario = ?midus, password = ?mpass, " + ;
		"fecpasiva = ?mfecp, diasaviso = ?mdiasaviso, IdCodMed = ?midCodMed ,leg_id = ?mlegajo,email  = ?memail,nrodocumento= ?mnrodocumento &mcrip  where id = ?mid")

Case mabm = 3 &&& baja
	mret = SQLExec(mcon1, "update tabusuario set fecpasiva = ?mfecp"+;
		" where codigovax = ?mcodv")

Endcase

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
