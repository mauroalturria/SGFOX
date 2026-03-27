** Crea archivo temporal
Function sp_crea_temp(cArch)
ctemp = alltrim(sys(2023))
do case
	case type("cArch") # "C"
		carch = "&cTemp\" + substr(alltrim(sys(2015)),3,10) + ".TMP"
	case empty(carch)
		carch = "&cTemp\" + substr(alltrim(sys(2015)),3,10) + ".TMP"
	case type("cArch") = "C" and at(".",carch) = 0
		carch = "&cTemp\" + alltrim(carch) + ".TMP"
	otherwise
		carch = "&cTemp\" + alltrim(carch)
endcase
return carch
