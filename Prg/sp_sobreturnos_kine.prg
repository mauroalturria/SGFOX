*****************************
* Genera Sobre Turnos
* AUTOR:Claudia Antoniow
*****************************
* FECHA:10/06/2002
* Modificada:10/06/2002
*****************************
Lparameters xrtipot
If Vartype(xrtipot)<>"N"
	xrtipot=2
ENDIF
*mdmasX    =ctod('20/05/2004')
*mccodesp  ='FONI'
mndiasem  =Dow(mdmasX)
mncanttur =1
singenerar_st =0
mlismed    = '( '
If mxambito >1
	mccpoambm = " m.codambito = ?mxambito and "
	mccpoambt = " t.codambito = ?mxambito and "
	mcjoin = 	" and m.codambito = t.codambito "
Else
	mccpoambm = ''
	mcjoin = ''
	mccpoambt = ''
Endif
mret=SQLExec(mcon1,"SELECT t.codmed,t.diasem,t.horadesde,t.horahasta, "+;
	" t.porcentaje,t.cantidad,t.fvigend,t.fvigenh  "+;
	" FROM tabsobretoA as t, medpresta as m ,turnos as a,Tabtipoturno as tt "+;
	" WHERE &mccpoambm &mccpoambt t.Diasem=?mndiasem AND t.Cantidad >0 and t.tipoturno=2 "+;
	" AND t.Codmed = a.codmed and a.fechatur=?mdmasX And a.tipoturno = tt.tipoturno "+;
	" and tt.grupo in(0,1,3) "+;
	" AND m.codmed=t.codmed AND m.codesp=?mccodesp "+mcjoin +;
	" AND ?mdmasX between t.fvigend and t.fvigenh "+;
	" AND ?mdmasX between m.fecVigend and m.fecVigenH "+;
	" GROUP BY t.Codmed,t.diasem,t.Horadesde,t.horahasta,t.cantidad "+;
	" ORDER BY t.Codmed,t.diasem,t.Horadesde,t.horahasta,t.cantidad ","MWKSobre")
SELECT * FROM MWKSobre WHERE INLIST(codmed ,915,4456) INTO CURSOR controlo
IF RECCOUNT('controlo')>0
SET STEP ON
endif

Sele MWKSobre
Go Top


Do While !Eof('MWKsobre')

	mncodmed  =MWKSobre.codmed
	mnporc    =MWKSobre.cantidad
	mtfechatur=mdmasX
	thora     =Ttoc(MWKSobre.Horadesde,2)
	thorad    =MWKSobre.Horadesde
	thorah    =MWKSobre.Horahasta

	If mnporc >0
		Do sp_valido_sobretur.prg
		Sele MWKExisteTurno
		Go Top
		If Eof('MWKExisteTurno') Or Bof('MWKExisteTurno')
			mnporc  =MWKSobre.cantidad
			Do sp_datos_sobretur.prg
			Sele MwkPorcSOfer
			Go Top
			If !Eof('MwkPorcSOfer') Or !Bof('MwkPorcSOfer')
				If MwkPorcSOfer.Cantur >0
					Do sp_valido_franjaHor With mncodmed, mndiasem,;
						thorad,thorah,mtfechatur
					Sele MWKExisteFr
					Go Top
					If !Eof('MWKExisteFr')
						Do sp_cargo_sobretur With xrtipot,mnporc,thorad,thorah
						
					Else
						If mlismed    = '( '
							mlismed   = mlismed  + Allt(Str(mncodmed))
						Else
							mlismed   = mlismed  + ',' + Allt(Str(mncodmed))
						Endif
						singenerar_st = singenerar_st + 1
					Endif
				Endif
			Endif
		Endif
	Endif
	If Used('MWKExisteTurno')
		Sele MWKExisteTurno
		Use
	Endif
	If Used('MwkPorcSOfer')
		Sele MwkPorcSOfer
		Use
	Endif
	If Used('MWKHorasTr')
		Sele MWKHorasTr
		Use
	Endif

	Skip 1 In MWKSobre
Enddo

If singenerar_st > 0
	Messagebox('No se generar  ST para ' + Str(singenerar_st ) +;
		' Medicos Por dif. de franjas ',64,'Validacion')

	mlismed = mlismed + ')'

	Do prg_listo_medicos With mlismed
	mtfhoy =sp_busco_fecha_serv('DT')
	Sele MwkLisMed
	Go Top
	Report Form repturno41b Noconsole To Printer
Endif
