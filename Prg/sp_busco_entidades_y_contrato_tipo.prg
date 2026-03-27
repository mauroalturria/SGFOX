*!*	
*!*	Busco Entidades con contrato Y por tipo
*!*	  
*!*	mtipo = "AMB"
*!*	mtipo = "INT"
*!*	mtipo = "GUA"
*!*	mtipo = "HEM"
*!*	mtipo = "" && TODOS
*!*	==============================================================================
Parameter mtipo

If Vartype(mbusco)#"C"
	mbusco= ''
Endif

mfecha= Ctod('01/01/1900')

Do Case
	Case mtipo = "AMB"
			mAuxTipo = "(tipo = ?mTipo or (tipo is Null))"
	Otherwise 
		If !Empty(mTipo)
			mAuxTipo = "(tipo = ?mTipo)"
		Else
			mAuxTipo = "1=1" && Todos
		Endif 	
Endcase

mret = SQLExec(mcon1, "select ENT_codent, ENT_descrient, " + ;
	"contrato, CON_descricont, Tipo, ENT_codagrup,ent_capita " + ;
	"from entidades, entidcontr2, contratos " + ;
	"where entidcontr2.contrato = contratos.CON_codcont and " + ;
	"CON_fecpasiva is null and ENT_fecpas is null and  " + ;
	mAuxTipo + " and " + ;
	"entidad = ENT_codent and " + ;
	"ENT_fecpas is null " + mbusco + ;
	"order by ENT_descrient " + ;
	" ", "mwkEntCont")

If mRet < 0 
	MessageBox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	Cancel 
Endif
