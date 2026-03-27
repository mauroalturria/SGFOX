*****
***** Grabo modificaciones a prestadores 
*****

parameter mid,ccampos,cvalores,amguardia,aminterna,amambula,amfaltaa,amfbajaa;
	,amfaltag,amfbajag,amfaltai,amfbajai,amfaltap,amfbajap,ambdesde,ambhasta,afechamod

musuarios =  mwkusuario.codigovax
mfechaMod = sp_busco_fecha_serv("DT")

mret = sqlexec(mcon1, "Insert into TabMedLog (codmed "+ccampos+", usuario, fechamod )"+;
	" values(?mid "+cvalores +" ,?musuarios, ?mfechaMod )")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
