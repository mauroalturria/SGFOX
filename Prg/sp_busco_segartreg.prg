*---------------------------------------------------------------------------------------------------------------------------------------*
* REGISTRO ART
* mtipo  = "T"otal "P"arcial - solo activos = 01/01/1900
* mTipo2 = AMB - INT
*---------------------------------------------------------------------------------------------------------------------------------------*
Lparameters mtipo,mbusca

mwhere = ""

If mtipo <> "T"

	mwhere = " and TAR_finpro = '1900-01-01' "
Endif

Use In Select("mwkregistro")


mret = SQLExec(mcon1,"select REG_nombrepac, ENT_descrient,TAR_entidad , TabArtReg.id as lid "+;
	" ,TAR_Admision, TAR_HabCama, TAR_codart, TAR_codsg, TAR_entidad,TAR_fecmov, TAR_finpro "+;
	" ,TAR_inipro, TAR_proxate, TAR_registracio, TAR_siniestro, TAR_tipo, TAR_tipoAlta,TAR_usuario"+;
	", TAR_evolint ,ZabSegART.*  "+;
	" from TabArtReg,entidades,registracio,ZabSegART   "+;
	" where ENT_codent = TAR_entidad and REG_nroregistrac = TAR_registracio " +;
	" and SA_Nroregistrac  =  TAR_registracio and TAR_siniestro =  cast( SA_Siniestro as int) "+ mwhere +;
	" ", "mwkregistro")
 

If mret < 0
	mltabla = "REGISTRO ART"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Use In Select("mwkregistrob")


Select  REG_nombrepac,ENT_descrient,TAR_siniestro,TAR_proxate,TAR_inipro,descrip,;
	IIF(TAR_finpro=Ctod("01/01/1900"),{//},TAR_finpro) As TAR_finpro,;
	IIF(TAR_finpro=Ctod("01/01/1900"),{//},TAR_finpro) As TAR_finprorg,;
	lid, TAR_codart, TAR_evolint, TAR_evolint As TAR_evolint2, ;
	TAR_registracio,  TAR_Admision, TAR_HabCama, Nvl(TAR_TipoAlta,0) As TAR_TipoAlta,SA_Estado ;
	from mwkregistro,mwkestadoART WHERE SA_Estado= estado;
	INTO Cursor mwkregistrob
  
Use In Select("mwkregistro")
Use Dbf('mwkregistrob') In 0 Again Alias mwkregistro
Use In Select("mwkregistrob")

Return .T.
