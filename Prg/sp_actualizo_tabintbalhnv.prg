parameters tnOpcion, tnId, tnentsal, ttfechaH, tnidevol, tcobserva, tntipo, tnusuario, tnvolumen,tnhora,tncoloco,lcambiocol,lcambiocan,lfechabal
if vartype(lfechabal) #"D"
	lfechabal = ttod(ttfechaH)-iif(hour(ttfechaH)<7,1,0)
endif

camposcolI 	= ''
valorcolI	= ''
updtcolo 	= ''
if lcambiocol
	camposcolI 	= ',BHI_fechahC, BHI_horaC,BHI_usuarioC '
	valorcolI	= ',?ttfechaH, ?tnhora, ?tnusuario '
	updtcolo = ',BHI_fechahC = ?ttfechaH, BHI_horaC = ?tnhora,BHI_usuarioC = ?tnusuario '
endif
campospasoI	= ''
valorpasoI	= ''
updtpaso	= ''
if lcambiocan
	campospasoI 	= ',BHI_fechah, BHI_hora,BHI_usuario '
	valorpasoI	= ',?ttfechaH, ?tnhora, ?tnusuario '
	updtpaso	= ',BHI_fechah = ?ttfechaH, BHI_hora = ?tnhora,BHI_usuario = ?tnusuario '
endif
do case
	case tnOpcion = 1
		lcSql = "Insert into TabIntBalH " + ;
			" (BHI_entsal,  BHI_idevol, BHI_observa, BHI_tipo, BHI_volumen,BHI_volColocado,BHI_fechaBal  " + ;
			" &camposcolI &campospasoI )"+;
			" Values " + ;
			" (?tnentsal, ?tnidevol, ?tcobserva, ?tntipo, ?tnvolumen,?tncoloco,?lfechabal &valorcolI &valorpasoI) "

	case tnOpcion = 2

		lcSql = "Update TabIntBalH " + ;
			" Set BHI_observa = ?tcobserva,BHI_volumen = ?tnvolumen,BHI_volColocado = ?tncoloco " + updtcolo + updtpaso +;
			"Where id = ?tnId "
	case tnOpcion = 3

		lcSql = "Update TabIntBalH " + ;
			" Set BHI_fecBaja = ?ttfechaH,BHI_usuBaja = ?tnusuario, BHI_reprocesado = 1 " + ;
			" Where id = ?tnId "
	otherwise

endcase

if !Prg_EjecutoSql(lcSql,'',.f.)
	return .f.
endif
