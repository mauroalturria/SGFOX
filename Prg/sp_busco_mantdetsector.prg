*
* Busco sector x usuario
*
Parameters mCodigoVax,lmante

if vartype(lmante)="U"
	lmante = .f.
endif
If used('mwkEstxSector')
	Use in mwkEstxSector
Endif
if !lmante
	mret = sqlexec(mcon1, "select CodigoVax,codsector "+;
		"from TabMantDetSector where CodigoVax = ?mCodigoVax ", "mwkEstxSector")
	If mret < 0
		Messagebox("EN CONSULTA DE SECTORES - MANTENIMIENTO"+chr(10)+"AVISE A SISTEMAS", 16, "ERROR")
	Endif
else
	select mCodigoVax as CodigoVax, codigo as codsector  from mwksectores into cursor mwkEstxSector
endif
