lcOS = OS(1)
Do CASE
Case "6.00" $ lcOS
	Do CASE
	Case OS(5) = "6000"
		lcPlatform = "VISTA"
	Case OS(5) = "6001"
		Do CASE
		Case OS(11) = 1
			lcPlatform = "VistaSP1"
		Case INLIST(OS(11),2,3)
			lcPlatform = "Win2008"
		Otherwise
			lcPlatform = "(Unknown)"
		Endcase
	Otherwise
		lcPlatform = "(Unknown)"
	Endcase
Case "5.02" $ lcOS
	lcPlatform = "WIN2003"
Case "5.01" $ lcOS
	lcPlatform = "WINXP"
Case "5.0" $ lcOS
	lcPlatform = "WIN2000"
Case "NT" $ lcOS
	lcPlatform = "WINNT"
Case "4.0" $ lcOS OR "3.9" $ lcOS
	lcPlatform = "WIN95"
Case "4.1" $ lcOS
	lcPlatform = "WIN98"
Case "4.9" $ lcOS
	lcPlatform = "WINME"
Case "3." $ lcOS
	lcPlatform = "WIN31"
Otherwise
	lcPlatform = "(Unknown)"
Endcase
Return lcPlatform
