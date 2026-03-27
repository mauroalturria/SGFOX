*
* Incorporación, Partidas de medicamentos citostáticos y Ciclos de Aplicación
*
Lparameters mthisform, mimporta

If vartype(mimporta) <> "C"
	mimporta = "N"
Endif

With mthisform

	If mimporta = "N"
		Dimension vdatos[11]
		vdatos[01] = .txtpartida.value
		vdatos[02] = .txtfecha.value
		vdatos[03] = mwkinst.id
		vdatos[04] = .pnroRegistrac
		vdatos[05] = 0  &&.cboubica.listindex
		vdatos[06] = '' &&.txtpisocama.value
		vdatos[07] = .cboorigen.listindex
		vdatos[08] = iif(.cboorigen.listindex=4,.txtotro.value,'')
		vdatos[09] = sp_busco_fecha_serv("DT")
		vdatos[10] = mwkusuario.idusuario
		vdatos[11] = myip
	Endif

	mret = sqlexec(mcon1,"insert into TabFarmCitosP "+;
		"(TCP_partida,TCP_fecha,TCP_institucion,TCP_registracio,"+;
		"TCP_origen,TCP_otros,TCP_fechacarga,TCP_idusuario,TCP_ipuesto) "+;
		"values "+;
		"(?vdatos[01],?vdatos[02],?vdatos[03],?vdatos[04],"+;
		"?vdatos[07],?vdatos[08],?vdatos[09],?vdatos[10],?vdatos[11])")

	If mret < 0
		Messagebox("EN ACTUALIZACION MAESTRO PARTIDAS",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif
	
	Release vdatos

Endwith

