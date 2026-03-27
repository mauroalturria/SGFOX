*
* Calculo de turnos franjas horarias para cursor web, a partir de fecha desde
*
lparameters mfechad

if vartype(mfechad)#"D"
	mfechad = sp_busco_fecha_serv("DD") + 28
endif

wait "GENERANDO TABLA DE TURNOS WEB, AGUARDE UNOS MINUTOS" windows nowait

mfechah = mfechad + 6

dimension vdatos[48,2]

if used('mwkconsul')
	use in mwkconsul
endif

mfecini = mfechad - 1
mdias   = mfechah - mfechad + 1

create cursor mwkconsulf;
	(codesp c(4),medico n(9),codprest n(9),diasem n(1),hhmmdes n(6),hhmmhas n(6),ldia c(10),lfecha D) && Agregado

for mid = 1 to mdias

	if used('mwkaux0')
		use in mwkaux0
	endif
	mfecha = mfecini + mid
	mdia   = dow(mfecha)
	mret=sqlexec(mcon1,"SELECT * from franjahoraria "+;
		" where diasem=?mdia  and fecvigend<=?mfecha and fecvigenh>?mfecha "+;
		" and fecvigend <> fecvigenh and tipoturno = 0 ","mwkfranjahora1")

	mret = sqlexec(mcon1,"select nombre,diasem,sala,hdesde1,hhasta1,"+;
		"fecvigend,fecvigenh,generaagen,hhmmdes,hhmmhas,medpresta.codesp,"+;
		"ESP_descripcion,prestadores.id,codprest,medpresta.codmed as codmedp " +;
		"from medpresta,prestadores,especialid,prestacions " + ;
		"where medpresta.codmed=prestadores.id and " + ;
		"prestacions.PRE_codprest=medpresta.codprest and prestacions.PRE_WebTurnos='S' and "+;
		"medpresta.diasem=?mdia and medpresta.codesp=ESP_codesp and " + ;
		"medpresta.fecvigend<=?mfecha and medpresta.fecvigenh>?mfecha " + ;
		"and (estado=1 or fecpasiva>?mfecha) and medpresta.fecvigend<>medpresta.fecvigenh " +;
		"and hhmmdes>=5 and diasem<>null "+;
		"group by codmed,medpresta.codesp,diasem,sala,hhmmdes,hhmmhas,generaagen,codprest " + ;
		"order by codmed,medpresta.codesp,hhmmdes,hhmmhas,fecvigend,fecvigenh,codprest", "mwkaux0")

	select a.* from mwkaux0 as a,mwkfranjahora1 as f ;
		where a.codmedp = f.codmed and a.diasem = f.diasem and a.hhmmdes = f.hhmmdes ;
		and a.hhmmhas = f.hhmmhas and a.fecvigend >= f.fecvigend and a.fecvigenh <= f.fecvigenh ;
		group by a.codmedp,a.codesp,a.diasem,a.sala,a.hhmmdes,a.hhmmhas,a.generaagen,a.codprest  ;
		into cursor mwkaux00

	if used('mwkauxturnos')
		use in mwkauxturnos
	endif

	mret = sqlexec(mcon1,"select codmed,fechatur " + ;
		"from turnos where fechatur=?mfecha and tipoturno = 0 "+;
		"group by codmed,fechatur","mwkauxturnos")
	if mret < 0
		= aerr(eros)
		do prg_error with eros,'TURNOS WEB'
	endif
	if used('mwkaux')
		use in mwkaux
	endif
	select * from mwkaux00 left join mwkauxturnos on id=codmed into cursor mwkaux
	if used('mwkauxf')
		use in mwkauxf
	endif
	select codesp,id,codprest,diasem,hhmmdes,hhmmhas,fechatur from mwkaux ;
		order by codesp,diasem,codprest,hhmmdes into cursor mwkauxf
	select mwkauxf
	go top
	scan
		mtur = nvl(mwkauxf.fechatur,ctod('  /  /    '))
		if mwkauxf.fechatur <> ctod('  /  /    ')
			mesp = mwkauxf.codesp
			mmed = mwkauxf.id
			mpre = mwkauxf.codprest
			mdia = mwkauxf.diasem
			mdes = mwkauxf.hhmmdes
			mhas = mwkauxf.hhmmhas
			mdiac = iif(mwkauxf.diasem=2,"Lunes" ,iif(mwkauxf.diasem=3,"Martes" ,iif(mwkauxf.diasem=4,"Miercoles",;
				iif(mwkauxf.diasem=5,"Jueves",iif(mwkauxf.diasem=6,"Viernes",iif(mwkauxf.diasem=7,"Sabado","Domingo"))))))

			insert into mwkconsulf (codesp,medico,codprest,diasem,hhmmdes,hhmmhas,lfecha,ldia) ;
				values (mesp,mmed,mpre,mdia,mdes,mhas,mtur,mdiac)
		endif
	endscan
next

if reccount('mwkconsulf')>0
	if used('mwkauxd')
		use in mwkauxd
	endif
*	Select * from mwkconsulf into table mwkauxd
	select * from mwkconsulf into cursor mwkauxd

	if used('mwkauxd2')
		use in mwkauxd2
	endif

	if used('mwkcurweb')
		use in mwkcurweb
	endif

	if used('mwkcurweb2')
		use in mwkcurweb2
	endif

	if file('c:\temp\web\turno_especialidad.txt')
		delete file c:\temp\web\turno_especialidad.txt
	endif
	if file('c:\temp\web\turno_profesion.txt')
		delete file c:\temp\web\turno_profesion.txt
	endif

	set century on
	set date to YMD
	set mark to '-'

	for msalto = 1 to 2
		if used('mwkconsuld')
			use in mwkconsuld
		endif
		create cursor mwkconsuld (medico n(9),codesp c(4),diasem c(10),hhmmdes c(10),hhmmhas c(10),;
			codpres n(9),lfecha c(10))
		if msalto = 1
			mwhere = 'fecha,codprest,hdesde,medico'
			mif = 'mfec = mwkcurweb.fecha and mcod = mwkcurweb.codprest '
		else
			mwhere = 'fecha,codprest,medico,hdesde'
			mif = 'mfec = mwkcurweb.fecha and mcod = mwkcurweb.codprest and mmed = mwkcurweb.medico  '
		endif
		select mwkauxd
		go top
		select codesp,medico,codprest,ldia,transform(lfecha,"9999-99-99") as fecha,;
			transform(hhmmdes,"@L 99:99:00") as hdesde,transform(lfecha,"9999-99-99") as fecha2,;
			transform(hhmmhas,"@L 99:99:00") as hhasta ;
			from mwkauxd order by &mwhere into cursor mwkcurweb

		select mwkcurweb
		go top

		mesp = mwkcurweb.codesp
		mmed = mwkcurweb.medico
		mcod = mwkcurweb.codprest
		mfec = mwkcurweb.fecha
		mdes = mwkcurweb.hdesde
		mhas = mwkcurweb.hhasta
		mdia = mwkcurweb.ldia

		scan
			if &mif
				mpas = .t.
				if mwkcurweb.hhasta >= mhas and mwkcurweb.hdesde <= mhas and mcod = mwkcurweb.codprest
					mhas = mwkcurweb.hhasta
				else
					if mwkcurweb.hdesde >= mdes and mwkcurweb.hhasta <= mhas and mcod = mwkcurweb.codprest
						mpas = .t.
					else
						insert into mwkconsuld (medico,codesp,diasem,hhmmdes,hhmmhas,codpres,lfecha) values ;
							(mmed,mesp,mdia,mdes,mhas,mcod,mfec)
						mesp = mwkcurweb.codesp
						mmed = mwkcurweb.medico
						mcod = mwkcurweb.codprest
						mfec = mwkcurweb.fecha
						mdes = mwkcurweb.hdesde
						mhas = mwkcurweb.hhasta
						mdia = mwkcurweb.ldia
						mpas = .f.
					endif
				endif
			else
				insert into mwkconsuld (medico,codesp,diasem,hhmmdes,hhmmhas,codpres,lfecha) values ;
					(mmed,mesp,mdia,mdes,mhas,mcod,mfec)
				mesp = mwkcurweb.codesp
				mmed = mwkcurweb.medico
				mcod = mwkcurweb.codprest
				mfec = mwkcurweb.fecha
				mdes = mwkcurweb.hdesde
				mhas = mwkcurweb.hhasta
				mdia = mwkcurweb.ldia
				mpas = .f.
			endif
		endscan
		if msalto = 1
			select *,dow(ctod(lfecha)) as eldia from mwkconsuld order by codesp,lfecha,codpres into cursor mwkconsuld
			select * from mwkconsuld order by codesp,eldia,codpres into cursor mwkconsuld
			select mwkconsuld
			go top
			scan
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
				strtofile( mlinea3, "c:\temp\web\turno_especialidad.txt", .t. )
			endscan
		else
			select *,dow(ctod(lfecha)) as eldia from mwkconsuld order by codesp,lfecha,medico,codpres into cursor mwkconsuld
			select * from mwkconsuld order by codesp,eldia,medico,codpres into cursor mwkconsuld
			select mwkconsuld
			go top
			morden = 0
			scan
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
				strtofile( mlinea3, "c:\temp\web\turno_profesion.txt", .t. )
			endscan
		endif
	endfor
endif
release vdatos
set date to dmy
set mark to '/'
return
