* Rutina para subir / bajar archivos desde FTP
* 2022/12/28

Parameters archivolocal,archivoftp,tipo

Local lcDirName

If tipo = 2
	lmsg = ' Subiendo archivo. Aguarde un instante por favor. '
Else
	lmsg = ' Bajando archivo. Aguarde un instante por favor. '
Endif

Wait Window lmsg At (Srows()/2), (Scols()/2)-(Len(lmsg)/2)  Nowait Noclear

Set Procedure To prg_ftp.prg Additive

mArchivoftp_0 = archivoftp
mArchivopdf = archivolocal

sz_ftp = Createobject('ftp_service')

If !sz_ftp.OpenInternet('usrsamba', "usrsambapwd",'nas01.sca.local', "21")

	=Messagebox('No se puede conectar al servidor FTP',64,'Error en conexion')

Else

*=Messagebox(sz_ftp.GetConnectedState())

	Do Case

	Case tipo = 1  && Para Bajar

		dato = sz_ftp.OpenFTPConnection('DATOS')
		dato = sz_ftp.GetFtpFile(archivoftp,mArchivopdf)
		dato = sz_ftp.CloseFTPConnection()
		If File(mArchivopdf)
			lcruta = mArchivopdf
		Else
			lcruta = ""
		Endif

	Case tipo = 2 && Para Subir

		dato = sz_ftp.OpenFTPConnection('DATOS')

		If !sz_ftp.ChangeFtpDirectory("zabdocupac")
		Endif

		sz_ftp.GetFtpDirectory(@lcDirName)
		lccarpeta = Upper(Substr(lcDirName,2,Len(lcDirName)))

		lfecha = sp_busco_fecha_serv('DD')

		lfolder_a  = Alltrim(Str(Year(lfecha)))
		lfolder_m = Padl(Alltrim(Str(Month(lfecha))),2,'0')
		lfolder_d  = Padl(Alltrim(Str(Day(lfecha))),2,'0')

		lfolder = lfolder_a + lfolder_m + lfolder_d

		If lccarpeta = 'ZABDOCUPAC'
			valor = sz_ftp.ChangeFtpDirectory(lfolder)
			mArchivoftp = mArchivoftp_0 + '.pdf'
			If !valor
				If sz_ftp.CreateFtpDirectory(lfolder)
					mArchivoftp = lfolder + '/' + mArchivoftp_0 + '.pdf'
				Else
					?sz_ftp.GetErrorCode(.T.)
				Endif
			Endif
		Endif

*!*			sz_ftp.GetFtpDirectory(@lcDirName)
*!*			lccarpeta = Upper(Substr(lcDirName,2,Len(lcDirName)))
*!*
*!*			?lccarpeta
*!*
*!*			If !sz_ftp.GetFtpDirectory('Test')
*!*				sz_ftp.GetErrorCode(.T.)
*!*				lcDirName = ''
*!*				existe = 'existe'
*!*				Messagebox(existe)
*!*			Else
*!*				existe = 'no existe'
*!*				Messagebox(existe)
*!*				If !sz_ftp.CreateFtpDirectory('Test')
*!*					?sz_ftp.GetErrorCode(.T.)
*!*				Endif
*!*			Endif
		dato = sz_ftp.PutFTPFile(mArchivoftp, mArchivopdf)
		dato = sz_ftp.CloseFTPConnection()

		lcruta = lfolder + '/' + mArchivoftp_0 + '.pdf'

	Endcase

Endif

=sz_ftp.CloseInternet()

Release Procedure prg_ftp.prg Additive
Release sz_ftp

Wait Clear

Return lcruta
