*
* Log de Vales generados en Prescripcion Medica
*
Lparameters midevol, mvale, minfids, minfida, mltipo

=Alines(v1,minfids,",")
=Alines(v2,minfida,",")

muser  = Alltrim(mwkusuarios.idusuario)
mfechr = sp_busco_fecha_serv("DT")

For mi = 1 To Alen(v1)

	mlid = Val(v1[mi])
	If mlid > 0
		mret = SQLExec(mcon1,"insert into TabIntPmVales (IPV_vale, IPV_idevol, IPV_idreginsumo, IPV_instipo, IPV_movimiento, IPV_usuariomodif, IPV_fechormodif) "+;
			" values (?mvale, ?midevol, ?mlid, 'P', ?mltipo, ?muser, ?mfechr)")

		If mret < 0
			mltabla = "LOG DE PRESCRIPCION MEDICA VALES - INSUMOS PRINCIPAL/SOLUCION"
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return .F.
		Endif
	Endif

Endfor

For mi = 1 To Alen(v2)

	mlid = Val(v2[mi])
	If mlid > 0
		mret = SQLExec(mcon1,"insert into TabIntPmVales (IPV_vale, IPV_idevol, IPV_idreginsumo, IPV_instipo, IPV_movimiento, IPV_usuariomodif, IPV_fechormodif) "+;
			" values (?mvale, ?midevol, ?mlid, 'A', ?mltipo, ?muser, ?mfechr)")

		If mret < 0
			mltabla = "LOG DE PRESCRIPCION MEDICA VALES - INSUMOS AGREGADOS"
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return .F.
		Endif
	Endif

Endfor

Release v1, v2

Return .T.
