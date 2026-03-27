*!*	sp_actualizo_TabIntBalH (tnOpcion, tnId, tnentsal, ttfechaH, tnidevol, tcobserva, tntipo, tnusuario, tnvolumen)
Parameters tnOpcion, tnId, tnentsal, ttfechaH, tnidevol, tcobserva, tntipo, tnusuario, tnvolumen,tnhora,tncoloco,lcambiocol,lcambiocan,lfechabal
IF VARTYPE(lfechabal) #"D"
	lfechabal = ttod(ttfechaH)-iif(hour(ttfechaH)<7,1,0)
endif

Do Case
	Case tnOpcion = 1
		lcSql = "Insert into TabIntBalH " + ;
			" (BHI_entsal, BHI_fechaH, BHI_idevol, BHI_observa, BHI_tipo, BHI_usuario, BHI_volumen,BHI_hora,BHI_volColocado,BHI_fechaBal ) " + ;
			" Values " + ;
			" (?tnentsal, ?ttfechaH, ?tnidevol, ?tcobserva, ?tntipo, ?tnusuario, ?tnvolumen,?tnhora,?tncoloco,?lfechabal ) "

	Case tnOpcion = 2

		lcSql = "Update TabIntBalH " + ;
			" Set BHI_entsal = ?tnentsal, BHI_fechaH = ?ttfechaH, BHI_idevol = ?tnidevol,BHI_hora= ?tnhora, BHI_observa = ?tcobserva, " + ;
			"BHI_tipo = ?tntipo, BHI_usuario = ?tnusuario, BHI_volumen = ?tnvolumen,BHI_volColocado = ?tncoloco " + ;
			"Where id = ?tnId " 
	Case tnOpcion = 3

		lcSql = "Update TabIntBalH " + ;
			" Set BHI_fecBaja = ?ttfechaH,BHI_usuBaja = ?tnusuario, BHI_reprocesado = 1 " + ;
			" Where id = ?tnId " 

	Otherwise

Endcase

if !Prg_EjecutoSql(lcSql,'',.f.)
	Return .f.
Endif 

