*
* Busco Médicos tipo Ambulatorios
*
Lparameters mbproto

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif 

mret = Sqlexec(mcon1,"Select Prestadores.nombre,Prestadores.id" +;
		" From Prestadores" +;
		" Join TabAmbulatorio on TabAmbulatorio.protocolo = ?mbproto " +;
		" and TabAmbulatorio.codmed = Prestadores.Id" + mccpoamb + ;
		" group by Prestadores.nombre,Prestadores.id" +;
		" order by Prestadores.nombre","mwkmedicoprot")

If mret < 0
	Messagebox("EN CONSULTA DE PROFESIONALES, AREA AMBULATORIOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
