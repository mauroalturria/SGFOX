****
** GRABO INFORMACION DE CONTROL DE PADRONES
***

parameter moform, mcomen, mafil, mfechabaja, mcodenti
dimension td(20)
td(1)= "  "
td(2)= "LE"
td(3)= "LC"
td(4)= "CI"
td(5)= "DNI"
td(6)= "PAS"
td(7)= "LM"
td(8)= "LF"
td(9)= "OTR"
td(10)= "RN"
ldomi = (mcomen<>"BAJA Afiliación Activa")

mfecha 		= sp_busco_fecha_serv('DT')
musuario 	= mwkusuario.idusuario
fecnul=ctod("01/01/1900")
lok = .t.
with moform
	if vartype(.txtnombre)#"O"
		lok = .f.
	else
		md01 = iif(used('mwkbuspacie1'),allt(mwkbuspacie1.reg_nrohclinica),'')
		md02 = allt(.txtnombre.value)
		md03 = ''&&iif(ldomi,alltrim(prg_saca_char(.txtdomici.value)),'')
		md04 = iif(ldomi,val(transform(.txtnrodoc.value)),0)
		md05 = ttod(mfecha)
		md06 = iif(ldomi,.txtfecnac.value,ctod("01/01/1950"))
		md07 = fecnul
		md08 = iif(used('mwkbuspacie1'),mwkbuspacie1.REG_nroregistrac,0)
		md09 = ''&&iif(ldomi,val(transform(.txtcpostal.value)),0)
		md10 = ''&&iif(ldomi,allt(mwkpcia.descrip),'')
		tdoc = iif(ldomi,.cbodocu.value,4)
		md11 = td(tdoc +1)
		md12 = ''&&iif(ldomi,allt(mwkloca.descrip),'')
		md13 = 'M'&&iif(.cbosexo.displayvalue = 'MASCULINO' or ldomi, 'M','F')
		md14 = ''&&iif(ldomi,left(allt(.txttel.value),20),'')
		md15 = 0
		md16 = mcomen
		md17 = mafil
		md18 = iif(NVL(mfechabaja,ctod("  /  /  "))=ctod("  /  /  "),fecnul,mfechabaja)
		md19 = mcodenti
	endif
endwith
if lok
	select mwkbuspacie1
	mh01 = REG_nrohclinica
	mh02 = REG_nombrepac
	mh03 = ''&&REG_domicilio
	mh04 = REG_numdocumento
	mh05 = fecnul
	mh06 = nvl(REG_fecnacimiento,fecnul)
	mh07 = fecnul
	mh08 = REG_nroregistrac
	mh09 = ''&&REG_cpostal
	mh10 =''&& REG_provincia
	mh11 = td(val(nvl(REG_tipodocumento,'0'))+1)
	mh12 = ''&&REG_localidad
	mh13 = REG_sexo
	mh14 = ''&&REG_telefonos
	mh15 = ''&&blr_codigobloqueo
	mh16 = REG_bloq_comen
	mh17 = mwkafient1.AFI_nroafiliado
	mh18 = nvl(mwkafient1.AFI_fechabaja ,fecnul)
	mh19 = mwkafient1.ENT_codent
	mnroc = 2

mret = sqlexec(mcon1, "insert into TabCtrlUnif ( fecha,usuario "+;
		" ,AFI_codentidadD,AFI_codentidadO "+;
		" ,AFI_nroafiliadoD, AFI_nroafiliadoO  "+;
		" , REG_bloq_comenD, REG_bloq_comeO"+;
		" ,AFI_fechabajaD  , AFI_fechabajaO "+;
		",REG_fecnacimientoD, REG_fecnacimientoO" +;
		" ,REG_fecaltapadronD, REG_fecaltapadronO"+;
		" ,REG_nombrepacD, REG_nombrepacO"+;
		" ,REG_nrohclinicaD, REG_nrohclinicaO"+;
		" ,REG_nroregistracD,REG_nroregistracO "+;
		" ,REG_numdocumentoD, REG_numdocumentoO"+;
		" ,REG_sexoD, REG_sexoO "+;
		" ,REG_tipodocumentoD, REG_tipodocumentoO,nrocontrol) values  " +;
		"( ?mfecha,?musuario,?md19, ?mh19 "+;
		" , ?md17,  ?mh17,?md16 , ?mh16"+;
		" ,?md18 , ?mh18 "+;
		",?md06, ?mh06" +;
		" ,?md05, ?mh05"+;
		" ,?md02, ?mh02"+;
		" ,?md01, ?mh01"+;
		" ,?md08, ?mh08"+;
		" ,?md04, ?mh04"+;
		" ,?md13, ?mh13"+;
		" ,?md11,  ?mh11"+;
		" ,?mnroc )")
	if mret < 0
		=aerr(eros)
		messagebox("ERROR AL ACTUALIZAR CONTROL, AVISAR A SISTEMAS",16, "Validacion")
	endif

endif
