****
** busco los protocolos de vales no aprobados o suspendidos
****

parameter  mfechas
use in select('mwkveoinsun')
mfechades = ttod(mwkUfgua.Fecha_Uval_Gua)
fhlimite = ttod(mfechas)
mret = sqlexec(mcon1, "select VAL_OperadorCarga," + ;
	" VAL_fechasolicitud,VAL_horasolicitud,val_codvaleasist,VAL_horacargasolic, VAL_fechacargasoli "+;
	" from valesasist "+;
	" where  VAL_codservvale=5410 and  VAL_fechasolicitud >= ?mfechades and VAL_codsector ='EME' and VAL_estado <> 3 " , "mwktodoinsa1")
if mret<0
	=aerr(eros)
	messagebox(eros(3))
endif
use in select('mwkveoinsu')
select ctot(dtoc(VAL_fechacargasoli )+" "+ttoc(VAL_horacargasolic,2)) as fechahoraate, ;
	val_codvaleasist as nrovale ,"INT" as tipopac ;
	from mwktodoinsa1 where ctot(dtoc(VAL_fechacargasoli )+" "+ttoc(VAL_horacargasolic,2)) < mfechas ;
	group by val_codvaleasist into cursor mwkveoinsu
