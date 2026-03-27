mcpathact = allt(sys(5))+sys(2003)
cd "h:\datos\todos\DATOS\"
SET SAFETY OFF
cantdbf = adir(misdbfs,"*.dbf")
for uu=1 to cantdbf 
	if upper(misdbfs(uu,1)) # ".DBF"
		use (misdbfs(uu,1)) excl
		zap
		use in  (misdbfs(uu,1))
	endif
endfor
SET SAFETY ON
cd &mcpathact 