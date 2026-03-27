*
* Busqueda de vales de Pacientes Ambulatorios
*
Lparameters mnreg,  midmedico,mncodprest, mcCursor,mdesde,mcursor,mcodserv
If Vartype(midmedico)<>"N"
	midmedico= 0
Endif
If Vartype(mcursor)<>"C"
	mcursor = "mwkvaleambu"
Endif
If Vartype(mcodserv)<>"N"
	mcodserv = 0
Endif
If Vartype(mdesde ) # "D"
	mdesde = sp_busco_fecha_serv("DD")
Endif
If midmedico=0 And mcodserv = 0 AND mnreg = 0
	Return
Endif
mbusamb = ''
If Val(Transform(mnreg))>0
	mbusamb = ' and nroregistrac =?mnreg '
Endif
If midmedico>0
	mbusamb = mbusamb + " and codmed ="+Transf(midmedico)
Endif
If mcodserv >0
	mbusamb = mbusamb + " and pre_codservicio  = "+Transf(mcodserv )
Endif
If Val(Transform(mncodprest)) > 0
	mbusamb =  mbusamb +  ' and  codprest = ?mncodprest '
Endif

If Vartype(mcCursor)# "C"
	mcCursor = "mwkvaleambu"
Endif
mret = SQLExec(mcon1,"select TabAmbulatorio.* "+;
	" from TabAmbulatorio inner join prestacions on codprest = pre_codprest"+;
	" where fechaate  = ?mdesde  " +mbusamb ,mcursor)
If mret < 0
	Messagebox("EN BUSQUEDA DE vales AMBULATORIOS " + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

