***************************
* AUTOR:Claudia Antoniow
* FECHA:06/11/2002
***************************
* Modificado:06/11/2003
***************************
Parameter mfechagen

If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif
mret = SQLExec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where &mccpoamb  id<100000 order by fechacierre ','mwkctrlfecha')
Go Bottom In mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use In mwkctrlfecha
mccpocmed =''
If mxambito =1
	mccpocmed = " and centromed = ?mxcentromedico "
Endif
lcSql = 'SELECT tipoturno, Abreviatura,Descrip, grupo, ID FROM Tabtipoturno'+;
	' ORDER BY tipoturno '
If !Prg_EjecutoSql(lcSql,"mwktipt")
	Return .F.
Endif
mccampo =''
Select mwktipt
Select *,Iif(!Empty(abreviatura),abreviatura,"NO") As ctt From mwktipt Where !Inlist(tipoturno,8,9) Into Cursor mwktiptu
Select Max(tipoturno) As limi From mwktiptu Into Cursor mwkcuantos
Select mwktiptu

mccampo =''
Scan
	mccampo = mccampo + ',SUM(Iif(tipoturno ='+ Transform(mwktiptu.tipoturno)+',1,0)) as '+ Alltrim(mwktiptu.ctt)
Endscan
Mdiassem = Dow(mfechagen)
mret=SQLExec(mcon1," select diasem,fecvigend,fecvigenh,codmed, "+;
	" tiposervicio,estructura,imparchivo,id,hhmmdes,hhmmhas "+;
	" , centromed  from franjaHoraria where "+mccpoamb+" fecvigend<=?mfechagen and diasem = ?Mdiassem " +;
	" and fecvigenH >=?mfechagen and fecvigenD < fecvigenH "+ mccpocmed  +;
	"  ","mwkfranjaH")

If mret < 0
	Messagebox('ERROR DE CURSOR FRANJAS HORARIAS',64,'VALIDACION')
	mret=0
Endif
mret=SQLExec(mcon1, ' select nombre,horatur,codmed,hhmmtur, fechatur,'+;
	' cast(fechagenera as date) as fechaGen,usuariogenera,tipoturno,afiliado '+;
	' from turnos left join prestadores on turnos.codmed = prestadores.id'+;
	' where &mccpoamb fechatur=?mfechagen ' ,'MwkveoturGen')
If mret < 0
	mret=0
	Messagebox('ERROR DEL CURSOR DE Turnos Generados, REINTENTE',16,'VALIDACION')
Endif
Select nombre,Min(horatur) As Primero, Max(horatur) As ult,;
	fechaGen ,usuariogenera &mccampo ;
	from MwkveoturGen,mwkfranjaH ;
	Where mwkfranjaH.codmed = MwkveoturGen.codmed ;
	And mwkfranjaH.hhmmdes <= MwkveoturGen.hhmmtur ;
	AND mwkfranjaH.hhmmhas>= MwkveoturGen.hhmmtur And mwkfranjaH.fecvigend <= MwkveoturGen.fechatur ;
	AND mwkfranjaH.fecvigenh>= MwkveoturGen.fechatur;
	Group By MwkveoturGen.codmed,fechaGen,usuariogenera ;
	order By nombre,fechaGen,usuariogenera Into Cursor MwkveoturGenA


Select nombre ,usuariogenera &mccampo ;
	from MwkveoturGen,mwkfranjaH ;
	Where mwkfranjaH.codmed = MwkveoturGen.codmed ;
	And mwkfranjaH.hhmmdes <= MwkveoturGen.hhmmtur ;
	AND mwkfranjaH.hhmmhas>= MwkveoturGen.hhmmtur And mwkfranjaH.fecvigend <= MwkveoturGen.fechatur ;
	AND mwkfranjaH.fecvigenh>= MwkveoturGen.fechatur;
	  Into Cursor Mwkveoturval
*!*	sum(Iif(tipoturno=0,1,0)) As NOR,;
*!*		sum(Iif(tipoturno=1,1,0)) As SO, ;
*!*		sum(Iif(tipoturno=2,1,0)) As ST, ;
*!*		sum(Iif(tipoturno=3,1,0)) As GI, ;
*!*		sum(Iif(tipoturno=4,1,0)) As ESP,;
*!*		sum(Iif(tipoturno=5,1,0)) As PS, ;
*!*		sum(Iif(tipoturno=6,1,0)) As RE, ;
*!*		sum(Iif(tipoturno=7,1,0)) As PE, ;
*!*		sum(Iif(tipoturno=8,1,0)) As TI, ;
*!*		sum(Iif(tipoturno=9,1,0)) As AN,  ;
*!*		sum(Iif(tipoturno=11,1,0)) As AM,  ;
*!*		sum(Iif(tipoturno=13,1,0)) As TP,  ;
*!*		sum(Iif(tipoturno=14,1,0)) As TE,  ;
*!*		sum(Iif(tipoturno=15,1,0)) As HS, ;
*!*		sum(Iif(tipoturno=16,1,0)) As TL
If mfechagen <= mfechalimite
	mret=SQLExec(mcon1, ' select nombre,horatur,codmed,fechatur,'+;
		' cast(fechagenera as date) as fechaGen,usuariogenera,tipoturno'+;
		' from turnoshis left join prestadores on turnoshis .codmed=prestadores.id'+;
		' where &mccpoamb fechatur=?mfechagen ' ,'MwkveoturGen')
	If mret < 0
		mret=0
		Messagebox('ERROR DEL CURSOR DE Turnos Generados, REINTENTE',16,'VALIDACION')
	Endif

	Select nombre,Min(horatur) As Primero, Max(horatur) As ult,;
		fechaGen ,usuariogenera,&mccampo ;
		from MwkveoturGen;
		group By codmed,fechaGen,usuariogenera ;
		order By nombre,fechaGen,usuariogenera Into Cursor MwkveoturGenB


	Select * From MwkveoturGenA;
		union;
		select * From MwkveoturGenB;
		into Cursor MwkveoturGen
Else
	Select * From MwkveoturGenA;
		into Cursor MwkveoturGen

Endif
If Used('MwkveoturGenA')
	Use In MwkveoturGenA
Endif
If Used('MwkveoturGenB')
	Use In MwkveoturGenB
Endif
