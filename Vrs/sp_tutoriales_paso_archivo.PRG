*
* Pasaje de Archivos a un campo General en Tablas CACHE
*
If !directory("C:\temp\videos")
	Mkdir "C:\temp\videos"
Endif
Dimension vdat[5]
vdat[1]= 2008
vdat[2]= 'GUARDIA VIDEOS TUTORIALES'
vdat[3]= '1'
vdat[4]= 'AVI'
rutavideo = 'c:\temp\prueba4.avi'  && Hardcodeado para demo
If used ('videos')
	Use in VIDEOS
Endif
If used ('__DATA')
	Use in __DATA
Endif
If file("C:\temp\videos\videos.dbf")
	Erase ("C:\temp\videos\videos.dbf")
Endif
If file("C:\temp\videos\videos.fpt")
	Erase ("C:\temp\videos\videos.fpt")
Endif
Select 0
Create table "C:\temp\videos\videos.dbf" free (video M)
*!* Toma el dato binario del archivo introducido en el memo
Select VIDEOS
Append blank
miVideo = ''
Do prg_LoadBin with rutavideo,miVideo
mpaso = .f.
If !empty(miVideo)
	Replace video with miVideo
	Use
*!* Cambia el campo memo a un tipo general para introducir a sql server
	LL = fopen("C:\temp\videos\videos.dbf",12)
	Fseek(LL,43)
	Fwrite(LL,'G')
	Fclose(LL)
*!* Escribe el dato en sql server
	Use C:\temp\VIDEOS\VIDEOS.dbf alias __DATA
	mpaso = .t.
Else
	Create cursor __DATA (video M)
Endif
If mpaso
	mret = sqlexec(mcon1, "insert into TabDocGral (anio,descripcion,documento,tema,tipo) "+;
		"values (?vdat[1],?vdat[2],?__DATA.video,?vdat[3],?vdat[4])")
	If mret < 0
		Messagebox("EN INCORPORACION DE ARCHIVO AVI "+CHR(10)+"AL MAESTRO DE DOCUMENTOS GENERALES",16,"ERROR")
	Endif
Endif
Release vdat
If used ('videos')
	Use in VIDEOS
Endif
If used ('__DATA')
	Use in __DATA
Endif
Return




