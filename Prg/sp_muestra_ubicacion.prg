*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
Lparameters lnactivos
If Vartype(lnactivos)#"N"
	lnactivos = 0
Endif
If Used('MwkUbica')
	Use In MwkUbica
Endif
mbusco = ''
If lnactivos=1
	mbusco = " and habilitado <> 0  "
Endif
If mxambito> 1
	mret=SQLExec(mcon1,"Select id, (piso || descrip || numero) as lugar, interno,habilitado,centromedico  "+;
		"From Tabubicacion where codambito = ?mxambito &mbusco Order by piso, numero ",'MwkUbica00')
Else
	mret=SQLExec(mcon1,"Select id, (piso || descrip || numero) as lugar, interno,habilitado,centromedico  "+;
		"From Tabubicacion where centromedico = ?mxcentromedico and codambito = ?mxambito &mbusco Order by piso, numero ",'MwkUbica00')
Endif
If mret < 0
	Messagebox('ERROR DE CURSOR, REINTENTE',64,'Validacion')
	mret=0
	
Endif

If Used('MwkUbicacion')
	Use In MwkUbicacion
Endif
If mxcentromedico = 1
	mret=SQLExec(mcon1,"Select piso, descrip, interno, numero,"+;
		"id,habilitado,centromedico   "+;
		"From Tabubicacion where codambito = ?mxambito &mbusco  Order by piso, numero ",'MwkUbicacion00')
Else
	mret=SQLExec(mcon1,"Select piso, descrip, interno, numero,"+;
		"id,habilitado ,centromedico    "+;
		"From Tabubicacion where  centromedico = ?mxcentromedico and codambito = ?mxambito &mbusco  Order by piso, numero ",'MwkUbicacion00')
Endif
If mret < 0
	Messagebox('ERROR DE CURSOR, REINTENTE',64,'Validacion')
	mret=0
	 
Else
	Select piso, Descrip, interno, numero,Iif(habilitado=1,"SI",Iif(habilitado=2,"IM",Iif(habilitado=3,"VC","  "))) As habil,;
		Id,habilitado,centromedico  From MwkUbicacion00 Into Cursor MwkUbicacion
	Use In Select('MwkUbica')
	Select Id, lugar, interno,;
		Iif(habilitado=1,"SI",Iif(habilitado=2,"IM",Iif(habilitado=3,"VC","  "))) As habil,centromedico ;
		From MwkUbica00 Into Cursor MwkUbica Readwrite
Endif
