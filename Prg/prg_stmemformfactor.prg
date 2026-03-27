Lparameters lnFormFactor
*-------------------------------------------------
Local lcResu
Store "" To lcResu

Do Case && lnFormFactor
	Case lnFormFactor = 0 
		lcResu = "Unknown"
	Case lnFormFactor = 1
		lcResu = "Other"
 	Case lnFormFactor = 2
 		lcResu = "SIP"
 	Case lnFormFactor = 3
 		lcResu = "DIP"
 	Case lnFormFactor = 4
 		lcResu = "ZIP"
 	Case lnFormFactor = 5
 		lcResu = "SOJ"
 	Case lnFormFactor = 6
 		lcResu = "Proprietary"
 	Case lnFormFactor = 7
 		lcResu = "SIMM"
 	Case lnFormFactor = 8
 		lcResu = "DIMM"
 	Case lnFormFactor = 9
 		lcResu = "TSOP"
 	Case lnFormFactor = 10
 		lcResu = "PGA"
 	Case lnFormFactor = 11
 		lcResu = "RIMM"
 	Case lnFormFactor = 12
 		lcResu = "SODIMM"
 	Case lnFormFactor = 13
 		lcResu = "SRIMM"
 	Case lnFormFactor = 14
 		lcResu = "SMD"
 	Case lnFormFactor = 15
 		lcResu = "SSMP"
 	Case lnFormFactor = 16
 		lcResu = "QFP"
 	Case lnFormFactor = 17
 		lcResu = "TQFP"
 	Case lnFormFactor = 18
 		lcResu = "SOIC"
 	Case lnFormFactor = 19
 		lcResu = "LCC"
 	Case lnFormFactor = 20
 		lcResu = "PLCC"
 	Case lnFormFactor = 21
 		lcResu = "BGA"
 	Case lnFormFactor = 22
 		lcResu = "FPBGA"
 	Case lnFormFactor = 23
 		lcResu = "LGA"
 	Otherwise 
 		lcResu = "NUEVO"
Endcase 		

Return lcResu
