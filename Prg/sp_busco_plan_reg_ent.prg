****
** busco Planes por entidad
****

Parameter mbusreg,mient

mfecpas = Ctod("01/01/1900")
mret = SQLExec(mcon1,"select ID , descripcion,Abreviatura, AbreviaEnt, CodEntAg,PlanCoseg "+;
	" from Planes where FecPasivaPlan = ?mfecpas and CodEntAg =?mient "  , "mwkplant")

mret = SQLExec(mcon1,"select AFI_nroafiliado, AFI_idplan "+;
	" from AFILIACION where AFI_codentidad = ?mient and REGISTRACIO = ?mbusreg ","mwknroafiplan")
If mret<1
	=Aerr(eros)
*	messagebox(eros(3))
Endif
miplan =  Nvl(mwknroafiplan.AFI_idplan ,0)
Select mwkplant
Locate For id = miplan
If Found()
	Return Padr(Nvl(descripcion,'') ,40)
Else
	Return Space(40)
Endif

