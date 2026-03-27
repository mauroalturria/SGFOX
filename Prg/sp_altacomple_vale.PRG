Parameters tnIdAC, tnNroVale

Text To lcsql Textmerge Noshow Pretext 7
	Update AutPrevias Set APV_NroVale = ?tnNroVale Where Id = ?tnIdAC
Endtext 

If !Prg_EjecutoSql(lcSql,"mwk")
	Return .f.
Endif  