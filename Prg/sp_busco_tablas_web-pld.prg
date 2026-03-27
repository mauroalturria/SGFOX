*
* Elaboración TXT web
*

*!*	Public mcon1,mcon2,mcon3
*!*	Close databases
*!*	Set DATE TO FRENCH
*!*	Set CENTURY ON
*!*	Set SYSMENU TO
*!*	Set EXCLUSIVE OFF
*!*	Set DECIMALS TO 0
*!*	Set MULTILOCKS ON
*!*	Set NOTIFY OFF
*!*	Set CPDIALOG OFF
*!*	Set SAFETY OFF
*!*	mcon1 = SQLCONNECT("conec01")
Wait "ACTUALIZANDO TABLAS WEB, AGUARDE UNOS MINUTOS" Windows Nowait	
If used('mwkespe')
	Use in mwkespe
Endif
mret = sqlexec(mcon1,"select esp_codesp,esp_descripcion,esp_medinterna,esp_matinfantil,esp_clinquir,"+;
	"esp_diagtratamiento "+;
	"from especialid where ESP_Web = 'S' order by esp_codesp","mwkespe")
If mret > 0
	If file('c:\temp\web\especialidad.txt')
		Delete file c:\temp\web\especialidad.txt
	Endif
	If file('c:\temp\web\areas_especialidad.txt')
		Delete file c:\temp\web\areas_especialidad.txt
	Endif
	If used('mwkespe')
		Select mwkespe
		Go top
		If reccount('mwkespe')>0
			Scan
				mcod = mwkespe.esp_codesp
				mdes = mwkespe.esp_descripcion
				mlinea = ''
				mlinea = alltrim(mcod)+'|'+alltrim(mdes)+chr(13)+chr(10)
				Strtofile( mlinea, "c:\temp\web\especialidad.txt", .t. )
				If mwkespe.esp_medinterna = 'S'
					mlinea = ''
					mlinea = '1'+'|'+alltrim(mcod)+chr(13)+chr(10)
					Strtofile( mlinea, "c:\temp\web\areas_especialidad.txt", .t. )
				Endif
				If mwkespe.esp_matinfantil = 'S'
					mlinea = ''
					mlinea = '2'+'|'+alltrim(mcod)+chr(13)+chr(10)
					Strtofile( mlinea, "c:\temp\web\areas_especialidad.txt", .t. )
				Endif
				If mwkespe.esp_clinquir = 'S'
					mlinea = ''
					mlinea = '3'+'|'+alltrim(mcod)+chr(13)+chr(10)
					Strtofile( mlinea, "c:\temp\web\areas_especialidad.txt", .t. )
				Endif
				If mwkespe.esp_diagtratamiento = 'S'
					mlinea = ''
					mlinea = '4'+'|'+alltrim(mcod)+chr(13)+chr(10)
					Strtofile( mlinea, "c:\temp\web\areas_especialidad.txt", .t. )
				Endif
			Endscan
		Endif
		Use in mwkespe
	Endif
Endif
If file('c:\temp\web\prestacion.txt')
	Delete file c:\temp\web\prestacion.txt
Endif
If used('mwkpresta')
	Use in mwkpresta
Endif
*!*	mret = sqlexec(mcon1,"select pre_codprest,pre_descriprest,pre_codservicio,pre_especialidad,"+;
*!*		"CAST( (case when PRE_WebTurnos = 'S' then 1 else 0 end) as int) as turno,Tabmensaje.mensaje as msg "+;
*!*		"from prestacions "+;
*!*		"left join Tabmensaje on codprest=pre_codprest and web='S' " +;
*!*		"left join Tabmensaje on codesp=pre_especialidad and web='S' "+;
*!*		"left join Tabmensaje on codserv=pre_codservicio and web='S' " +;
*!*		"where PRE_fechapasiva is null "+;
*!*		"and PRE_Web = 'S' or PRE_WebTurnos = 'S' "+;
*!*	    "group by pre_codprest "+;
*!*		"order by pre_codprest","mwkpresta")
mret = sqlexec(mcon1,"select pre_codprest,pre_descriprest,pre_codservicio,pre_especialidad,"+;
	"CAST( (case when PRE_WebTurnos = 'S' then 1 else 0 end) as int) as turno,Tabmensaje.mensaje as msg"+;
	" from prestacions"+;
	" left join Tabmensaje on Tabmensaje.codservm = prestacions.pre_codservicio and"+;
	" tabmensaje.web='S'"+;
	" where PRE_fechapasiva is null"+;
	" and PRE_Web = 'S' or PRE_WebTurnos = 'S'"+;
	" order by pre_codprest","mwkpresta")
If mret > 0
	If used('mwkpresta')
		Select mwkpresta
		Go top
		If reccount('mwkpresta')>0
			Scan
				mcod = alltrim(transform(mwkpresta.pre_codprest,"999999999999"))
				mdes = alltrim(mwkpresta.pre_descriprest)
				mtur = transform(mwkpresta.turno,"9")
				mmsg = iif(mwkpresta.turno=1,'Para solicitar un turno a través de la web, para esta práctica haga click'+;
					' sobre la misma',nvl(alltrim(mwkpresta.msg),'.'))
				mlinea = ''
				mlinea = mcod+'|'+mdes+'|'+mtur+'|'+mmsg+chr(13)+chr(10)
				Strtofile( mlinea, "c:\temp\web\prestacion.txt", .t. )
			Endscan
		Endif
		Use in mwkpresta
	Endif
Else
	= aerror(merror)
	Messagebox(merror(1))
Endif

If file('c:\temp\web\empresas.txt')
	Delete file c:\temp\web\empresas.txt
Endif
If used('mwkempre')
	Use in mwkempre
Endif
mret = sqlexec(mcon1,"select distinct ENT_codent,ENT_sigla,ENT_desccomp,ENT_DIRENT,ENT_localent,ENT_url,ENT_email,"+;
	"case when max(ENT_turnosweb)='Y' then 1 else 0 end as ent_turnosweb,"+;
	"case when max(ENT_web)='Y' then 1 else 0 end as ent_web "+;
	"from SQLUser.ENTIDADES "+;
	"where ent_desccomp <> ' ' and ( ENT_turnosweb = 'Y' or ENT_web = 'Y' ) "+;
	"group by ent_sigla "+;
	"order by ENT_desccomp","mwkempre")
If mret > 0
	If used('mwkempre')
		Select mwkempre
		Go top
		If reccount('mwkempre')>0
*!*         saco el '.' por ' '
			Scan
				mcod1 = mwkempre.ENT_codent
				msig1 = nvl(mwkempre.ENT_sigla,' ')
				mdes1 = nvl(mwkempre.ENT_desccomp,' ')
				mdir1 = nvl(mwkempre.ENT_dirent,' ')
				mloc1 = nvl(mwkempre.ENT_localent,' ')
				murl1 = nvl(mwkempre.ENT_url,' ')
				mail1 = nvl(mwkempre.ENT_email,' ')
				mtur1 = nvl(mwkempre.ENT_turnosweb,' ')
				mweb1 = nvl(mwkempre.ENT_web,' ')
				mcod = iif(len(alltrim(str(mcod1)))>0,alltrim(str(mcod1)),' ')
				msig = iif(len(alltrim(msig1))>0,alltrim(msig1),' ')
				mdes = iif(len(alltrim(mdes1))>0,alltrim(mdes1),' ')
				mdir = iif(len(alltrim(mdir1))>0,alltrim(mdir1),' ')
				mloc = iif(len(alltrim(mloc1))>0,alltrim(mloc1),' ')
				murl = iif(len(alltrim(murl1))>0,alltrim(murl1),' ')
				Mail = iif(len(alltrim(mail1))>0,alltrim(mail1),' ')
				mtur = iif(len(alltrim(mtur1))>0,alltrim(mtur1),' ')
				mweb = iif(len(alltrim(mweb1))>0,alltrim(mweb1),' ')
				mlinea = ''
				mlinea = mcod+'|'+msig+'|'+mdes+'|'+mdir+'|'+mloc+'|'+murl+'|'+mail+'|'+mtur+'|'+mweb+chr(13)+chr(10)
				Strtofile( mlinea, "c:\temp\web\empresas.txt", .t. )
			Endscan
		Endif
		Use in mwkempre
	Endif
Endif
Dimension varea[4]
varea[1]='Medicina Interna'
varea[2]='Materna Infantil'
varea[3]='Cirugía'
varea[4]='Diagnóstico y Tratamiento'
If file('c:\temp\web\areas.txt')
	Delete file c:\temp\web\areas.txt
Endif
For mi = 1 to 4
	mlinea = ''
	mlinea = transform(mi,"9")+'|'+alltrim(varea[mi])+chr(13)+chr(10)
	Strtofile( mlinea, "c:\temp\web\areas.txt", .t. )
Endfor
If file('c:\temp\web\cargos.txt')
	Delete file c:\temp\web\cargos.txt
Endif
If used('mwkcargo')
	Use mwkcargo
Endif
mret = sqlexec(mcon1,"select * from TabCargo","mwkcargo")
If mret > 0
	If used('mwkcargo')
		Select mwkcargo
		Go top
		If reccount('mwkcargo')>0
			Scan
				mlinea1 = alltrim(str(mwkcargo.id))+'|'+alltrim(mwkcargo.descrip)+;
					'|'+alltrim(str(mwkcargo.destacado))+'|'+alltrim(str(mwkcargo.nivel))+chr(13)+chr(10)
				Strtofile( mlinea1, "c:\temp\web\cargos.txt", .t. )
			Endscan
		Endif
		Use in mwkcargo
		For mip = 1 to 2
			If mip = 1
				mlinea1 = '100'+'|'+'Dirección Administrativa'+'|'+'0'+'|'+'0'+chr(13)+chr(10)
			Else
				mlinea1 = '101'+'|'+'Dirección Medica'+'|'+'0'+'|'+'0'+chr(13)+chr(10)
			Endif
			Strtofile( mlinea1, "c:\temp\web\cargos.txt", .t. )
		Endfor
	Endif
Else
	Messagebox("EN ARMADO DEL CURSOR CARGOS",16,"ERROR")
Endif

*!*	hConn = Sqlstringconnect("Driver=MySQL ODBC 3.51 Driver;Server=172.16.2.101;UID=malturria;PWD=mauro;Database=prueba")
*!*	=SQLSETPROP(hConn,"Transactions",2)
*!*	=SQLSETPROP(hConn,"Asynchronous",.F.)

If used('mwkcontenido')
	Use in mwkcontenido
Endif
If used('mwkexporta')
	Use in mwkexporta
Endif
If file('c:\temp\web\contenido.txt')
	Delete file c:\temp\web\contenido.txt
Endif
mret = sqlexec(hConn,"select * from contenido","mwkcontenido")
If mret > 0
	Select transform(id,"999999") as idcod,titulo,especialidad,descripcion,transform(seccion,"9") as idsec,transform(orden,"9") as idord ;
		from mwkcontenido into cursor mwkexporta
	Select mwkexporta
	Go top
	Scan
		mmemo = STRTRAN(mwkexporta.descripcion, chr(13), '<br>')
		mlines = alines(mvec,mmemo,.t.)
		mtexto = ''
		For mi = 1 to mlines
			mtexto = mtexto + alltrim(mvec[mi]) + ' '
		Endfor
		mc1 = alltrim(mwkexporta.idcod)
		mc2 = alltrim(mwkexporta.titulo)
		mc3 = alltrim(mtexto)
		mc4 = mwkexporta.especialidad
		mc5 = mwkexporta.idsec
		mc6 = mwkexporta.idord
		mlinea = ''
		mlinea = mlinea +mc1+'|'+mc2+'|'+mc3+'|'+mc4+'|'+mc5+'|'+mc6+chr(13)+chr(10)
		Strtofile( mlinea, "c:\temp\web\contenido.txt", .t. )
	Endscan
	If used('mwkexporta')
		Use in mwkexporta
	Endif
	If used('mwkcontenido')
		Use in mwkcontenido
	Endif
Endif
mpaso = .f.
If used('mwkpresta')
	Use in mwkpresta
Endif

*!*	*!* mret = sqlexec(hConn,"select * from prestadores","mwkpresta")
*!*	*mret = sqlexec(mcon1,"select *,id as iDmedico,codesp as codiEsp from prestadores","mwkpresta")

mret = sqlexec(mcon1,"select prestadores.id as iDmedico,prestadores.nombre,"+;
	"tabprofesp.codiesp,prestadores.emailcorp,especialid.esp_descripcion,"+;
	"tabprofesp.CodCargo,tabcargo.descrip,prestadores.fecaltap,prestadores.fecpas"+;
	"ivap,prestadores.emailcorp,prestadores.codprof,prestadores.sexo,prestadores.codesp as codiEsp"+;
	" from prestadores"+;
	" left join TabProfEsp on prestadores.id = tabprofesp.codprof"+;
	" left join tabcargo on tabprofesp.codcargo = tabcargo.id"+;
	" left join especialid on tabprofesp.codiesp = especialid.esp_codesp"+;
	" where"+;
	" ((dambula = 1 and (prestadores.fecpasiva='1900-01-01' or prestadores.fecpasiva > current_date)"+;
	" and (prestadores.fecalta <= current_date )) or"+;
	" (dguardia = 1 and (prestadores.fecpasivag='1900-01-01' or prestadores.fecpasivag > current_date)"+;
	" and (prestadores.fecaltag <= current_date )) or"+;
	" (dinterna = 1 and (prestadores.fecpasivai='1900-01-01' or prestadores.fecpasivai > current_date)"+;
	" and (prestadores.fecaltai <= current_date )) or"+;
	" (prestadores.fecaltap <= current_date ))"+;
	" and (prestadores.fecpasivap='1900-01-01' or  prestadores.fecpasivap > current_date)"+;
	" and codiesp is not null and codcargo is not null"+;
	" and esp_descripcion is not null"+;
	" and PRESTADORES.web = 'S'"+;
	" and especialid.ESP_Web = 'S'"+;
	" order by prestadores.id,ESP_descripcion,tabprofesp.CodCargo,nombre","mwkpresta")

*!*	" (( dambula = 1 and (prestadores.fecpasiva='1900-01-01' or prestadores.fecpasiva > current_date))"+;
*!*	" or ( dguardia = 1 and (prestadores.fecpasivag='1900-01-01' or prestadores.fecpasivag > current_date))"+;
*!*	" or ( dinterna = 1 and (prestadores.fecpasivai='1900-01-01' or prestadores.fecpasivai > current_date))"+;
*!*	" or (prestadores.fecpasivap='1900-01-01' or  prestadores.fecpasivap > current_date)"+;
*!*	" or (prestadores.fecalta >= current_date ) )"+;
*!*	" and codiesp is not null and codcargo is not null"+;
*!*	" and esp_descripcion is not null"+;
*!*	" and PRESTADORES.web = 'S'"+;
*!*	" and especialid.ESP_Web = 'S'"+;
*!*	" order by prestadores.id,ESP_descripcion,tabprofesp.CodCargo,nombre","mwkpresta")
*!* *!* " group by prestadores.id"+;
*!*	select mwkpresta
*!*	go top
*!*	brow

If mret >0
	If used('mwkcoord1')
		Use in mwkcoord1
	Endif
	mret = sqlexec(hConn,"select * from TabCoord order by TCO_especialidad","mwkcoord1")
	If mret > 0
		If used('mwkcoord2')
			Use in mwkcoord2
		Endif
		mret = sqlexec(hConn,"select * from TabSubCoord order by TSO_especialidad","mwkcoord2")
		If mret > 0
			mpaso = .t.
		Endif
	Endif
Endif
If mpaso
	If file('c:\temp\web\personas.txt')
		Delete file c:\temp\web\personas.txt
	Endif
	If file('c:\temp\web\personas_cargo.txt')
		Delete file c:\temp\web\personas_cargo.txt
	Endif
	If used('mwkexporta')
		Use in mwkexporta
	Endif
	If used('mwkexporta1')
		Use in mwkexporta1
	Endif
	Select * from mwkpresta left join mwkcoord1 on IDmedico = TCO_idMed left join ;
		mwkcoord2 on IDmedico = TSO_idMed order by IDmedico ;
		group by codiEsp,CodCargo,IDmedico into cursor mwkexporta1

	Select * from mwkexporta1 group by IDmedico into cursor mwkexporta
	Scan
*!*			If (mwkexporta.TCO_registro <> 'REG0035' and mwkexporta.TCO_registro <> 'REG0036' and ;
*!*					mwkexporta.TCO_registro <> 'REG0009' and mwkexporta.TCO_registro <> 'REG0027') or ;
*!*					( nvl(mwkexporta.TCO_registro,'1')='1' )

		midmed = alltrim(transform(mwkexporta.IDmedico,"999999"))
		mbusid = mwkexporta.IDmedico
		mbusca = 0
		If used('mwkprestaM')
			Use in mwkprestaM
		Endif
		mret = sqlexec(mcon1,"select * from prestadores where id=?mbusid","mwkprestaM")
		If mret > 0
			If used('mwkprestaM')
				If reccount('mwkprestaM')>0
					Select mwkprestaM
					Go top
					mbusca = mwkprestaM.codprof
					mlsexo = mwkprestaM.sexo
					memail = alltrim(nvl(mwkprestaM.emailcorp,'')) && '.'
				Endif
			Endif
		Endif
		If used('mwkprotit')
			Use in mwkprotit
		Endif
*!*     mret = sqlexec(hConn,"select * from TabProfesion where id=?mbusca","mwkprotit")
		mret = sqlexec(mcon1,"select * from TabProfesion where id=?mbusca","mwkprotit")
		If mret > 0
			If used('mwkprotit')
				If reccount('mwkprotit')>0
					If mlsexo = 'M' &&mwkexporta.sexo = 'M'
						mltitulo = alltrim(mwkprotit.titulo)
					Else
						mltitulo = alltrim(mwkprotit.titulof)
					Endif
				Endif
			Endif
		Endif
		If mbusca>0
			mnombr = mltitulo+' '+alltrim(mwkexporta.nombre)
		Else
			mnombr = mltitulo+' '+alltrim(mwkexporta.nombre)
		Endif	
		If nvl(mwkexporta.TSO_registro,'0') <> '0'	
*!**!*      memail = alltrim(nvl(mwkexporta.TSO_email,'.'))
			mv1 = alltrim(nvl(mwkexporta.TSO_actividad2  ,'')) && '.'
			mv2 = alltrim(nvl(mwkexporta.TSO_actlab      ,'')) && '.'
			mv3 = alltrim(nvl(mwkexporta.TSO_organismos  ,'')) && '.'
			mv4 = alltrim(nvl(mwkexporta.TSO_formacion   ,'')) && '.'
			mv5 = alltrim(nvl(mwkexporta.TSO_investiga   ,'')) && '.'
			mv6 = alltrim(nvl(mwkexporta.TSO_cursos      ,'')) && '.'
			mv7 = alltrim(nvl(mwkexporta.TSO_docente     ,'')) && '.'
			mv8 = alltrim(nvl(mwkexporta.TSO_especialidad,'')) && '.'
		Else
*!**!*         memail = alltrim(nvl(mwkexporta.TCO_email,'.'))
			mv1 = alltrim(nvl(mwkexporta.TCO_actividad2  ,'')) && '.'
			mv2 = alltrim(nvl(mwkexporta.TCO_actlab      ,'')) && '.'
			mv3 = alltrim(nvl(mwkexporta.TCO_organismos  ,'')) && '.'
			mv4 = alltrim(nvl(mwkexporta.TCO_formacion   ,'')) && '.'
			mv5 = alltrim(nvl(mwkexporta.TCO_investiga   ,'')) && '.'
			mv6 = alltrim(nvl(mwkexporta.TCO_cursos      ,'')) && '.'
			mv7 = alltrim(nvl(mwkexporta.TCO_docente     ,'')) && '.'
			mv8 = alltrim(nvl(mwkexporta.TCO_especialidad,'')) && '.'	
		Endif
		mv1a = iif(len(alltrim(mv1))>1,mv1,'') && '.'
		mv1  = mv1a
		mv1a = strtran(mv1 ,chr(10),'')
		mv1b = strtran(mv1a,chr(13),'<br>')
		mv1  = mv1b

		mv2a = iif(len(alltrim(mv2))>1,mv2,'') && '.'
		mv2  = mv2a
		mv2a = strtran(mv2 ,chr(10),'')
		mv2b = strtran(mv2a,chr(13),'<br>')
		mv2  = mv2b

		mv3a = iif(len(alltrim(mv3))>1,mv3,'') && '.'
		mv3  = mv3a
		mv3a = strtran(mv3 ,chr(10),'')
		mv3b = strtran(mv3a,chr(13),'<br>')
		mv3  = mv3b

		mlinea1 = ''

		If len(alltrim(mv1))>1
			mlinea1 = mlinea1+'En esta Institución :<br>'+mv1
		Endif
		If len(alltrim(mv2))>1
			mlinea1 = mlinea1+'<br>Asistencial y Laboral :<br>'+mv2
		Endif
		If len(alltrim(mv3))>1
			mlinea1 = mlinea1+'<br>En Organismos Científicos :<br>'+mv3
		Endif

		mlinea1a = strtran(mlinea1,'|','')

		mlinea1 = mlinea1a

		mv4a = iif(len(alltrim(mv4))>1,mv4,'') && '.'
		mv4  = mv4a
		mv4a = strtran(mv4 ,chr(10),'')
		mv4b = strtran(mv4a,chr(13),'<br>')
		mv4  = mv4b
		mv5a = iif(len(alltrim(mv5))>1,mv5,'') && '.'
		mv5  = mv5a
		mv5a = strtran(mv5 ,chr(10),'')
		mv5b = strtran(mv5a,chr(13),'<br>')
		mv5  = mv5b
		mv6a = iif(len(alltrim(mv6))>1,mv6,'') && '.'
		mv6  = mv6a
		mv6a = strtran(mv6 ,chr(10),'')
		mv6b = strtran(mv6a,chr(13),'<br>')
		mv6  = mv6b
		mv7a = iif(len(alltrim(mv1))>1,mv7,'') && '.'
		mv7  = mv7a
		mv7a = strtran(mv7 ,chr(10),'')
		mv7b = strtran(mv7a,chr(13),'<br>')
		mv7  = mv7b

		mlinea2 = midmed+'|'+mnombr+'|'+memail+'|'+mlinea1 +'|'+mv4+'|'+mv5+'|'+mv6+'|'+mv7+chr(13)+chr(10)

		Strtofile( mlinea2, "c:\temp\web\personas.txt", .t. )

*!*		Endif
	Endscan

	For mip = 1 to 2
		If mip = 1
			midmed = '5000'
			mnombr = 'Dr. GUTSZTAT JORGE'
			memail = 'direccion@silver-cross.com.ar'
		Else
			midmed = '5001'
			mnombr = 'Dr. PEZZELLA HECTOR'
			memail = 'direccion@silver-cross.com.ar'
		Endif
		mlinea1 = ''
		mv4  = ''
		mv5  = ''
		mv6  = ''
		mv7  = ''
		mlinea2 = midmed+'|'+mnombr+'|'+memail+'|'+mlinea1 +'|'+mv4+'|'+mv5+'|'+mv6+'|'+mv7+chr(13)+chr(10)
		Strtofile( mlinea2, "c:\temp\web\personas.txt", .t. )
	Endfor

	Select mwkexporta1
	Go top
	Scan
*!*			If (mwkexporta1.TCO_registro <> 'REG0035' and mwkexporta1.TCO_registro <> 'REG0036' and ;
*!*					mwkexporta1.TCO_registro <> 'REG0009' and mwkexporta1.TCO_registro <> 'REG0027') or ;
*!*					( nvl(mwkexporta1.TCO_registro,'1')='1' )
		midmed = alltrim(transform(mwkexporta1.IDmedico,"999999"))
		mcargo = alltrim(transform(mwkexporta1.CodCargo,"9999"))
		mv8    = alltrim(mwkexporta1.codiEsp)

		mlinea3 = midmed+'|'+mcargo+'|'+mv8+chr(13)+chr(10)
		Strtofile( mlinea3, "c:\temp\web\personas_cargo.txt", .t. )
*!*			Endif
	Endscan
	For mip = 1 to 2
		mv8 = 'CLIN'
		If mip = 1
			midmed = '5000'
			mcargo = '100'
*!*			mnombr = 'Dr. GUTSZTAT JORGE'
		Else
			midmed = '5001'
			mcargo = '101'
*!*			mnombr = 'Dr. PEZZELLA HECTOR'
		Endif
		mlinea3 = midmed+'|'+mcargo+'|'+mv8+chr(13)+chr(10)
		Strtofile( mlinea3, "c:\temp\web\personas_cargo.txt", .t. )
	Endfor
	If used('mwkexporta')
		Use in mwkexporta
	Endif
	If used('mwkexporta1')
		Use in mwkexporta1
	Endif
	If used('mwkpresta')
		Use in mwkpresta
	Endif
	If used('mwkcoord1')
		Use in mwkcoord1
	Endif
	If used('mwkcoord2')
		Use in mwkcoord2
	Endif
Else
	Messagebox("EN ARMADO DE ARCHIVO PERSONAS",16,"ERROR")
Endif

*!*	Close databases
*!*	= SQLDisconnect(mcon1)
*!*	= SQLDisconnect(hConn)
*!* Messagebox("ARCHIVOS TXT, TABLAS ELABORADOS",48,"WEB")

Return
