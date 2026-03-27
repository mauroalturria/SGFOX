*sp_busco_bonos_rec

parameters vr_fecha, vr_fecha1

mret=sqlexec(mcon1,'SELECT * FROM tabbonorec WHERE fecha between ?vr_fecha and ?vr_fecha1 ' +;
				   'ORDER BY Bonoserie, nrodesde, Nrohasta','MWKBonRec')

if mret <0
	messagebox('ERROR DE VALIDACION, AVISAR A SISTEMAS',64,'VALIDACION')
	mret=0
	cancel
endif