*
* AUTOR: S.G. Sistemas
* Todas las Conexiones e inicializaciones de Obj. y Variables
* Que necesito para el sistema y todos los seteos
* nombre de las coneXiones y var establecidas
*
* 2013 - Objeto p/gestion Policonsultorios
*
Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep

Public mcon1, mcdedonde, mccodesp,mncodmed,mncodprest,mncodserv,mncuantos,mclista, ;
	mtHrDes,mtHrHas,mcsala,mtdura,mbexiste,mndia,mdfecha_d,mdfecha_h,mpfecha, ;
	mcafil,mncodent,mnbloq,mncodmedsol,mntipotur,mntom,mcusu,mthorad,mthorah, mbusqlis,;
	mndiasem,mtfechatur,mdmasx,mthorad_ini,mthorah_ini,mcwhere1,mcdiasem, mcbuqdiasem,;
	mid_usu,mfecreprogtur1,mfecreprogtur2,mncanttur,mthrGuardia,mthrInter,mdfecVigenD,mdfecVigenh,;
	thorad,thorah,optres,mtfhoy,msql_reg,msql,lsicancelo,LNOVERIMAGEN,midf,mbloqturent,mnucodprest,;
	pHabSqlServer,mconSql 

mconSql = 0
pHabSqlServer = .f.

**Limpiamos directorio de imagenes.

*!*	If Directory('C:\temp\imagenes')
*!*		cfiles = 'C:\temp\imagenes\*.*'
*!*		Adir(mima,cfiles)
*!*		If Vartype(mima) <> 'U'
*!*			ncantfiles = Alen(mima,1)
*!*			lcErrorAnt = On("ERROR")
*!*			On Error =Aerr(eros)
*!*			For i=1 To ncantfiles
*!*				cfil = 'C:\temp\imagenes\'  + mima(i,1)
*!*				Delete File (cfil )
*!*			Endfor
*!*			On Error &lcErrorAnt
*!*		Endif
*!*	Endif

