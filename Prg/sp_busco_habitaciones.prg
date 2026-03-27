****
** busco camas en habitacions
****
Parameter mcodsec, mhabitsala, msql_cama
If !Used('mwkepicov')
	mifec = sp_busco_fecha_serv("DD")
	mfecbusca = prg_dtoc(mifec -50)
	Do sp_busco_ficha_covid With 2," and Zabregcontagio.FecHorDbAdd>='"+mfecbusca +"' and RC_fechaFin> {fn curdate()}  "
Endif
Do sp_busco_estados With 54,' and tipo = 99 ','mwkhabcolorcovid'&&
If mwkhabcolorcovid.estado = 0
	Select * From mwkepicov Where 1=2 Into Cursor mwkepicov
Endif
mret = SQLExec(mcon1, "select hab_codhabitacion, hab_codcama, hab_codpaciente, hab_codbloqueo, " + ;
	"hab_habilitada, pac_nombrepaciente, pac_sexo, pac_edad, " + ;
	"pac_descripdiagn, pac_categoria, pin_codentidad,PAC_sectorinternac, PAC_fechaadmision " + ;
	"from habitacions left outer join pacientes on " + ;
	"habitacions.hab_codpaciente = pacientes.pac_codadmision " + ;
	"left outer join pacinternad on pacinternad .pin_codadmision = pacientes.pac_codadmision " + ;
	"where hab_sectores = ?mcodsec " + ;
	"order by hab_codhabitacion, hab_codcama", "mwkcama0")

If Inlist( mcodsec ,"EME",'CEG','IDE','IEP')
	mifecha = sp_busco_fecha_serv("DT")-24*3600
	mret = SQLExec(mcon1," SELECT PACIENTE,IdMotivo,Atendido    "+;
		" FROM	SOCIO " + ;
		" WHERE	 IdMotivo =57 AND HoraLLegada>=?MIFECHA ","mwkAtendidoA")

	Select  mwkcama0.*,THC_Cor,	Iif(Inlist(PAC_sectorinternac,"EME",'CEG','IDE','IEP'),"Ingreso:"+Dtoc(mwkcama0.PAC_fechaadmision)+" - ",'')+Alltrim(pac_descripdiagn) As pac_diagn, ;
		iif(Isnull(IdMotivo) And !Isnull(pac_nombrepaciente),0,;
		iif(atendido,0,;
		iif(!Isnull(pac_nombrepaciente),1,0))) As Id_Motivo ,rc_estado,RC_hisopadoFecha,COV_HisopaVigilan  ;
		from mwkcama0;
		left Join mwkepicov  On  admisionficha = hab_codpaciente;
		left Join mwkCorcama On hab_codhabitacion = THC_Hab And hab_codcama = THC_Cama ;
		left Join mwkAtendidoA On Alltrim(mwkAtendidoA.PACIENTE)=hab_codpaciente;
		into Cursor mwkcama1a

Else
	Select  mwkcama0.*,THC_Cor,;
		iif(Inlist(PAC_sectorinternac,"EME",'CEG','IDE','IEP'),"Ingreso:"+Dtoc(mwkcama0.PAC_fechaadmision)+" - ",'')+Alltrim(pac_descripdiagn) As pac_diagn, ;
		0 As Id_Motivo ,rc_estado,RC_hisopadoFecha,COV_HisopaVigilan   ;
		from mwkcama0;
		left Join mwkepicov  On  admisionficha = hab_codpaciente;
		left Join mwkCorcama On hab_codhabitacion = THC_Hab And hab_codcama = THC_Cama ;
		into Cursor mwkcama1a
Endif
Use In 	Select('mwkcama0')
If myip ='172.16.1.7'
*	SET STEP ON
Endif
Select mwkcama1a.*,tiponaislanew As tipoaisla,codaisla,horaaud;
	FROM mwkcama1a Left Join mwkpacaisla On hab_codpaciente = apv_codadmision Into Cursor mwkcama1

If mhabitsala = 'H'
	Selec hab_codhabitacion;
		,Iif(hab_codcama = '01',hab_codcama,'  ')  As cam1 ;
		,Padr(Iif(hab_codcama = '01',Iif(Empty(Nvl(pac_categoria,'')) And Empty(Nvl(codaisla,' ')),' ',;
		Iif(Empty(Nvl(codaisla,'')),pac_categoria,codaisla)),' '),20) As pac1 ;
		,Iif(hab_codcama = '01',pin_codentidad ,pin_codentidad-pin_codentidad) As ent1 ;
		,Iif(hab_codcama = '01',pac_nombrepaciente ,Space(50) ) As nom1 ;
		,Iif(hab_codcama = '01',pac_sexo ,' ') As sex1 ;
		,Iif(hab_codcama = '01',pac_edad ,pac_edad-pac_edad) As eda1 ;
		,Iif(hab_codcama = '01',pac_descripdiagn ,Space(50)) As dia1 ;
		,Iif(hab_codcama = '01',hab_codpaciente ,'        ') As codp1 ;
		,Iif(hab_codcama = '01',Nvl(THC_Cor,0) ,0) As cama_esp_1 ;
		,Iif(hab_codcama = '01',Iif(Isnull(codaisla),Space(50) ,codaisla),Space(50) ) As codaisla1 ;
		,Iif(hab_codcama = '01',Iif(Isnull(tipoaisla),Space(50) ,tipoaisla),Space(50) ) As tipoaisla1 ;
		,Iif(hab_codcama = '01',Iif(Isnull(horaaud),Space(20),Ttoc(horaaud)),'        ') As hora1 ;
		,Iif(hab_codcama = '01',Nvl(rc_estado,0) ,0) As rc_estado_1 ;
		,Iif(hab_codcama = '01',Nvl(COV_HisopaVigilan,0) ,0) As COV_hv_1 ;
		,Iif(hab_codcama = '01',Nvl(RC_hisopadoFecha,Ctod("01/01/1900")),Ctod("01/01/1900")) As RC_hf1;
		,Iif(hab_codcama = '02',hab_codcama ,'  ') As cam2;
		,Padr(Iif(hab_codcama = '02',Iif(Empty(Nvl(pac_categoria,'')) And Empty(Nvl(codaisla,' ')),;
		' ',Iif(Empty(Nvl(codaisla,'')),pac_categoria,codaisla)),' '),20) As pac2 ;
		,Iif(hab_codcama = '02',pin_codentidad ,pin_codentidad-pin_codentidad) As ent2;
		,Iif(hab_codcama = '02',pac_nombrepaciente ,Space(50)) As nom2;
		,Iif(hab_codcama = '02',pac_sexo ,' ') As sex2 ;
		,Iif(hab_codcama = '02',pac_edad ,pac_edad-pac_edad) As eda2;
		,Iif(hab_codcama = '02',pac_diagn ,Space(50)) As dia2;
		,Iif(hab_codcama = '02',hab_codpaciente,'        ') As codp2 ;
		,Iif(hab_codcama = '02',Nvl(THC_Cor,0) ,0) As cama_esp_2,Id_Motivo  ;
		,Iif(hab_codcama = '02',Iif(Isnull(codaisla),Space(50) ,codaisla),Space(50) ) As codaisla2 ;
		,Iif(hab_codcama = '02',Iif(Isnull(tipoaisla),Space(50) ,tipoaisla),Space(50) ) As tipoaisla2 ;
		,Iif(hab_codcama = '02',Iif(Isnull(horaaud),Space(20),Ttoc(horaaud)),'        ') As hora2 ;
		,Iif(hab_codcama = '02',Nvl(rc_estado,0) ,0) As rc_estado_2 ;
		,Iif(hab_codcama = '02',Nvl(COV_HisopaVigilan,0) ,0) As COV_hv_2 ;
		,Iif(hab_codcama = '02',Nvl(RC_hisopadoFecha,Ctod("01/01/1900")),Ctod("01/01/1900"))  As RC_hf2;
		from mwkcama1 Into Cursor mwkc2

	Selec hab_codhabitacion As hab1, Max(cam1) As cam1, Max(pac1) As pac1, ;
		max(ent1) As ent1, Max(nom1) As nom1, Max(sex1) As sex1,  ;
		max(eda1) As eda1, Max(dia1) As dia1,Max(codp1) As codp1,Max(tipoaisla1 ) As tipoaisla1 ,Max(codaisla1 ) As codaisla1 ,Max(hora1) As hora1;
		,Max(rc_estado_1) As rc_estado_1,Max(COV_hv_1) As COV_hv_1,  Max(RC_hf1) As RC_hf1,  ;
		hab_codhabitacion As hab2, Max(cam2) As cam2, Max(pac2) As pac2, ;
		max(ent2) As ent2, Max(nom2) As nom2, Max(sex2) As sex2, ;
		max(eda2) As eda2, Max(dia2) As dia2,Max(codp2 ) As codp2,Max(tipoaisla2 ) As tipoaisla2,Max(codaisla2 ) As codaisla2,Max(hora2) As hora2;
		,Max(rc_estado_2) As rc_estado_2,Max(COV_hv_2) As COV_hv_2,Max(RC_hf2) As RC_hf2,   ;
		cama_esp_1, cama_esp_2,Id_Motivo  ;
		from mwkc2 Group By hab_codhabitacion;
		into Cursor mwkcamas

Else
	Select * From mwkcama1 Order By hab_codcama   Into Cursor mwkc2
	Select * From mwkcama1 Where hab_codcama = '' Into Cursor mwkc3
	Selec a.hab_codhabitacion As hab1, a.hab_codcama As cam1,Padr(Iif(Empty(Nvl(a.pac_categoria,'')) And Empty(Nvl(a.codaisla,' ')),' ',;
		Iif(Empty(Nvl(a.codaisla,'')),a.pac_categoria,a.codaisla)),20) As pac1, ;
		a.pin_codentidad As ent1, a.pac_nombrepaciente As nom1, a.pac_sexo As sex1,  ;
		a.pac_edad As eda1, a.pac_diagn As dia1,a.hab_codpaciente As codp1,'' As tipoaisla1,'' As codaisla1,'' As hora1,Nvl(a.rc_estado,0) As rc_estado_1 ,;
		Nvl(a.COV_HisopaVigilan,0) As COV_hv_1,Nvl(b.COV_HisopaVigilan,0) As COV_hv_2,;
		Nvl(a.RC_hisopadoFecha,Ctod("01/01/1900")) As RC_hf1,Nvl(b.RC_hisopadoFecha,Ctod("01/01/1900")) As RC_hf2 ,;
		b.hab_codhabitacion As hab2, b.hab_codcama As cam2, Padr(Iif(Empty(Nvl(b.pac_categoria,'')) And Empty(Nvl(b.codaisla,' ')),' ',;
		Iif(Empty(Nvl(b.codaisla,'')),b.pac_categoria,b.codaisla)),20) As pac2,'' As tipoaisla2,'' As codaisla2,'' As hora2,Nvl(b.rc_estado,0) As rc_estado_2,;
		b.pin_codentidad As ent2, b.pac_nombrepaciente As nom2, b.pac_sexo As sex2, ;
		b.pac_edad As eda2, b.pac_diagn As dia2,b.hab_codpaciente As codp2,;
		Nvl(a.THC_Cor,0) As cama_esp_1,Nvl(b.THC_Cor,0)  As cama_esp_2,Nvl(a.Id_Motivo,0) As Id_Motivo  ;
		from mwkc2 As a Left Outer Join	mwkc3 As b On a.hab_codhabitacion = b.hab_codhabitacion;
		into Cursor mwkcamas

Endif



msql_cama = "select distinc hab1, cam1, " + ;
	"padr(iif(at('A x',pac1)>0,pac1, iif(pac1 = 'A', 'AISL s/AC', iif(pac1 = 'I', 'IND ', iif(codp1 = 'BLOQUEO'," + ;
	" 'BLOQUEO', iif(codp1 = 'RESERV', 'RESERV', '    '))))),20) as est1, "+ ;
	"iif(isnull(ent1), '     ', transf( ent1, '@z 99999' ) ) as ent1, " + ;
	"iif(isnull(nom1), space(40), nom1) as nom1, " + ;
	"iif(isnull(sex1), ' ', sex1) as sex1, iif(val(codp1)=0 or isnull(eda1), '   ', str(eda1, 3)) as eda1, " + ;
	"iif(isnull(cam2), '  ', cam2) as cam2, PADR(iif( at('A x',pac2)>0,pac2,iif( pac2 = 'A', 'AISL s/AC', iif(pac2 = 'I',"+;
	" 'IND ', iif(codp2 = 'BLOQUEO'," + ;
	" 'BLOQUEO', iif(codp2 = 'RESERV', 'RESERV', '    '))))),20) as est2, " + ;
	"iif(isnull(ent2), '     ', transf( ent2, '@z 99999' ) ) as ent2, " + ;
	"iif(isnull(nom2), space(40), nom2) as nom2,"+;
	" iif(isnull(sex2), ' ', sex2) as sex2," + ;
	"iif(val(codp2)=0 or isnull(eda2), '   ', str(eda2, 3)) as eda2, dia1, dia2,cama_esp_1 ,cama_esp_2,Id_Motivo, "+;
	"tipoaisla1,codaisla1,hora1,rc_estado_1 ,hora2,tipoaisla2,codaisla2,rc_estado_2,RC_hf1,RC_hf2,COV_hv_1,COV_hv_2  " +;
	"from mwkcamas into cursor mwkcama"


