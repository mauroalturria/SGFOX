select iif(inlist(hab_sectores,"CEG","T09"),"INT.GRAL",chrtran(substr(sec_descripsec,at("(",sec_descripsec)+1),")","")) as sec,*;
	,padr(iif(occurs(' ',nvl(descripcion,''))>1,;
			left(nvl(descripcion,''),at(' ',nvl(descripcion,''))-1),nvl(descripcion,'')),7) as plan;
			from mwkpaccama1 	where !inlist(hab_sectores,"T11","T13");			
	and at("Y",PAC_nombrepaciente)= 0 and at("X",PAC_nombrepaciente)= 0 and at("SS",PAC_nombrepaciente)= 0;
	into cursor mwkpaccama