Lparameters vale,vista

lmsg = ' Procesando Vale de Laboratorio nro ' + Alltrim(Str(vale)) + '. Aguarde un instante por favor.'
Wait Window lmsg At (Srows()/2), (Scols()/2)-(Len(lmsg)/2)  Nowait Noclear Timeout 2000

Do sp_busco_estados With 7,' and Tipo in (59,60) order by tipo ','mwkconexionlabo'

mFecinsert = sp_busco_fecha_serv("DT")
mVale = vale
mParti_1 = Alltrim(Str(mVale)) + Alltrim(Str(Rand()*100)) && 46130493
mParti = Int(Val(mParti_1))
mArchivo = 'C:\tempdoc\'+Alltrim(Str(mVale)) && '46130493'
mfechora = Alltrim(Ttoc(sp_busco_fecha_serv('DT'),3))

mret = SQLExec(mcon1,"insert into tabResulabopdf (TRL_lote,TRL_codvale,TRL_archivo,TRL_fecped) values (" +;
	"?mParti,?mVale,?mArchivo,?mFecInsert)")

Select mwkconexionlabo
Go Top In 'mwkconexionlabo'

mFTPServer = "CN_IPTCP:"+Alltrim(mwkconexionlabo.Descrip)+"[1972]"
Skip In 'mwkconexionlabo'
mNameSpace = Alltrim(mwkconexionlabo.Descrip)

mLoteLabo = mParti

olevism = Newobject('vism','lib_olevism_lab')

olevism.olecontrol1.MServer = mFTPServer
olevism.olecontrol1.NameSpace = mNameSpace

mimensaje="D tabla^PDF1("+Alltrim(Str(mLoteLabo,16,0))+")"

olevism.olecontrol1.Code = mimensaje
olevism.olecontrol1.execflag = 1

olevism.olecontrol1.MServer = ""
olevism.olecontrol1.NameSpace = ""

= prg_olevism_reset(olevism.olecontrol1)

* -----------------------------------
* Bajo del FTP
* -----------------------------------

Set Procedure To prg_ftp.prg Additive
mArchivoftp = 'PDF/' + Alltrim(Str(mVale))+'.pdf'
mArchivopdf = 'C:\tempdoc\'+Alltrim(Str(mVale))+'.pdf'

If File(mArchivopdf)
	mArchivopdf = 'C:\tempdoc\'+Alltrim(Str(mVale))+Sys(2015)+'.pdf'
Endif

If !Directory('C:\tempdoc')
	Md C:\tempdoc
Endif

sz_ftp = Createobject('ftp_service')
Select mwkconexionlabo
Go Top In 'mwkconexionlabo'
mIPServLabo = Alltrim(mwkconexionlabo.Descrip)

If !sz_ftp.OpenInternet("labopdf", "labopdf",mIPServLabo, "21")
	=Messagebox('No me puedo conectar al servidor de internet',64,'Error en conexion')
Else
	f2=sz_ftp.GetFtpFile(mArchivoftp,mArchivopdf)
Endif
=sz_ftp.CloseInternet()
Release Procedure prg_ftp.prg Additive
Release sz_ftp

* --------------------
* Verifico el archivo
* --------------------

mok = 0
If File(mArchivopdf)
	Adir(lcarch,mArchivopdf)
	If lcarch(2) > 6361
		mok = 1
	Else
		*Messagebox('El resultado está pendiente',48,'Vale de laboratorio nro ' + Alltrim(Str(mVale)),3000)
	Endif
Else
	*Messagebox('No existe el archivo pdf',48,'Vale de laboratorio nro ' + Alltrim(Str(mVale)),3000)
Endif

Use In Select('mwkconexionlabo')

Wait Clear

If mok = 1
*!*		If mverpdf = 1
*!*			oShell = Createobject("WScript.Shell")
*!*			oShell.Run(mArchivopdf,1)
*!*		Endif
	Return mArchivopdf
Else
	Return ''
Endif