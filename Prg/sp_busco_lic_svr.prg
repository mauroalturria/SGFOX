Text To lcsql Textmerge Noshow Pretext 7
	select GetDate() as fh, * from LicenciasCache
Endtext 

If !Prg_EjecutoSql(lcSql,"mwkLicSVR")
	Return .f.
Endif  

