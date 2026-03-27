*
* Busco Reclamos, mbusco viene con AND
*
Lparameters mpend,mbusco,mcodigovax,mdisconf,mtipdis,mbuser,lmante,mNroSol

Use In Select("mwkrecla")

If Vartype(mbuser)#"C"
	mbuser = ""
Endif

If Vartype(mbusco)#"C"
	mbusco = ' 1 = 1 '
Endif

If Vartype(mdisconf)#"N"
	mdisconf = 0
Endif

If Vartype(mtipdis)#"N"
	mtipdis = 0
Endif

If Vartype(lmante)="U"
	lmante = .F.
Endif
mfecnull = Ctod("01/01/1900")

If mdisconf > 0
	If mtipdis > 0
		mbusco = mbusco + Iif(Empty(mbusco),'',' and ' )+" fechaprevtecconf=1 AND fechaprevtec<>?mfecnull "
	Else
		mbusco = mbusco + Iif(Empty(mbusco),'',' and ' )+ " fechaprevtecconf=2 "
	Endif
Endif

mfiltro = ''
**mbusco = mbusco + iif(mpend=1, iif(empty(mbusco),'',' and ' )+ ' (TabMantenimiento.estado in (0,1,4,6) or (conforme is null  AND TabMantenimiento.estado = 2 )) ','') + mbuser
If lmante
	Do Case
	Case mpend = 1   && Pendientes
		mbusco = mbusco + Iif(Empty(mbusco),'',' and ' )+ ' (TabMantenimiento.estado in (0,1,4,6)) ' + mbuser
	Case mpend = 2   && Sin Conforme
		mbusco = mbusco + Iif(Empty(mbusco),'',' and ' )+ ' (conforme is null  AND TabMantenimiento.estado = 2 ) ' + mbuser
	Case mpend = 3   && Solucionados
		mbusco = mbusco + Iif(Empty(mbusco),'',' and ' )+ ' (TabMantenimiento.estado = 2) '+ mbuser
	Case mpend = 4
	    IF EMPTY(mbuser)
	        mbusco = mbusco + Iif(Empty(mbusco),' 1=1 ',"")
	    else
		    mbusco = mbusco + Iif(Empty(mbusco),' 1=1 ',' and ' )+ mbuser
		ENDIF 
	Case mpend = 5   &&x Nro. de Solicitud
		If Nvl(mNroSol,0) = 0
			Messagebox("Debe ingresar Nro. de Solicitud.",16,"Validación")
			mBusco = " 1=0 "
		Else
			mbusco = ' TabMantenimiento.id = ' + Alltrim(Str(mNroSol)) + ' '
		Endif
	Endcase
Else

	mbusco = mbusco + Iif(Empty(mbusco),'',' and ' )+ ' (TabMantenimiento.estado in (0,1,4,6) or (conforme is null  AND TabMantenimiento.estado = 2 )) ' + mbuser
	mfiltro = Iif(Empty(mbusco),'',' and ' )+ ' TabMantenimiento.codsector in (select codsector from Tabmantdetsector where CodigoVax = ?mcodigovax )'

Endif
**mbusco = mbusco + iif(mpend=1, iif(empty(mbusco),'',' and ' )+ ' (TabMantenimiento.estado in (0,1,4,6) or (conforme is null  AND TabMantenimiento.estado = 2 )) ','') + mbuser

**
**if !lmante
**mfiltro = iif(empty(mbusco),'',' and ' )+ ' TabMantenimiento.codsector in (select codsector from Tabmantdetsector where CodigoVax = ?mcodigovax )'
**endif

**SET STEP ON

mret = SQLExec(mcon1,"select TabMantenimiento.id,ClasOrden,TabMantenimiento.CodSector,"+;
	" TabMantenimiento.CodigoVax,Conforme,Estado,FechaIngSolic,FechaPrevTec,FechaSolicUsu,"+;
	" FechaSolucion,FechaTomado,HorasEst,IdTipoRepar,InternoTE,Motivo,OtAdd,Prioridad,"+;
	" ProbTec,Sector,Solucion,TipoDeTarea,TipoEspera,UsuLog,Usuario,TabMantEst.descrip"+;
	" ,UsuFallaDetec,fechaprevtecconf,fechaactivacion,TabMantenimiento.IdArea,"+;
	" NVL(TabEeAreasPlanta.nombre,'') as NombreArea,NVL(TabEeSubAreasPlanta.nombre,'') as NombreSubArea, NVL(TabEePlantasEdificio.nombre,'') as nombreplanta" + ;
	" from TabMantenimiento"+;
	" left join TabMantEst on TabMantenimiento.estado = TabMantEst.codest"+ ;
	" left join TabEeAreasPlanta on TabMantenimiento.idArea = TabEeAreasPlanta.id" + ;
	" left join TabEePlantasEdificio on TabEeAreasPlanta.IdPlanta = TabEePlantasEdificio.id" + ;
	" left join TabEeSubAreasPlanta on TabMantenimiento.idSubArea = TabEeSubAreasPlanta.id" + ;
	" where "+ mbusco + mfiltro+;
	" group by TabMantenimiento.id ", "mwkrecla")

If mret < 0
	Messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
Endif
