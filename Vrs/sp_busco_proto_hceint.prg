****
** Busqueda de Protocolo
****
Parameter mbusca,mcual,mbuscog,magrup
If vartype(mcual)#"N"
	mcual = 0
Endif
If vartype(mbuscog)#"C"
	mbuscog =''
Endif
If vartype(magrup)#"C"
	magrup = 'IH_secuencia'
Endif
if mcual = 0 
	mret = SQLExec(mcon1, "select pacinternad.*,tabintevol.*"+;
		" from pacinternad "+;
		" left join TabintHCE on pin_codadmision  = tabintHCE.IH_admision " + ;
		" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
		" where pin_codadmision = ?mbusca "+;
		  mbuscog  , "mwkinterna01")
else
	mret = SQLExec(mcon1, "select pacinternad.*,tabintevol.*"+;
		" from pacinternad "+;
		" left join TabintHCE on pin_codadmision  = tabintHCE.IH_admision " + ;
		" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
		" where pin_codadmision = ?mbusca "+;
		  mbuscog  , "mwkinterna01")
endif	
If mret<1
	=aerr(eros)
	Messagebox(eros(3))
Endif
Select * from mwkinterna01 ;
	group by &magrup;
	order by EI_fechaHora desc  into cursor mwkinterna
