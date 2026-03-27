*
* Auditoria de Internación, estadisticos
*
Lparameters mfdesde,mwbusca

If used('mwkciamaud')
	Use in mwkciamaud
Endif

mctrl  = ctod('01/01/2100')

mret = sqlexec(mcon1,"select TCI_nombrepac,ENT_descrient,TCU_nombre,TabSectorInt.descrip,"+;
	" TCI_fecing,TCI_fecegr,"+;
	" TCI_identi,TCL_idtipo,TCI_idcentro,TCL_idaudint,TCI_fecmov"+;
	" from TabCiamAudIntLog"+;
	" join TabCiamAudInt on TabCiamAudInt.id = TCL_idaudint "+mwbusca+;
	" join Tabciamubica on Tabciamubica.id = TCI_idcentro"+;
	" left join entidades on ENT_codent = TCI_identi"+;
	" left join TabSectorInt on TabSectorInt.id = TCL_idtipo"+;
	" where ( tcl_fecdes <= ?mfdesde and TCL_fechasta >= ?mfdesde )"+;
	" or ( tcl_fecdes <= ?mfdesde and TCL_fechasta = ?mctrl )"+;
	" group by TCL_idaudint","mwkciamaud")
	
	

If mret < 0
	Messagebox("EN CONSULTA AUDITORIA DE INTERNACION"+chr(10)+;
	"AVISE A SISTEMAS",16,"ERROR")
Else

	mfe1 = sp_busco_fecha_serv('DD') - 1
	mfe2 = dtot( mfe1 )
	mfnu = ctod('01/01/1900')
	select * from mwkciamaud where TCI_fecegr = mfnu or TCI_fecmov >= mfe2 into cursor mwkciamaud

Endif
