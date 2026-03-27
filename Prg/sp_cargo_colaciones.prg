****
** busco pacientes para nutricion
****

Parameter mfechac

mfecdia = sp_busco_fecha_serv('DT')
Do sp_busco_ingred
mfechad = prg_calcula_diahabil(mfechac,-1,"1,7")
mfechanull  = "1900-01-01 00:00:00"
mfecnul = Ctod("01/01/1900")
mfechabaja = mwkfecserv.fechahora
*!*	Do sp_busco_tabintnut With 4, " order by IH_admision,ih_secuencia " ;
*!*		,'mwkIntNutsuspp'
*!*	Select * From mwkIntNutsuspp Group By IH_admision Into Cursor mwkIntNutsuspa
*!*	Select * From mwkIntNutsuspp  Where  IH_admision+Transform(ih_secuencia,"99") ;
*!*			in (Select  IH_admision+Transform(ih_secuencia,"99") From mwkIntNutsuspa) Into Cursor mwkIntNutsusp

*!*	Select IH_admision From mwkIntNutsusp Where INA_fechaHoraIni <= mfechabaja Into Cursor mwkayunos
DO sp_busco_tabintnut WITH 4, " order by IH_admision  ", 'mwkIntNutsusp'
SELECT ih_admision FROM mwkIntNutsusp WHERE ina_fechahoraini <= mfechabaja INTO CURSOR  mwkayunos
*** Nutricion
mret = SQLExec(mcon1, "select * from TabNutPaciente,pacinternad " + ;
	" left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id" + ;
	" where TNP_codadmision = pin_codadmision and TNP_Fecha = ?mfechad and TNP_CodServ = 5 "+;
	" and TNP_codadmision  not in (select TNP_codadmision from TabNutPaciente "+;
	" left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id " + ;
	" left join TabNutPrest on TabNutPrest.TNP_codPrest= TabNutDetalle.TND_codPrest " + ;
	" where TNP_CodServ = 5 and TNP_Fecha= ?mfechac )"+;
	" order by  TNP_codadmision ,TNP_Fecha ", "mwknutcol1")
If mret<1
	=Aerr(eros)
	Messagebox (eros(3))
Endif
mret = SQLExec(mcon1, "select * from TabNutPaciente,pacinternad  " + ;
	" left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id" + ;
	" where TNP_codadmision = pin_codadmision and TNP_Fecha = ?mfechad and TNP_CodServ = 6 "+;
	" and TNP_codadmision  not in (select TNP_codadmision from TabNutPaciente "+;
	" left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id " + ;
	" left join TabNutPrest on TabNutPrest.TNP_codPrest= TabNutDetalle.TND_codPrest " + ;
	" where TNP_CodServ = 6 and TNP_Fecha= ?mfechac )"+;
	" order by  TNP_codadmision ,TNP_Fecha ", "mwknutcol2")
If mret<1
	=Aerr(eros)
	Messagebox (eros(3))
Endif
Select * From mwknutcol1 Union All Select * From mwknutcol2 Into Cursor mwknutcol
If Reccount("mwknutcol1")>0
	If Reccount("mwknutcol2")/Reccount("mwknutcol1")*100<50
		mfechacn = mfechac -1
		mret = SQLExec(mcon1, "select * from TabNutPaciente,pacinternad  " + ;
			" left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id" + ;
			" where TNP_codadmision = pin_codadmision and TNP_Fecha = ?mfechad and TNP_CodServ = 6 "+;
			" and TNP_codadmision  not in (select TNP_codadmision from TabNutPaciente "+;
			" left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id " + ;
			" left join TabNutPrest on TabNutPrest.TNP_codPrest= TabNutDetalle.TND_codPrest " + ;
			" where TNP_CodServ = 6 and TNP_Fecha= ?mfechacn )"+;
			" order by  TNP_codadmision ,TNP_Fecha ", "mwknutcol2b")
		Select * From 	mwknutcol2b Union All Select * From mwknutcol2 Into Cursor mwknutcol2c
		Select * From mwknutcol2c Order By  TNP_codadmision ,TNP_Fecha Into Cursor mwknutcol2b
		Select * From mwknutcol2b Group By  TNP_codadmision Into Cursor mwknutcol2
	Endif
Endif

Select * From mwknutcol Where Nvl(TND_fecbaja,mfecnul ) = mfecnul Group By  TNP_codadmision,TNP_CodServ Into Cursor mwknutcolc
Select * From mwknutcolc ;
	left Join mwktningr On tnd_codprest = mwktningr.Id  ;
	where  TNP_codadmision  Not In (Select IH_admision From mwkayunos) ;
	order By TNP_codadmision,TNP_CodServ;
	into  Cursor mwkncolac

Select mwkncolac
Do While !Eof('mwkncolac')
	msec = 1
	mtiposerc	= mwkncolac.TNP_CodServ
	mingr 		= mwkncolac.TND_codPrest
	mcodadm		= mwkncolac.TNP_codadmision
	mvale 		= mwkncolac.TND_NroVale
	mobserva	= "->"  &&"Revisar"
	mdet 		=  mwkncolac.TNP_observaciones &&"Revisar"
	musu_carga 	= mwkusuario.codigovax
	mmedico		= 0
	mcodvax	= mwkusuario.codigovax
	mret =SQLExec(mcon1, "select id from TabNutPaciente "+;
		"where TNP_codadmision = ?mcodadm and TNP_Fecha = ?mfechac "+;
		" and TNP_CodServ = ?mtiposerc","mwkexistepac")
	If Reccount("mwkexistepac") = 0
		Do sp_actualizo_tab_nut_pac With 1, mcodadm, mtiposerc, mdet,'','',mfechac
		mret =SQLExec(mcon1, "select id from TabNutPaciente "+;
			"where TNP_codadmision = ?mcodadm and TNP_Fecha = ?mfechac "+;
			" and TNP_CodServ = ?mtiposerc","mwkexistepac")
		midpac= mwkexistepac.Id
		Do While !Eof('mwkncolac') And  mcodadm = mwkncolac.TNP_codadmision And mtiposerc	= mwkncolac.TNP_CodServ
			mingr 		= mwkncolac.TND_codPrest
			msec = Iif(	mcodadm = mwkncolac.TNP_codadmision,msec+1,1)
			mvale 		= msec
			Do sp_actualizo_tab_nut_det With 1, midpac, mingr, mvale,mfecdia,mobserva
			Skip 1 In mwkncolac
		Enddo
	Endif
Enddo

