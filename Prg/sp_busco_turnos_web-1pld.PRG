*
* Calculo de turnos franjas horarias para cursor web, a partir de fecha desde
*
Lparameters mfechad

*!*, mfechah
*!*	Public mcon1,mcon2,mcon3
*!*	mcon1 = SQLCONNECT("conec01")

If vartype(mfechad)#"D"
	mfechad = sp_busco_fecha_serv("DD")+28
Endif

*If vartype(mfechah)#"D"

Wait "GENERANDO TABLA DE TURNOS WEB, AGUARDE UNOS MINUTOS" Windows Nowait	

mfechah = mfechad + 6

*mfechah = sp_busco_fecha_serv("DD")+7
*Endif

*!*	Set notify off
*!*	Set cpdialog off
*!*	Set safety off

Dimension vdatos[48,2]

If used('mwkconsul')
	Use in mwkconsul
Endif

mfecini = mfechad - 1
mdias   = mfechah - mfechad + 1

Create cursor mwkconsul;
	(nombre c(50), espec c(50), consultorio c(20), dia D,cdia c(10),codpresta n(9),diasemana n(1),;
	h01 n(4),h02 n(4),h03 n(4),h04 n(4),h05 n(4),h06 n(4),;
	h07 n(4),h08 n(4),h09 n(4),h10 n(4),h11 n(4),h12 n(4),h13 n(4),;
	h14 n(4),h15 n(4),h16 n(4),h17 n(4),h18 n(4),h19 n(4),h20 n(4),;
	h21 n(4),h22 n(4),h23 n(4),h24 n(4),h25 n(4),h26 n(4),h27 n(4),;
	h28 n(4),h29 n(4),h30 n(4),h31 n(4),h32 n(4),h33 n(4),h34 n(4),;
	h35 n(4),h36 n(4),h37 n(4),h38 n(4),h39 n(4),h40 n(4),h41 n(4),;
	h42 n(4),h43 n(4),h44 n(4),h45 n(4),h46 n(4),h47 n(4),h48 n(4),;
	hdes n(4),ft n(1))

Create cursor mwkconsulf;
	(codesp c(4),medico n(9),codprest n(9),diasem n(1),hhmmdes n(6),hhmmhas n(6),ldia c(10),lfecha D) && Agregado

*!* Create cursor mwkconsuld (codesp c(4),diasem n(1),hhmmdes n(6),hhmmhas n(6), codpres n(9))

For mid = 1 to mdias

	If used('mwkaux0')
		Use in mwkaux0
	Endif
	mfecha = mfecini + mid
	mdia   = dow(mfecha)

	mret = sqlexec(mcon1,"select nombre,diasem,sala,hdesde1,hhasta1,"+;
		"fecvigend,fecvigenh,generaagen,hhmmdes,hhmmhas,medpresta.codesp,"+;
		"ESP_descripcion,prestadores.id,codprest " +;
		"from medpresta,prestadores,especialid,prestacions " + ;
		"where medpresta.codmed=prestadores.id and " + ;
		"prestacions.PRE_codprest=medpresta.codprest and prestacions.PRE_WebTurnos='S' and "+;
		"medpresta.diasem=?mdia and medpresta.codesp=ESP_codesp and " + ;
		"medpresta.fecvigend<=?mfecha and medpresta.fecvigenh>?mfecha " + ;
		"and (estado=1 or fecpasiva>?mfecha) and medpresta.fecvigend<>medpresta.fecvigenh " +;
		"and hhmmdes>=5 and diasem<>null "+;
		"group by codmed,medpresta.codesp,diasem,sala,hhmmdes,hhmmhas,generaagen,codprest " + ;
		"order by codmed,medpresta.codesp,hhmmdes,hhmmhas,fecvigend,fecvigenh,codprest", "mwkaux0")

	If used('mwkauxturnos')
		Use in mwkauxturnos
	Endif

	mret = sqlexec(mcon1,"select codmed,fechatur " + ;
		"from turnos where fechatur=?mfecha and tipoturno<9 "+;
		"group by codmed,fechatur","mwkauxturnos")
	If mret < 0
		= aerr(eros)
		Do prg_error with eros,'TURNOS WEB'
	Endif
	If used('mwkaux')
		Use in mwkaux
	Endif
	Select * from mwkaux0 left join mwkauxturnos on id=codmed into cursor mwkaux
	If used('mwkauxf')
		Use in mwkauxf
	Endif
	Select codesp,id,codprest,diasem,hhmmdes,hhmmhas,fechatur from mwkaux order by codesp,diasem,hhmmdes into cursor mwkauxf
	Select mwkauxf
	Go top
	Scan
		mtur = nvl(mwkauxf.fechatur,ctod('  /  /    '))
		If mwkauxf.fechatur <> ctod('  /  /    ')
			mesp = mwkauxf.codesp
			mmed = mwkauxf.id
			mpre = mwkauxf.codprest
			mdia = mwkauxf.diasem
			mdes = mwkauxf.hhmmdes
			mhas = mwkauxf.hhmmhas
			mdiac = iif(mwkauxf.diasem=2,"Lunes" ,iif(mwkauxf.diasem=3,"Martes" ,iif(mwkauxf.diasem=4,"Miercoles",;
				iif(mwkauxf.diasem=5,"Jueves",iif(mwkauxf.diasem=6,"Viernes",iif(mwkauxf.diasem=7,"Sabado","Domingo"))))))

			Insert into mwkconsulf (codesp,medico,codprest,diasem,hhmmdes,hhmmhas,lfecha,ldia) ;
				values (mesp,mmed,mpre,mdia,mdes,mhas,mtur,mdiac)
		Endif
	Endscan
	Select mwkaux
	Go top
	Do while !Eof()
		mnombre = nombre
		msala   = sala
		mdiasem = mfecha
		mcodpre = codprest
		mft  = iif(isnull(fechatur) and generaagen=1,0,1)
		mdia = iif(diasem=2,"Lunes" ,iif(diasem=3,"Martes" ,iif(diasem=4,"Miercoles",;
			iif(diasem=5,"Jueves",iif(diasem=6,"Viernes",iif(diasem=7,"Sabado","Domingo"))))))

		mdia   = mdia &&+ " "+str(day(mfecha),2,0)
		mespec = ESP_descripcion
		mhdes  = hhmmdes
		mdiasemana = diasem

		vdatos[01,1]="0000,0029"
		vdatos[02,1]="0030,0099"
		vdatos[03,1]="0100,0129"
		vdatos[04,1]="0130,0199"
		vdatos[05,1]="0200,0229"
		vdatos[06,1]="0230,0299"
		vdatos[07,1]="0300,0329"
		vdatos[08,1]="0330,0399"
		vdatos[09,1]="0400,0429"
		vdatos[10,1]="0430,0499"
		vdatos[11,1]="0500,0529"
		vdatos[12,1]="0530,0599"
		vdatos[13,1]="0600,0629"
		vdatos[14,1]="0630,0699"
		vdatos[15,1]="0700,0729"
		vdatos[16,1]="0730,0799"
		vdatos[17,1]="0800,0829"
		vdatos[18,1]="0830,0899"
		vdatos[19,1]="0900,0929"
		vdatos[20,1]="0930,0999"
		vdatos[21,1]="1000,1029"
		vdatos[22,1]="1030,1099"
		vdatos[23,1]="1100,1129"
		vdatos[24,1]="1130,1199"
		vdatos[25,1]="1200,1229"
		vdatos[26,1]="1230,1299"
		vdatos[27,1]="1300,1329"
		vdatos[28,1]="1330,1399"
		vdatos[29,1]="1400,1429"
		vdatos[30,1]="1430,1499"
		vdatos[31,1]="1500,1529"
		vdatos[32,1]="1530,1599"
		vdatos[33,1]="1600,1629"
		vdatos[34,1]="1630,1699"
		vdatos[35,1]="1700,1729"
		vdatos[36,1]="1730,1799"
		vdatos[37,1]="1800,1829"
		vdatos[38,1]="1830,1899"
		vdatos[39,1]="1900,1929"
		vdatos[40,1]="1930,1999"
		vdatos[41,1]="2000,2029"
		vdatos[42,1]="2030,2099"
		vdatos[43,1]="2100,2129"
		vdatos[44,1]="2130,2199"
		vdatos[45,1]="2200,2229"
		vdatos[46,1]="2230,2299"
		vdatos[47,1]="2300,2329"
		vdatos[48,1]="2330,2400"
		For mi = 1 to 48
			vdatos[mi,2]=0
		Endfor
		Do while !Eof() and mnombre = nombre and msala = sala
			mdesdev = hhmmdes
			mhastav = hhmmhas
			mi = 0
			msalgo = .t.
			mbldesde = 0
			Do while mi < 49 and msalgo
				mi = mi + 1
				mbusca = vdatos[mi,1] && Ej. "30,100"
				If between(mdesdev,&mbusca)
					mbldesde = mi
					msalgo = .f.
				Endif
			Enddo
			mi = 0
			msalgo = .t.
			mblhasta = 0
			Do while mi < 49 and msalgo
				mi = mi + 1
				mbusca = vdatos[mi,1] && Ej. "30,100"
				If between(mhastav,&mbusca)
					mblhasta = mi
					msalgo = .f.
				Endif
			Enddo
			mi = 1
			If mbldesde > 0 and mblhasta > 0
				For mi = mbldesde to mblhasta
					If mi = mbldesde
						vdatos[mi,2] = mdesdev && 1
					Else
						If mi = mblhasta
							vdatos[mi,2] = mhastav && 3
						Else
							vdatos[mi,2] = 1 && 2
						Endif
					Endif
				Endfor
			Endif
			Skip
		Enddo

		Insert into mwkconsul (nombre,espec,consultorio,dia,cdia,codpresta,diasemana,;
			h01,h02,h03,h04,h05,h06,h07,h08,h09,h10,;
			h11,h12,h13,h14,h15,h16,h17,h18,h19,h20,;
			h21,h22,h23,h24,h25,h26,h27,h28,h29,h30,;
			h31,h32,h33,h34,h35,h36,h37,h38,h39,h40,;
			h41,h42,h43,h44,h45,h46,h47,h48,;
			hdes,ft) values ;
			(mnombre,mespec,msala,mdiasem,mdia,mcodpre,mdiasemana,;
			vdatos[01,2],vdatos[02,2],vdatos[03,2],vdatos[04,2],vdatos[05,2],;
			vdatos[06,2],vdatos[07,2],vdatos[08,2],vdatos[09,2],vdatos[10,2],;
			vdatos[11,2],vdatos[12,2],vdatos[13,2],vdatos[14,2],vdatos[15,2],;
			vdatos[16,2],vdatos[17,2],vdatos[18,2],vdatos[19,2],vdatos[20,2],;
			vdatos[21,2],vdatos[22,2],vdatos[23,2],vdatos[24,2],vdatos[25,2],;
			vdatos[26,2],vdatos[27,2],vdatos[28,2],vdatos[29,2],vdatos[30,2],;
			vdatos[31,2],vdatos[32,2],vdatos[33,2],vdatos[34,2],vdatos[35,2],;
			vdatos[36,2],vdatos[37,2],vdatos[38,2],vdatos[39,2],vdatos[40,2],;
			vdatos[41,2],vdatos[42,2],vdatos[43,2],vdatos[44,2],vdatos[45,2],;
			vdatos[46,2],vdatos[47,2],vdatos[48,2],mhdes,mft)
		Select mwkaux

	Enddo
	Use IN mwkaux
Next

If reccount('mwkconsul')>0
	Select nombre,espec,codpresta,dia,cdia,diasemana;
		h01,h02,h03,h04,h05,h06,h07,h08,h09,h10,;
		h11,h12,h13,h14,h15,h16,h17,h18,h19,h20,;
		h21,h22,h23,h24,h25,h26,h27,h28,h29,h30,;
		h31,h32,h33,h34,h35,h36,h37,h38,h39,h40,;
		h41,h42,h43,h44,h45,h46,h47,h48 from mwkconsul order by dia,espec into cursor mwkconsul
	Select mwkconsul
	Go top
	If used('mwkauxd')
		Use in mwkauxd
	Endif
	Select * from mwkconsulf into table mwkauxd
	If used('mwkauxd2')
		Use in mwkauxd2
	Endif

*!*		Select distinct(diasem) as ldia from mwkconsulf into cursor mwkauxd2
*!*		Select mwkauxd
*!*		Go top
*!*		Scan
*!*			If used('mwkauxf')
*!*				Use in mwkauxf
*!*			Endif
*!*			mbusca = mwkauxd2.ldia
*!*			Select codesp,medico,codprest,diasem,hhmmdes,hhmmhas from mwkauxd where diasem = mbusca order by codesp,codprest,hhmmdes into cursor mwkauxf
*!*			Select mwkauxf
*!*			Go top
*!*			mesp = mwkauxf.codesp
*!*			mdes = mwkauxf.hhmmdes
*!*			mhas = mwkauxf.hhmmhas
*!*			mcod = mwkauxf.codprest
*!*			mpas = .f.
*!*			Scan
*!*				If mesp = mwkauxf.codesp
*!*					mpas = .t.
*!*					If mwkauxf.hhmmhas >= mhas and mwkauxf.hhmmdes <= mhas and mcod = mwkauxf.codprest
*!*						mhas = mwkauxf.hhmmhas
*!*					Else
*!*						If mwkauxf.hhmmdes >= mdes and mwkauxf.hhmmhas <= mhas and mcod = mwkauxf.codprest
*!*							mpas = .t.
*!*						Else
*!*							Insert into mwkconsuld (codesp,diasem,hhmmdes,hhmmhas,codpres) values (mesp,mbusca,mdes,mhas,mcod)
*!*							mesp = mwkauxf.codesp
*!*							mdes = mwkauxf.hhmmdes
*!*							mhas = mwkauxf.hhmmhas
*!*							mcod = mwkauxf.codprest
*!*							mpas = .f.
*!*						Endif
*!*					Endif
*!*				Else
*!*					Insert into mwkconsuld (codesp,diasem,hhmmdes,hhmmhas,codpres) values (mesp,mbusca,mdes,mhas,mcod)
*!*					mesp = mwkauxf.codesp
*!*					mdes = mwkauxf.hhmmdes
*!*					mhas = mwkauxf.hhmmhas
*!*					mcod = mwkauxf.codprest
*!*					mpas = .f.
*!*				Endif
*!*			Endscan
*!*			If mpas
*!*				Insert into mwkconsuld (codesp,diasem,hhmmdes,hhmmhas) values (mesp,mbusca,mdes,mhas)
*!*			Endif
*!*			Select mwkauxd2
*!*		Endscan
*!*		Select codesp,medico,codprest,diasem,hhmmdes,hhmmhas from mwkconsulf order by codesp,diasem,hhmmdes into cursor mwkauxf
*!*		Select mwkauxf
*!*		Go top
*!*	*	copy to c:\cursor1 type csv
*!*		Select mwkconsuld
*!*		Go top
*!*	*	copy to c:\cursor2 type csv

	If used('mwkcurweb')
		Use in mwkcurweb
	Endif

	If used('mwkcurweb2')
		Use in mwkcurweb2
	Endif

*!*		Create cursor mwkcurweb2 ;
*!*			(codesp c(4),medico n(9),codprest n(9),hhmmdes c(8),hhmmhas c(8),ldia c(10),lfecha c(10)) && Agregado

	If file('c:\temp\web\turno_especialidad.txt')
		Delete file c:\temp\web\turno_especialidad.txt
	Endif
	If file('c:\temp\web\turno_profesion.txt')
		Delete file c:\temp\web\turno_profesion.txt
	Endif

	Set century on
	Set date to YMD
	Set MARK TO '-'

	For msalto = 1 to 2
		If used('mwkconsuld')
			Use in mwkconsuld
		Endif
		Create cursor mwkconsuld (medico n(9),codesp c(4),diasem c(10),hhmmdes c(10),hhmmhas c(10),;
			codpres n(9),lfecha c(10))
		If msalto = 1
			mwhere = 'codesp,codprest,fecha,hdesde'
			mif = 'mesp = mwkcurweb.codesp'
		Else
			mwhere = 'codesp,medico,codprest,fecha,hdesde'
			mif = 'mesp = mwkcurweb.codesp and mmed = mwkcurweb.medico'
		Endif
		Select mwkauxd
		Go top
		Select codesp,medico,codprest,ldia,transform(lfecha,"9999-99-99") as fecha,;
			transformf(hhmmdes) as hdesde,transform(lfecha,"9999-99-99") as fecha2,transformf(hhmmhas) as hhasta ;
			from mwkauxd order by &mwhere into cursor mwkcurweb

*!*		c:\desaguemes\mwkauxd

		Select mwkcurweb
		Go top

		mesp = mwkcurweb.codesp
		mmed = mwkcurweb.medico
		mcod = mwkcurweb.codprest
		mfec = mwkcurweb.fecha
		mdes = mwkcurweb.hdesde
		mhas = mwkcurweb.hhasta
		mdia = mwkcurweb.ldia

		Scan
			If &mif
				mpas = .t.
				If mwkcurweb.hhasta >= mhas and mwkcurweb.hdesde <= mhas and mcod = mwkcurweb.codprest
					mhas = mwkcurweb.hhasta
				Else
					If mwkcurweb.hdesde >= mdes and mwkcurweb.hhasta <= mhas and mcod = mwkcurweb.codprest
						mpas = .t.
					Else
						Insert into mwkconsuld (medico,codesp,diasem,hhmmdes,hhmmhas,codpres,lfecha) values ;
							(mmed,mesp,mdia,mdes,mhas,mcod,mfec)
						mesp = mwkcurweb.codesp
						mmed = mwkcurweb.medico
						mcod = mwkcurweb.codprest
						mfec = mwkcurweb.fecha
						mdes = mwkcurweb.hdesde
						mhas = mwkcurweb.hhasta
						mdia = mwkcurweb.ldia
						mpas = .f.
					Endif
				Endif
			Else
				Insert into mwkconsuld (medico,codesp,diasem,hhmmdes,hhmmhas,codpres,lfecha) values ;
					(mmed,mesp,mdia,mdes,mhas,mcod,mfec)
				mesp = mwkcurweb.codesp
				mmed = mwkcurweb.medico
				mcod = mwkcurweb.codprest
				mfec = mwkcurweb.fecha
				mdes = mwkcurweb.hdesde
				mhas = mwkcurweb.hhasta
				mdia = mwkcurweb.ldia
				mpas = .f.
			Endif
		Endscan
		If msalto = 1
			Select *,dow(ctod(lfecha)) as eldia from mwkconsuld order by codesp,lfecha,codpres into cursor mwkconsuld
			Select * from mwkconsuld order by codesp,eldia,codpres into cursor mwkconsuld
			Select mwkconsuld
			Go top
			Scan
				mc1 = mwkconsuld.lfecha
				mc3 = alltrim(mwkconsuld.hhmmdes)
				mc4 = alltrim(mwkconsuld.hhmmhas)
				mc5 = mwkconsuld.codpres
				mc6 = mwkconsuld.codesp
				mc7 = mwkconsuld.diasem
				mespec = alltrim(mc6)
				mprest = alltrim(str(mc5))
				meldia = alltrim(mc7)
				mfecha = mc1+' '+mc3
				mfech2 = mc1+' '+mc4

				mlinea3 = mespec+'|'+mprest+'|'+meldia+'|'+mfecha+'|'+mfech2+chr(13)+chr(10)
				Strtofile( mlinea3, "c:\temp\web\turno_especialidad.txt", .t. )
			Endscan
		Else
			Select *,dow(ctod(lfecha)) as eldia from mwkconsuld order by codesp,lfecha,medico,codpres into cursor mwkconsuld
			Select * from mwkconsuld order by codesp,eldia,medico,codpres into cursor mwkconsuld
			Select mwkconsuld
			Go top
			morden = 0
			Scan
				mc1 = mwkconsuld.lfecha
				mc2 = mwkconsuld.medico
				mc3 = alltrim(mwkconsuld.hhmmdes)
				mc4 = alltrim(mwkconsuld.hhmmhas)
				mc5 = mwkconsuld.codpres
				mc6 = mwkconsuld.codesp
				mc7 = mwkconsuld.diasem

				mmedic = alltrim(str(mc2))
				mespec = alltrim(mc6)
				mprest = alltrim(str(mc5))
				meldia = alltrim(mc7)
				mfecha = mc1+' '+mc3
				mfech2 = mc1+' '+mc4

				morden  = morden + 1
				mlorden = alltrim(str(morden))

				mlinea3 = mlorden+'|'+mespec+'|'+mmedic+'|'+mprest+'|'+meldia+'|'+mfecha+'|'+mfech2+chr(13)+chr(10)
				Strtofile( mlinea3, "c:\temp\web\turno_profesion.txt", .t. )
			Endscan
		Endif
	Endfor
Endif
Release vdatos
*!* Close databases
*!* = SQLDisconnect(mcon1)
*!* Messagebox("ARCHIVOS TXT, TURNOS ELABORADOS",48,"WEB")
	Set date to DMY
	Set MARK TO '/'

Return
*
Function transformf( mhora1 )
mhora0 = alltrim(str(mhora1))
mhora2 = len(mhora0)
Do case
Case mhora2 = 1
	mretorno = "00:00:0"+mhora0
Case mhora2 = 3
	mretorno = "0"+left(mhora0,1)+":"+right(mhora0,2)+":00"
Case mhora2 = 4
	mretorno = left(mhora0,2)+":"+right(mhora0,2)+":00"
Otherwise
	If mhora2 > 4
		If mhora2 = 6
			mretorno = left(mhora0,2)+":"+substr(mhora0,3,2)+":"+right(mhora0,2)
		Else && 5
			mretorno = "0"+left(mhora0,1)+":"+substr(mhora0,2,2) +":"+right(mhora0,2)
		Endif
	Else && 2
		mretorno = "00:00:"+mhora0
	Endif
Endcase
Return mretorno
