** -RLV 10/3/2016:56317,57398
mid  =          57398
mnid =          56317
** -RLV 10/3/2016:
*mid  = 31100
*mnid = 31019
*
** -RLV 10/3/2016:
*mid  = 31041
*mnid = 30984
set step on
*!*	mid =           26182
*!*	mnid =      25186
vid = mid
id =mid
requery('tabintevolnurse')
messagebox("tabintevolnurse: " + transform(reccount('tabintevolnurse')))
update tabintevolnurse set ein_idevol =  mnid 
set step on
vid =mid
id =mid
requery('tabintcuipac')
messagebox("tabintcuipac: " + transform(reccount('tabintcuipac')))
update tabintcuipac set einn_idevol =  mnid
vid =mid
id =mid
requery('tabintcuic')
messagebox("tabintcuic: " + transform(reccount('tabintcuic')))
update tabintcuic set eicp_idevol =  mnid

vid =mid
id =mid
requery('tabintobsenf')
messagebox("tabintobsenf: " + transform(reccount('tabintobsenf')))
update tabintobsenf set obs_idevol =  mnid
vid =mid
id =mid
requery('tabintcuiisn')
messagebox("tabintcuiisn: " + transform(reccount('tabintcuiisn')))
update tabintcuiisn set ici_idevol =  mnid
vid =mid
id =mid
requery('tabintcsv')
messagebox("tabintcsv: " + transform(reccount('tabintcsv')))
update tabintcsv set esv_idevol = mnid 
vid =mid
id =mid
requery('tabintbalh')
messagebox("tabintbalh: " + transform(reccount('tabintbalh')))
update tabintbalh set bhi_idevol =    mnid 
vid =mid
id =mid
requery('tabintscornur')
messagebox("tabintscornur: " + transform(reccount('tabintscornur')))
update tabintscornur set eis_idevol =  mnid

vid =mid
id =mid
requery('tabintevolmed')
messagebox("tabintevolmed: " + transform(reccount('tabintevolmed')))
update tabintevolmed set eim_idevol =  mnid
* medicacion
vid =mid
id =mid
requery('tabintplplan')
messagebox("tabintplplan: " + transform(reccount('tabintplplan')))
*delete all
requery('tabintpmsol')
messagebox("tabintpmsol: " + transform(reccount('tabintpmsol')))
*delete all
vid =mid
id =mid
requery('tabintpmagre')
messagebox("tabintpmagre: " + transform(reccount('tabintpmagre')))
*delete all
vid =mid
id =mid
requery('tabintinicia')
messagebox("tabintinicia: " + transform(reccount('tabintinicia')))
update tabintinicia set pss_idevol =  mnid

** log
vid =mid
id =mid
requery('tabintplplanlg')
messagebox("tabintplplanlg: " + transform(reccount('tabintplplanlg')))
*delete all
vid =mid
id =mid
requery('tabintpmsollg')
messagebox("tabintpmsollg: " + transform(reccount('tabintpmsollg')))
*delete all
vid =mid
id =mid
requery('tabintpmagrelg')
messagebox("tabintpmagrelg: " + transform(reccount('tabintpmagrelg')))
*delete all

vid =mid
id =mid
requery('tabintscore')
messagebox("tabintevolnurse: " + transform(reccount('tabintscore')))
update tabintscore set eis_idevol =  mnid
vid =mid
id =mid
requery('tabintvale')
messagebox("tabintvale: " + transform(reccount('tabintvale')))
update tabintvale set ipv_idevol =  mnid
vid =mid
id =mid
requery('tabintnut')
messagebox("tabintnut: " + transform(reccount('tabintnut')))
*delete all
vid =mid
id =mid
requery('tabintavn')
messagebox("tabintavn: " + transform(reccount('tabintavn')))
update tabintavn set avn_idevol =  mnid
vid =mid
id =mid
*!*	requery('tabintanamk')
*!*	messagebox("tabintanamk: " + transform(reccount('tabintanamk')))
*!*	update tabintanamk set iak_idevol =  mnid
vid =mid
id =mid
requery('tabintevolk')
messagebox("tabintevolk: " + transform(reccount('tabintevolk')))
update tabintevolk set eik_idevol =  mnid
vid =mid
id =mid
requery('tabintakm')
messagebox("tabintakm: " + transform(reccount('tabintakm')))
update tabintakm set kme_idevol =  mnid
vid =mid
id =mid
requery('tabintakr')
messagebox("tabintakr: " + transform(reccount('tabintakr')))
update tabintakr set kre_idevol =  mnid
vid =mid
id =mid
requery('tabintpararm')
messagebox("tabintpararm: " + transform(reccount('tabintpararm')))
update tabintpararm set arm_idevol =  mnid

