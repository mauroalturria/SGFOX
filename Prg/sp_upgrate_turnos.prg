***
***   Actualizacion de turnos
***
* Marcelo Torres, 30/03/2022
* mDerivacionPapel(0-1)

Parameter ind, mtipo,mresto,mproto_solicia,mDerivacionPapel
Local laviso
lerrgrab = .F.
If Vartype(mproto_solicia)#"N"
	mproto_solicia= 1
Endif
laviso = .T.
msolicigia = mproto_solicia
mhtomado = sp_busco_fecha_serv('DT')
mcodigovax = mwkusuario.codigovax
midusunew = mwkusuario.idusuario
mususec = mwksector2.Id
mret = SQLExec(mcon1, "select * from turnos where id = ?midturno", "mwkveoturno")
lliberoxdur = .F.
mcodmed1 = mwkveoturno.codmed
mdiasem1 = mwkveoturno.diasem
mcantasig = 0
mturasig = 0
mfechalibre = sp_busco_fecha_serv("DD")+3
mcantdado = 0
mtipotur = Transform(mwkveoturno.tipoturno)
mxobserva = mtipotur +"!"+myip
mhhmm1	= mwkveoturno.hhmmtur
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif
If mwkusuario.codigovax = 54035
*	set step on
Endif

mcicpoamb = ''
mvicpoamb = ''
lctrldura = .T.  &&para no controlar la duracion de los turnos de poli tomados desde sg

* Por si el valor no viene parametrizado
If Vartype(mDerivacionPapel) <> "N"
	mDerivacionPapel = 0
Endif

If mxambito >1
	lctrldura = !(Left(myip,6)='172.16' Or Left(myip,3)='100')
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
Endif
mifec = Ttod(mfectur)
Select durtur From mwkmedp Where codmed = mcodmed1  And diasem = mdiasem1 ;
	and Between(mhhmm1,hhmmdes,hhmmhas) And Between(mifec ,fecvigend,fecvigenh);
	and codprest = mwkbuscotexto.pre_codprest;
	into Cursor mwkdura
Select mwkdura
Go Top

If Reccount('mwkdura')=0
	Use In Select('mwkmedp')
	mret = SQLExec(mcon1, "select codmed, diasem, horadesde, horahasta, codprest, sala, " + ;
		"fecvigend, fecvigenh, hdesde1, hhasta1,hhmmdes,hhmmhas,duracion as durtur,reservados " + ;
		"from medpresta " + ;
		"where codmed = ?mcodmed1  and diasem = ?mdiasem1 and "+ mccpoamb+;
		"  hhmmdes<=?mhhmm1 and hhmmhas>=?mhhmm1 and fecvigend<=?mifec and fecvigenh>=?mifec " +;
		" and generaagen = 1 and fecvigenh <>fecvigend "  , "mwkmedp")
	Select durtur From mwkmedp Where codmed = mcodmed1  And diasem = mdiasem1 ;
		and Between(mhhmm1,hhmmdes,hhmmhas) And Between(mifec ,fecvigend,fecvigenh);
		and codprest = mwkbuscotexto.pre_codprest;
		into Cursor mwkdura
	Select mwkdura
	Go Top
	If Reccount('mwkdura')=0
		Messagebox('NO PUDO ESTABLECERSE LA DURACION DEL TURNO, SELECCIONE OTRA VEZ', 48, 'Validacion')
		mokgrabo = mokgrabo + 1
	Endif
Endif

If !Inlist(mwkveoturno.afiliado , 0,1,2)
	Messagebox('EL TURNO YA FUE TOMADO POR OTRO USUARIO', 48, 'Validacion')
	mokgrabo = mokgrabo + 1
Endif
If mokgrabo =0
	If mcreserva = "*"
		mcreserva	= Right(Strtran(Str((midtur(ind)), 8, 0), " ", "0") + '-' + Str(mresto, 1), 9)
	Endif
	If  (mcodespe = 'KINE' Or mcodespe = 'LABO' Or Inlist(mcodprest, 22020300, 12040601) Or Nvl(mwkbuscotexto.PA_turnosmultip,1)>1);
			and !(mcodserv  = 1130 And mwkveoturno.fechatur >= Ctod("25/11/2019"))
		lerrgrab = .F.
		mret = SQLExec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb) "+;
			"values (  ?mnrohc, ?midturno, ?mhtomado, ?mcodigovax, ?mxobserva , 99 &mvicpoamb) ")
		lerrgrab = (lerrgrab Or mret<1)

		mret = SQLExec(mcon1,"update turnos set afiliado = ?mnrohc, usuario = ?midusunew , " + ;
			"fechatomado = ?mhtomado, codprest = ?mcodprest, UsuarioSector = ?mususec, " + ;
			"codmedsoli = ?mcodsoli, solicigia = ?msolicigia, codreserva = ?mcreserva, " + ;
			"codent = ?mcodent, codserv = ?mcodserv, codesp = ?mcodespe, tipotomado = ?mtipo, Tomado = ?mDerivacionPapel " + ;
			"where id = ?midturno and afiliado IN (0,2) ")
		lerrgrab = (lerrgrab Or mret<1)

		mret = SQLExec(mcon1, "select id from turnosaudit where &mccpoamb afiliado = ?mnrohc and turnoid = ?midturno "+;
			" and fechatomado = ?mhtomado and codigo = 99","mwkctraud")
		lerrgrab = (lerrgrab Or mret<1)

		midaudit = mwkctraud.Id
		mret = SQLExec(mcon1,"select id from turnos where &mccpoamb afiliado = ?mnrohc and id = ?midturno ","mwkctraud")
		lerrgrab = (lerrgrab Or mret<1)

		mcontrol = Iif(Reccount("mwkctraud")>0,10,0)
		mret = SQLExec(mcon1,"update turnosaudit set codigo = ?mcontrol " + ;
			"where id = ?midaudit ")
		lerrgrab = (lerrgrab Or mret<1)
		If lerrgrab
			Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion")
			Do sp_desconexion With "error"
			Cancel
		Endif
	Else
*********desde aca
		If mcodserv  = 1130 And mwkveoturno.fechatur >= Ctod("25/11/2019")
			If !Inlist(mwkveoturno.tipoturno,1,2,3,4,6)  && es sobreoferta, sobreturno, etc
				mret = SQLExec(mcon1, 'select * from medpresta where codmed = ?mcodmed1 and ' + ;
					'codprest = ?mcodprest and diasem = ?mdiasem1 and ' + ;
					'generaagen = 1', 'mwkchequeo')

				If Eof('mwkchequeo')
					Messagebox('HAY UN ERROR EN EL MEDICO SOLICITADO, POR FAVOR, BUSQUE OTRO TURNO',16, 'Validacion')
				Else
					Select mwkturnos2
					Go Top
					Locate For mwkturnos2.Id = midtur(ind) Nooptimize
					mduraci = mwkbuscotexto.pre_duracion * 60 		&& la transformo a segundos
					mcodmed = mwkturnos2.codmed
					mfectur = mwkturnos2.fecha
					mhortur = mwkturnos2.horatur
					mtturno = mwkturnos2.tipoturno
					If Used('mwkNivel')
						Select mwkNivel
						msql_nivel 	= ' in ('
						mturhab =  ' inlist(tipoturno,'
						Scan All
							mturhab =mturhab  + Str(tipoturno,2,0)+","
							msql_nivel = msql_nivel + Str(tipoturno,2,0)+","
							Select mwkNivel
						Endscan
						msql_nivel = Substr(msql_nivel,1,Len(msql_nivel)-1) + " ) "
						mturhab = Substr(mturhab ,1,Len(mturhab )-1) + " ) "
					Else

						mturhab =' 1 = 1 '

					Endif
					mcodent	= Iif(Used('mwkafient1'),mwkafient1.ent_codent,Iif(Used('mwkafient'),mwkafient.ent_codent,mwkbuspacie1.ent_codent))
					Select * From mwkenturno Where codent = mcodent And ;
						fecvigenh>mfecturno Into Cursor mwktxeok
					mfiltratur =   mturhab
					mret = SQLExec(mcon1, "select turnos.*,liberable  from turnos,tabtipoturno  " + ;
						"where turnos.tipoturno =tabtipoturno.tipoturno  and  codmed = ?mcodmed and fechatur = ?mfectur and afiliado = 0 " + ;
						"and turnos.tipoturno <>9 group by horatur,turnos.tipoturno order by horatur " , "mwkasignop")
					Select * From mwkasignop Where &mfiltratur Or (horatur<= mfechalibre And liberable< 3)  Group By horatur  Order By horatur,Id Into Cursor mwkasigno
					Locate For mwkasigno.horatur = mhortur Nooptimize
					mveohora = horatur + mduraci
					mduratur = Hour(mwkdura.durtur)*3600+ Minute(mwkdura.durtur)*60
					mduratur = Iif(mduratur =0,mduraci,mduratur )
					mcantasig = Ceil(mduraci/mduratur)
					mturasig = 0
					Do While !Eof('mwkasigno') And lctrldura
						If mwkasigno.horatur <=  mveohora
							mturasig = mturasig +1
						Else
							If mturasig < mcantasig
								Messagebox('LA DURACION DE LA PRESTACION ES MAYOR A LA DISPONIBILIDAD',64,'Validacion')
								Exit
							Else
								Exit
							Endif
						Endif
						Skip 1 In mwkasigno
					Enddo
					If mturasig < mcantasig And Eof('mwkasigno') And lctrldura
						Messagebox('LA DURACION DE LA PRESTACION ES MAYOR A LA DISPONIBILIDAD',64,'Validacion')
					Endif

					Locate For mwkasigno.horatur = mhortur Nooptimize
					Do While !Eof('mwkasigno')
						If mwkasigno.horatur >= mveohora
							Exit
						Else
							If mcreserva = "*"
								mcreserva	= Right(Strtran(Str((midtur(ind)), 8, 0), " ", "0") + '-' + Str(mresto, 1), 9)
							Endif

							midturno = mwkasigno.Id
							lerrgrab = .F.

							mret = SQLExec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo ) "+;
								"values (  ?mnrohc, ?midturno, ?mhtomado, ?mcodigovax, ?mxobserva , 99 ) ")
							lerrgrab = (lerrgrab Or mret<1)

							mret = SQLExec(mcon1,"update turnos set afiliado = ?mnrohc, usuario = ?midusunew , " + ;
								"fechatomado = ?mhtomado, codprest = ?mcodprest, UsuarioSector = ?mususec, " + ;
								"codmedsoli = ?mcodsoli, solicigia = ?msolicigia, codreserva = ?mcreserva, " + ;
								"codent = ?mcodent, codserv = ?mcodserv, codesp = ?mcodespe, tipotomado = ?mtipo, Tomado = ?mDerivacionPapel " + ;
								"where id = ?midturno and afiliado = 0")

							lerrgrab = (lerrgrab Or mret<1)

							mret = SQLExec(mcon1, "select id from turnosaudit where afiliado = ?mnrohc and turnoid = ?midturno "+;
								" and fechatomado = ?mhtomado and codigo = 99","mwkctraud")
							lerrgrab = (lerrgrab Or mret<1)

							midaudit = mwkctraud.Id
							mret = SQLExec(mcon1,"select id from turnos where afiliado = ?mnrohc and id = ?midturno ","mwkctraud")
							lerrgrab = (lerrgrab Or mret<1)

							mcontrol = Iif(Reccount("mwkctraud")>0,10,0)
							mret = SQLExec(mcon1,"update turnosaudit set codigo = ?mcontrol " + ;
								"where id = ?midaudit ")
							lerrgrab = (lerrgrab Or mret<1)
							If lerrgrab
								Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion")
								Do sp_desconexion With "error"
								Cancel
							Endif
							Skip 1 In mwkasigno
						Endif
					Enddo
				Endif
			Endif
		Else
***********hasta aca
			If Inlist(mwkveoturno.tipoturno,1,2,4,6,22,13) Or (mcodserv  = 1130 And mwkveoturno.fechatur < Ctod("25/11/2019"))&& es sobreoferta, sobreturno, etc no toma varios!!!!
				lerrgrab = .F.
				mret = SQLExec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb) "+;
					"values (  ?mnrohc, ?midturno, ?mhtomado, ?mcodigovax, ?mxobserva , 99 &mvicpoamb) ")
				lerrgrab = (lerrgrab Or mret<1)
				mret = SQLExec(mcon1,"update turnos set afiliado = ?mnrohc, usuario = ?midusunew , " + ;
					"fechatomado = ?mhtomado, codprest = ?mcodprest,UsuarioSector = ?mususec,  " + ;
					"codmedsoli = ?mcodsoli, solicigia = ?msolicigia, codreserva = ?mcreserva, " + ;
					"codent = ?mcodent, codserv = ?mcodserv, codesp = ?mcodespe, tipotomado = ?mtipo, Tomado = ?mDerivacionPapel " + ;
					"where id = ?midturno and afiliado = 0")
				lerrgrab = (lerrgrab Or mret<1)

				mret = SQLExec(mcon1, "select id from turnosaudit where &mccpoamb afiliado = ?mnrohc and turnoid = ?midturno "+;
					" and fechatomado = ?mhtomado and codigo = 99","mwkctraud")
				lerrgrab = (lerrgrab Or mret<1)

				midaudit = mwkctraud.Id
				mret = SQLExec(mcon1,"select id from turnos where &mccpoamb afiliado = ?mnrohc and id = ?midturno ","mwkctraud")
				lerrgrab = (lerrgrab Or mret<1)

				mcontrol = Iif(Reccount("mwkctraud")>0,10,0)
				mret = SQLExec(mcon1,"update turnosaudit set codigo = ?mcontrol " + ;
					"where id = ?midaudit ")
				lerrgrab = (lerrgrab Or mret<1)
				If lerrgrab
					Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion")
					Do sp_desconexion With "error"
					Cancel
				Endif
			Else

				mret = SQLExec(mcon1, 'select * from medpresta where &mccpoamb codmed = ?mcodmed1 and ' + ;
					'codprest = ?mcodprest and diasem = ?mdiasem1 and ' + ;
					'generaagen = 1', 'mwkchequeo')

				If Eof('mwkchequeo')
					Messagebox('HAY UN ERROR EN EL MEDICO SOLICITADO, POR FAVOR, BUSQUE OTRO TURNO',16, 'Validacion')
				Else
					Select mwkturnos2
					Go Top
					Locate For mwkturnos2.Id = midtur(ind) Nooptimize
					mduraci = Nvl(mwkbuscotexto.pa_duracion,mwkbuscotexto.pre_duracion) * 60 		&& la transformo a segundos
					mcodmed = mwkturnos2.codmed
					mfectur = mwkturnos2.fecha
					mhortur = mwkturnos2.horatur
					mtturno = mwkturnos2.tipoturno
*!*						minsel = Iif(mtturno = 'PE' , ' ( 0,5,7) ', ;
*!*							Iif(mtturno = 'GI' , ' ( 0,3,5) ', ;
*!*							iif(mtturno = 'TI' , ' ( 8 ) ', Iif(mtturno = 'HS' , ' ( 0,5,15 ) ',;
*!*							iif(mtturno = 'TP' , ' ( 13 ) ', Iif(mtturno = 'TE' , ' ( 14 ) ', ;
*!*							Iif(mtturno = 'TL' , ' ( 16 ) ', Iif(mtturno = 'WA' , ' ( 17 ) ', ;
*!*							Iif(mtturno = 'PA' , ' ( 18 ) ', Iif(mtturno = 'TV' , ' ( 19 ) ', ' ( 0,4,5) '))))))))))
					If Used('mwkNivel')
						Select mwkNivel
						msql_nivel 	= ' in ('
						mturhab =  ' inlist(tipoturno,'
						Scan All
							mturhab =mturhab  + Str(tipoturno,2,0)+","
							msql_nivel = msql_nivel + Str(tipoturno,2,0)+","
							Select mwkNivel
						Endscan
						msql_nivel = Substr(msql_nivel,1,Len(msql_nivel)-1) + " ) "
						mturhab = Substr(mturhab ,1,Len(mturhab )-1) + " ) "
					Else
						mturhab =' 1 = 1 '

					Endif
					mcodent	= Iif(Used('mwkafient1'),mwkafient1.ent_codent,Iif(Used('mwkafient'),mwkafient.ent_codent,mwkbuspacie1.ent_codent))
					Select * From mwkenturno Where codent = mcodent  And ;
						fecvigenh>mfecturno Into Cursor mwktxeok
					If MWKEXE.NOMEXE<>'AMBULATORIO'
						If   At("EXTERNADO",mwkbuscotexto.prestacion)=0
							mfiltratur = "  (tipoturno in (select tipoturno from  mwktxeok where "+mturhab +"  )  ) "
						Else
							mfiltratur =   mturhab
						Endif
					Else
						mfiltratur =   mturhab
					Endif
					mret = SQLExec(mcon1, "select turnos.*,liberable  from turnos,tabtipoturno  " + ;
						"where turnos.tipoturno =tabtipoturno.tipoturno  and codmed = ?mcodmed and fechatur = ?mfectur and afiliado = 0 " + ;
						"and turnos.tipoturno <>9 group by horatur,turnos.tipoturno order by horatur " , "mwkasignop")
					Select * From mwkasignop Where &mfiltratur  Or (horatur<= mfechalibre And liberable< 3) Group By horatur  Order By horatur,Id Into Cursor mwkasigno
*!*						mret = SQLExec(mcon1, "select * from turnos " + ;
*!*							"where &mccpoamb codmed = ?mcodmed and fechatur = ?mfectur and afiliado in (0,2) " + ;
*!*							"and tipoturno in "+ minsel +" order by horatur" , "mwkasigno")

					Locate For mwkasigno.horatur = mhortur Nooptimize
					mveohora = horatur + mduraci -1
					mduratur = Hour(mwkdura.durtur)*3600+ Minute(mwkdura.durtur)*60
					mduratur = Iif(mduratur =0,mduraci,mduratur )
					mcantasig = Ceil(mduraci/mduratur)
					mturasig = 0
					Do While !Eof('mwkasigno')
						If mwkasigno.horatur <=  mveohora
							mturasig = mturasig +1
						Else
							If mturasig < mcantasig
								Messagebox('LA DURACION DE LA PRESTACION ES MAYOR A LA DISPONIBILIDAD',64,'Validacion')
								If mduraci>20*60 And mduraci/mduratur>=2
									Messagebox('ESTA PRESTACION NO PUEDE BRINDARSE EN EL TURNO DISPONIBLE',64,'Validacion')
									lliberoxdur = .T.
								Endif
								Exit
							Else
								Exit
							Endif
						Endif
						Skip 1 In mwkasigno
					Enddo
					If mturasig < mcantasig And Eof('mwkasigno')
						Messagebox('LA DURACION DE LA PRESTACION ES MAYOR A LA DISPONIBILIDAD',64,'Validacion')
						If mduraci>20*60 And mduraci/mduratur>=2
							Messagebox('ESTA PRESTACION NO PUEDE BRINDARSE EN EL TURNO DISPONIBLE. SELECCIONE OTRO HORARIO',64,'Validacion')
							lliberoxdur = .T.
						Endif
					Endif
					If lliberoxdur
						mret = SQLExec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb) "+;
							"values (  ?mnrohc, ?midturno, ?mhtomado, ?mcodigovax, ?mxobserva , 98 &mvicpoamb) ")
						lerrgrab = (lerrgrab Or mret<1)

						mret = SQLExec(mcon1,"update turnos set afiliado = 0, usuario = '', " + ;
							"fechatomado = ?mhtomado, codprest = 0, UsuarioSector = 0, " + ;
							"codmedsoli = 0, solicigia = '', codreserva = '', " + ;
							"codent = 0, codserv = 0, codesp = '', tipotomado = 0, Tomado = 0 " + ;
							"where id = ?midturno and afiliado = ?mnrohc")
					Else
						Locate For mwkasigno.horatur = mhortur Nooptimize
						Do While !Eof('mwkasigno')
							If mwkasigno.horatur >= mveohora And mcantdado = mturasig
								Exit
							Else
								If mcreserva = "*"
									mcreserva	= Right(Strtran(Str((midtur(ind)), 8, 0), " ", "0") + '-' + Str(mresto, 1), 9)
								Endif

								midturno = mwkasigno.Id
								lerrgrab = .F.
								mret = SQLExec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb) "+;
									"values (  ?mnrohc, ?midturno, ?mhtomado, ?mcodigovax, ?mxobserva , 99 &mvicpoamb) ")
								lerrgrab = (lerrgrab Or mret<1)

								mret = SQLExec(mcon1,"update turnos set afiliado = ?mnrohc, usuario = ?midusunew , " + ;
									"fechatomado = ?mhtomado, codprest = ?mcodprest, UsuarioSector = ?mususec, " + ;
									"codmedsoli = ?mcodsoli, solicigia = ?msolicigia, codreserva = ?mcreserva, " + ;
									"codent = ?mcodent, codserv = ?mcodserv, codesp = ?mcodespe, tipotomado = ?mtipo, Tomado = ?mDerivacionPapel " + ;
									"where id = ?midturno and afiliado in (0,2)")

								lerrgrab = (lerrgrab Or mret<1)
								mcantdado  = mcantdado  +1

								mret = SQLExec(mcon1, "select id from turnosaudit where &mccpoamb afiliado = ?mnrohc and turnoid = ?midturno "+;
									" and fechatomado = ?mhtomado and codigo = 99","mwkctraud")
								lerrgrab = (lerrgrab Or mret<1)

								midaudit = mwkctraud.Id
								mret = SQLExec(mcon1,"select id from turnos where &mccpoamb afiliado = ?mnrohc and id = ?midturno ","mwkctraud")
								lerrgrab = (lerrgrab Or mret<1)

								mcontrol = Iif(Reccount("mwkctraud")>0,10,0)
								mret = SQLExec(mcon1,"update turnosaudit set codigo = ?mcontrol " + ;
									"where id = ?midaudit ")
								lerrgrab = (lerrgrab Or mret<1)
								If lerrgrab
									Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion")
									Do sp_desconexion With "error"
									Cancel
								Endif
								Skip 1 In mwkasigno
							Endif
						Enddo
					Endif
				Endif
			Endif
		Endif
************este tambien
	Endif
Endif
If Used('mwkveoturno')
	Select mwkveoturno
	Use
Endif
If Used('mwkasigno')
	Select mwkasigno
	Use
Endif
If Used('mwkchequeo')
	Select mwkchequeo
	Use
Endif
