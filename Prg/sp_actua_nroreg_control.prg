****
** Actualizo nro de registracio en turnos por unificacion
***

Parameter nroregistra, newregistra,mfecd,mfech
Select * From mwkdocu Order By codigovax Into Cursor mwkdocu2
If !Used('mwkdocu')
	Do sp_tabla_documentos
Endif

mfecha 		= sp_busco_fecha_serv('DT')
musuario 	= mwkusuario.idusuario
fecnul=Ctod("01/01/1900")
tdoc = Val(Nvl(mwkbuspacied.REG_tipodocumento,'4'))
Select mwkdocu
Locate For codigovax = tdoc
If Eof()
	md11 = "DNI"
Else
	md11 = mwkdocu.abrevio
ENDIF

tdoc = Val(Nvl(mwkbuspacieh.REG_tipodocumento,'4'))
Select mwkdocu
Locate For codigovax = tdoc
If Eof()
	mh11 = "DNI"
Else
	mh11 = mwkdocu.abrevio
ENDIF
Select mwkbuspacied
md01 = REG_nrohclinica
md02 = REG_nombrepac
md03 = REG_domicilio
md04 = REG_numdocumento
md05 = Nvl(REG_fecaltapadron,fecnul)
md06 = Nvl(REG_fecnacimiento,fecnul)
md07 = Iif(Vartype(mfecd)="D",mfecd,Nvl(REG_fecbajapadron,fecnul))
md08 = REG_nroregistrac
md09 = REG_cpostal
md10 = REG_provincia
md12 = REG_localidad
md13 = REG_sexo
md14 = REG_telefonos
md15 = blr_codigobloqueo
md16 = REG_bloq_comen
md17 = AFI_nroafiliado
md18 = Nvl(AFI_fechabaja ,fecnul)
md19 = ENT_codent

Select mwkbuspacieh
mh01 = REG_nrohclinica
mh02 = REG_nombrepac
mh03 = REG_domicilio
mh04 = REG_numdocumento
mh05 = Nvl(REG_fecaltapadron,fecnul)
mh06 = Nvl(REG_fecnacimiento,fecnul)
mh07 = Iif(Vartype(mfech)="D",mfech,Nvl(REG_fecbajapadron,fecnul))
mh08 = REG_nroregistrac
mh09 = REG_cpostal
mh10 = REG_provincia
mh12 = REG_localidad
mh13 = REG_sexo
mh14 = REG_telefonos
mh15 = blr_codigobloqueo
mh16 = REG_bloq_comen
mh17 = AFI_nroafiliado
mh18 = Nvl(AFI_fechabaja ,fecnul)
mh19 = ENT_codent
mcontrol = Round(Seconds(),0)

mret = prg_ejecutosql1("insert into TabCtrlUnif ( nrocontrol,AFI_codentidadD, "+;
"AFI_codentidadO,fecha,usuario ) values  " +;
"( ?mcontrol ,?md19, ?mh19,?mfecha,?musuario)")
If mret < 0
	Messagebox("ERROR AL ACTUALIZAR CONTROL, AVISAR A SISTEMAS",16, "Validacion")
Else
	mret = prg_ejecutosql1("select id from TabCtrlUnif where nrocontrol = ?mcontrol "+;
	"and fecha = ?mfecha and usuario = ?musuario " ,"mwkctru")

	mid = 	mwkctru.Id
	mret = prg_ejecutosql1("update TabCtrlUnif set AFI_nroafiliadoD = ?md17, AFI_nroafiliadoO = ?mh17 "+;
	" , REG_bloq_comenD=?md16 , REG_bloq_comeO= ?mh16"+;
	" ,AFI_fechabajaD =?md18 , AFI_fechabajaO =?mh18 "+;
	" ,REG_fecbajapadronD= ?md07, REG_fecbajapadronO=?mh07"+;
	",REG_fecnacimientoD=?md06, REG_fecnacimientoO= ?mh06" +;
	" ,REG_fecaltapadronD= ?md05, REG_fecaltapadronO=?mh05"+;
	" , REG_bloqueoD= ?md15, REG_bloqueoO=?mh15 "+;
	", REG_cpostalD=?md09, REG_cpostalO= ?mh09,"+;
	" REG_fecnacimientoD=?md06, REG_fecnacimientoO= ?mh06,"+;
	" REG_domicilioD= ?md03, REG_domicilioO=?mh03"+;
	" where id = ?mid ")

	mnroc = Iif(Vartype(mfecd)="D",1,-1)

	mret = prg_ejecutosql1("update TabCtrlUnif set REG_localidadD= ?md12, REG_localidadO=?mh12"+;
	" ,REG_nombrepacD= ?md02, REG_nombrepacO=?mh02"+;
	" ,REG_nrohclinicaD= ?md01, REG_nrohclinicaO=?mh01"+;
	" ,REG_nroregistracD= ?md08, REG_nroregistracO=?mh08"+;
	" ,REG_numdocumentoD= ?md04, REG_numdocumentoO=?mh04"+;
	" ,REG_provinciaD= ?md10, REG_provinciaO=?mh10"+;
	" ,REG_sexoD= ?md13, REG_sexoO=?mh13"+;
	" ,REG_telefonosD= ?md14, REG_telefonosO=?mh14"+;
	" ,REG_tipodocumentoD= ?md11, REG_tipodocumentoO=?mh11"+;
	" ,nrocontrol = ?mnroc where id = ?mid ")

Endif
