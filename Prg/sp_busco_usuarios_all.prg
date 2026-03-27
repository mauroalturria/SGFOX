***
*** Busqueda de usuario
***
Lparameters mexe,mfecpasiva,mcontrolamb,mbus,mtodos
mfecpas = Ctod('01/01/1900')
mfp = ' and tabusuario.fecpasiva = ?mfecpas '
If Vartype(mfecpasiva)="D"
	mfp = " and (tabusuario.fecpasiva = ?mfecpas or tabusuario.fecpasiva >= ?mfecpasiva ) "
Endif
If Vartype(mbus)#"C"
	mbus = ''
Endif
If Vartype(mcontrolamb)#"N"
	mcontrolamb = 0
ENDIF
If Vartype(mtodos)#"N"
	mtodos = 0
Endif
Use In Select("mwkusuariosall")

If Type('mexe')#'C'

	mfp = Iif(Vartype(mfecpasiva)="D"," and (tabusuario.fecpasiva = ?mfecpas or tabusuario.fecpasiva >= ?mfecpasiva ) ",'')

	mret = SQLExec(mcon1, "select * from tabusuario " + ;
		"where id<10000000 &mfp group by codigovax order by nomape ", "mwkusuariosall")
Else
	If Empty(mexe)
		mbuscco = ''
	Else
		mbuscco = " and tabexe.nomexe=?mexe "
	ENDIF 
	mcambjoin = ''
	If mcontrolamb = 1 And mxambito>1
		mcambjoin = ' inner join TabPermisosAmbito on ( '+;
			' Tabpermisosambito.codambito = ?mxambito '+;
			' AND Tabpermisosambito.codusuario = Tabusuario.ID )'
	Endif
	mret = SQLExec(mcon1, "select tabusuario.*,tabsectores.descrip,tabsectorusuario.codsector " + ;
		" from tabpermisosexe,tabexe,tabusuario " + ;
		" left join tabsectorusuario on (tabsectorusuario.codusuario = tabusuario.id " + ;
		" and preferido =1 ) "+;
		" left join tabsectores  on tabsectores.id =  tabsectorusuario.codsector " + ;
		mcambjoin +" where tabpermisosexe.codusuario = tabusuario.id "+;
		" and tabpermisosexe.codexe = tabexe.id "+;
		mfp + mbuscco  + ;
		" and tabpermisosexe.fecpasiva = ?mfecpas  " + ;
		" and tabexe.fecpasiva = ?mfecpas  " + mbus +;
		" and tabusuario.id<10000000 group by tabusuario.id order by nomape ", "mwkusuariosall")
IF 	mtodos = 1
	mret = SQLExec(mcon1, "select tabusuario.*,tabsectores.descrip,tabsectorusuario.codsector " + ;
		" from tabpermisosexe,tabexe,tabusuario " + ;
		" left join tabsectorusuario on  tabsectorusuario.codusuario = tabusuario.id " + ;
 		" left join tabsectores  on tabsectores.id =  tabsectorusuario.codsector " + ;
		mcambjoin +" where tabpermisosexe.codusuario = tabusuario.id "+;
		" and tabpermisosexe.codexe = tabexe.id "+;
		mfp + mbuscco  + ;
		" and tabpermisosexe.fecpasiva = ?mfecpas  " + ;
		" and tabexe.fecpasiva = ?mfecpas  " + mbus +;
		" and tabusuario.id<10000000 group by tabusuario.id order by nomape ", "mwkusuariosallsinsec")
endif

Endif
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do prg_cancelo
Endif
