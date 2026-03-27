*****
*  Busco la entidad de una admision
*  Marcelo Torres, 31/03/2021.
*  Se agregó el parametro nRetorno y nPrimero
*  1 = codigo, 2 = descripcion
*  1 = primero, 2 = ultimo 
*  tiene que venir lenti <> "U"
******
Parameters mcodigo,lenti,nRetorno,nPrimero

Local mretorno

nRetorno = Iif(Vartype(nRetorno) <> "N", 1,nRetorno)
nPrimero = Iif(Vartype(nPrimero) <> "N",1,nPrimero)

IF nRetorno = 1
   mRetorno = 0
ELSE
   mRetorno = ""
ENDIF 

If Used('mwkpacCob')
	Use In mwkpacCob
Endif
If Vartype(lenti)="U"
	mret=SQLExec(mcon1,"select COB_codentidad "+;
		"from coberturas where  COB_pacientes  = ?mcodigo","mwkpacCob")
Else
	mret=SQLExec(mcon1,"select COB_codentidad,ENT_descrient,ENT_nroprestadorexterno "+;
		" from coberturas inner join entidades on COB_codentidad = ent_codent "+;
		" where  COB_pacientes  = ?mcodigo","mwkpacCob")
Endif
If mret < 0
	Messagebox("ERROR EN BUSQUEDA DEL NOMBRE DEL PACIENTE",48,"Validacion")
	mRetorno = 0
Else

	If Reccount('mwkpacCob')>0
	
		Select mwkpacCob
		
		If nPrimero = 1
			Go Top
		Else
			Go Bottom
		Endif

		If nRetorno = 1
			mretorno = mwkpacCob.COB_codentidad
		Else
			mretorno = mwkpacCob.Ent_Descrient
		Endif

	Endif

ENDIF

Return mretorno

