Lparameters lcProtocolo, lcBusco,lnregistra

If Vartype(lcBusco)#"C"
	lcBusco = ""
Endif 
if !used('mwkserv')
	do sp_servicio with 4
endif
If Vartype(lcProtocolo)#"C"
	mBusco = " Apv_Registracio = ?lnregistra "
ELSE
	mBusco = " APV_Protocolo = ?lcProtocolo "
ENDIF
do sp_busco_estados with 26 , " order by descrip  ","Servicios"

mbusco = mbusco + lcBusco 
mRet = Sqlexec(mcon1,"select TabAutPrevias.*, " + ;
	" tabestados.descrip as descest, tabestados.estado as estadoori, " + ;
	" tabbacteriotipomuestra.ID as IdTipoMuestra, tabbacteriotipomuestra.BAC_codigomuestra,"+;
	" tabbacteriotipomuestra.BAC_descripmuestra,Tabambulatorio.centromedico " +;
	" from TabAutPrevias " + ;
	" Inner join tabestados on (tabestados.subestado = TabAutPrevias.APV_Estado and tabestados.propietario = 28) " + ;
	" left join tabbacteriotipomuestra on TabAutPrevias.APV_codmuestra = tabbacteriotipomuestra.id " +;
	" left join Tabambulatorio on TabAutPrevias.APV_protocolo  = Tabambulatorio.protocolo " +;
	" Where " + mbusco , "mwkpacac")
	
If mRet <= 0
	Messagebox("ERROR DE LECTURA DE AUTORIZACIONES ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 	
select mwkpacac.*,Servicios.descrip as SER_descriprubro,ser_descripserv from mwkpacac;
	left join mwkserv on ser_codserv= APV_servicio ;
	left join Servicios on subestado = APV_servicio ;
	group by mwkpacac.id into  cursor mwkAutPrevias
