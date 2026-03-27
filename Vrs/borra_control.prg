mcpathact = allt(sys(5))+sys(2003)
cd "h:\datos\todos\Scaneos\"

cantdbf = adir(misdbfs,"*.dbf")
for uu=1 to cantdbf 
	use (misdbfs(uu,1)) excl
	zap
	use in  (misdbfs(uu,1))
endfor

cd &mcpathact 