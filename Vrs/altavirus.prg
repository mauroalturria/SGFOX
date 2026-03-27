Select contagio2
Scan
	Requery('regishccov')
	Replace nreg With regishccov.registracio
Endscan

Select resul_nroVALE  ,RESUL_fechahorarecepmuestra,RESUL_fechahoraresultado From resulLABO Where  resul_nroVALE Not In ;
	(Select vale From ctg) Into Cursor nuevos

Select resul_nroVALE As vale ,RESUL_fechahorarecepmuestra As fecha_hiso,RESUL_fechahoraresultado From  nuevos Into Cursor nuevo
Select ctg
Append From Dbf('nuevo')

Select ctg
Use vales_real Again In 0
Select vales_real
Select ctg
Scan
	Requery('vales_real')
	Replace nreg With vales_real.pac_codhci,fecha_vale With vales_real.VAL_fechasolicitud,reg_nrohcl With vales_real.pac_codhce
Endscan
Select ctg
Use regishccov Again In 0
Select regishccov
Select ctg
Scan
	Requery('regishccov')
	Replace REG_nombre   With regishccov.REG_nombrepac  , telefono With Nvl(regishccov.REG_telefonos,''),dni  With regishccov.REG_numdocumento
Endscan
Go Top
Modify View tabregctglog

Use c:\desaguemes\ctgproc.Dbf In 0 Excl

Append From Dbf('ctg')

Select agrego
Scan
	Requery('regishccov')
	Replace hclin  With regishccov.REG_nrohclinica
Endscan
Modify View ficha_covid
Select * From ficha_covid Where Isnull(rc_estado) And  Id>1 Into Cursor actualizo
Select actualizo
Set Step On
Scan
*	Requery('regishc')
*	mireg = regishc.reg_nroregistrac
	mireg = reg_nroregistrac
	Select tabregctg
	Locate For rc_nroregistracio = mireg
	If Found()
*	replace RC_hisopadoFecha WITH actualizo.fecham,RC_hisopadoResul with actualizo.subestado, RC_estado WITH IIF(agregohiso.res=3,3,1)
	Else
		Insert Into tabregctg ( rc_estado,  RC_fechaFin, RC_fechaInicio,  RC_fechaPasiva, rc_nroregistracio,RC_periodoLatencia, RC_virus;
			,RC_ARM,RC_hisopadoFecha,RC_hisopadoResul);
			VALUES (1,Ctod("01/01/2100"),actualizo.cov_inisintoma,Ctod("01/01/1900"),mireg,0,1,0,actualizo.cov_fecmodifica,0)
	Endif
	Select actualizo
Endscan

Select agrego
Set Step On
Scan
*	Requery('regishc')
*	mireg = regishc.reg_nroregistrac
	mireg = agrego.nreg
	mimed = 1
	mfecha = agrego.horavale
	mest = agrego.estadoctg
	Select tabregctg
	Locate For rc_nroregistracio = mireg
	If Found()
		Replace RC_hisopadoFecha With agrego.fechahiso,RC_hisopadoResul With agrego.resul, rc_estado With agrego.estadoctg
		If agrego.estadoctg =2
			Replace RC_fechaFin With agrego.fechahiso
		Endif

	Else
		Insert Into tabregctg ( rc_estado,  RC_fechaFin, RC_fechaInicio,  RC_fechaPasiva, rc_nroregistracio,RC_periodoLatencia, RC_virus;
			,RC_ARM,RC_hisopadoFecha,RC_hisopadoResul);
			VALUES (estadoctg ,Ctod("01/01/2100"),agrego.fecha,Ctod("01/01/1900"),mireg,0,1,agrego.arm,agrego.fecha,agrego.res)
	Endif

	MID = agrego.idctg
	If MID>0
		mimed = 1
		mfecha = agrego.fechahiso

		Insert Into tabregctglog( RCL_estado,RCL_hisopadoResul, RCL_idRegCtg,RCL_observaciones, RCL_usuario,RCL_fechahora);
			VALUES (mest,agrego.resul,MID,'',mimed,mfecha)
	Endif
	Select agrego
Endscan


Set Step On
Select resul
Set Step On
Scan
	mireg = nuevohisop.rc_nroregistracio
	MID = nuevohisop.idctg
	mimed = nuevohisop.idusu
	mfecha = nuevohisop.fecha

	Insert Into tabregctglog( RCL_estado,RCL_hisopadoResul, RCL_idRegCtg,RCL_observaciones, RCL_usuario,RCL_fechahora);
		VALUES (1,1,MID,'',mimed,mfecha)
	Select nuevohisop
Endscan

resul_coddeterminacion

Set Step On
Select resulta
Set Step On
Scan
	mireg = resulta.resul_coddeterminacion
	Select * From tabregctg Where rc_nroregistracio = mireg Into Cursor cttabregctg

	If Reccount('cttabregctg')>0
		If Reccount('cttabregctg')>1
			Set Step On
		Endif
		MID = cttabregctg.Id
		mimed = 1
		mfecha = resulta.RESUL_fechahoraresultado
		mobserva = resulta.desres
		MESTRE=cttabregctg.rc_estado
		MIEST = resulta.Id
		Insert Into tabregctglog( RCL_estado,RCL_hisopadoResul, RCL_idRegCtg,RCL_observaciones, RCL_usuario,RCL_fechahora);
			VALUES (1,MESTRE,MID,'',mimed,mfecha)
	Endif
	Select resulta

Endscan
*actualiza tabregctg y agrega log

Select fechahiso,nreg,fechahiso As fecharesul,estado_a,subestado,RC_hisopadoFecha,rc_estado,RC_hisopadoResul ;
	FROM AGREGO2,tabregctg Where nreg = rc_nroregistracio Into Cursor nuevohisop2

Set Step On
Select nuevohisop2
Set Step On
Scan
	mireg = nuevohisop2.nreg
	mimed = 1
	miestres = nuevohisop2.estado_a
	miestc = nuevohisop2.subestado
	mfecha = nuevohisop2.fechahiso
	Select tabregctg
	Locate For rc_nroregistracio = mireg
	If Found()
		miestctg = Iif(	Inlist(miestres,3,4),miestc ,  Iif(	Inlist(miestres,6) And tabregctg.rc_estado<2,miestc ,tabregctg.rc_estado ))
		Replace RC_hisopadoFecha With mfecha , RC_hisopadoResul With miestres , rc_estado With miestctg
		MID = tabregctg.Id

*!*			Insert Into tabregctglog( RCL_estado,RCL_hisopadoResul, RCL_idRegCtg,RCL_observaciones, RCL_usuario,RCL_fechahora);
VALUES (miestctg ,miestres ,MID,'',mimed,mfecha)
	Else
		Set Step On
	Endif
	Select nuevohisop2
Endscan




Set Step On
Select sisa
Set Step On
Scan
	Requery('regishc')
	mireg = regishc.reg_nroregistrac
	Replace nroreg With  mireg

	Select sisa
Endscan

Select AGREGO2
Set Step On
Scan
*	Requery('regishc')
*	mireg = regishc.reg_nroregistrac
	mireg = nreg
	Select tabregctg
	Locate For rc_nroregistracio = mireg
	If Found()

*replace RC_hisopadoFecha WITH agregohiso.fecha,RC_ARM WITH agregohiso.res, RC_hisopadoResul with agregohiso.res, RC_estado WITH IIF(agregohiso.res=3,3,1)
	Else
		Insert Into tabregctg ( rc_estado,  RC_fechaFin, RC_fechaInicio,  RC_fechaPasiva, rc_nroregistracio,RC_periodoLatencia, RC_virus;
			,RC_ARM,RC_hisopadoFecha,RC_hisopadoResul);
			VALUES (AGREGO2.subestado,Ctod("01/01/2100"),Ttod(AGREGO2.fechahiso),Ctod("01/01/1900"),mireg,0,1,0,Ttod(AGREGO2.fecharesul),AGREGO2.estado_a)
	Endif
	Select AGREGO2
Endscan




*!*	Select resulcovid
*!*	Select Id,  RESUL_coddeterminacion,RESUL_fechahoraincorpsg, RESUL_fechahorarecepmuestra, ;
*!*		RESUL_fechahoraresultado, RESUL_nrovale,Nvl(RESUL_resultado,RESUL_observaciones) As resul, RESUL_observaciones,  RESUL_resultado;
*!*		FROM resulcovid Into Cursor resul
*!*	Copy To resultados
*!*	Use c:\desaguemes\resultados.Dbf In 0 Exclusive


Use c:\desaguemes\contagio.Dbf In 0 Exclusive
Select * From contagio Where nreg Not In (Select rc_nroregistracio From tabregctg) Into Cursor agrego


Use c:\desaguemes\resulLABO.Dbf In 0 Exclusive
Select * From resulLABO,tabestados Where tipo = 2 And resulLABO.estado = tabestados.estado And nreg ;
	In (Select rc_nroregistracio From tabregctg) Order By nreg,fecharesul Into Cursor agrego
Select * From agrego Group By vale Into Cursor AGREGO2

Select fechahiso,nreg,fechahiso As fecharesul,'' As observa,estado_a,subestado,tabregctg.Id As idctg From resul;
	INNER Join tabregctg On nreg = rc_nroregistracio Order By nreg,fecharesul Into Cursor nuevohiso
Select * From 	nuevohiso Group By nreg Into Cursor nuevohisop2

Select * From resul,tabestados Where tipo = 2 And resul.resul = tabestados .estado ;
	Order By nreg Desc Into Cursor cambios



Select subestado As rc_estado,  Ctod("01/01/2100") As RC_fechaFin,Ttod(fechahiso) As  RC_fechaInicio,;
	CTOD("01/01/190") As  RC_fechaPasiva;
	,nreg As  rc_nroregistracio,0 As RC_periodoLatencia, 1 As RC_virus	,0 As RC_ARM,Ttod(fecharesul) As RC_hisopadoFecha,;
	estado_b As RC_hisopadoResul From AGREGO2 Into Cursor nuevo



Select * From sisa Where hclin Not In (Select REG_nrohclinica From tabregctg) Into Cursor agrego
Modify View regishc

Select * From sisa  Group By hclin,fecha,solic Order By fecha  Desc Into Cursor Base
Select * From Base Group By hclin Into Cursor contagion
Select * From Base Group By hclin Into Cursor contagios

Select * From Base Group By hclin Having Count(hclin)>1 Into Cursor hiso

RC_hisopadoFecha,rc_nroregistracio



Select * From Base Where hclin+Dtos(fecha) Not In (Select hclin+Dtos(fecha) From contagios) And  hclin  In (Select hclin From hiso) Into Cursor nuevohiso

Select * From nuevohisop2 Where fecharesul<RC_hisopadoFecha

Select nuevohiso.*,tabusuario.Id As idusu, rc_nroregistracio,tabregctg.Id As idctg ;
	FROM nuevohiso,tabregctg,tabusuario Where hclin = REG_nrohclinica  And idcodmed = codmed Into Cursor nuevohisop
Update sisa Set fecha = Ttod(fechor)

Update resulLABO Set fechahiso = Ctot(Alltrim(fecham)),fecharesul = Ctot(Alltrim(fechar))
Update resulLABO Set estado = 6 Where Alltrim(resul)='NO DETECTABLE' And estado = 0
Update resulLABO Set estado = 1 Where Alltrim(resul)='ANULADO' And estado = 0
Update resulLABO Set estado = 1 Where Left(Alltrim(resul),3)='ANU' And estado = 0

Update resulLABO Set estado = 3 Where Alltrim(resul)='POSITIVO' And estado = 0
Update resulLABO Set estado = 2 Where Alltrim(resul)='CON MUESTRA SIN RESULTADO' And estado = 0
Update resulLABO Set estado = 3 Where Alltrim(resul)='DETECTABLE' And estado = 0
Update resulLABO Set estado = 3 Where Left(Alltrim(resul),3)='DET' And estado = 0
Update resulLABO Set estado = 6 Where Left(Alltrim(resul),5)='NO DE' And estado = 0
Update resulLABO Set estado = 4 Where Alltrim(resul)='SE SOLICITA NUEVA MUESTRA' And estado = 0
Update resulLABO Set estado = 5 Where Alltrim(resul)='MUESTRA NO APTA' And estado = 0
Update resulLABO Set estado = 7 Where Alltrim(resul)='NO SE REALIZA EL TEST' And estado = 0
Update resulLABO Set estado = 8 Where Alltrim(resul)='NOTA' And estado = 0
Update resulLABO Set estado = 9 Where Alltrim(resul)='REPETIR' And estado = 0
Update resulLABO Set estado = 10 Where Alltrim(resul)='SE SOLICITA NUEVA MUESTRA' And estado = 0

Use c:\desaguemes\conta2.Dbf In 0 Excl
Browse Last
Update conta2 Set fechor = Ctot(Dtoc(fecha)+" " +Strtran(hora,".",":"))
Select hclin,fecha,"     " As hora,codmed As solic,Dtot(fecha) As fechor From contagio Union All;
	select * From conta2 Into Cursor Conta

Select * From Base Where nroreg In (Select rc_nroregistracio From tabregctg) Into Cursor agregohiso
Select * From contagio2 Where hclin Not In (Select REG_nrohclinica From tabregctg ) Into Cursor nuevos
Select 84
Browse Last
Select * From agrego Where cov_registrac Not In (Select nreg From nuevos)
Select * From nuevos Where nreg  Not In (Select cov_registrac From agrego )
Select * From agrego Left Join nuevos On nreg =  cov_registrac ;
	Where (cov_registrac Not In (Select REG_nrohclinica From tabregctg) And  nreg Not In(Select REG_nrohclinica;
	From tabregctg))
Modify View tabregctg
Select * From agrego Left Join nuevos On nreg =  cov_registrac;
	WHERE (cov_registrac Not In (Select rc_nroregistracio From tabregctg) And  nreg Not In(Select rc_nroregistracio From tabregctg))
Select 88
Browse Last
Select * From nuevos  Left Join agrego On nreg =  cov_registrac;
	WHERE (cov_registrac Not In (Select rc_nroregistracio From tabregctg) And  nreg Not In(Select rc_nroregistracio From tabregctg))

Select epibloq
Scan
	Requery('tabhciarchivo')
	Replace estado  With tabhciarchivo.hca_estado
Endscan
Select osde
Scan
	Requery('tabhciarchivo')
	Replace estado  With tabhciarchivo.hca_estado
Endscan

Select osde
Scan
	Requery('vales_real')
	Replace codmed With vales_real.VAL_medicosolicit
Endscan
Select tabregctg.*,Ttod(Nvl(FecHorDbAdd,Datetime())) As fecha,estado.Descrip As estado,resul.Descrip As resultado,ficha_covid.*;
	From tabregctg ;
	LEFT Join tabestados estado On (rc_estado =estado.estado And estado.tipo =1) ;
	LEFT Join tabestados resul On (RCL_hisopadoResul =resul.estado And resul.tipo = 2) ;
	LEFT Join ficha_covid On (cov_registrac = rc_nroregistracio) Into Cursor contagios
Update resul Set Id = 6 Where Alltrim(resul_observaciones)='NO DETECTABLE' And Id = 0
Update resul Set Id = 1 Where Alltrim(resul_observaciones)='ANULADO' And Id = 0

Update resul Set Id = 6 Where (At('NO DETECTABLE',Alltrim(resul_observaciones))>0 Or At('NO DETECTABLE',Alltrim(resul_resultado))>0) And Id = 0
Update resul Set Id = 3 Where  Alltrim(resul_observaciones)='DETECTABLE'
Update resul Set Id = 4 Where Like(Alltrim(resul_observaciones),'%NUEVA MUESTRA%') And Id = 0
Update resul Set Id = 5 Where Like(Alltrim(resul_observaciones),'%NO APTA%') And Id = 0
Update resul Set Id = 7 Where Like(Alltrim(resul_observaciones),'%NO SE REALIZA%') And Id = 0
Update resul Set Id = 8 Where Like(Alltrim(resul_observaciones),'%NOTA%') And Id = 0
Update resul Set Id = 9 Where Like(Alltrim(resul_observaciones),'%REPETIR And id = 0

Select RESUL_fechahorarecepmuestra As horavale,RESUL_fechahoraresultado As horaresu,resul_nroVALE As nrovale,;
	ALLTRIM(Nvl(resul_resultado,''))+Alltrim(Nvl(resul_observaciones,'')) As resul,0 As nreg,0 As estresu From resulcovid Into Table resulLABO


Select resul.*,estado.Descrip As estado,res.subestado As estadoctg,res.Descrip As resultado From resul;
	LEFT Join tabestados res On (resul.resul =res.estado And res.tipo = 2) ;
	LEFT Join tabestados estado On (res.subestado = estado.estado And estado.tipo =1) ;
	Into Cursor contagios
Select contagios.*,tabregctg.Id As idctg  From contagios Left Join tabregctg On nreg=rc_nroregistracio Into Cursor agrego

Select
Select contagios
Go Top
Set Step On
Do While !Eof('contagios')
	mireg = contagios.nreg
	fecini = contagios.horavale
	estctg = contagios.estadoctg
	fecfin = Ctod("01/01/2100")
	MIEST = 'Sospechoso de COVID-19'
	Do While !Eof('contagios') And mireg = nreg
		mivale = contagios.vale
		Do While !Eof('contagios') And mireg = nreg And mivale = vale
			Insert Into Pruebacar (RC_ARM, RC_ResuhisopadoFecha, descrestado, descresul, rc_estado,;
				RC_fechaFin, RC_fechaInicio,  RC_hisopadoFecha, RC_hisopadoResul,;
				RC_nrovale, rc_nroregistracio) Values (0,contagios.horavale,contagios.estado_b,contagios.resultado,contagios.estadoctg;
				,Iif(contagios.estadoctg=2,contagios.horaresu,fecfin),fecini ,contagios.horavale,;
				contagios.estado_a,contagios.nrovale,contagios.nreg )
			Select contagios
			Skip 1
		Enddo
	Enddo
Enddo



Select Id, RC_ARM, RC_ResuhisopadoFecha,;
	descrestado, descresul, rc_estado,;
	RC_fechaFin, RC_fechaInicio,;
	RC_hisopadoFecha, RC_hisopadoResul,;
	RC_nrovale, rc_nroregistracio;

Select dnibys
Set Step On
Scan
	Requery('regishc')
	mireg = regishc.reg_nroregistrac
	midni  = regishc.REG_numdocumento
	mhc = regishc.REG_nrohclinica
	mnom  = regishc.REG_nombrepac
	Select dnibys
	Replace hcli With mhc,nombre With mnom,nreg With mireg
Endscan

Select
Select admi
Scan
	Requery('vales_plasma')
	Replace vale  With vales_plasma.VAL_codvaleasist,estado ;
		With vales_plasma.VAL_estado,cantidad With vales_plasma.pia_cantsolicitada
Endscan
Select vales
Scan
	Requery('vales_prestac')
	Replace hclin With vales_prestac.pac_codhce,codprest With vales_prestac.pia_codprest,prestacion With vales_prestac.pre_descriprest
Endscan

Modify View ficha_covid_usu
Modify View tabusuario_med
Select ficha_covid_usu.*,idusuario From ficha_covid_usu INNER Join tabusuario_med On NomApeNotifica= nombre Into Cursor corrijo

Select ficha_covid_usu.*,tabusuario_med.idcodmed as idmed From ficha_covid_usu INNER Join tabusuario_med On NomApeNotifica= tabusuario_med.nombre;
	group By ficha_covid_usu.Id  Into Cursor corrijo
Select ficha_covid_usu.*,tabusuario_med.idcodmed as idmed From ficha_covid_usu INNER Join tabusuario_med On NomApeNotifica= tabusuario_med.nomape;
	group By ficha_covid_usu.Id  Into Cursor corrijo
Select corrijo
Scan
	MID = Id
	Select ficha_covid_usu
	Locate For Id = MID
	If Found()
		Replace cov_usuario With TRANSFORM(corrijo.idmed)
	Else
		Set Step On
	ENDIF
	Select corrijo
ENDSCAN

UPDATE ficha_covid_usu SET  cov_usuario= 'ANRIOS' WHERE NomApeNotifica  ='RIOS  ANTONELA SOLEDAD'


SELECT ficha_covid_usu 
Scan
	MID = VAL(UserDbUpd)
	Select tabusuario_med 
	Locate For Idcodmed = MID
	If Found()
		Select ficha_covid_usu 
		Replace cov_usuario With tabusuario_med.idusuario
	Else
		Set Step On
	ENDIF
	Select ficha_covid_usu 
ENDSCAN