*********
* Busco Materiales para Cirugia
*********
Lparameters midq,midap,midta,mnreg,mfeccx,mfeccxhasta,mcursor   &&& id de quirofano, id de Autprevias, id de TabAutprevias
If Vartype(mcursor)<>"C"
	mcursor = 'mwkquiroMate'
Endif
If Vartype(mnreg)<>"N"
	mnreg=0
Endif
If Vartype(midap)<>"N"
	midap=0
Endif
If Vartype(midta)<>"N"
	midta=0
Endif
If Vartype(midq)<>"N"
	midq=0
Endif
mret = SQLExec(mcon1, "select top 1 * from  Tabquiromaterial ",mcursor )
Select &mcursor
If  Empty(Field('qm_accionesfc',mcursor ))
	Select * From &mcursor  Where 1=2 Into Cursor &mcursor
	Return
Else
	If !Used("mwkusuariosall")
		Do sp_busco_usuarios_all With ,sp_busco_fecha_serv("DD")-100
	Endif
	Select * From &mcursor  Where 1=2 Into Cursor &mcursor
	mbusca = " "
	If midq>0
		mbusca = mbusca  + ' and ( QM_idquiro = ?midq'
	Endif
	If midap>0
		mbusca = mbusca  + Iif(Empty(mbusca ),' and ( ',' or ')+' QM_idAutprevias= ?midap '
	Endif
	If midta   >0
		mbusca = mbusca  +Iif(Empty(mbusca ),' and ( ',' or ')+'  QM_idTabautprevias= ?midta   '
	Endif
	If Vartype(mfeccxhasta)="D"
		mbusfec = " and QM_fechaCX >= ?mfeccx) "
	Else
		mbusfec = " and QM_fechaCX = ?mfeccx) "
	Endif
	If mnreg >0
		mbusca = mbusca  +Iif(Empty(mbusca ),' and ( ',' or ')+'  (QM_Nroregistrac =?mnreg '+mbusfec
	Endif
	If Empty(mbusca)
		Return
	Else
		mbusca = mbusca  +')'
		mret = SQLExec(mcon1,"SELECT TabQuiroMaterial.*"+;
			",Tabautprevias.APV_CodMedicoSolic as codmedamb,Autprevias.APV_OperSolicitud  as codigovaxmed,Tabquirofano.Cirujano "+;
			", Autprevias.APV_Diagnostico as diagnoint, Tabautprevias.APV_Diagnostico as diagnoamb, Tabquirofano.Diagnostico as diagno"+;
			", Autprevias.APV_fechasolicitud as fechasolint, Tabautprevias.APV_fechasolicitud as fechasolamb "+;
			" from TabQuiroMaterial "+;
			" LEFT OUTER JOIN SQLUser.TabQuirofano Tabquirofano "+;
			"   ON  Tabquiromaterial.QM_idquiro = Tabquirofano.ID "+;
			" LEFT OUTER JOIN SQLUser.TabAutPrevias Tabautprevias "+;
			" 	ON  Tabquiromaterial.QM_idTabautprevias = Tabautprevias.ID "+;
			" LEFT OUTER JOIN SQLUser.AutPrevias Autprevias  "+;
			"   ON  Tabquiromaterial.QM_idAutprevias = Autprevias.ID "+;
			" where  QM_fecpasiva = '1900-01-01' " +mbusca +;
			"   " , 'mwkQMPrev')
		If mret < 1
			=Aerr(eros)
			Messagebox(eros(3)+'AVISE A SISTEMAS', 64,'Validacion')
		Endif
		Select mwkQMPrev.*,mwkmedtodos.nombre,mwkusuariosall.nomape  From  mwkQMPrev;
			left Join mwkmedtodos On codmedamb = mwkmedtodos.Id;
			left Join mwkusuariosall On codigovaxmed = mwkusuariosall.codigovax;
			into Cursor mwkQMlisto
		Select Padr(Nvl(nombre,'')+ Nvl(nomape,'')+ Nvl(Cirujano ,''),40) As nombremed,* From mwkQMlisto Into Cursor &mcursor
	Endif
Endif
