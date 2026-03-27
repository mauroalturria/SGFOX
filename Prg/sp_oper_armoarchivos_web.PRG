*!*
*!* Generar archivos Coordinadores y Subcoordinadores, download de los archivos generados, backup de bases locales
*!*
*!* Directorio de descargar  : c:\Temp\Web2
*!* Archivo Coordinadores    : archcoord.txt
*!* Archivo Subcoordinadores : archsubco.txt
*!*
*!* URL para generarlos y poseterior descarga http://www.silver-cross.com.ar/coord/sg-exportar.php
*!*
*!* MySql - Backup
*!* TabCoord    => TabCoord_Bak
*!* TabSubCoord => TabSubCoord_Bak
*!*
*!* Upload desde FTP a Local : vfpconnection
*!*

mfecmov = sp_busco_fecha_serv("DT")
miduser = mwkusuario.idusuario


*!* 1) Corro el generador de los TXT para poseteriormente descargarlos Local

lcfile = "http://www.silver-cross.com.ar/coord/sg-exportar.php"
Wait windows nowait "Generando Archivos TXT para descarga ..."
loBrowser = createobject("InternetExplorer.Application")
loBrowser.Navigate(lcfile)
loBrowser.visible=.t.
Release loBrowser

mrespu = messagebox("VERIFIQUE UN CORRECTO RESULTADO"+chr(10)+;
	" DEL MODULO WEB, CONTINUA ?",4+32,"Atención")

If mrespu = 7
	mpaso = .f.
	Return
Endif

*!* 2) Los descargo en C:

If file("c:\temp\web2\archcoord.txt")
	Delete file c:\temp\web2\archcoord.txt
Endif

If file("c:\temp\web2\archsubco.txt")
	Delete file c:\temp\web2\archsubco.txt
Endif

mresulta = .t.

Do prg_ftp_download with "http://www.silver-cross.com.ar/coord/","c:\temp\web2\",;
	"archcoord.txt"

If !mresulta
	Return
Endif

Do prg_ftp_download with "http://www.silver-cross.com.ar/coord/","c:\temp\web2\",;
	"archsubco.txt"

If !mresulta
	Return
Endif

*!* 3) Hago previo Backup de las Tablas MySql

Dimension vdat[23]

If used('mwktabcoord')
	Use in mwktabcoord
Endif

mret = sqlexec(hConn,"select * from TabCoord","mwktabcoord")
If mret < 0
	=aerror(merror)
	Messagebox(merror(3)+chr(13)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Return
Endif

mpaso = .t.
Select mwktabcoord
Scan

	vdat[01] = mwktabcoord.TCO_idMed
	vdat[02] = mwktabcoord.TCO_registro
	vdat[03] = mwktabcoord.TCO_email
	vdat[04] = mwktabcoord.TCO_especialidad
	vdat[05] = mwktabcoord.TCO_introduccion
	vdat[06] = mwktabcoord.TCO_chk1
	vdat[07] = mwktabcoord.TCO_asistencia
	vdat[08] = mwktabcoord.TCO_chk2
	vdat[09] = mwktabcoord.TCO_internacion
	vdat[10] = mwktabcoord.TCO_chk3
	vdat[11] = mwktabcoord.TCO_intervencion
	vdat[12] = mwktabcoord.TCO_chk4
	vdat[13] = mwktabcoord.TCO_emergencia
	vdat[14] = mwktabcoord.TCO_equipo
	vdat[15] = mwktabcoord.TCO_academico
	vdat[16] = mwktabcoord.TCO_apenom
	vdat[17] = mwktabcoord.TCO_actividad2
	vdat[18] = mwktabcoord.TCO_formacion
	vdat[19] = mwktabcoord.TCO_actlab
	vdat[20] = mwktabcoord.TCO_organismos
	vdat[21] = mwktabcoord.TCO_investiga
	vdat[22] = mwktabcoord.TCO_cursos
	vdat[23] = mwktabcoord.TCO_docente

	mret = sqlexec( hConn,"insert into TabCoord_Bak "+;
		"(TCO_idMed,TCO_registro,TCO_email,TCO_especialidad,TCO_introduccion,TCO_chk1,TCO_asistencia,TCO_chk2,"+;
		"TCO_internacion,TCO_chk3,TCO_intervencion,TCO_chk4,TCO_emergencia,TCO_equipo,TCO_academico,TCO_apenom,"+;
		"TCO_actividad2,TCO_formacion,TCO_actlab,TCO_organismos,TCO_investiga,TCO_cursos,TCO_docente,"+;
		"TCO_idusuario,TCO_fecmov)"	+;
		" values "+;
		"(?vdat[01],?vdat[02],?vdat[03],?vdat[04],?vdat[05],?vdat[06],?vdat[07],?vdat[08],?vdat[09],?vdat[10],"+;
		" ?vdat[11],?vdat[12],?vdat[13],?vdat[14],?vdat[15],?vdat[16],?vdat[17],?vdat[18],?vdat[19],?vdat[20],"+;
		" ?vdat[21],?vdat[22],?vdat[23],?miduser,?mfecmov)")

	If mret < 0
		mpaso = .f.
		=aerror(merror)
		Messagebox(merror(3)+chr(13)+;
			"AVISE A SISTEMAS",16,"ERROR")
		Exit
	Endif

Endscan

Release vdat
Dimension vdat[11]

If mpaso
	mret = sqlexec(hConn,"delete from TabCoord")
	If mret < 0
		=aerror(merror)
		Messagebox(merror(3)+chr(13)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Else
		If used('mwkTabSubCoord')
			Use in mwkTabSubCoord
		Endif
		mret = sqlexec(hConn,"select * from TabSubCoord","mwkTabSubCoord")
		If mret < 0
			=aerror(merror)
			Messagebox(merror(3)+chr(13)+;
				"AVISE A SISTEMAS",16,"ERROR")
			Return
		Endif
		Select mwkTabSubCoord
		Scan
			vdat[01] = mwkTabSubCoord.TSO_IdMed
			vdat[02] = mwkTabSubCoord.TSO_registro
			vdat[03] = mwkTabSubCoord.TSO_email
			vdat[04] = mwkTabSubCoord.TSO_especialidad
			vdat[05] = mwkTabSubCoord.TSO_actividad2
			vdat[06] = mwkTabSubCoord.TSO_formacion
			vdat[07] = mwkTabSubCoord.TSO_actlab
			vdat[08] = mwkTabSubCoord.TSO_organismos
			vdat[09] = mwkTabSubCoord.TSO_investiga
			vdat[10] = mwkTabSubCoord.TSO_cursos
			vdat[11] = mwkTabSubCoord.TSO_docente
			mret = sqlexec( hConn,"insert into TabSubCoord_Bak "+;
				"(TSO_IdMed,TSO_registro,TSO_email,TSO_especialidad,TSO_actividad2,TSO_formacion,TSO_actlab,"+;
				"TSO_organismos,TSO_investiga,TSO_cursos,TSO_docente,TSO_idusuario,TSO_fecmov)"	+;
				" values "+;
				"(?vdat[01],?vdat[02],?vdat[03],?vdat[04],?vdat[05],?vdat[06],?vdat[07],?vdat[08],?vdat[09],?vdat[10],"+;
				" ?vdat[11],?miduser,?mfecmov)")
			If mret < 0
				mpaso = .f.
				=aerror(merror)
				Messagebox(merror(3)+chr(13)+;
					"AVISE A SISTEMAS",16,"ERROR")
				Exit
			Endif
		Endscan

		If mpaso

			mret = sqlexec(hConn,"delete from TabSubCoord")
			If mret < 0
				=aerror(merror)
				Messagebox(merror(3)+chr(13)+;
					"AVISE A SISTEMAS",16,"ERROR")
			Else

				For mprocesa = 1 to 2
					If mprocesa = 1
						If used('mwkTabCoord')
							Use in mwktabcoord
						Endif
						Create cursor mwktabcoord ( TCO_idMed n(5),  TCO_registro c(7),  TCO_email c(40),  TCO_especialidad c(4),  TCO_introduccion m,;
							TCO_chk1 c(1), TCO_asistencia m,  TCO_chk2 c(1),  TCO_internacion m,  TCO_chk3 c(1),  TCO_intervencion m,  TCO_chk4 c(1),;
							TCO_emergencia m,  TCO_equipo m,  TCO_academico m,   TCO_apenom c(50),  TCO_actividad2 m,  TCO_formacion m,  TCO_actlab m,;
							TCO_organismos m,  TCO_investiga m,  TCO_cursos m,  TCO_docente m )
						marchivo = FILETOSTR("c:\temp\web2\archcoord.txt")
					Else
						If used('mwkTabSubCoord')
							Use in mwkTabSubCoord
						Endif
						Create cursor mwkTabSubCoord ( TSO_IdMed n(5), TSO_registro c(7), TSO_email c(40),;
							TSO_especialidad c(4), TSO_actividad2 m,  TSO_formacion m,  TSO_actlab m,  TSO_organismos m,;
							TSO_investiga m, TSO_cursos m,  TSO_docente m )
						marchivo = FILETOSTR("c:\temp\web2\archsubco.txt")
					Endif

					mi  = 0
					mi2 = 0
					msigue = .t.

					Do while msigue
						mi = mi + 1
						mbusca = "LIN-EXI-" + alltrim(str(mi))
						mresul = at(mbusca,marchivo)
						Dimension vdesde[mi,2]
						mdesde = mresul + len(mbusca) + 1
						vdesde[mi,1] = mdesde
						mi2 = mi + 1
						mbusca = "LIN-EXI-" + alltrim(str(mi2))
						mresul = at(mbusca,marchivo)
						If mresul > 0
							mhasta = mresul - mdesde
							vdesde[mi,2] = mhasta
						Else
							vdesde[mi,2] = 0
							msigue = .f.
						Endif
					Enddo

					If mprocesa = 1
						Dimension vcampos[23]
					Else
						Dimension vcampos[11]
					Endif

					For mi = 1 to alen(vdesde,1)
						If vdesde[mi,2]>0
							Store '' to vcampos
							mdatos  = alltrim(substr(marchivo,vdesde[mi,1],vdesde[mi,2]))
							mstring = ''
							mind    = 1
							For mi2 = 1 to len(mdatos)
								If substr(mdatos,mi2,1)='|'
									vcampos[mind] = mstring
									mstring = ''
									mind = mind + 1
								Else
									mstring = mstring + substr(mdatos,mi2,1)
								Endif
							Endfor
							If len(mstring) > 0
								vcampos[mind] = mstring
							Endif
							If mprocesa = 1
								Insert into mwktabcoord ( TCO_idMed,  TCO_registro,  TCO_email,  TCO_especialidad,  TCO_introduccion,;
									TCO_chk1, TCO_asistencia,  TCO_chk2,  TCO_internacion,  TCO_chk3,  TCO_intervencion,  TCO_chk4,;
									TCO_emergencia,  TCO_equipo,  TCO_academico,   TCO_apenom ,  TCO_actividad2,  TCO_formacion,  TCO_actlab,;
									TCO_organismos,  TCO_investiga,  TCO_cursos,  TCO_docente );
									values;
									(val(vcampos[1]),vcampos[2],vcampos[3],vcampos[4],vcampos[5],vcampos[6],vcampos[7],vcampos[8],vcampos[9],;
									vcampos[10],vcampos[11],vcampos[12],vcampos[13],vcampos[14],vcampos[15],vcampos[16],vcampos[17],vcampos[18],;
									vcampos[19],vcampos[20],vcampos[21],vcampos[22],vcampos[23])
							Else
								Insert into mwkTabSubCoord ( TSO_IdMed,TSO_registro,TSO_email,TSO_especialidad,;
									TSO_actividad2,TSO_formacion,TSO_actlab,TSO_organismos,TSO_investiga,TSO_cursos,TSO_docente);
									values ;
									(val(vcampos[1]),vcampos[2],vcampos[3],vcampos[4],vcampos[5],vcampos[6],vcampos[7],vcampos[8],vcampos[9],;
									vcampos[10],vcampos[11])
							Endif
						Endif
					Endfor
					Release vcampos
				Endfor

				If used('mwkTabCoord')
					If reccount('mwkTabCoord')>0
						mpaso = .t.
						Dimension vdat[23]
						Select mwktabcoord
						Scan
							vdat[01] = mwktabcoord.TCO_idMed
							vdat[02] = mwktabcoord.TCO_registro
							vdat[03] = mwktabcoord.TCO_email
							vdat[04] = mwktabcoord.TCO_especialidad
							vdat[05] = mwktabcoord.TCO_introduccion
							vdat[06] = mwktabcoord.TCO_chk1
							vdat[07] = mwktabcoord.TCO_asistencia
							vdat[08] = mwktabcoord.TCO_chk2
							vdat[09] = mwktabcoord.TCO_internacion
							vdat[10] = mwktabcoord.TCO_chk3
							vdat[11] = mwktabcoord.TCO_intervencion
							vdat[12] = mwktabcoord.TCO_chk4
							vdat[13] = mwktabcoord.TCO_emergencia
							vdat[14] = mwktabcoord.TCO_equipo
							vdat[15] = mwktabcoord.TCO_academico
							vdat[16] = mwktabcoord.TCO_apenom
							vdat[17] = mwktabcoord.TCO_actividad2
							vdat[18] = mwktabcoord.TCO_formacion
							vdat[19] = mwktabcoord.TCO_actlab
							vdat[20] = mwktabcoord.TCO_organismos
							vdat[21] = mwktabcoord.TCO_investiga
							vdat[22] = mwktabcoord.TCO_cursos
							vdat[23] = mwktabcoord.TCO_docente

							mret = sqlexec( hConn,"insert into TabCoord "+;
								"(TCO_idMed,TCO_registro,TCO_email,TCO_especialidad,TCO_introduccion,TCO_chk1,TCO_asistencia,TCO_chk2,"+;
								"TCO_internacion,TCO_chk3,TCO_intervencion,TCO_chk4,TCO_emergencia,TCO_equipo,TCO_academico,TCO_apenom,"+;
								"TCO_actividad2,TCO_formacion,TCO_actlab,TCO_organismos,TCO_investiga,TCO_cursos,TCO_docente)"	+;
								" values "+;
								"(?vdat[01],?vdat[02],?vdat[03],?vdat[04],?vdat[05],?vdat[06],?vdat[07],?vdat[08],?vdat[09],?vdat[10],"+;
								" ?vdat[11],?vdat[12],?vdat[13],?vdat[14],?vdat[15],?vdat[16],?vdat[17],?vdat[18],?vdat[19],?vdat[20],"+;
								" ?vdat[21],?vdat[22],?vdat[23])")

							If mret < 0
								mpaso = .f.
								=aerror(merror)
								Messagebox(merror(3)+chr(13)+;
									"AVISE A SISTEMAS",16,"ERROR")
								Exit
							Endif
						Endscan
					Endif
				Endif

				If used('mwkTabSubCoord')
					If reccount('mwkTabSubCoord')>0
						Release vdat
						Dimension vdat[11]
						Select mwkTabSubCoord
						Scan
							vdat[01] = mwkTabSubCoord.TSO_IdMed
							vdat[02] = mwkTabSubCoord.TSO_registro
							vdat[03] = mwkTabSubCoord.TSO_email
							vdat[04] = mwkTabSubCoord.TSO_especialidad
							vdat[05] = mwkTabSubCoord.TSO_actividad2
							vdat[06] = mwkTabSubCoord.TSO_formacion
							vdat[07] = mwkTabSubCoord.TSO_actlab
							vdat[08] = mwkTabSubCoord.TSO_organismos
							vdat[09] = mwkTabSubCoord.TSO_investiga
							vdat[10] = mwkTabSubCoord.TSO_cursos
							vdat[11] = mwkTabSubCoord.TSO_docente
							mret = sqlexec( hConn,"insert into TabSubCoord "+;
								"(TSO_IdMed,TSO_registro,TSO_email,TSO_especialidad,TSO_actividad2,TSO_formacion,TSO_actlab,"+;
								"TSO_organismos,TSO_investiga,TSO_cursos,TSO_docente)"	+;
								" values "+;
								"(?vdat[01],?vdat[02],?vdat[03],?vdat[04],?vdat[05],?vdat[06],?vdat[07],?vdat[08],?vdat[09],?vdat[10],"+;
								" ?vdat[11])")
							If mret < 0
								mpaso = .f.
								=aerror(merror)
								Messagebox(merror(3)+chr(13)+;
									"AVISE A SISTEMAS",16,"ERROR")
								Exit
							Endif
						Endscan
					Endif
				Endif
			Endif
		Endif
	Endif
Endif

If used('mwkTabCoord')
	Use in mwktabcoord
Endif
If used('mwkTabSubCoord')
	Use in mwkTabSubCoord
Endif

Release vdat
















