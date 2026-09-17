*
* Busqueda de vales de Pacientes Ambulatorios
*
Lparameters mnreg,  midmedico,mncodprest, mcCursor,mdesde,mcursor,mcodserv,lsoloactivo
If Vartype(midmedico)<>"N"
	midmedico= 0
Endif
If Vartype(lsoloactivo)<>"N"
	lsoloactivo= 0
Endif
If Vartype(mcursor)<>"C"
	mcursor = "mwkvaleambu"
Endif
If Vartype(mcodserv)="C"
	mbcodserv = " in ("+Alltrim(mcodserv)+") "
	mcodserv = VAL(mcodserv)
Else
	If Vartype(mcodserv)<>"N"
		mcodserv = 0
	Else
		mbcodserv = " in ("+Transform(mcodserv)+") "
	Endif

Endif

If Vartype(mdesde ) # "D"
	mdesde = sp_busco_fecha_serv("DD")
Endif
If midmedico=0 And mcodserv = 0 And mnreg = 0
	Return
Endif
mbusamb = ' and centromedico = ?mxcentromedico  '
If Val(Transform(mnreg))>0
	mbusamb = mbusamb + ' and nroregistrac =?mnreg '
Endif
If midmedico>0
	mbusamb = mbusamb + " and codmed ="+Transf(midmedico)
Endif
If mcodserv >0
	mbusamb = mbusamb + " and pre_codservicio  "+mbcodserv 
Endif
If Val(Transform(mncodprest)) > 0
	mbusamb =  mbusamb +  ' and  codprest = ?mncodprest '
Endif
If lsoloactivo >0
	mbusamb = mbusamb + " and demanda in (0,1) "
Endi
If Vartype(mcCursor)# "C"
	mcCursor = "mwkvaleambu"
Endif
mret = SQLExec(mcon1,"select TabAmbulatorio.*,pre_codservicio as codiserv "+;
	" from TabAmbulatorio inner join prestacions on codprest = pre_codprest"+;
	" where fechaate  = ?mdesde  " +mbusamb ,mcursor)
If mret < 0
	Messagebox("EN BUSQUEDA DE vales AMBULATORIOS " + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

