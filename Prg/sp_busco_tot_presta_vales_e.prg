****
** busco vales de demanda espontanea
****

parameter mfecdes, mfechas, mbusco, msql_tot,mgroup
if used('mwktv')
	use in mwktv
endif

mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest " + ;
	"FROM prestacions where pre_fechapasiva is null " + ;
	"group by pre_codprest " , "mwkpresta")

*if month(mfecdes) < month(mfechas)
mfd = mfecdes
do while mfd <= mfechas
	mfp = mfd+31
	mfh = date(year(mfp),month(mfp),1)-1
	mfh = iif(mfh>mfechas,mfechas,mfh )
	wait windows ("Procesando hasta "+dtoc(mfh)) nowait

	mret = sqlexec(mcon1, "select valesasist ,VAL_tipopaciente,sum(pia_cantsolicitada) as canti, " + ;
		"pia_codprest, VAL_circuitoorigen,VAL_fechasolicitud,VAL_codservvale,val_operadorcarga  " + ;
		",pac_edad,pac_fecnacimiento "+;
		"from pacientes, valesasist " + ;
		"left join  presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist " + ;
		"where " + ;
		"PAC_codadmision = VAL_codadmision and " + ;
		"VAL_fechasolicitud >= ?mfd and " + ;
		"VAL_fechasolicitud <= ?mfh and " + ;
		" dateadd('dd',29,pac_fecnacimiento  )>VAL_fechasolicitud "+;
		mbusco  + ;
		"group by VAL_codservvale, VAL_tipopaciente " + mgroup +  ;
		"" , "mwktotval")
	if mret<0
		=aerr(eros)
		messagebox(eros(3))
		messagebox("SI ES ERROR 400 DEBE SELECCIONAR UN RANGO MENOR")
	endif

	mfd = mfh +1
	if used('mwktv')
		select * from  mwktv union select * from mwktotval  into cursor mwktv
	else
		select * from  mwktotval into cursor mwktv
	endif
enddo
wait clear
select ser_descripserv, VAL_tipopaciente,  month(VAL_fechasolicitud) as mes;
	, pia_codprest,canti as cantidad,val_operadorcarga, VAL_codservvale, ;
	nvl(VAL_circuitoorigen,'2') as VAL_circuitoorigen,pre_descriprest;
	from mwktv,mwkpresta ;
	left join  mwkserv on VAL_codservvale = ser_codserv ;
	where  pre_codprest = pia_codprest;
	order by ser_descripserv, VAL_tipopaciente ;
	into cursor mwktotvale1

if at('VAL_fechasolicitud',mgroup)>0
	mgr = strtran(mgroup,'VAL_fechasolicitud','mes')
	select ser_descripserv, VAL_tipopaciente, mes,pia_codprest, ;
		sum(cantidad) as cantid,VAL_circuitoorigen, pre_descriprest,val_operadorcarga;
		from mwktotvale1;
		group by VAL_codservvale, VAL_tipopaciente &mgr into cursor mwktotvale
else
	select ser_descripserv, VAL_tipopaciente, mes,pia_codprest, ;
		sum(cantidad) as cantid,VAL_circuitoorigen , pre_descriprest,val_operadorcarga;
		from mwktotvale1 ;
		group by VAL_codservvale, VAL_tipopaciente &mgroup into cursor mwktotvale
endif
**						"group by VAL_codservvale, pia_codprest,VAL_circuitoorigen " + ;
**       							" and pia_codprest=105  " +;

if used ('mwktv')
	use in mwktv
endif
if used ('mwktotval')
	use in mwktotval
endif
