Parameters tcUrl 

IF EMPTY(tcUrl)  && Marcelo Torres. Para permitir usar Plexus
   RETURN .t.
ENDIF 

If !prg_veo_url(tcUrl)
	Return .f.
Endif 