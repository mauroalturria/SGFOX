


*Append From c:\desaguemes\hclin.txt Delimited With Tab

Select  Base
Set Step On
Scan
	nhc = Base.hcli
	Requery('regishc')
	mnroreg = regishc.REG_nroregistrac
	Select  Base
	Replace usualta WITH transform( Nvl(regishc.REG_bloq_oper,0)), fechalta With regishc.REG_fecregistra  ;
		, usumod With transform(NVL(regishc.REG_operadormod,0))  , fechamod With NVL(regishc.REG_fechamod,CTOD("//"))

	Requery('guardia')
	If Reccount('guardia')>0
		Select guardia
		Go Top
		Select  Base
		Replace usugua With guardia.usuario, fechagua With guardia.fechahoraing
	Endif
	Requery('ambu')
	If Reccount('ambu')>0
		Select ambu
		Go Top
		Select  Base
		Replace usuamb With Transform(ambu.VAL_OperadorCarga), fechaamb With ambu.VAL_fechasolicitud
	Endif
	Requery('turnohis')
	If Reccount('turnohis')>0
		Select turnohis
		Go Top
		Select  Base
		Replace usutur With Transform(turnohis.usuario), fechatur With turnohis.fechatomado
	
	ELSE
		Requery('turno')
	If Reccount('turno')>0
		Select turno
		Go Top
		Select  Base
		Replace usutur With Transform(turno.usuario), fechatur With turno.fechatomado
	ENDIF
	Endif
Endscan


