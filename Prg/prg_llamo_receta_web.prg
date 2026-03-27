Parameters registracion,idmedico,entidad,dni,idambula,cie,origen

* prg_llamo_receta_web / Revisión 2025-01-07
* Revisiòn 2025-02-06
* Revision 2026-03-20. Como a veces queda mal mxambito, volvemos a consularlo. 



lpaciente = registracion
lmedico = idmedico
lmedicopaso = idmedico
lentidad = entidad
ldni = dni
lidambula = idambula
lcie = cie
lorigen = origen

* Setea nuevamente mxambito. A veces no lo pasa bien.
* Marcelo Torres, 20/03/2026
* Hablado con Carmen Alvarez
Do buscoini With Upper(mwkexe.nomexe)

lcSql = 'select * from tabestados where propietario = 57 and tipo = 62 and estado = 1'
If !Prg_EjecutoSql(lcSql,"mwkLinkRecetas","")
	Return .F.
Endif

If !Reccount('mwkLinkRecetas')>0
	Return .F.
Endif

murl = Alltrim(mwkLinkRecetas.Descrip)

*Paciente
mv1 = Alltrim(Str(lpaciente))
mv2 = Alltrim(Str(lentidad))
mv3 = Alltrim(Str(lidambula))
mv4 = Alltrim(Str(ldni))
mv5 = ''


If mxambito=1
	If lmedico>9999
		lcSql = "select p.ID from PRESTADORES p inner join TabMedExterno me on trim(p.matriculas) = trim(me.matricula)  where me.ID = ?lmedico"
		If !Prg_EjecutoSql(lcSql,"mwkMedicoExiste","")
			Return .F.
		Endif
		If Reccount('mwkMedicoExiste')>0
			lmedico = mwkMedicoExiste.id
		Else
			Messagebox("No se encuentra el profesional en prestadores. "+Chr(10)+"No puede emitir recetas en Ambito 1",48,"Receta Médica en HCEWeb")
			Return .F.
		Endif
	Endif
Endif


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
		Messagebox('Profesional medico SIN USUARIO'+ Chr(10) + "Comuniquese con Mesa de Ayuda Interno 8309",48,'Médico no registrado para Receta')
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


mv6 = Alltrim(mwkMedico.nomape)
mv7 = Alltrim(Str(mwkMedico.Id))
mv8 = Iif(mxambito=1,Alltrim(Str(mwkMedico.codigovax)),'0')
mv9 = Iif(mxambito=1,Alltrim(mwkMedico.idusuario),'0')
mv10 = Alltrim(Str(lmedicopaso))
mv11 = mv4
mv12 = Alltrim(Str(mxambito))
mv13 = Iif(mv12='1','SG','No SG')

mv14 = Alltrim(lorigen)
mv15 = Alltrim(Str(lcie))

lncentrolima = mxcentromedico

* Envio url + parámetros

lclink = murl + '?v1=' + mv1 + '&v2=' + mv2 + '&v3=' + mv3 + '&v4=' + mv4 + '&v5=' + mv5 + '&v6=' + mv6 + '&v7=' + mv7 + '&v8=' + mv8 + '&v9=' + mv9 + '&v10=' + mv10 + '&v11=' + mv11 + "&v12=" + mv12 + '&v13=' + mv13 + '&llamadesde=' + mv14 + '&dx=' + mv15 + '&centro=' + Alltrim(Str(lncentrolima))
lclink = Strtran(lclink,' ','%20')

lnexiste = 0
lcnavegador = ""

Do Case
Case File('C:\Archivos de Programa\Google\Chrome\Application\Chrome.exe')
	lcnavegador = 'C:\Archivos de Programa\Google\Chrome\Application\Chrome.exe'
	lnexiste = 1
Case File('C:\Archivos de Programa (x86)\Google\Chrome\Application\Chrome.exe')
	lcnavegador = 'C:\Archivos de Programa (x86)\Google\Chrome\Application\Chrome.exe'
	lnexiste = 1
Case File('C:\program files\Google\Chrome\Application\Chrome.exe')
	lcnavegador = 'C:\program files\Google\Chrome\Application\Chrome.exe'
	lnexiste = 1
Case File('C:\program files (x86)\Google\Chrome\Application\Chrome.exe')
	lcnavegador = 'C:\program files (x86)\Google\Chrome\Application\Chrome.exe'
	lnexiste = 1
Otherwise
	lnexiste = 0
Endcase

If lnexiste>0
	Declare Integer ShellExecute In "Shell32.dll" ;
		INTEGER HWnd, ;
		STRING lpVerb, ;
		STRING lpFile, ;
		STRING lpParameters, ;
		STRING lpDirectory, ;
		LONG nShowCmd
	=ShellExecute(0,"Open",lcnavegador,lcLink,"",0)
Else
	o = Createobject("Shell.Application")
	o.Open(lcLink)
Endif

RETURN lclink
