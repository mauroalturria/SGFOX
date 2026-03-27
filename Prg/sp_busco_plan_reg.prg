****
** busco Planes por entidad
****

Parameter mbusca

If !Used('mwkplant')
	mfecpas = Ctod("01/01/1900")
	mret = SQLExec(mcon1,"select ID , descripcion,Abreviatura, AbreviaEnt, CodEntAg,PlanCoseg "+;
		" from Planes where FecPasivaPlan = ?mfecpas "  , "mwkallplan")
	Select Val(Alltrim(Abreviatura)) As idplan,* From mwkallplan Into Cursor mwkplant
Endif
mret = SQLExec(mcon1,"select reg_distrito "+;
	" from registracio    where reg_nroregistrac = ?mbusca "   , "mwkTplan")
If mret<1
	=Aerr(eros)
*	messagebox(eros(3))
Endif
miplan = Val(Nvl(mwkTplan.reg_distrito,''))
SELECT mwkplant
LOCATE FOR idplan= miplan
If FOUND()
	Return Padr(Nvl(descripcion,'') ,40)
Else
	Return Space(40)
Endif

