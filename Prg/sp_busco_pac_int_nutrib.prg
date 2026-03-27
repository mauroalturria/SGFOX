****
** busco pacientes para nutricion
****

Parameter msector
mfecdia = sp_busco_fecha_serv('DD')

mret =	sqlexec(mcon1, "select pre_codprest,PRE_descriprest" + ;
	" from prestacions " + ;
	" where pre_codservicio=9400 and PRE_fechapasiva is null " , "mwkpres")
If mret<1
	=Aerr(eros)
	Messagebox(eros(2))
Endif

*** Nutricion
mret = sqlexec(mcon1, "select PAC_habitacion, PAC_cama,PAC_nombrepaciente " + ;
	", PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision, pin_codentidad,PAC_edad, PAC_codadmision,PAC_fecnacimiento "+;
	", TabNutPaciente.* " + ;
	", TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga, TND_observa "+;
	" from pacinternad left join pacientes on pin_codadmision = PAC_codadmision " + ;
	" left join habitacions on hab_codpaciente = PAC_codadmision " + ;
	" left join TabNutPaciente on pin_codadmision = TNP_codadmision" + ;
	" left join TabNutDetalle on TND_idPaciente = TabNutPaciente.id" + ;
	" left join  afiliacion on " +;
	"	PAC_codhci = registracio and " + ;
	"	pin_codentidad = AFI_codentidad " + ;
	" where PAC_sectorinternac = ?msector "  +;
	" order by PAC_habitacion, PAC_cama,TNP_CodServ ", "mwknutcam1")
If mret<1
	=Aerr(eros)
	Messagebox (eros(2))
Endif
mret = sqlexec(mcon1, "select pin_codadmision,TNH_fecha,TNH_anamnesis " + ;
	" from pacinternad left join pacientes on pin_codadmision = PAC_codadmision " + ;
	" left join TabNutHpac on PAC_codhci = TNH_registracio "+;
	" where PAC_sectorinternac = ?msector " + ;
	" order by pin_codadmision,TNH_fecha", "mwknuthana")
If mret<1
	=Aerr(eros)
	Messagebox (eros(2))
Endif
Select * From mwknuthana Group By pin_codadmision;
	into Cursor mwknuthana1

If Used('mwkauxi')
	Use In mwkauxi
Endif
Select PAC_habitacion+'-'+PAC_cama As habitac,PAC_nombrepaciente  ;
	, Proper(PAC_descripdiagn) As PAC_descripdiagn, PAC_edad;
	, Dtoc(PAC_fechaadmision)+" "+Ttoc(PAC_horaadmision,2) As PAC_fechaadmision;
	, pin_codentidad,ENT_descrient , PAC_codadmision ;
	, Iif(PAC_edad>0,Transf(PAC_edad,'999'),Transf(Round((mfecdia-PAC_fecnacimiento)/30,0),'99')+"M") As anios ;
	, Nvl(TNP_Fecha,mfecdia) As TNP_Fecha ,Nvl(TNP_CodServ,0) As TNP_CodServ;
	, Nvl(TNP_CodFact,Space(50)) As TNP_CodFact1;
	, Nvl(TNP_CodFact,Space(50)) As TNP_CodFact2;
	, Nvl(TNP_Observaciones,Space(200)) As TNP_Observaciones1;
	, Nvl(TNP_Observaciones,Space(200)) As TNP_Observaciones2;
	, Nvl(TNP_Usuario, 00000) As TNP_Usuario,Nvl(TND_observa,Space(50)) As TND_observa;
	, TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga,pre_descriprest ;
	,Space(200) As indicacion,Space(250) As Observaciones;
	, ' ' As Hanam,TNH_anamnesis  ;
	from mwknutcam1 ;
	left Outer Join mwkentidad On pin_codentidad = ENT_codent ;
	left Outer Join mwknuthana1 On PAC_codadmision = pin_codadmision;
	left Join mwkpres On TND_codPrest = pre_codprest ;
	order By TNP_Fecha,habitac, PAC_codadmision , TNP_CodServ,TND_NroVale  ;
	into Cursor mwknutcd1

Use Dbf() In 0 Again Alias mwkauxi
Select mwkauxi
Go Top
If !Eof()
	mhabitac 	= habitac
	mpac 		= PAC_codadmision
	mcodserv 	= Round(TNP_CodServ/2,0)
	man1		= Iif(Mod(TNP_CodServ,2)=1,TNP_Observaciones1,'')
	man2		= Iif(Mod(TNP_CodServ,2)=0,TNP_Observaciones2,'')
	mcf1		= Iif(Mod(TNP_CodServ,2)=1,TNP_CodFact1,'')
	mcf2		= Iif(Mod(TNP_CodServ,2)=0,TNP_CodFact2,'')
	manam 		= Iif(Empty(Nvl(TNH_anamnesis,''))," ","*")
	mpresta 	= Proper(Iif(!Isnull(pre_descriprest);
		,Iif(At("DIETA",pre_descriprest)=1;
		,Alltrim(Strtran(pre_descriprest,"DIETA ",""));
		,Alltrim(pre_descriprest));
		,''))
	mobserva 	= Proper(Alltrim(TND_observa))
	nreg= Recno()
	Skip
	Do While !Eof()
		Do While !Eof() And  mhabitac = habitac And mpac = PAC_codadmision
			mcodserv 	= Round(TNP_CodServ/2,0)
			man1		= Iif(Mod(TNP_CodServ,2)=1,TNP_Observaciones1,'')
			man2		= Iif(Mod(TNP_CodServ,2)=0,TNP_Observaciones2,'')
			mcf1		= Iif(Mod(TNP_CodServ,2)=1,TNP_CodFact1,'')
			mcf2		= Iif(Mod(TNP_CodServ,2)=0,TNP_CodFact2,'')
			Do While !Eof() And  mhabitac = habitac And mpac = PAC_codadmision;
					and mcodserv = Round(TNP_CodServ/2,0)
				mpresta 	= mpresta + Iif(!Isnull(pre_descriprest);
					,"+" + Proper(Iif(At("DIETA",pre_descriprest)=1;
					,Alltrim(Strtran(pre_descriprest,"DIETA ",""));
					,Alltrim(pre_descriprest)));
					,'')
				mobserva 	= mobserva+ "+" + Proper(Alltrim(TND_observa))
				man1		= Iif(Mod(TNP_CodServ,2)=1,TNP_Observaciones1,man1)
				man2		= Iif(Mod(TNP_CodServ,2)=0,TNP_Observaciones2,man2)
				mcf1		= Iif(Mod(TNP_CodServ,2)=1,TNP_CodFact1,mcf1)
				mcf2		= Iif(Mod(TNP_CodServ,2)=0,TNP_CodFact2,mcf2)
				Delete
				Goto nreg
				Skip
			Enddo
			Go nreg
			Replace indicacion With mpresta, Observaciones With mobserva, Hanam  With manam;
				,TNP_Observaciones1 With man1, TNP_Observaciones2 With man2;
				,TNP_CodFact1 With mcf1,TNP_CodFact2 With mcf2
			Skip
		Enddo
		If nreg>0
			Go nreg
			Replace indicacion With mpresta, Observaciones With mobserva, Hanam  With manam;
				,TNP_Observaciones1 With man1, TNP_Observaciones2 With man2;
				,TNP_CodFact1 With mcf1,TNP_CodFact2 With mcf2
			Skip
			mhabitac = habitac
			mpac = PAC_codadmision
			manam 		= Iif(Empty(Nvl(TNH_anamnesis,''))," ","*")
			mcodserv = Round(TNP_CodServ/2,0)
			mpresta 	= Iif(!Isnull(pre_descriprest);
				,"+" + Proper(Iif(At("DIETA",pre_descriprest)=1;
				,Alltrim(Strtran(pre_descriprest,"DIETA ",""));
				,Alltrim(pre_descriprest)));
				,'')
			mobserva 	= Proper(Alltrim(TND_observa))
			man1		= Iif(Mod(TNP_CodServ,2)=1,TNP_Observaciones1,'')
			man2		= Iif(Mod(TNP_CodServ,2)=0,TNP_Observaciones2,'')
			mcf1		= Iif(Mod(TNP_CodServ,2)=1,TNP_CodFact1,'')
			mcf2		= Iif(Mod(TNP_CodServ,2)=0,TNP_CodFact2,'')
			If !Eof()
				nreg= Recno()
				Skip
			Else
				nreg= -1
			Endif
		Else
			Exit
		Endif
	Enddo
	If nreg>0
		Go nreg
		Replace indicacion With mpresta, Observaciones With mobserva, Hanam  With manam;
			,TNP_Observaciones1 With man1, TNP_Observaciones2 With man2;
			,TNP_CodFact1 With mcf1,TNP_CodFact2 With mcf2

	Endif

Endif
Select * From mwkauxi Where TNP_Fecha= mfecdia Into Cursor mwkcataux0

Select pin_codadmision From mwknuthana1 ;
	where pin_codadmision Not In (Select PAC_codadmision ;
	from mwkcataux0) Into Cursor mwkcataux1

Select * From mwkauxi ;
	where PAC_codadmision In (Select pin_codadmision ;
	from mwkcataux1);
	group By PAC_codadmision Into Cursor mwkcataux2

Select * From mwkcataux0 ;
	union ;
	select habitac,PAC_nombrepaciente, PAC_descripdiagn, PAC_edad,;
	PAC_fechaadmision, pin_codentidad,ENT_descrient , PAC_codadmision ;
	, anios, TNP_Fecha ,0 As TNP_CodServ, TNP_CodFact1, TNP_CodFact1;
	, TNP_Observaciones1,TNP_Observaciones2;
	, TNP_Usuario,TND_observa, TND_idPaciente,TND_codPrest,TND_NroVale;
	, TND_FHoraCarga,pre_descriprest, indicacion, Observaciones,Hanam,TNH_anamnesis  ;
	from mwkcataux2 ;
	into Cursor mwkcatering

Select habitac,PAC_nombrepaciente, PAC_descripdiagn, PAC_edad,PAC_fechaadmision, pin_codentidad,ENT_descrient , PAC_codadmision ;
	, anios,TNP_Fecha ,TNP_CodServ, TNP_CodFact1, TNP_Observaciones1;
	, Hanam,indicacion,Observaciones;
	,Iif(TNP_CodServ=1,Iif(Empty(TNP_Observaciones1),Alltrim(indicacion),TNP_Observaciones1)  ,Space(250)) As an1;
	,Iif(TNP_CodServ=2,Iif(Empty(TNP_Observaciones2),Alltrim(indicacion),TNP_Observaciones2)  ,Space(250)) As an2;
	,Iif(TNP_CodServ=3,Iif(Empty(TNP_Observaciones1),Alltrim(indicacion),TNP_Observaciones1)  ,Space(250)) As an3;
	,Iif(TNP_CodServ=4,Iif(Empty(TNP_Observaciones2),Alltrim(indicacion),TNP_Observaciones2)  ,Space(250)) As an4;
	,Iif(TNP_CodServ=5,Iif(Empty(TNP_Observaciones1),Alltrim(indicacion),TNP_Observaciones1)  ,Space(250)) As an5;
	,Iif(TNP_CodServ=6,Iif(Empty(TNP_Observaciones2),Alltrim(indicacion),TNP_Observaciones2)  ,Space(250)) As an6;
	from mwkauxi Where TNP_Fecha< mfecdia ;
	order By TNP_Fecha Desc,habitac, PAC_codadmision ;
	group By TNP_Fecha,habitac, PAC_codadmision ;
	into Cursor mwkcatAnt