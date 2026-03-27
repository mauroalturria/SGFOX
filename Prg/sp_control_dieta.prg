****
** busco dieta
****
Parameter mfecha,nserv,mbusco 
If type('mbusco')#"C"
	mbusco=''
Endif
mfecdia = sp_busco_fecha_serv('DD')
mfechanull  = "1900-01-01 00:00:00"


mret = sqlexec(mcon1, "select TabNutPaciente.*, TabNutDetalle.*" + ;
	" from TabNutPaciente inner join pacinternad on TabNutPaciente.TNP_codadmision = PIN_codadmision " + ;
	" inner join TabNutDetalle on TabNutDetalle .TND_idPaciente = TabNutPaciente.id" + ;
	" inner join TabNutPrest on TabNutPrest.TNP_codPrest= TabNutDetalle .TND_codPrest" + ;
	" where TNP_Fecha= ?mfecha  and TNP_CodServ = 0  "+ mbusco , "mwkctrldieta")
If mret<1
	=aerr(eros)
	Messagebox (eros(3))
Endif

