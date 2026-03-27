****
* Solicitud de Cambio de Cama
*****
Parameters msec,mobserva,mimot
If Vartype(mimot)#"N"
	mimot=66
Endif
If myip='172.16.1.7'
	Set Step On
Endif
mdtF    = sp_busco_fecha_serv('DT')
mfecnul = Ctod("01/01/1900")

musu = Iif(Used('mwkusuarios'),mwkusuarios.idusuario,mwkusuario.idusuario)

midusu = Iif(Used('mwkusuarios'),mwkusuarios.codigovax,mwkusuario.codigovax)
If Used('mwkpacint1')
	Select mwkpacint1
	mpac 	= pac_nombrepaciente
	madmis	= pac_codadmision
	ment 	= ENT_codent
Else
	Select mwkveoproto
	mpac 	= reg_nombrepac
	madmis	= mwkveoproto.reg_nrohclinica
	ment 	= mwkafient.ENT_codent
Endif
mmot	= mimot &&66 cambio de cama

mret=SQLExec(mcon1,"SELECT HoraLLegada, HoraFinalizacion,idmotivo  FROM SOCIOaux where id = 1","mwksocaux")
*If !(Between(mdtF,mwksocaux.HoraLLegada ,mwksocaux.HoraFinalizacion ) And mwksocaux.idmotivo = 1)
 Do sp_busco_estados With 57,' and tipo = 20 and subestado = '+Transform(mxcentromedico),'mwkHabSQL'&&
	If mwkHabSQL.estado = 2
		Do sp_grabo_mesaentsql   With mpac ,mmot,mobserva,ment,madmis
	Else
		Do sp_grabo_mesaent  With mpac ,mmot,mobserva,ment,madmis
	Endif
*Endif
Do sp_grabo_mesaentaux  With mpac ,mmot,mobserva,ment,madmis

If mimot = 66
	Messagebox('SE GRABO EL PEDIDO DE CAMBIO CORRECTAMENTE', 64,'Validacion')
Else
	Messagebox('SE GRABO LA SOLICITUD CORRECTAMENTE', 64,'Validacion')
Endif
