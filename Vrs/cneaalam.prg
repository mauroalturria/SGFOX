SELECT tab_nut_eti
SCAN
miadm = pac_codadmision
miobs = tne_adaptacion
SELECT tab_nut
upDATE tab_nut SET tnp_codfact = miobs,tnp_observaciones = '' WHERE pac_codadmision=miadm 
 
SELECT tab_nut_eti


ENDSCAN
