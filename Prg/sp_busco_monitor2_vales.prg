*!*	--------------------------------------------------------------------- 
*!*	busqueda monitor de vales no impresos
*!*	--------------------------------------------------------------------- 
parameters mcodpun, mfecdes, mbus

*!*	mfecdes  = ctot("10/08/2009")
*!*	mbus    = "( 6300, 7700 ) " 
mbusco = iif(mcodpun= 0," val_fechasolicitud >= ?mfecdes "," val_codpun > ?mcodpun ")
mdestino = zzdesti

if used("mwkvalesfar6")
	use in mwkvalesfar6
endif

mret = sqlexec(mcon1, "select val_codvaleasist, val_fechasolicitud, val_horasolicitud,"+;
	"val_codadmision, val_codsector, val_codservvale, val_cama, val_habitacion, "+;
	"val_tipopaciente, val_prestador, val_codpun, descrip, "+;
	"nvl(tipo,0) as ttipo, tvo_fechamov, tvo_subestado "+;
	"from valesasist " + ;
	"left outer join tabvalobs on tabvalobs.tvo_codpun = valesasist.val_codpun "+;
	"left outer join tabestados on tabestados.subestado = tabvalobs.tvo_subestado "+;
	"and tabestados.propietario = 32 and tabestados.estado = ?mdestino "+;
	" where " + mbusco + ;
	" and val_estado <> 3 and val_codsector not in ('GUA','AMB') and " + ;
	" val_codservvale in " + mbus +;
	" order by val_codvaleasist,tvo_subestado ","mwkvalesfar6")

if mret < 0
	=aerr(eros)
	messagebox("error " + eros(3) + " en la generacion del cursor, avisar a sistemas", 16, "validacion")
	return
endif

*!*	--------------------------------------------------------------------- 
&& los pendientes 
***mwhere = " where ttipo = 0 and (nvl(tvo_subestado,0) = 0 or nvl(tvo_subestado,0) > 19)" 
mwhere = " where ttipo = 0 " 

select val_codvaleasist, val_fechasolicitud, val_horasolicitud, ;
	val_codadmision, val_codsector, val_codservvale, val_cama, val_habitacion, ;
	val_tipopaciente, val_prestador, val_codpun, tvo_fechamov,;
	sum(iif(nvl(tvo_subestado,0)<10,nvl(tvo_subestado,0),0)) as tvo_subestado ;
	from mwkvalesfar6 ;
	where ttipo = 0 ;
	group by val_codvaleasist ;
	into cursor mwkconsu06

if used("mwkvalesfar6")
	use in mwkvalesfar6
endif 	

*!*	--------------------------------------------------------------------- 
*!* reimpresiones y fecha del movimiento p/registros vales dentro de fecha desde/hasta
if used("mwkconsu6a")
	use in mwkconsu6a
endif	

select iif(isnull(tvo_fechamov),val_fechasolicitud,tvo_fechamov) as tvo_fechamov,;
	nvl(tvo_subestado,0) as tvo_subestado, val_fechasolicitud, val_codvaleasist,;
	val_codadmision, val_codsector, val_habitacion, val_cama, VAL_horasolicitud, ;
	val_tipopaciente,;
	val_codpun, val_codservvale,"O" as OrdDup  ;
	from mwkconsu06 ;
	where tvo_subestado = 0 ;
	order by val_codvaleasist ;
	into cursor mwkconsu6

*!*		order by tvo_fechamov desc ;
	
select mwkconsu6
go top