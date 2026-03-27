mret = sqlexec(mcon1, " select reg_nrohclinicaO,reg_nrohclinicaD,hca_registrac from tabhciarchivo,TabCtrlUnif "+;
					  " where hca_registrac = reg_nroregistracD ", "mwkTabHciArchivo")
if mret<1
    =aerr(eros)
    messagebox(eros(3))
endif


SELECT mwkTabHciArchivo
  SCAN
      mreg_nroregistracO  = reg_nroregistracO 
      mreg_nroregistracD  = reg_nroregistracD 
      mhca_registrac      = hca_registrac
      mret = sqlexec(mcon1," UPDATE tabhciarchivo SET hca_registrac =?mreg_nroregistracO " +;
      						" WHERE hca_registrac = ?mhca_registrac ")
		if mret<1
		    =aerr(eros)
		    messagebox(eros(3))
		endif
  ENDSCAN 
  
mret = sqlexec(mcon1, " select  reg_nrohclinicaO,reg_nrohclinicaD,hcmnrohcli,reg_nroregistracD,reg_nroregistracO " +;
					  "  from tabhcimovst,"+;
					  " TabCtrlUnif where hcmregistrac = reg_nroregistracD ","mwkHciMovst")

  
if mret<1
    =aerr(eros)
    messagebox(eros(3))
endif

SELECT mwkTabHciArchivo
  SCAN
      mreg_nrohclinicaO   = reg_nrohclinicaO 
      mrreg_nrohclinicaD  = reg_nrohclinicaD 
      mhcmnrohcli         = hcmnrohcli
      mreg_nroregistracO  = reg_nroregistracO
      mhcmregistrac       = hcmregistrac
      mret = sqlexec(mcon1," UPDATE  tabhcimovst SET hcmnrohcli =?mreg_nrohclinicaO,hcmregistrac =?mreg_nroregistracO" +;
      					   "  WHERE hcmregistrac = ?mhcmregistrac ")
		if mret<1
		    =aerr(eros)
		    messagebox(eros(3))
		endif
  ENDSCAN 
  


