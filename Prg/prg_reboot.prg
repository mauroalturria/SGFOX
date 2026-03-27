Lparameters tbSalir 

If Vartype(tbSalir) # "L"
	tbSalir = .f.
Endif 

lnTiempo = 1
lnDelay  = 1

lcRun = "!/n tsshutdn " + Alltrim(Str(lnTiempo)) + " /DELAY:" 
lcRun = lcRun + Alltrim(Str(lnDelay)) + " /reboot "
&lcRun 

If tbSalir
	Quit
Endif 	
