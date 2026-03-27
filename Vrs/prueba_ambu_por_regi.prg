Clear
Clear



*mReg = 3166603
*mreg = 1486563 && 4 
mreg = 2843209

?"Busco los datos de registracion"
?Sqlexec(mcon1,"Select * from Registracio where Reg_NroRegistrac = ?mreg ","mwkReg")

?"NOMBRE                  : " + mwkReg.reg_nombrepac
? "HISTORIA - CLINICA  : " + mwkReg.reg_nrohclinica

?"Busco los datos de turnos "
?Sqlexec(mcon1,"Select Cast('' as char(13)) as protocolo,* from turnos where Afiliado = ?mreg ","mwkTurnos")

?"Busco los datos de guardia "
?Sqlexec(mcon1,"Select * from Guardia where nroregistrac = ?mreg ","mwkGuardia")

?"Busco los datos de Ambulatorio"
?Sqlexec(mcon1,"Select * from TabAmbulatorio where nroregistrac = ?mreg","mwkAmbu") 

?""
?"Buscando Protocolos"

Select mwkTurnos
Scan All

	Select mwkAmbu
	Locate For mwkAmbu.NroVale = mwkTurnos.NroVale
	If Found()
		?"----------------------------------"
		?"Turno " + Str(mwkTurnos.Id)
		?"  Vale " + Str(mwkTurnos.NroVale)
		?"	  Horatur " + Ttoc(mwkturnos.horatur)
		?"	  Fechaconfirma " + Ttoc(mwkturnos.FechaConfirma)
		?"	  FechaTomado " + Ttoc(mwkturnos.FechaTomado)

		Select mwkAmbu
		Scan All For mwkAmbu.NroVale = mwkTurnos.NroVale
			? "Ambu " + Str(mwkAmbu.Id)
			?? "    fechahoraing " + ttoc(mwkAmbu.fechahoraing)
			
			If mwkturnos.FechaConfirma = mwkAmbu.fechahoraing
				?"PROTOCOLO " + mwkAmbu.Protocolo
				Select mwkTurnos
				replace protocolo With mwkAmbu.Protocolo
				
			Endif 
			
			Select mwkAmbu
		Endscan 
	Endif 
	
	Select mwkTurnos
Endscan 

Select mwkTurnos
Browse

*------------------------------------


*!*	Select mwkAmbu.Protocolo as proto_ambu, mwkTurnos.* ;
*!*	From mwkTurnos ;
*!*	Left join mwkAmbu on mwkAmbu.NroVale = mwkTurnos.NroVale 

*!*	And ;
*!*		mwkAmbu.CodPrest = mwkTurnos.CodPrest And ;
*!*		mwkTurnos.FechaConfirma = mwkAmbu.fechahoraing 
