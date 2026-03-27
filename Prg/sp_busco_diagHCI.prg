****
** Busqueda de diagnostico de internacion, datos basicos
****
Parameter mnroadm

mret = SQLExec(mcon1, "select IH_codcie ,IH_motIngreso,Tabcie10.descrip,PAC_descripdiagn  "+;
	" from pacientes ,TabintHCE "+;
	" inner join tabcie10 on Tabinthce.IH_motIngreso = Tabcie10.ID "+;
	" where pac_codadmision = ?mnroadm and  pac_codadmision = tabintHCE.IH_admision order by tabintHCE.id" , "mwkdiagin")
If mret<1
	Return("SIN DIAGNOSTICO DEFINIDO")
Else
	If Reccount("mwkdiagin")=0
		mret = SQLExec(mcon1, "select PAC_descripdiagn  "+;
			" from pacientes where pac_codadmision = ?mnroadm " , "mwkdiagin")
		midiag =  "-"+mwkdiagin.PAC_descripdiagn
		Use In Select('mwkdiagin')
		Return midiag
	Else
		Go Bott
		midiag = Nvl(Descrip,"-"+PAC_descripdiagn )
		Use In Select('mwkdiagin')
		Return midiag
	Endif
Endif
