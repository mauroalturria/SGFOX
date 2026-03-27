Parameters registracion,idmedico,entidad,dni,idambula,cie,origen

* prg_turnos_web 2022/11/23

lpaciente = registracion
lmedico = idmedico
lentidad = entidad
ldni = dni
lidambula = idambula
lcie = cie
lorigen = origen


mccon = ''
mccon = Left(SQLGetprop(mcon1,'ConnectString'),80)

Do Case
Case  (".190" $ mccon) && Desarrollo 190
	murl = "https://desa.sg.com.ar/intranet/lanzador/prog/wambdev/turnos_visual.php" && Desarrollo
Case  (".50.110" $ mccon) && Desarrollo 50.110
	murl = "https://desa.sg.com.ar/intranet/lanzador/prog/wambdev/turnos_visual.php" && Desarrollo
Case  (".50.102" $ mccon) && QAS 50.102
	murl = "https://profesionalqas.sg.com.ar/intranet/lanzador/prog/wamb/turnos_visual.php" && Desarrollo
Otherwise  && Producción
	murl = "https://profesional.sg.com.ar/intranet/lanzador/prog/wamb/turnos_visual.php" && Producción
Endcase

*Paciente
mv1 = Alltrim(Str(lpaciente))
mv2 = Alltrim(Str(lentidad))
mv3 = Alltrim(Str(lidambula))
mv4 = Alltrim(Str(ldni))
mv5 = ''

* Datos del Medico / Validación del Medico si es fuera del ambito 1
If mxambito = 1
	lcSql = 'select * from tabusuario where idcodmed = ?lmedico'
	If !Prg_EjecutoSql(lcSql,"mwkMedico","")
		Return .F.
	Endif
	If !Used('mwkMedico')
		Messagebox('Problemas al buscar datos del médico en Ambito 1',48,'Aviso')
		Return .F.
	Endif
	If !Reccount('mwkMedico')>0
		Messagebox('No hay datos del médico en Ambito 1',48,'Aviso')
		Return .F.
	Endif
Else
	lcSql = 'select Nvl(DNI,0) AS DNI from PRESTADORES where ID = ?lmedico'
	If !Prg_EjecutoSql(lcSql,"mwkPresta","")
		Return .F.
	Endif
	If mwkPresta.dni=0
		Messagebox('PRESTADOR SIN DOCUMENTO',48,'Aviso')
		Return .F.
	Endif
	lcSql = "select * from tabusuario where nrodocumento = ?mwkPresta.DNI and fecpasiva = '1900-01-01' "
	If !Prg_EjecutoSql(lcSql,"mwkMedico","")
		Return .F.
	Endif
	If !Used('mwkMedico')
		Messagebox('Problemas al buscar datos del médico (mwkMedico)',48,'Aviso')
		Return .F.
	Endif
	If !Reccount('mwkMedico')>0
		Messagebox('No hay datos del médico',48,'Aviso')
		Return .F.
	Endif
Endif

* -----------------

*!*	If mxambito = 1
*!*	lcSql = 'select * from tabusuario where idcodmed = ?medico'
*!*	Else
*!*	lcSql = 'select * from prestadores where id = ?medico'
*!*	Endif

* -----------------

*mv6 = Iif(mxambito=1,Alltrim(mwkMedico.nomape),Alltrim(mwkMedico.nombre))

mv6 = Alltrim(mwkMedico.nomape)
mv7 = Alltrim(Str(mwkMedico.Id))
mv8 = Iif(mxambito=1,Alltrim(Str(mwkMedico.codigovax)),'0')
mv9 = Iif(mxambito=1,Alltrim(mwkMedico.idusuario),'0')
mv10 = Alltrim(Str(lmedico))
mv11 = mv4
mv12 = Alltrim(Str(mxambito))
mv13 = Iif(mv12='1','SG','No SG')

mv14 = Alltrim(lorigen)
mv15 = Alltrim(Str(lcie))

lncentrolima = mxcentromedico

* Envio url + parámetros
*!*	o = Createobject("Shell.Application")
*!*	o.Open(lclink)

lclink = murl + '?v1=' + mv1 + '&v2=' + mv2 + '&v3=' + mv3 + '&v4=' + mv4 + '&v5=' + mv5 + '&v6=' + mv6 + '&v7=' + mv7 + '&v8=' + mv8 + '&v9=' + mv9 + '&v10=' + mv10 + '&v11=' + mv11 + "&v12=" + mv12 + '&v13=' + mv13 + '&llamadesde=' + mv14 + '&dx=' + mv15 + '&centro=' + Alltrim(Str(lncentrolima))
lclink = Strtran(lclink,' ','%20')

lnexiste = 0

*lcnavegador2 = 'C:\program files (x86)\mozilla firefox\firefox.exe'
lcnavegador1 = 'C:\program files (x86)\Google\Chrome\Application\Chrome.exe'

If File(lcnavegador1)
	lcnavegador = lcnavegador1
	lnexiste=1
Else
*!*		If File(lcnavegador2)
*!*			lcnavegador = lcnavegador2
*!*			lnexiste=1
*!*		Endif
Endif

If lnexiste>0
	Declare Integer ShellExecute In "Shell32.dll" ;
		INTEGER HWnd, ;
		STRING lpVerb, ;
		STRING lpFile, ;
		STRING lpParameters, ;
		STRING lpDirectory, ;
		LONG nShowCmd
	=ShellExecute(0,"Open",lcnavegador,lclink,"",0)
Else
	o = Createobject("Shell.Application")
	o.Open(lclink)
Endif
