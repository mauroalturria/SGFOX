select presu
scan
	mbusco1  = " AFI_codentidad = "+alltrim(transf(presu.entidad))+" and AFI_nroafiliado='"+alltrim(transf(presu.nroafiliado))+"' and "
	do sp_busco_por_tipynro with mbusco1
	if presu.paciente = 
endscan
