*
* Ingreso / Actualizacion de H.C. en depuración
*
Lparameters mltipo,melid,menti,mdesd,mhast,mcaja,mcarp

mfecha = sp_busco_fecha_serv("DT")
musuar = mwkusuario.idusuario

If mltipo = "A"
	mret = sqlexec(mcon1,"insert into TabHCIUbicacion (HCU_caja,HCU_carpeta,HCU_codent,"+;
		"HCU_fecha,HCU_HCDesde,HCU_HCHasta,HCU_usuario)"+;
		" values (?mcaja,?mcarp,?menti,?mfecha,?mdesd,?mhast,?musuar)")
Else
	mret = sqlexec(mcon1,"update TabHCIUbicacion set"+;
		" HCU_caja=?mcaja,HCU_carpeta=?mcarp,HCU_codent=?menti,HCU_fecha=?mfecha,"+;
		" HCU_HCDesde=?mdesd,HCU_HCHasta=?mhast"+;
		" where TabHCIUbicacion.ID=?melid")
Endif

If mret < 0
	Messagebox("EN "+iif(mltipo="A","INGRESO","ACTUALIZACION")+" DE H.C. DEPURADAS"+CHR(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Else
	mresultado = .t.
Endif
