****
** busco camas en habitacions
****
Parameter mcodsec, mhabitsala, msql_cama,sectoresped

If !Used('mwkepicov')
	mifec = sp_busco_fecha_serv("DD")
	mfecbusca = prg_dtoc(mifec -50)
	Do sp_busco_ficha_covid With 2," and Zabregcontagio.FecHorDbAdd>='"+mfecbusca +"' "
ENDIF
Do sp_busco_estados With 54,' and tipo = 99 ','mwkhabcolorcovid'&&
If mwkhabcolorcovid.estado = 0
	Select * From mwkepicov Where 1=2 Into Cursor mwkepicov
Endif
*!*	mret = SQLExec(mcon1, "select hab_codpaciente " + ;
*!*		" from habitacions inner join pacientes on " + ;
*!*		" habitacions.hab_codpaciente = pacientes.pac_codadmision " + ;
*!*		" inner join Tabrelreg on pacientes.pac_codadmision = TRR_AdmOrig " + ;
*!*		" inner join pacinternad on pacinternad.pin_codadmision = pacientes.pac_codadmision " + ;
*!*		" where 1=2 and hab_sectores = ?mcodsec " , "mwkcama0a")

*!*	If Reccount("mwkcama0a")>0
*!*		mret = SQLExec(mcon1, "select hab_codhabitacion, hab_codcama, hab_codpaciente, hab_codbloqueo, " + ;
*!*			" hab_habilitada, pacientes.pac_nombrepaciente, pacientes.pac_sexo, pacientes.pac_edad, " + ;
*!*			" pacientes.pac_descripdiagn, pacientes.pac_categoria, pin_codentidad,pacientes.PAC_sectorinternac, pacientes.PAC_fechaadmision,"+;
*!*			" TRR_AdmOrig ,nacimiento.pac_nombrepaciente AS NAC_nombrepaciente ,nacimiento.pac_sexo as nac_sexo"+;
*!*			" ,nacimiento.pac_edad as nac_edad,nacimiento.pac_descripdiagn as nac_descripdiagn,nacimiento.pac_codadmision as nac_codadmision   " + ;
*!*			" from habitacions left outer join pacientes on " + ;
*!*			" habitacions.hab_codpaciente = pacientes.pac_codadmision " + ;
*!*			" left outer join pacinternad on pacinternad .pin_codadmision = pacientes.pac_codadmision " + ;
*!*			" left outer join Tabrelreg on pacinternad .pin_codadmision = TRR_AdmOrig " + ;
*!*			" left outer join pacientes as nacimiento on nacimiento.pac_codadmision = TRR_AdmDest  " + ;
*!*			" where hab_sectores = ?mcodsec " + ;
*!*			" order by hab_codhabitacion, hab_codcama", "mwkcama0")
*!*	Else
Do sp_busco_estados With 57," and tipo = 53  order by subestado ","mwkhabcmsec"
mwcm = ''
If mwkhabcmsec.estado = 1
	mwcm = " and hab_sectores in (select sec_codsector from sectores where sec_centromedico = ?mxcentromedico) "
Endif
mret = SQLExec(mcon1, "select hab_codpaciente " + ;
	" from habitacions inner join pacientes on " + ;
	" habitacions.hab_codpaciente = pacientes.pac_codadmision " + ;
	" inner join Tabrelreg on pacientes.pac_codadmision = TRR_AdmDest" + ;
	" inner join pacinternad on pacinternad.pin_codadmision = Tabrelreg.TRR_AdmOrig  " + ;
	" where hab_sectores = ?mcodsec " +mwcm, "mwkcama0b")
If Reccount("mwkcama0b")>0
	mret = SQLExec(mcon1, "select hab_codhabitacion, hab_codcama, hab_codpaciente, hab_codbloqueo, " + ;
		" hab_habilitada, pacientes.pac_nombrepaciente, pacientes.pac_sexo, pacientes.pac_edad, " + ;
		" pacientes.pac_descripdiagn, pacientes.pac_categoria, pin_codentidad,pacientes.PAC_sectorinternac, pacientes.PAC_fechaadmision,"+;
		" TRR_AdmOrig ,nacimiento.pac_nombrepaciente AS NAC_nombrepaciente ,nacimiento.pac_sexo as nac_sexo,nacimiento.pac_motivoalta   "+;
		" ,nacimiento.pac_edad as nac_edad,nacimiento.pac_descripdiagn as nac_descripdiagn,nacimiento.pac_codadmision as nac_codadmision   " + ;
		" ,nacimiento.pac_categoria as nac_categoria,nacimiento.PAC_sectorinternac as nAC_sectorinternac,nacimiento.PAC_habitacion as nAC_habitacion,nacimiento.PAC_cama as nAC_cama" + ;
		" from habitacions left outer join pacientes on " + ;
		" habitacions.hab_codpaciente = pacientes.pac_codadmision " + ;
		" left outer join pacinternad on pacinternad .pin_codadmision = pacientes.pac_codadmision " + ;
		" left outer join Tabrelreg on pacinternad .pin_codadmision = TRR_AdmDest " + ;
		" left outer join pacientes as nacimiento on nacimiento.pac_codadmision = TRR_AdmOrig  " + ;
		" where hab_sectores = ?mcodsec " +mwcm+ ;
		" order by hab_codhabitacion, hab_codcama", "mwkcama0")
Else
	mret = SQLExec(mcon1, "select hab_codhabitacion, hab_codcama, hab_codpaciente, hab_codbloqueo, " + ;
		" hab_habilitada, pac_nombrepaciente, pac_sexo, pac_edad, " + ;
		" pac_descripdiagn, pac_categoria, pin_codentidad,PAC_sectorinternac, PAC_fechaadmision " + ;
		" from habitacions left outer join pacientes on " + ;
		" habitacions.hab_codpaciente = pacientes.pac_codadmision " + ;
		" left outer join pacinternad on pacinternad .pin_codadmision = pacientes.pac_codadmision " + ;
		" where hab_sectores = ?mcodsec " +mwcm+ ;
		" order by hab_codhabitacion, hab_codcama", "mwkcama0")

Endif


*!*	Endif
If mcodsec="EME" Or mcodsec$sectoresped
	mifecha = sp_busco_fecha_serv("DT")-24*3600
	mret = SQLExec(mcon1," SELECT PACIENTE,IdMotivo,Atendido    "+;
		" FROM	SOCIO " + ;
		" WHERE	 IdMotivo =57 AND HoraLLegada>=?MIFECHA ","mwkAtendidoA")

	Select  mwkcama0.*,THC_Cor,Iif(Inlist(PAC_sectorinternac,"EME",'CEG','IDE'),"Ingreso:"+Dtoc(PAC_fechaadmision)+" - ",'')+Alltrim(pac_descripdiagn) As pac_diagn, ;
		iif(Isnull(IdMotivo) And !Isnull(pac_nombrepaciente),0,Iif(atendido,0,Iif(!Isnull(pac_nombrepaciente),1,0))) As Id_Motivo ,rc_estado,COV_HisopaVigilan,RC_hisopadoFecha ;
		from mwkcama0;
		left Join mwkepicov  On  admisionficha = hab_codpaciente;
		left Join mwkCorcama On hab_codhabitacion = THC_Hab And hab_codcama = THC_Cama ;
		left Join mwkAtendidoA On Alltrim(mwkAtendidoA.PACIENTE)=hab_codpaciente;
		into Cursor mwkcama1a

Else
	Select  mwkcama0.*,THC_Cor,;
		iif(Inlist(PAC_sectorinternac,"EME",'CEG','IDE'),"Ingreso:"+Dtoc(PAC_fechaadmision)+" - ",'')+Alltrim(pac_descripdiagn) As pac_diagn, ;
		0 As Id_Motivo,rc_estado,COV_HisopaVigilan,RC_hisopadoFecha  ;
		from mwkcama0;
		left Join mwkepicov  On  admisionficha = hab_codpaciente ;
		left Join mwkCorcama On hab_codhabitacion = THC_Hab And hab_codcama = THC_Cama ;
		into Cursor mwkcama1a
Endif
Use In 	Select('mwkcama0')

Select mwkcama1a.*,tipoaisla,Ctot(Dtoc(apv_fechaauditoria)+" "+Left(Ttoc(apv_horaauditoria,2),5)) As horaaud,tiponaislanew,codaisla;
	FROM mwkcama1a Left Join mwkpacintaisla On hab_codpaciente = mwkpacintaisla.apv_codadmision;
	Left Join mwkpacintaislanew On hab_codpaciente = mwkpacintaislanew.apv_codadmision Into Cursor mwkcama1

If mhabitsala = 'H'  And Reccount("mwkcama0b")=0
	Selec hab_codhabitacion;
		,Iif(hab_codcama = '01',hab_codcama,'  ')  As cam1 ;
		,Iif(hab_codcama = '01',Iif(Empty(pac_categoria) And Empty(Nvl(tipoaisla,' ')),' ',Iif(Empty(Nvl(tipoaisla,'')),pac_categoria,'B')),' ') As pac1 ;
		,Iif(hab_codcama = '01',pin_codentidad ,pin_codentidad-pin_codentidad) As ent1 ;
		,Iif(hab_codcama = '01',pac_nombrepaciente ,Space(50) ) As nom1 ;
		,Iif(hab_codcama = '01',pac_sexo ,' ') As sex1 ;
		,Iif(hab_codcama = '01',pac_edad ,pac_edad-pac_edad) As eda1 ;
		,Iif(hab_codcama = '01',pac_descripdiagn ,Space(50)) As dia1 ;
		,Iif(hab_codcama = '01',hab_codpaciente ,'        ') As codp1 ;
		,Iif(hab_codcama = '01',Nvl(THC_Cor,0) ,0) As cama_esp_1 ;
		,Iif(hab_codcama = '01',Iif(Isnull(tipoaisla),Space(50) ,tipoaisla),Space(50) ) As tipoaisla1 ;
		,Iif(hab_codcama = '01',Iif(Isnull(horaaud),Space(20),Ttoc(horaaud)),'        ') As hora1 ;
		,Iif(hab_codcama = '01',Nvl(rc_estado,0) ,0) As rc_estado_1 ;
		,Iif(hab_codcama = '01',Nvl(COV_HisopaVigilan,0) ,0) As COV_hv_1 ;
		,Iif(hab_codcama = '01',Nvl(RC_hisopadoFecha,Ctod("01/01/1900")),Ctod("01/01/1900")) As RC_hf1;
		,Iif(hab_codcama = '02',hab_codcama ,'  ') As cam2;
		,Iif(hab_codcama = '02',Iif(Empty(pac_categoria) And Empty(Nvl(tipoaisla,' ')),' ',Iif(Empty(Nvl(tipoaisla,'')),pac_categoria,'B')),' ') As pac2 ;
		,Iif(hab_codcama = '02',pin_codentidad ,pin_codentidad-pin_codentidad) As ent2;
		,Iif(hab_codcama = '02',pac_nombrepaciente ,Space(50)) As nom2;
		,Iif(hab_codcama = '02',pac_sexo ,' ') As sex2 ;
		,Iif(hab_codcama = '02',pac_edad ,pac_edad-pac_edad) As eda2;
		,Iif(hab_codcama = '02',pac_diagn ,Space(50)) As dia2;
		,Iif(hab_codcama = '02',hab_codpaciente,'        ') As codp2 ;
		,Iif(hab_codcama = '02',Nvl(THC_Cor,0) ,0) As cama_esp_2,Id_Motivo  ;
		,Iif(hab_codcama = '02',Iif(Isnull(tipoaisla),Space(50) ,tipoaisla),Space(50) ) As tipoaisla2 ;
		,Iif(hab_codcama = '02',Iif(Isnull(horaaud),Space(20),Ttoc(horaaud)),'        ') As hora2 ;
		,Iif(hab_codcama = '02',Nvl(rc_estado,0) ,0) As rc_estado_2 ;
		,Iif(hab_codcama = '02',Nvl(COV_HisopaVigilan,0) ,0) As COV_hv_2 ;
		,Iif(hab_codcama = '02',Nvl(RC_hisopadoFecha,Ctod("01/01/1900")),Ctod("01/01/1900"))  As RC_hf2;
		from mwkcama1 Into Cursor mwkc2

	Selec hab_codhabitacion As hab1, Max(cam1) As cam1, Max(pac1) As pac1, ;
		max(ent1) As ent1, Max(nom1) As nom1, Max(sex1) As sex1,  ;
		max(eda1) As eda1, Max(dia1) As dia1,Max(codp1) As codp1,Max(tipoaisla1 ) As tipoaisla1 ,Max(hora1) As hora1;
		,Max(rc_estado_1) As rc_estado_1,Max(COV_hv_1) As COV_hv_1,  Max(RC_hf1) As RC_hf1,  ;
		hab_codhabitacion As hab2, Max(cam2) As cam2, Max(pac2) As pac2, ;
		max(ent2) As ent2, Max(nom2) As nom2, Max(sex2) As sex2, ;
		max(eda2) As eda2, Max(dia2) As dia2,Max(codp2 ) As codp2,Max(tipoaisla2 ) As tipoaisla2,Max(hora2) As hora2;
		,Max(rc_estado_2) As rc_estado_2,Max(COV_hv_2) As COV_hv_2,Max(RC_hf2) As RC_hf2,   ;
		cama_esp_1, cama_esp_2,Id_Motivo  ;
		from mwkc2 Group By hab_codhabitacion;
		into Cursor mwkcamas


*!*		select * from mwkcama1 where hab_codcama = '01' into cursor mwkc2
*!*		select * from mwkcama1 where hab_codcama = '02' into cursor mwkc3
Else
	If   Reccount("mwkcama0b") > 0
		Selec hab_codhabitacion;
			,hab_codcama  As cam1 ;
			,pac_categoria As pac1 ;
			,pin_codentidad As ent1 ;
			,pac_nombrepaciente  As nom1 ;
			,pac_sexo  As sex1 ;
			,pac_edad   As eda1 ;
			,pac_descripdiagn As dia1 ;
			,hab_codpaciente As codp1 ;
			,Nvl(THC_Cor,0)  As cama_esp_1 ;
			,Iif(Isnull(pac_motivoalta) And !Isnull(nAC_sectorinternac),nAC_sectorinternac,"   ") As cam2;
			,Iif(Isnull(pac_motivoalta) And !Isnull(nac_categoria ),nac_categoria ,' ') As pac2 ;
			,Iif(Isnull(pac_motivoalta) And !Isnull(nAC_habitacion),nAC_habitacion,'    ') As ent2;
			,Iif(Isnull(pac_motivoalta) And !Isnull(nac_nombrepaciente),nac_nombrepaciente ,Space(50)) As nom2;
			,Iif(Isnull(pac_motivoalta) And !Isnull(nac_sexo ),nac_sexo ,' ') As sex2 ;
			,Iif(Isnull(pac_motivoalta) And !Isnull(nac_edad),nac_edad ,pac_edad-pac_edad) As eda2;
			,Iif(Isnull(pac_motivoalta) And !Isnull(nac_descripdiagn),nac_descripdiagn ,Space(50)) As dia2;
			,Iif(Isnull(pac_motivoalta) And !Isnull(nac_codadmision),nac_codadmision ,'        ') As codp2 ;
			,Iif(Isnull(pac_motivoalta) And !Isnull(THC_Cor),THC_Cor,0)  As cama_esp_2,Id_Motivo ;
			,Nvl(rc_estado,0) As rc_estado_1 ,Nvl(COV_HisopaVigilan,0) As COV_hv_1, 0 As COV_hv_2;
			,0 As rc_estado_2,Nvl(RC_hisopadoFecha,Ctod("01/01/1900")) As RC_hf1,Ctod("01/01/1900") As RC_hf2 ;
			from mwkcama1 Into Cursor mwkc2

		Selec hab_codhabitacion As hab1, cam1, pac1, ;
			ent1, nom1, sex1,  eda1, dia1,codp1, ;
			hab_codhabitacion As hab2, cam2, pac2,'' As tipoaisla1,'' As hora1 ;
			,ent2, nom2, sex2, eda2, dia2,codp2,'' As tipoaisla2,''As hora2 ;
			, cama_esp_1, cama_esp_2,Id_Motivo,rc_estado_1,COV_hv_1,COV_hv_2 ,rc_estado_2,RC_hf1,RC_hf2   ;
			from mwkc2 Group By hab_codhabitacion,cam1,codp1,codp2;
			into Cursor mwkcamas
	Else
		Select * From mwkcama1 Order By hab_codcama   Into Cursor mwkc2
		Select * From mwkcama1 Where hab_codcama = '' Into Cursor mwkc3
		Selec a.hab_codhabitacion As hab1, a.hab_codcama As cam1, a.pac_categoria As pac1, ;
			a.pin_codentidad As ent1, a.pac_nombrepaciente As nom1, a.pac_sexo As sex1,  ;
			a.pac_edad As eda1, a.pac_diagn As dia1,a.hab_codpaciente As codp1,'' As tipoaisla1,'' As hora1,Nvl(a.rc_estado,0) As rc_estado_1 ,;
			Nvl(a.COV_HisopaVigilan,0) As COV_hv_1,Nvl(b.COV_HisopaVigilan,0) As COV_hv_2,;
			Nvl(a.RC_hisopadoFecha,Ctod("01/01/1900")) As RC_hf1,Nvl(b.RC_hisopadoFecha,Ctod("01/01/1900")) As RC_hf2 ,;
			b.hab_codhabitacion As hab2, b.hab_codcama As cam2, b.pac_categoria As pac2,'' As tipoaisla2,'' As hora2,Nvl(b.rc_estado,0) As rc_estado_2,;
			b.pin_codentidad As ent2, b.pac_nombrepaciente As nom2, b.pac_sexo As sex2, ;
			b.pac_edad As eda2, b.pac_diagn As dia2,b.hab_codpaciente As codp2,;
			Nvl(a.THC_Cor,0) As cama_esp_1,Nvl(b.THC_Cor,0)  As cama_esp_2,Nvl(a.Id_Motivo,0) As Id_Motivo  ;
			from mwkc2 As a Left Outer Join	mwkc3 As b On ;
			a.hab_codhabitacion = b.hab_codhabitacion;
			into Cursor mwkcamas

	Endif
Endif
*!*	msql_cama = "select hab1, cam1, " + ;
*!*		"iif(pac1 = 'A', 'AISL', iif(pac1 = 'I', 'IND ', iif(codp1 = 'BLOQUEO'," + ;
*!*		" 'BLQ ', iif(codp1 = 'RESERV', 'RES ', '    ')))) as est1, "+ ;
*!*		"iif(isnull(ent1), '     ', transf( ent1, '@z 99999' ) ) as ent1, " + ;
*!*		"iif(isnull(nom1), space(40), nom1) as nom1, " + ;
*!*		"iif(isnull(sex1), ' ', sex1) as sex1, iif(val(codp1)=0 or isnull(eda1), '   ', str(eda1, 3)) as eda1, " + ;
*!*		"iif(isnull(cam2), '  ', cam2) as cam2, iif( codp2 = 'BLOQUEO', 'BLQ ', " +;
*!*		" iif(codp2 = 'RESERV', 'RES ', IIF(EMPTY(pac2),'    ',PADR(pac2,4))) as est2, " + ;
*!*		"iif(isnull(ent2), '     ', transf( ent2, '@z 99999' ) ) as ent2, " + ;
*!*		"iif(isnull(nom2), space(40), nom2) as nom2,"+;
*!*		" iif(isnull(sex2), ' ', sex2) as sex2, " + ;
*!*		"iif(val(codp2)=0 or isnull(eda2), '   ', str(eda2, 3)) as eda2, dia1, dia2,cama_esp_1 ,cama_esp_2,Id_Motivo   "+;
*!*		"from mwkcamas into cursor mwkcama"


*!*	**---------- Marcelo Torres, 31/05/2019-------------------*
*!*	mret = SQLExec(mcon1,"select max(a.id) as _id,a.POA_sector, a.POA_cama, a.POA_habitacion, a.POA_estado " +;
*!*		"from tabaltapac as a " + ;
*!*		"inner join Sectores as b on a.POA_sector = b.SEC_codsector " +;
*!*		"where a.POA_sector = ?mcodsec and a.POA_vigente = 1 and a.POA_estado in (4,11,12) and NVL(b.SEC_circaltas,0) = 1 " +;
*!*		"group by a.poa_sector, a.poa_cama, a.poa_habitacion " +;
*!*		"order by a.poa_habitacion, a.poa_cama ","mwkAltapac")
 mwcm = STRTRAN(mwcm,"hab_sectores","POA_sector")
mret = SQLExec(mcon1,"select a.id, a.POA_sector, a.POA_cama, a.POA_habitacion, a.POA_estado " +;
	"from tabaltapac as a " +;
	"right join (select max(c.id) as _id " +;
	"from tabaltapac as c " +;
	"left join Sectores as d on c.POA_sector = d.SEC_codsector " +;
	"where c.POA_vigente = 1 and NVL(d.sec_circaltas,0) = 1 "+;
	"group by c.poa_sector, c.poa_cama, c.poa_habitacion) as k on a.id = k._id " +;
	"where a.poa_sector = ?mcodsec and a.poa_vigente = 1 and a.POA_estado in (4,11,12) "+mwcm, "mwkAltapac")

If mret<=0
	Messagebox("ERROR EN LA LECTURA - TABLA ALTAPAC",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif


*!*	msql_cama = "select distinc hab1, cam1, " + ;
*!*		"iif(pac1 = 'B', 'AxAC', iif(pac1 = 'A', 'AISL', iif(pac1 = 'I', 'IND ', iif(codp1 = 'BLOQUEO'," + ;
*!*		" 'BLQ ', iif(codp1 = 'RESERV', 'RES ', '    '))))) as est1, "+ ;
*!*		"iif(isnull(ent1), '     ', transf( ent1, '@z 99999' ) ) as ent1, " + ;
*!*		"iif(isnull(nom1), space(40), nom1) as nom1, " + ;
*!*		"iif(isnull(sex1), ' ', sex1) as sex1, iif(val(codp1)=0 or isnull(eda1), '   ', str(eda1, 3)) as eda1, " + ;
*!*		"iif(isnull(cam2), '  ', cam2) as cam2, iif(pac2 = 'B', 'AxAC',iif( pac2 = 'A', 'AISL', iif(pac2 = 'I', 'IND ', iif(codp2 = 'BLOQUEO'," + ;
*!*		" 'BLQ ', iif(codp2 = 'RESERV', 'RES ', '    '))))) as est2, " + ;
*!*		"iif(isnull(ent2), '     ', transf( ent2, '@z 99999' ) ) as ent2, " + ;
*!*		"iif(isnull(nom2), space(40), nom2) as nom2,"+;
*!*		" iif(isnull(sex2), ' ', sex2) as sex2, " + ;
*!*		"iif(val(codp2)=0 or isnull(eda2), '   ', str(eda2, 3)) as eda2, dia1, dia2,cama_esp_1 ,cama_esp_2,Id_Motivo,"+;
*!*		"tipoaisla1,hora1,hora2,tipoaisla2," +;
*!*		"nvl(mwkAltaPac.POA_estado,0) as POA_estado " +;
*!*		"from mwkcamas " + ;
*!*		"left join mwkAltapac on mwkcamas.hab1 = mwkAltapac.POA_habitacion and mwkcamas.cam1 = mwkAltapac.POA_cama " + ;
*!*		"into cursor mwkcama"

msql_cama = "select distinc A.hab1, A.cam1, " + ;
	"iif(A.pac1 = 'B', 'A.AxAC', iif(A.pac1 = 'A', 'AISL', iif(A.pac1 = 'I', 'IND ', iif(A.codp1 = 'BLOQUEO'," + ;
	" 'BLQ ', iif(A.codp1 = 'RESERV', 'RES ', '    '))))) as est1, "+ ;
	"iif(isnull(A.ent1), '     ', transf( A.ent1, '@z 99999' ) ) as ent1, " + ;
	"iif(isnull(A.nom1), space(40), A.nom1) as nom1, " + ;
	"iif(isnull(A.sex1), ' ', A.sex1) as sex1, iif(val(A.codp1)=0 or isnull(A.eda1), '   ', str(A.eda1, 3)) as eda1, " + ;
	"iif(isnull(A.cam2), '  ', A.cam2) as cam2, iif(A.pac2 = 'B', 'AxAC',iif( A.pac2 = 'A', 'AISL', iif(A.pac2 = 'I', 'IND ', iif(A.codp2 = 'BLOQUEO'," + ;
	" 'BLQ ', iif(A.codp2 = 'RESERV', 'RES ', '    '))))) as est2, " + ;
	"iif(isnull(A.ent2), '     ', transf( A.ent2, '@z 99999' ) ) as ent2, " + ;
	"iif(isnull(A.nom2), space(40), A.nom2) as nom2,"+;
	" iif(isnull(A.sex2), ' ', A.sex2) as sex2, " + ;
	"iif(val(A.codp2)=0 or isnull(A.eda2), '   ', str(A.eda2, 3)) as eda2, A.dia1, A.dia2,A.cama_esp_1 ,A.cama_esp_2,A.Id_Motivo,"+;
	"A.tipoaisla1,A.hora1,a.rc_estado_1 ,A.hora2,A.tipoaisla2,a.rc_estado_2,a.RC_hf1,a.RC_hf2,a.COV_hv_1,a.COV_hv_2, " +;
	"nvl(B.POA_estado,000) as POA_estado1, nvl(c.POA_estado,000) as POA_estado2 " +;
	"from mwkcamas as A " + ;
	"left join mwkAltapac as B on A.hab1 = B.POA_habitacion and A.cam1 = B.POA_cama " + ;
	"left join mwkAltapac as C on A.hab1 = C.POA_habitacion and A.cam2 = C.POA_cama " + ;
	"into cursor mwkcama "

**&msql_cama

