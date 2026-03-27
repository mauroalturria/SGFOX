****
* BUSCA PACIENTES
****

Parameter mbusco1

Do sp_busco_estados With 57,' and Tipo = 3 ','mwkbloqueaplan'
mcpoplan = ''
If mwkbloqueaplan.estado = 0
	mcpoplan = ',AFI_idplan '
Endif
mret = SQLExec(mcon1,"select REG_nrohclinica, REG_nombrepac, REG_domicilio, "+;
"reg_tipodocumento, REG_numdocumento, entidades.ENT_descrient, REG_fecaltapadron, AFI_fechabaja, " + ;
"AFI_nroafiliado, REG_fecnacimiento, REG_fecbajapadron, ENT_fecpas, ENT_turnoshabilit, " + ;
"entidades.ENT_codent, REG_nroregistrac, REG_cpostal, REG_provincia, ENT_capita, ENT_tipo,ENT_nroprestadorexterno , " + ;
" REG_localidad, REG_sexo, REG_telefonos,reg_cuit ,  " + ;
"blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado " + ;
", TPV_Audit , TPV_Observa,reg_email "+mcpoplan +;
"FROM afiliacion, entidades, registracio left outer join bloqregist on " + ;
" registracio.REG_bloqueo = bloqregist.blr_codigobloqueo " + ;
" left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
"where &mbusco1 " + ;
"registracio.REG_nroregistrac = afiliacion.registracio and " + ;
"afiliacion.AFI_codentidad = entidades.ENT_codent " + ;
"ORDER BY REG_nombrepac, AFI_fechabaja, ENT_turnoshabilit", "mwkbuscopa")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Messagebox(eros(3))

	Do prg_cancelo
Endif

If At("afi_nroafiliado",Lower(mbusco1))>0
	pbusco = Strtran(Lower(mbusco1) ,'afi_nroafiliado','NroAfiliado')
	pbusco = Strtran(Lower(pbusco) ,'afi_codentidad','Entidad')
Else
	pbusco = Strtran(Lower(mbusco1) ,'reg_numdocumento','Documento')
Endif
mret = SQLExec(mcon1,"select ApeyNom , CUIL , Documento  "+;
", FecEgreso , FecIngreso , FecNac , Nombre , NroAfiliado "+;
", Sexo , abrevio,TipoDocumento,ent_descrient,plan,pmi,AFTipoAfiliacion "+;
" FROM entidades,PadCabe " +;
" left join tabdocumentos on PadCabe.TipoDocumento= tabdocumentos.codigovax"+;
" where  " + pbusco + " entidad = ent_codent ", "mwkbuspadron")
