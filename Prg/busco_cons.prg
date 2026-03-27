do sp_conexion
mfecdes = ctod("01/01/2007")
mfechas = ctod("01/02/2007")
select padronsanjuan
go top
scan
	ndoc= documento
	mcons = 0
	mret=sqlexec(mcon1,"SELECT REG_nroregistrac, REG_nombrepac,REG_nrohclinica"+;
		" FROM Registracio WHERE REG_numdocumento = ?ndoc","mwkauxi")
	mregistracio = REG_nroregistrac
	if mregistracio >0
		mret = sqlexec(mcon1, "select VAL_fechasolicitud ,VAL_codservvale , VAL_tipopaciente " + ;
			",PIA_codprest, PIA_cantsolicitada,val_codadmision,VAL_codvaleasist "+; 
			"from histambgua, pacientes, valesasist,presinsuvas " + ;
			"where his_nroregistrac = ?mregistracio  and " + ;
			"his_codadmision = PAC_codadmision and VAL_codsector ='AMB' and " + ;
			"PAC_codadmision = VAL_codadmision and " + ;
			"VAL_fechasolicitud <?mfechas and "+;
			"VAL_fechasolicitud >=?mfecdes "+;
			"and PIA_VALESASIST = VALESASIST  " , "mwkconsAmb")
DOCUMENTO                                                                                                                       
VAL_FECHAS                                                                                                                      
VAL_CODSER                                                                                                                      
VAL_TIPOPA                                                                                                                      
PIA_CODPRE                                                                                                                      
PIA_CANTSO                                                                                                                      
VAL_CODADM                                                                                                                      
VAL_CODVAL                                                                                
		mret = sqlexec(mcon1, "select VAL_fechasolicitud ,VAL_codservvale , VAL_tipopaciente " + ;
			",PIA_codprest, PIA_cantsolicitada,val_codadmision,VAL_codvaleasist "+; 
			"where his_nroregistrac = ?mregistracio  and " + ;
			"his_codadmision = PAC_codadmision and VAL_codsector ='GUA'  and " + ;
			"PAC_codadmision = VAL_codadmision and " + ;
			"VAL_fechasolicitud <?mfechas and "+;
			"VAL_fechasolicitud >=?mfecdes "+;
			"and PIA_VALESASIST = VALESASIST " , "mwkconsgua")

		mret = sqlexec(mcon1, "select PAC_codhci " + ;
			"from pacientes " + ;
			"where " + ;
			" ?mfechas >= PAC_fechaadmision and " +;
			" ?mfecdes <= PAC_fechaalta and " +;
				" PAC_codhci = ?mregistracio " , "mwkconsINT")
		if reccount("mwkconsAmb")>0
			mcons = mcons  + 100
		endif
		if reccount("mwkconsgua")>0
			mcons = mcons  + 10
		endif

		if reccount("mwkconsINT")>0
			mcons = mcons +1
		endif
	else 
		mcons = mcons +3
	endif
	select padronsanjuan
	replace qcons with mcons
endscan
go top
do sp_desconexion
**			
