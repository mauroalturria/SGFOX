*
* Busqueda de Registro informe Control de Entrega a Facturación
*
Lparameters mfiltro,mfiltro1,mfiltro2

If !used('mwkprestadores')
	mret = sqlexec(mcon1,"select id as idprest,nombre from prestadores", "mwkprestadores" )
	If mret < 0
		Messagebox("EN MAESTRO DE PRESTADORES",16,"ERROR")
		Return
	Endif
Endif

If used('mwkInformes')
	Use in mwkInformes
Endif

mjoin = iif(len(mfiltro2)>0," join ENTIDADES on ENT_codent = Histambgua.HIS_codentidad and ENT_codent in "+mfiltro2,;
	" join ENTIDADES on ENT_codent = Histambgua.HIS_codentidad")

mret = sqlexec(mcon1,"select Pacientes.PAC_nombrepaciente,Pacientes.PAC_codhci,val_codadmision,"+;
	"val_nroprotocolo,VAL_codvaleasist,"+;
	"val_prestador,val_codservvale,VAL_tipopaciente,val_fechasolicitud,ser_descripserv,"+;
	"TabValObs.TVO_Obser as tpobserva,"+;
	"TabValObs.TVO_SubEstado as tpestado,"+;
	"val_codpun,Histambgua.HIS_codentidad,ENT_descrient,ENT_nroprestadorexterno,ENT_fecpas"+;
	" from TabValObs"+;
	" join Tabestados on  Tabestados.Id = TabValObs.TVO_subestado and Tabestados.propietario = 11 and"+;
	" Tabestados.tipo = 2 and Tabestados.subestado = 1"+;
	" join Valesasist on Val_codpun = TabValObs.TVO_codpun " + mfiltro + mfiltro1 +;
	" join servicios on ser_codserv = valesasist.val_codservvale"+;
	" join Pacientes on Pacientes.PAC_codadmision = Valesasist.VAL_codadmision"+;
	" join Histambgua on Histambgua.HIS_codadmision = Pacientes.PAC_codadmision and"+;
	" Histambgua.HIS_nroregistrac = Pacientes.PAC_codhci" + mjoin,"mwkInformes")

If mret < 0
	Messagebox("EN CONSULTA DE REGISTROS c/ENTREGA A FACTURACION"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
