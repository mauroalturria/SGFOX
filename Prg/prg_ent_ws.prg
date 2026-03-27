lparameters tnCodEnt

lcAlias = alias()

local lbResu
lbResu = .f.

if .t. && !sp_busco_EntWS(tnCodEnt)
	create cursor mwkEntWS (Ent_WS l(1))
endif

do case

	case reccount("mwkEntWS")>0
		lbResu = mwkEntWS.Ent_WS

	otherwise
		lbResu = inlist( tnCodEnt, 711, 100, 101, 102, 106 )
endcase
if lbResu
	if used('mwkdatos')
		select mwkdatos
		use
	endif
	do sp_busco_datos
	if mwkdatos.remitobono # 1  && NO habilitado
		messagebox("NO HAY COMUNICACION CON PADRON HOMINIS ON LINE."+chr(13)+chr(13)+;
			"SE VERIFICARAN DATOS POR MODULO DE PADRONES",48,"Falla de Conexion On line")
		lbResu = .f.
	endif
endif
use in select("mwkEntWS")

if !empty(lcAlias)
	select &lcAlias
endif

return lbResu
