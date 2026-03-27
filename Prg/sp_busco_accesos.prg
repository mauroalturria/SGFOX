***
*** Busco accesos del usuario y sector
***
Lparameters mversion
lXdisconnec = .F.

If !Used("mwkserver1")
	Do sp_conexion
	lXdisconnec = .T.
	Do sp_busco_server_namespaces
	Select * From mwktabcfg Into Cursor mwklauncher
	Use In Select('mwktabcfg')
Endif
Do sp_busco_estados With 7,' and tipo = 32 ','mwkscreen'

If Directory("X:\Qepd1a1\Exe")
	Do Sp_Actualizo_ExeLog With "C", "X" , mversion, 0
Else
	If Directory(zzvolumen+"\Qepd1a1\Exe")
		Do Sp_Actualizo_ExeLog With "C", zzvolumen , mversion, 0
	Else
		Do Sp_Actualizo_ExeLog With "C", "C" , mversion, 0
	Endif
Endif

*!*	--------------------------------------------------------------------------
mcarch = Alltrim(myip)+'.txt'
mcarchTemp = Alltrim(myip)+'_temp.txt'
mlinea  = ''
If File(mcarchTemp)
	mlinea = Filetostr(mcarchTemp)
	mnCant = Alines(laLineas,mlinea)

	For fila = 1 To mnCant
		mcLinea = laLineas(fila)
		If !Empty(mcLinea)
			mcFecha = Substr(mcLinea,1,At(Chr(9),mcLinea,1)-1)
*!*		mcIp    = substr(mcLinea,at(chr(9),mclinea,1) + 1,  at(chr(9),mclinea,2) -  at(chr(9),mclinea,1) - 1)
			mcFDesde = Substr(mcLinea,At(Chr(9),mcLinea,2) + 1,  At(Chr(9),mcLinea,3) -  At(Chr(9),mcLinea,2) - 1)
			mcDesde  = Justdrive(mcFDesde)
*!*		mcFecAr  = substr(mcLinea,at(chr(9),mclinea,3) + 1,  at(chr(9),mclinea,4) -  at(chr(9),mclinea,3) - 1)
			mversion = Substr(mcLinea,At(Chr(9),mcLinea,4) + 1)
			Do Sp_Actualizo_ExeLog With mcDesde, "" , mversion, 0, Ctot(mcFecha)
		Endif
	Next
Endif
Strtofile(mlinea, mcarch, .T.) && Paso a txttotal
Strtofile("",mcarchTemp,.F.)   && Borro txt Temp
*!*	--------------------------------------------------------------------------

mcoduser 	= mwkusuario.Id
mcodsec		= mwksector2.Id
mfecpas 	= Ctod('01/01/1900')
If myip='172.16.1.7'
	Set Step On
Endif
mret = SQLExec(mcon1, "select * " + ;
	"from tabpermisosexe, tabexe " + ;
	"where codusuario  = ?mcoduser and " + ;
	"tabpermisosexe.fecpasiva = ?mfecpas and " + ;
	"tabexe.fecpasiva = ?mfecpas and " + ;
	"codexe = tabexe.id " , "mwkAccexeu")

mret = SQLExec(mcon1, "select * " + ;
	"from tabpermisosexe, tabexe " + ;
	"where codigovax  = ?mcodsec and " + ;
	"tabpermisosexe.fecpasiva = ?mfecpas and " + ;
	"tabexe.fecpasiva = ?mfecpas and " + ;
	"codexe = tabexe.id " , "mwkAccexes")

If Used("mwkAccexes")
	Select * From mwkAccexeu Union Select * From mwkAccexes Into Cursor mwkAccexegrupal Readwrite
Else
	Select * From mwkAccexeu Into Cursor mwkAccexegrupal Readwrite
Endif



*** AGREGADO DESDE ACA 31-5-16


*TEXT TO LCSQL TEXTMERGE NOSHOW PRETEXT 7

LCSQL = "select * from tabgcusugrup "+;
	"inner join tabexegrupo on tabexegrupo.teg_idtabgc = tabgcusugrup.idgrupo  and teg_fechabaja = '1900-01-01'"+;
	"inner join TabExe on TabExe.Id = Teg_IdTabExe and fecpasiva = '1900-01-01' "+;
	"where idusuario = ?mwkusuario.id order by modoejecucion "
*ENDTEXT

If !PRG_EJECUTOSQL(LCSQL,"mwkejecutables")
	Return .F.
Endif

If Used("mwkejecutables")

	Insert Into mwkAccexegrupal (codusuario,fecpasiva,Descrip,codexe,fechaversionactual,icono,launcher,nomexe,titulo,versionactual,versionminima,modoejecucion);
		Select idusuario,fecpasiva,Descrip,teg_idtabexe,fechaversionactual,icono,launcher,nomexe,titulo,versionactual,versionminima,modoejecucion;
		From mwkejecutables

Endif

*** HASTA ACA 31-5-16***

Select * From mwkAccexegrupal Group By nomexe Order By modoejecucion Into Cursor mwkAccexeprevio
If Used("mwkAccexe")
	Use In mwkAccexe
Endif
Use Dbf("mwkAccexeprevio") In 0 Again Alias mwkAccexe
If Used("mwkAccexes")
	Use In mwkAccexes
Endif
If Used("mwkAccexeu")
	Use In mwkAccexeu
Endif
If Used("mwkAccexegrupal")
	Use In mwkAccexegrupal
Endif


If mret < 0
	= Aerr(eros)
	Messagebox(eros(3))
Endif
If lXdisconnec
*	Select * From mwktabcfg Into Cursor mwklauncher
	Do sp_desconexion With "sp_busco_server_namespace"
Endif
