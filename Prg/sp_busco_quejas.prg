Lparameters tnOpcion,mlwhere

Local strIdResponsa

LDFECHA = SP_BUSCO_FECHA_SERV('DD') - 10
Do Case
Case tnOpcion = 2

**mlwhere = Iif(Empty(mlwhere), " NVL(TQD_fecPasiva,'1900-01-01') = '1900-01-01' ", mlwhere + " and NVL(TQD_fecPasiva,'1900-01-01') = '1900-01-01' ")

	mret=SQLExec(mcon1,"select tabquejadetalle.*,"+;
		" tqj_paciente,TQJ_NumQueja,tabqueja.id as registronum,TQJ_fechenviopaciente,"+;
		" Estado10.Descrip As Estadoqueja,"+;
		" estado3.Descrip As area,"+;
		" Estado12.Descrip As parentesco,"+;
		" TQJ_Parentesco,"+;
		" estado1.Descrip As subareamedica,"+;
		" tabquejaresponsables.tqr_cargo As responsable,"+;
		" tabareades.area As sector,"+;
		" Estado13.descrip As motivos, "+;
		" estado5.Descrip As subareaadmin,"+;
		" Estado6.Descrip As devolucionpaciente,"+;
		" estado7.Descrip As categoria,"+;
		" Estado8.ent_descrient As entidad,"+;
		" tqj_devolucionpaciente,"+;
		" TQJ_fechqueja As fechaqueja,"+;
		" tqj_categ,"+;
		" tqj_estado,"+;
		" tqD_FECHAENVIO As fechenvio,"+;
		" estado9.Descrip As estadorespu,"+;
		" NVL(TQRR_EstadoRespuesta,0) As EstaRespu,"+;
		" TQRR_Respuestas As Respuestas,"+;
		" TQRR_Usuario as usuario,"+;
		" tqrr_cargafechahora As fechrespurespo,"+;
		" TABUSUARIO.email As Mail ,"+;
		" Estado11.descrip As decidire,"+;
		" tqj_entidad,"+;
		" TQJ_NroRegistracio,"+;
		" TQJ_Observacionesant,"+;
		" TQJ_Libro,"+;
		" TQJ_Hojas,"+;
		" tqj_cargafechahora,"+;
		" TQJ_Folio,"+;
		" TQJ_riesgo, TQJ_emailrespu, TQD_fecpasiva "+;
		" From tabquejadetalle "+;
		" inner Join tabqueja  On tabqueja.id  = tqd_numeroqueja "+;
		" Left Join tabestados As  Estado13  On  tqd_motivo  =  Estado13.estado And Estado13.tipo=10 and Estado13.propietario=15"+;
		" Left join TabQuejaRespuestaResponsable on tqrr_usuario=tqd_responsable and tqd_numeroqueja=tqrr_numeroqueja"+;
		" Left Join tabquejaresponsables   On  tabquejaresponsables.Id = tqd_responsable "+;
		" Left Join tabareades On tabareades.Id = tqd_sector "+;
		" Left Join tabestados As Estado6  On  tqj_devolucionpaciente = Estado6.estado And  Estado6.tipo =0 and Estado6.propietario=15" +;
		" Left Join tabestados As estado3  On  tqd_area = estado3.estado And estado3.tipo=1 and Estado3.propietario=15"+;
		" Left Join tabestados As estado5  On  TQD_SubAreaAdmin   = estado5.estado And estado5.tipo=2 and Estado5.propietario=15"+;
		" Left Join tabestados As estado1  On  tqd_subareamedica  = estado1.estado And estado1.tipo=3 and Estado1.propietario=15 "+;
		" Left Join tabestados As estado7  On  tabqueja.tqj_categ = estado7.estado And estado7.tipo=5 and Estado7.propietario=15"+;
		" Left Join tabestados As Estado10 On  tqj_estado = Estado10.estado And Estado10.tipo=6  and Estado10.propietario=15"+;
		" left Join tabestados As estado9  on  TQRR_EstadoRespuesta=estado9.estado And estado9.tipo=8 and Estado9.propietario=15"+;
		" Left Join tabestados As Estado12 On  TQJ_Parentesco=Estado12.estado And Estado12.tipo=7 and Estado12.propietario=15 "+;
		" Left Join entidades  As Estado8  On  tqj_entidad = Estado8.ent_codent " +;
		" Left Join tabestados As Estado11 On  TQD_DecisionDire = Estado11.estado And Estado11.tipo=10 and Estado11.propietario=15 "+;
		" Left Join TABUSUARIO On tabquejaresponsables.tqr_codigovax=TABUSUARIO.codigovax "+;
		Iif(Empty(mlwhere)," "," Where " + mlwhere)+;
		" Order By tabqueja.Id ","mwkdato1")

** " TQJ_riesgo, TQJ_emailrespu, NVL(TQD_fecpasiva,CAST('1900-01-01' AS DATE)) as TQD_fecpasiva "+;

	If mret <= 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("ERROR DE LECTURA 2",48,"VALIDACION")
*!*	            =Aerror(eros)
*!*	            Messagebox(eros(3))
		Return .F.

	Endif

	Select * From mwkdato1 Where (Nvl(TQD_fecPasiva,Ctod('01/01/1900')) = Ctod('01/01/1900') OR EMPTY(TQD_fecpasiva)) Into Cursor mwkDato READWRITE 
**Update mwkdato Set EstaRespu=0 Where Isnull(EstaRespu)

Case tnOpcion = 3

** ----------- Obtenemnos los responsables del sector (Marcelo Torres, 11/08/2017)
**mret = SQLExec(mcon1,"select * from tabquejaresponsables where TQR_resagrup = ?mlwhere","mwkQuejaResponsa")

	If At("(",mlwhere) > 0
		mret = SQLExec(mcon1,"select * from tabquejaresponsables where TQR_resagrup in " + mlwhere,"mwkQuejaResponsa")
	Else
		mret = SQLExec(mcon1,"select * from tabquejaresponsables where TQR_resagrup = ?mlwhere","mwkQuejaResponsa")
	Endif

	If mret < 0
		Messagebox("ERROR EN LA LECTURA DE RESPONSABLES",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	strIdResponsa = ""
	Select mwkQuejaResponsa
	Go Top
	Scan All
		strIdResponsa = strIdResponsa + Alltrim(Str(mwkQuejaResponsa.Id))+ ","
	Endscan

	If Len(strIdResponsa) > 0
		strIdResponsa = Left(strIdResponsa,Len(strIdResponsa)-1)
	Endif
** ---------------------- Buscamos los datos para el sector

	mret=SQLExec(mcon1,"select TQJ_NumQueja as NumeroQueja,"+;
		" TQD_NumeroQueja,tabqueja.id as registronum,TQRR_USUARIO, "+;
		" TQJ_Libro,"+;
		" TQJ_Hojas,"+;
		" TQJ_Folio, "+;
		" TQD_responsable,"+;
		" tabareades.area as sector,"+;
		" TabQuejaRespuestaResponsable.id,"+;
		" TabQuejaRespuestaResponsable.TQRR_EstadoRespuesta, "+;
		" TabQuejaRespuestaResponsable.tqrr_usuario,"+;
		" TQJ_fechqueja as fechaqueja,"+;
		" tqD_FECHAENVIO As fechenvio,"+;
		" TQRR_Respuestas as respuesta, "+;
		" TabQuejaResponsables.id as usuario,"+;
		" tqj_paciente as paciente, "+;
		" Estado13.descrip As motivos,"+;
		" estado7.descrip as categoria,"+;
		" TABUSUARIO.email as mail,"+;
		" tqrr_cargafechahora as fechrespurespo ,"+;
		" tqd_decisiondire,NVL(TQD_fecpasiva,CAST('1900-01-01' AS DATE)) as TQD_fecpasiva, "+;
		" R.Reg_numdocumento, TQJ_NroRegistracio " +;
		" from tabquejadetalle"+;
		" inner join tabqueja   	on tabqueja.id           = TQD_NumeroQueja  "+;
		" left join Registracio as R on tabqueja.TQJ_nroregistracio = R.Reg_nroregistrac " + ;
		" inner join  TabQuejaResponsables on TQD_Responsable = TabQuejaResponsables.id"+;
		" Left join  tabestados As Estado13 on tqd_motivo    = Estado13.estado And Estado13.tipo=10 and Estado13.propietario=15  "+;
		" Left join  TabQuejaRespuestaResponsable on TQD_NumeroQueja = TQRR_NumeroQueja and TabQuejaResponsables.id = Tqrr_usuario "+;
		" Left join  tabareades on tabareades.id = tqd_sector "+;
		" Left Join  TABUSUARIO On tabquejaresponsables.tqr_codigovax = TABUSUARIO.codigovax "+;
		" Left Join  tabestados As estado7 On  tabqueja.tqj_categ     = estado7.estado And"+;
		" estado7.tipo= 5 and Estado7.propietario = 15"+;
		" WHERE tabquejaresponsables.id in ("+strIdResponsa+") and tqj_estado < 4 "+;
		" and (tqd_decisiondire = 53 or tqd_decisiondire = 0) "+;
		" order by tabqueja.id","mwkrespuestaresponsable1")

*  Iif(Empty(mlwhere)," "," where " + mlwhere)+;*

	If mret <= 0
		Messagebox("ERROR EN LA LECTURA DE QUEJAS/DETALLES POR RESPONSABLES.",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

** ----------- filtro los registros pasivados del detalle
	Select * From mwkrespuestaresponsable1 Where Nvl(TQD_fecPasiva,Ctod('01/01/1900')) = Ctod('01/01/1900') Into Cursor mwkrespuestaresponsable READWRITE 


	Update mwkrespuestaresponsable Set TQRR_EstadoRespuesta = 0;
		Where  Isnull(mwkrespuestaresponsable.TQRR_EstadoRespuesta)

	Update mwkrespuestaresponsable Set sector  = "SIN SECTOR" Where Isnull(sector)
	Update mwkrespuestaresponsable Set motivos = "SIN MOTIVOS" Where Isnull(motivos)

	Select * From mwkrespuestaresponsable Where TQRR_EstadoRespuesta >=2;
		And fechrespurespo>=LDFECHA  ;
		Into Cursor mwkrespuestaresponsablefinal Readwrite

	Select * From mwkrespuestaresponsable Where TQRR_EstadoRespuesta <2;
		Into Cursor mwkrespuestaresponsable Readwrite

	Use In Select("mwkQuejaResponsa")

Case tnOpcion = 4

	If Vartype(mlwhere) # 'N'
		mlwhere1 = " tabQuejaResponsables.id in ("+mlwhere+")"
	Else
		mlwhere= Str(mlwhere)
		mlwhere1 = " tabQuejaResponsables.id in ("+mlwhere+")"
	Endif

	LNOCCURS = Occurs(",",mlwhere)
	If LNOCCURS > 0
		lnfirst  = At(",",mlwhere,1)
		lnsecond = At(",",mlwhere,2)
		lnid1 = Val(Substr(mlwhere,1,lnfirst))
		lnid2 = Val(Substr(mlwhere,lnfirst + 1,lnsecond - lnfirst))
		lnid3 = Val(Substr(mlwhere,lnsecond + 1))
	Else
		lnid1 = Val(mlwhere)
		lnid2 = 0
		lnid3 = 0
	Endif

	mret=SQLExec(mcon1,"select TQJ_NumQueja as NumeroQueja,"+;
		" TQD_NumeroQueja,tabqueja.id as registronum, "+;
		" tqj_estado,"+;
		" TQJ_Libro,"+;
		" TQJ_Hojas,"+;
		" TQJ_Folio, "+;
		" tabareades.area as sector,"+;
		" TabQuejaRespuestaResponsable.id,"+;
		" TabQuejaRespuestaResponsable.TQRR_EstadoRespuesta, "+;
		" TQJ_fechqueja as fechaqueja,"+;
		" tqD_FECHAENVIO As fechenvio,"+;
		" TQRR_Respuestas as respuesta, "+;
		" TabQuejaResponsables.id as usuario,"+;
		" tqj_paciente as paciente, "+;
		" Estado13.descrip As motivos,"+;
		" estado7.descrip as categoria,"+;
		" TABUSUARIO.email as mail,"+;
		" TABUSUARIO.nomape as nombrerespo,"+;
		" tqrr_cargafechahora as fechrespurespo ,"+;
		" tqd_decisiondire, NVL(TQD_fecpasiva,CAST('1900-01-01' AS DATE)) as TQD_fecpasiva, "+;
		" R.Reg_numdocumento " +;
		" from tabquejadetalle"+;
		" inner join tabqueja  on tabqueja.id  = TQD_NumeroQueja  "+;
		" left join Registracio as R on tabqueja.TQJ_nroregistracio = R.Reg_nroregistrac " + ;
		" left join tabestados As Estado13 on tqd_motivo = Estado13.estado And Estado13.tipo=10 and Estado13.propietario=15 "+;
		" left join  TabQuejaResponsables on TabQuejaResponsables.id = TQD_Responsable  "+;
		" left join TabQuejaRespuestaResponsable on TQD_NumeroQueja = TQRR_NumeroQueja  "+;
		" left join tabareades on tabareades.id = tqd_sector"+;
		" Left Join TABUSUARIO On tabquejaresponsables.tqr_codigovax=TABUSUARIO.codigovax "+;
		" Left Join tabestados As estado7 On  tabqueja.tqj_categ = estado7.estado And estado7.tipo = 5 and Estado7.propietario = 15"+;
		Iif(Empty(mlwhere)," "," where " + mlwhere1)+" and tqj_estado < 4  "+;
		" and tqd_decisiondire in(53,0,52) "+;
		" order by tabqueja.id","mwkrespuestaresponsable1")
*  Iif(Empty(mlwhere)," "," where " + mlwhere)+;*
* TQR_NomApe = ?mlwhere and
*

	If mret <= 0

		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("ERROR DE LECTURA QUEJAS/DETALLES - 4",48,"VALIDACION")
*!*			=Aerror(eros)
*!*			Messagebox(eros(3))
		Return .F.

	Endif

** ------------------ Excluyo los items con fecha de pasiva
	Select * From mwkrespuestaresponsable1 Where Nvl(TQD_fecPasiva,Ctod('01/01/1900')) = Ctod("01/01/1900") Into Cursor mwkrespuestaresponsable READWRITE 


	Update mwkrespuestaresponsable Set TQRR_EstadoRespuesta = 0;
		Where  Isnull(mwkrespuestaresponsable.TQRR_EstadoRespuesta)

	Update mwkrespuestaresponsable Set sector  = "SIN SECTOR"  Where Isnull(sector)
	Update mwkrespuestaresponsable Set motivos = "SIN MOTIVOS" Where Isnull(motivos)

	If lnid3 > 0

		Select * From mwkrespuestaresponsable Where TQD_DecisionDire = 50 And TQRR_EstadoRespuesta <2;
			AND usuario <= lnid3;
			Into Cursor mwkrespuestaresponsable1 Readwrite

		Select * From mwkrespuestaresponsable Where TQRR_EstadoRespuesta >= 2;
			And fechrespurespo>=LDFECHA ;
			AND usuario <=lnid3;
			Into Cursor mwkrespuestaresponsablefinal Readwrite


		Select * From mwkrespuestaresponsable Where usuario <= lnid3;
			And TQD_DecisionDire In (52,53) And TQRR_EstadoRespuesta <2;
			Into Cursor mwkrespuestaresponsable
	Else

		Select * From mwkrespuestaresponsable Where TQD_DecisionDire=50 And TQRR_EstadoRespuesta <2;
			AND usuario =lnid1;
			Into Cursor mwkrespuestaresponsable1 Readwrite

		Select * From mwkrespuestaresponsable Where TQRR_EstadoRespuesta >=2;
			And fechrespurespo>=LDFECHA And TQD_DecisionDire <>52;
			AND usuario =lnid1;
			Into Cursor mwkrespuestaresponsablefinal Readwrite


		Select * From mwkrespuestaresponsable Where usuario=lnid1;
			And TQD_DecisionDire  In (52,53)  And TQRR_EstadoRespuesta <2;
			Into Cursor mwkrespuestaresponsable


	Endif

	Select * From mwkrespuestaresponsable1;
		union;
		Select * From mwkrespuestaresponsable;
		Into Cursor mwkrespuest Readwrite

	Select * From  mwkrespuest;
		into Cursor mwkrespuestaresponsable

	Use In mwkrespuest
	Use In mwkrespuestaresponsable1

Case tnOpcion = 5

	mret=SQLExec(mcon1,"select TQJ_NumQueja as NumeroQueja,"+;
		" TQD_NumeroQueja,tabqueja.id as registronum,"+;
		" tqj_estado,"+;
		" TQJ_Libro,"+;
		" TQJ_Hojas,"+;
		" TQJ_Folio, "+;
		" tabareades.area as sector,"+;
		" TabQuejaRespuestaResponsable.id,"+;
		" TabQuejaRespuestaResponsable.TQRR_EstadoRespuesta, "+;
		" TQJ_fechqueja as fechaqueja,"+;
		" tqD_FECHAENVIO As fechenvio,"+;
		" TQRR_Respuestas as respuesta, "+;
		" TabQuejaResponsables.id as usuario,"+;
		" tqj_paciente as paciente, "+;
		" Estado13.descrip As motivos,"+;
		" estado7.descrip as categoria,"+;
		" TABUSUARIO.email as mail,"+;
		" tqrr_cargafechahora as fechrespurespo ,"+;
		" tqd_decisiondire,NVL(TQD_fecpasiva,CAST('1900-01-01' AS DATE)) as TQD_fecpasiva "+;
		" from tabquejadetalle"+;
		" inner join tabqueja     on tabqueja.id  = TQD_NumeroQueja  "+;
		" left join tabestados As Estado13 on tqd_motivo =Estado13.estado And Estado13.tipo=10 and Estado13.propietario=15 "+;
		" left join  TabQuejaResponsables on TabQuejaResponsables.id = TQD_Responsable "+;
		" left join TabQuejaRespuestaResponsable on TQD_NumeroQueja = TQRR_NumeroQueja and TabQuejaResponsables.id = Tqrr_usuario"+;
		" left join tabareades on tabareades.id = tqd_sector"+;
		" Left Join TABUSUARIO On tabquejaresponsables.tqr_codigovax=TABUSUARIO.codigovax "+;
		" Left Join tabestados As estado7 On  tabqueja.tqj_categ = estado7.estado And estado7.tipo=5 and Estado7.propietario=15"+;
		" WHERE TabQuejaResponsables.id = ?mlwhere and tqj_estado < 4  "+;
		" and ( tqd_decisiondire = 53 or tqd_decisiondire = 0 or tqd_decisiondire = 54) "+;
		" order by tabqueja.id","mwkrespuestaresponsable1")
*  Iif(Empty(mlwhere)," "," where " + mlwhere)+;*
* TQR_NomApe = ?mlwhere and

	If mret <= 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("ERROR DE LECTURA QUEJAS/DETALLES - 5",48,"VALIDACION")
*!*	            =Aerror(eros)
*!*	            Messagebox(eros(3))
		Return .F.

	Endif

** -------------------------- Excluimos Detalles pasivados
	Select * From mwkrespuestaresponsable1 Where Nvl(TQD_fecPasiva,Ctod('01/01/1900')) = Ctod("01/01/1900") Into Cursor mwkrespuestaresponsable READWRITE 


	Update mwkrespuestaresponsable Set TQRR_EstadoRespuesta = 0;
		Where  Isnull(mwkrespuestaresponsable.TQRR_EstadoRespuesta)

	Update mwkrespuestaresponsable Set sector  = "SIN SECTOR"  Where Isnull(sector)
	Update mwkrespuestaresponsable Set motivos = "SIN MOTIVOS" Where Isnull(motivos)

	Select * From mwkrespuestaresponsable Where TQD_DecisionDire=54 And TQRR_EstadoRespuesta <2;
		Into Cursor mwkrespuestaresponsable1 Readwrite

	Select * From mwkrespuestaresponsable Where TQRR_EstadoRespuesta >=2;
		And fechrespurespo>=LDFECHA And TQD_DecisionDire <>54;
		AND usuario=?mlwhere;
		Into Cursor mwkrespuestaresponsablefinal Readwrite

	Select * From mwkrespuestaresponsable Where usuario=?mlwhere;
		And TQD_DecisionDire <>54 And TQRR_EstadoRespuesta <2;
		Into Cursor mwkrespuestaresponsable

	Select * From mwkrespuestaresponsable1;
		union;
		Select * From mwkrespuestaresponsable;
		Into Cursor mwkrespuest Readwrite

	Select * From  mwkrespuest;
		into Cursor mwkrespuestaresponsable

	Use In mwkrespuest
	Use In mwkrespuestaresponsable1

Case tnOpcion = 6

**mlwhere = Iif(Empty(mlwhere), " NVL(TQD_fecPasiva,'1900-01-01') = '1900-01-01' ", mlwhere + " and NVL(TQD_fecPasiva,'1900-01-01') = '1900-01-01' ")

	mret=SQLExec(mcon1,"select tabquejadetalle.*,"+;
		" tqj_paciente,TQJ_NumQueja as NumeroQueja,tabqueja.id as registronum,"+;
		" Estado10.Descrip As Estadoqueja,"+;
		" estado3.Descrip As area,"+;
		" Estado12.Descrip As parentesco,"+;
		" TQJ_Parentesco,"+;
		" estado1.Descrip As subareamedica,"+;
		" tabquejaresponsables.tqr_cargo As responsable,"+;
		" tabareades.area As sector,"+;
		" Estado13.descrip As motivos, "+;
		" estado5.Descrip As subareaadmin,"+;
		" Estado6.Descrip As devolucionpaciente,"+;
		" estado7.Descrip As categoria,"+;
		" Estado8.ent_descrient As entidad,"+;
		" tqj_devolucionpaciente,"+;
		" TQJ_fechqueja As fechaqueja,"+;
		" tqj_categ,"+;
		" tqj_estado,"+;
		" TQJ_Libro,"+;
		" TQJ_Hojas,"+;
		" TQJ_Folio, "+;
		" tqD_FECHAENVIO As fechenvio,"+;
		" estado9.Descrip As estadorespu,"+;
		" TQRR_EstadoRespuesta As EstaRespu,"+;
		" TQRR_Respuestas As Respuestas,"+;
		" TQRR_Usuario as usuario,"+;
		" tqrr_cargafechahora As fechrespurespo,"+;
		" TABUSUARIO.email As Mail ,"+;
		" Estado11.MotivoText As decidire,"+;
		" tqj_entidad,"+;
		" TQJ_NroRegistracio,"+;
		" TQJ_Observacionesant,"+;
		" TQJ_Libro,"+;
		" TQJ_Hojas,"+;
		" TQJ_Folio, NVL(TQD_fecpasiva,CAST('1900-01-01' AS DATE)) as TQD_fecpasiva "+;
		" From tabquejadetalle "+;
		" inner Join tabqueja   On tabqueja.id  = tqd_numeroqueja "+;
		" left join tabestados As Estado13 on tqd_motivo =Estado13.estado And Estado13.tipo=10 and Estado13.propietario=15  "+;
		" Left join TabQuejaRespuestaResponsable on tqrr_usuario=tqd_responsable and tqd_numeroqueja=tqrr_numeroqueja"+;
		" Left Join tabquejaresponsables   On  tabquejaresponsables.Id = tqd_responsable "+;
		" Left Join tabareades On tabareades.Id = tqd_sector "+;
		" Left Join tabestados As Estado6  On  tqj_devolucionpaciente = Estado6.estado And  Estado6.tipo=0 and Estado6.propietario=15" +;
		" Left Join tabestados As estado3  On  tqd_area = estado3.estado And estado3.tipo=1 and Estado3.propietario=15"+;
		" Left Join tabestados As estado5  On  TQD_SubAreaAdmin = estado5.estado And estado5.tipo=2 and Estado5.propietario=15"+;
		" Left Join tabestados As estado1  On  tqd_subareamedica= estado1.estado And estado1.tipo=3 and Estado1.propietario=15 "+;
		" Left Join tabestados As estado7  On  tabqueja.tqj_categ =estado7.estado And estado7.tipo=5 and Estado7.propietario=15"+;
		" Left Join tabestados As Estado10 On  tqj_estado = Estado10.estado And Estado10.tipo=6  and Estado10.propietario=15"+;
		" left Join tabestados As estado9  on  TQRR_EstadoRespuesta=estado9.estado And estado9.tipo =8 and Estado9.propietario=15"+;
		" Left Join tabestados As Estado12 On  TQJ_Parentesco=Estado12.estado And Estado12.tipo  =7 and Estado12.propietario=15 "+;
		" Left Join entidades  As Estado8  On  tqj_entidad = Estado8.ent_codent " +;
		" Left Join motivos    As Estado11 On  Estado11.Idmotivo = TQD_DecisionDire "+;
		" Left Join TABUSUARIO On tabquejaresponsables.tqr_codigovax = TABUSUARIO.codigovax "+;	
		Iif(Empty(mlwhere)," "," Where " + mlwhere)+;
		" Order By tabqueja.Id ","mwkquejastot1")

	If mret <= 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("ERROR DE LECTURA",48,"VALIDACION")
*!*			            =Aerror(eros)
*!*			           Messagebox(eros(3))
		Return .F.

	Endif

** -------------------- Excluimos detalles pasivados
	Select * From mwkquejastot1 Where Nvl(TQD_fecPasiva,Ctod('01/01/1900')) = Ctod("01/01/1900") Into Cursor mwkquejastot READWRITE 


	Update mwkquejastot Set responsable = "SIN RESPONSABLE"     Where Isnull(responsable)
	Update mwkquejastot Set motivos     = "SIN MOTIVOS"         Where Isnull(motivos)
	Update mwkquejastot Set decidire    = "SIN DECISIÓN"        Where Isnull(decidire)
	Update mwkquejastot Set Estadoqueja = "SIN ESTADO DEFINIDO" Where Isnull(Estadoqueja)

Case tnOpcion = 7
	mret=SQLExec(mcon1,"select TQJ_NumQueja as NumeroQueja,"+;
		" TQD_NumeroQueja ,tabqueja.id as registronum,"+;
		" tqj_estado,"+;
		" TQJ_Libro,"+;
		" TQJ_Hojas,"+;
		" TQJ_Folio, "+;
		" tabareades.area as sector,"+;
		" TabQuejaRespuestaResponsable.id,"+;
		" TabQuejaRespuestaResponsable.TQRR_EstadoRespuesta, "+;
		" TQJ_fechqueja as fechaqueja,"+;
		" tqD_FECHAENVIO As fechenvio,"+;
		" TQRR_Respuestas as respuesta, "+;
		" TabQuejaResponsables.id as usuario,"+;
		" tqj_paciente as paciente, "+;
		" Estado13.descrip As motivos,"+;
		" estado7.descrip as categoria,"+;
		" TABUSUARIO.email as mail,"+;
		" tqrr_cargafechahora as fechrespurespo ,"+;
		" tqd_decisiondire,NVL(TQD_fecpasiva,CAST('1900-01-01' AS DATE)) as TQD_fecpasiva "+;
		" from tabquejadetalle"+;
		" inner join tabqueja     on tabqueja.id= TQD_NumeroQueja  "+;
		" left join tabestados As Estado13 on tqd_motivo =Estado13.estado And Estado13.tipo=10 and Estado13.propietario=15 "+;
		" left join  TabQuejaResponsables on TabQuejaResponsables.id = TQD_Responsable "+;
		" left join TabQuejaRespuestaResponsable on TQD_NumeroQueja = TQRR_NumeroQueja"+;
		" left join tabareades on tabareades.id = tqd_sector"+;
		" Left Join TABUSUARIO On tabquejaresponsables.tqr_codigovax=TABUSUARIO.codigovax "+;
		" Left Join tabestados As estado7 On  tabqueja.tqj_categ = estado7.estado And estado7.tipo=5 and Estado7.propietario=15"+;
		" WHERE tqj_estado < 4 "+;
		" order by tabqueja.id","mwkrespuestaresponsable1")
*  Iif(Empty(mlwhere)," "," where " + mlwhere)+;*
* TQR_NomApe = ?mlwhere and

	If mret <= 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("ERROR DE LECTURA",48,"VALIDACION")
*!*	            =Aerror(eros)
*!*	            Messagebox(eros(3))
		Return .F.

	Endif

** -------------------- Excluimos detalles pasivados
	Select * From mwkrespuestaresponsable1 Where Nvl(TQD_fecPasiva,Ctod('01/01/1900')) = Ctod("01/01/1900") Into Cursor mwkrespuestaresponsable READWRITE


	Update mwkrespuestaresponsable Set TQRR_EstadoRespuesta = 0;
		Where  Isnull(mwkrespuestaresponsable.TQRR_EstadoRespuesta)

	Update mwkrespuestaresponsable Set sector  = "SIN SECTOR" Where Isnull(sector)
	Update mwkrespuestaresponsable Set motivos = "SIN MOTIVOS" Where Isnull(motivos)
	Update mwkrespuestaresponsable Set Id  = 0 Where Isnull(Id)


	Select * From mwkrespuestaresponsable Where TQRR_EstadoRespuesta>=2;
		into Cursor mwkrespuestaresponsablefinal

	Select * From mwkrespuestaresponsable Where TQRR_EstadoRespuesta<2;
		into Cursor mwkrespuestaresponsable Readwrite

Endcase

USE IN SELECT("mwkrespuestaresponsable1")
USE IN SELECT("mwkquejastot1")

