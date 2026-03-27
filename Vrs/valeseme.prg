select ctot(dtoc(VAL_fechasolicitud)+" "+
select ctot(dtoc(VAL_fechasolicitud)+" "+strtran(VAL_horasolicitud,",",":")) as ipv_fechormodif,ii as ipv_idevol,
select ctot(dtoc(VAL_fechasolicitud)+" "+strtran(VAL_horasolicitud,",",":")) as ipv_fechormodif,ii as ipv_idevol,pia_codprest as ipv_insumo,"CFUNES" as ipv_usuariomodif,val_codvaleasit as ipv_vale
select distinct id,ih_admision from tabinthce_a where ih_secagrup = "CEG" int cursor paci
select distinct id,ih_admision from tabinthce_a where ih_secagrup = "CEG" into cursor paci
browse
select * from vales_realins,paci where val_codadmision = ih_admision int ocursor vales
select * from vales_realins,paci where val_codadmision = ih_admision into ocursor vales
select * from vales_realins,paci where val_codadmision = ih_admision into cursor vales
BROWSE LAST
select ctot(dtoc(VAL_fechasolicitud)+" "+strtran(VAL_horasolicitud,",",":")) as ipv_fechormodif,ii as ipv_idevol,pia_codprest as ipv_insumo,"CFUNES" as ipv_usuariomodif,val_codvaleasit as ipv_vale;
select distinct id,ih_admision from tabinthce_a where ih_secagrup = "CEG" int cursor paci
select ctot(dtoc(VAL_fechasolicitud)+" "+strtran(VAL_horasolicitud,",",":")) as ipv_fechormodif,ii as ipv_idevol,pia_codprest as ipv_insumo,"CFUNES" as ipv_usuariomodif,val_codvaleasit as ipv_vale;
from vales into cursor agrego
select ctot(dtoc(VAL_fechasolicitud)+" "+strtran(VAL_horasolicitud,",",":")) as ipv_fechormodif,id as ipv_idevol,pia_codprest as ipv_insumo,"CFUNES" as ipv_usuariomodif,val_codvaleasit as ipv_vale;
from vales into cursor agrego
select ctot(dtoc(VAL_fechasolicitud)+" "+strtran(VAL_horasolicitud,",",":")) as ipv_fechormodif,id as ipv_idevol,pia_codprest as ipv_insumo,"CFUNES" as ipv_usuariomodif,val_codvaleasist as ipv_vale;
from vales into cursor agrego
browse
?dtoc(VAL_fechasolicitud)+" "+strtran(VAL_horasolicitud,",",":")
?dtoc(VAL_fechasolicitud)+" "+strtran(VAL_horasolicitud,".",":")
select ctot(dtoc(VAL_fechasolicitud)+" "+strtran(VAL_horasolicitud,".",":")) as ipv_fechormodif,id as ipv_idevol,pia_codprest as ipv_insumo,"CFUNES" as ipv_usuariomodif,val_codvaleasist as ipv_vale;
from vales into cursor agrego
browse
select ctot(dtoc(VAL_fechasolicitud)+" "+strtran(VAL_horasolicitud,".",":")) as ipv_fechormodif,id as ipv_idevol,pia_codprest as ipv_idreginsumo,;
"P" as ipv_instipo,"" as ipv_movimiento,"CFUNES" as ipv_usuariomodif,val_codvaleasist as ipv_vale;
from vales into cursor agrego
select ctot(dtoc(VAL_fechasolicitud)+" "+strtran(VAL_horasolicitud,".",":")) as ipv_fechormodif,id as ipv_idevol,pia_codprest as ipv_idreginsumo,;
"P" as ipv_instipo,"Normal" as ipv_movimiento,"CFUNES" as ipv_usuariomodif,val_codvaleasist as ipv_vale;
from vales into cursor agrego
browse
append from dbf('agrego')