select edad

set step on
scan
	mipres = int(pre_codpre)
	mdesde = pre_edadde
	mhasta = pre_edadha
	select prestacion 
	update prestacion set pre_edaddesde = mdesde , pre_edadhasta = mhasta  where pre_codprest = mipres
endscan
