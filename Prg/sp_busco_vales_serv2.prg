
Parameters mfecdes, mbus, mfecfull

If len(mbus)>1
	mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, " + ;
		"VAL_URGENCIASERV,VAL_codadmision,val_codsector,VAL_codservvale,VAL_prestador, VAL_tipopaciente, VAL_nroprotocolo, "+;
        "VAL_cama, VAL_habitacion "+;
		"from valesasist " + ;
		"where VAL_codservvale in "+mbus+" and VAL_fechasolicitud >= ?mfecdes","mwkvalesfar0") 
		
		* +;
		*" and val_codsector<>'GUA' and val_codsector<>'AMB' ", "mwkvalesfar0")
Else
	mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, " + ;
		"VAL_URGENCIASERV,VAL_codadmision,val_codsector,VAL_codservvale,VAL_prestador, VAL_tipopaciente, VAL_nroprotocolo, "+;
        "VAL_cama, VAL_habitacion "+;
		"from valesasist " + ;
		"where VAL_fechasolicitud >= ?mfecdes","mwkvalesfar0")
		
		* +;
		*" and val_codsector<>'GUA' and val_codsector<>'AMB' ", "mwkvalesfar0")
Endif

If mret < 0
	=aerr(eros)
	Messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	Return
Endif

If !used('mwkpMed')
  Do sp_busco_phordatos
Endif

mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv,scv_mnemonico "+;
					  "from servicios, servcargval " + ;
					  "where ser_codserv = servcargval.scv_codservicio " + ;
				  	  "and scv_mnemonico is not null and ser_fechapasiva is null "+;
					  "order by ser_descripserv", "mwkserv")

If mret < 0
	=aerr(eros)
	Messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	Return
Endif


Select *, ctot(dtoc(VAL_fechasolicitud)+ " " +strtran(alltrim(VAL_horasolicitud),".",":")+":00") as fechahora from mwkvalesfar0 ;
	into cursor mwkcons_prev


Select mwkcons_prev.*,nombre, ser_descripserv, ser_codserv,scv_mnemonico from  mwkcons_prev;
			left join mwkpmed on val_prestador = mwkpmed.id ;
			left join mwkserv on val_codservvale = mwkserv.ser_codserv ;
			where fechahora >= mfecfull ;
			into cursor mwkconsumoss
			
select * from mwkconsumoss order by VAL_fechasolicitud desc,VAL_horasolicitud desc,VAL_tipopaciente asc;
into cursor mwkconsumoss

select mwkconsu 
zap

select mwkconsumoss
go top

scan

insert into mwkconsu ;
(esta,VAL_codadmision,VAL_tipopaciente,VAL_fechasolicitud,VAL_codvaleasist, ;
 VAL_nroprotocolo,nombre,ser_descripserv,VAL_codsector,ser_codserv, ;
 scv_mnemonico,VAL_cama,VAL_habitacion) values ;
(0,mwkconsumoss.VAL_codadmision,mwkconsumoss.VAL_tipopaciente,mwkconsumoss.VAL_fechasolicitud,mwkconsumoss.VAL_codvaleasist, ;
 iif(isnull(mwkconsumoss.VAL_nroprotocolo), space(10), str(mwkconsumoss.VAL_nroprotocolo)),;
 iif(isnull(mwkconsumoss.nombre), space(40), mwkconsumoss.nombre),;
 mwkconsumoss.ser_descripserv,mwkconsumoss.VAL_codsector,mwkconsumoss.ser_codserv, ;
 mwkconsumoss.scv_mnemonico,iif(isnull(mwkconsumoss.VAL_cama), space(3), mwkconsumoss.VAL_cama), ;
 iif(isnull(mwkconsumoss.VAL_habitacion), space(5), mwkconsumoss.VAL_habitacion))	
				
endscan				

select mwkconsu
go top

