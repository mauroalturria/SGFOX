public mcon1
do sp_conexion
mret = sqlexec(mcon1,"SELECT count(PIA_cantsolicitada) as cantidad,  PIA_codprest ,val_codsector"+;
	" FROM Valesasist,Presinsuvas"+;
	" WHERE PIA_VALESASIST = VALESASIST"+;
	"   AND VAL_fechasolicitud >= to_date('01/08/2006','dd/mm/yyyy')"+;
	"   AND VAL_fechasolicitud < to_date('01/09/2006','dd/mm/yyyy')"+;
	"   AND PIA_codprest in( 18010407,68010330,68010331)"+;
	" group by PIA_codprest,val_codsector","cosa1")
if mret<1
	=aerr(eros)
	message(eros(3))
endif
copy to sem0607 type xls