
do sp_busco_usuarios_all
do sp_tablas_monitor
do sp_busco_prestacion 
do sp_sectorint

ldhoy = sp_busco_fecha_serv('DD') 

do sp_busco_vales_internados with '', ldhoy, '' && mwkconsumo

Select * ;
	From mwkconsumo ;
	where  VAL_codservvale = 8900 and  ttipo = 0 and val_estado < 3 ;
	Into Cursor mwkInterCons


Select Distinct pre_especialidad, esp_descripcion ;
	From mwkInterCons ;
	Order By esp_descripcion ;
	Into Cursor mwkEspLst1

lcSep = Chr(13)
lcVal = ''

Select mwkEspLst1
Scan All
	lcVal = lcVal + Alltrim(mwkEspLst1.esp_descripcion) + lcSep 
	lcVal = lcVal + Replicate("-",50) + lcSep 

	Select mwkInterCons.* ;
		From mwkInterCons ;
		where mwkInterCons.pre_especialidad= mwkEspLst1.pre_especialidad ;
		Into Cursor mwkInterC1	

		Select mwkInterC1	
		Scan All 
		
			lcVal = lcVal + "" + lcSep 
			lcVal = lcVal + "PACIENTE: " + Alltrim(mwkInterC1.Pac_nombrePaciente) + " - ADM: " + Alltrim(mwkInterC1.val_codadmision) + lcSep 
			lcVal = lcVal + "PISO: " + Alltrim(mwkInterC1.Scamhab) + lcSep 
			lcVal = lcVal + "OBS: " + Proper(Alltrim(Nvl(mwkInterC1.VAL_observaciones,''))) + lcSep 
			lcVal = lcVal + "DIAG.ING: " + Proper(Alltrim(Nvl(mwkInterC1.PAC_descripdiagn,''))) + lcSep 
			lcVal = lcVal + "DIAG.CIE: " + Proper(Alltrim(Nvl(mwkInterC1.DiagnosticoCie,''))) + lcSep 
			
			lcVal = lcVal + "" + lcSep 
		
			Select mwkInterC1	
		Endscan 
		
		lcVal = lcVal + "" + lcSep 

	Select mwkEspLst1
Endscan 	


_cliptext = lcVal