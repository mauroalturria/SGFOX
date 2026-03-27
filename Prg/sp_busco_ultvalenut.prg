****
** Busca nuevos vales de Nutricion
****
Lparameters lvalesGUA,lsigue_coc
If myip = '172.16.1.7'
	Set Step On
Endif
If Vartype(lsigue_coc )<>"L"
	lsigue_coc = .F.
Endif
Do sp_busco_ultfechanut
Dimension cf(100),tdieta(21)
Store '' To cf
Store 0 To tdieta
tdieta(11) = 6
tdieta(10) = 9
If Vartype(lvalesGUA)#"N"
	lvalesGUA = 1
Endif
*!*	do sp_busco_estados with 7,' and tipo = 20 ','mwkhabnut'   &&habilita rNutricion desde HCE
*!*	msechab = "'1'"
*!*	go top in 'mwkhabnut'
*!*	if mwkhabnut.estado > 0 &&or mwkusuario.Sector = "SISTEMAS"
*!*		select mwkhabnut
*!*		scan
*!*			msechab = msechab + ","+mwkhabnut.descrip
*!*		endscan
*!*	endif
mfechabaja = sp_busco_fecha_srv2('DT')
mfechahoy  = Ttod(mfechabaja)
fhlimite = Nvl(mwkUfan.Fecha_UAct_Alim,Ctot("01/01/1900"))
fhlimitec = fhlimite
fechalimite =Ttod(fhlimite )
fechatope = Ctot("01/01/2100")
fechaant = Dtot(fechalimite )
horalimite = Ctot( Dtoc(mfechahoy) + " 11:00:00")
cflim = Left(prg_dtoc(fechalimite),10)+ " "+ Ttoc(fhlimite,2)
cflimhce = Left(prg_dtoc(mfechahoy ),10)+ " 00:00"
Do sp_busco_tabintnut With 4, " order by IH_admision  " ;
	,'mwkIntNutsusp'
*!*	Select * From mwkIntNutsuspp Group By IH_admision Into Cursor mwkIntNutsuspa
*!*	Select * From mwkIntNutsuspp  Where  IH_admision+Transform(ih_secuencia,"99") ;
*!*		in (Select  IH_admision+Transform(ih_secuencia,"99") From mwkIntNutsuspa) Into Cursor mwkIntNutsusp
Select ih_admision From  mwkIntNutsusp Where ina_fechahoraini <=  mfechabaja Into Cursor mwkayunos

Do sp_busco_tabintnut With 2, " order by IH_admision,ih_secuencia desc,TNP_Dieta   " ;
	,'mwkIntNutsectotal'
*!*	Select * From mwkIntNutsectot Group By IH_admision Into Cursor mwkIntNutsectotal
*!*	Select *,Id As mide  From mwkIntNutsectot Where  IH_admision+Transform(ih_secuencia,"99") ;
*!*		in (Select  IH_admision+Transform(ih_secuencia,"99") From mwkIntNutsectotal ) Into Cursor mwkintultsec

Do sp_busco_tabinthce With 1,'','mwkhcepac'
Select IH_admision From mwkIntNutsusp Where INA_fechaHoraIni <= mfechabaja Into Cursor mwkayunos
*!*	Select Max(Id) As mide From mwkhcepac;
*!*		group By IH_admision Into Cursor mwkintultsec &&where !inlist(PAC_sectorinternac,'RCV','CEG')

Select Max(Id) As mide From mwkhcepac Group By  ih_admision Into Cursor mwkintultsec
fhlimitehce = Iif (mfechahoy  = fechalimite , Ttod(fhlimite -10*60),mfechahoy  )
*!*	Select * From mwkIntNutsectotal ;
*!*		where IN_fechaHoraApli<fhlimitehce And in_idevol In (Select mide From mwkintultsec) ;
*!*		group By in_idevol,IN_codprest Into Cursor mwkintnutsec	&&busco las actualizaciones para las ultimas secuencias

*!*	Select IH_admision From mwkIntNutsectotal ;
*!*		where Between(IN_fechaHoraApli,mfechahoy-1,mfechahoy+1);
*!*		and in_idevol In (Select mide From mwkintultsec) Into Cursor mwkctrladm  && busco aquellas admisiones que tuvieron actualizaciones en las ultimas 24hs

*!*	Select * From mwkintnutsec Where IH_admision Not In (Select IH_admision From mwkayunos) ;
*!*		into Cursor  mwkIntNut &&Actualizaciones habilitadas
Select * From mwkIntNutsectotal;
	WHERE in_fechahoraapli < fhlimitehce And in_idevol In(Select mide From mwkintultsec) ;
	GROUP By in_idevol, in_codprest ;
	INTO Cursor  mwkintnutsec
Select ih_admision From mwkIntNutsectotal ;
	WHERE  Between(in_fechahoraapli, mfechahoy - 1, mfechahoy + 1);
	AND in_idevol In(Select mide From mwkintultsec)  Into Cursor mwkctrladm
Select * From mwkintnutsec ;
	WHERE Not ih_admision In(Select ih_admision From mwkayunos) Into Cursor mwkIntNut


If Reccount('mwkIntNut')>0
*!*		Select * From mwkIntNutsectotal ;
*!*			where in_idevol In (Select mide From mwkintultsec) ;
*!*			and  in_idevol In (Select in_idevol From mwkintnutsec);
*!*			and IH_admision Not In (Select IH_admision From mwkayunos) ;
*!*			into Cursor  mwkIntNut  && indicaciones completas para aquellas que tuvieron modificaciones y estan en sectores habilitados
	Select * From   mwkIntNutsectotal  ;
		WHERE in_idevol  IN(Select mide From   mwkintultsec) And  ;
		in_idevol In(SELECT in_idevol From  mwkintnutsec) And   ;
		NOT ih_admision  IN(Select  ih_admision From  mwkayunos)   ;
		INTO CURSOR mwkIntNut
		
	Select Distinct IH_admision From mwkIntNut Into Cursor mwkcontrolo  && que admisiones van a generar vale

	Select  IH_admision  From mwkctrladm ;
		where IH_admision  Not In ( Select IH_admision  From mwkcontrolo ) ;
		into Cursor mwknocargar			&& que admisiones ya generaron vale y no van a tomar nuevos vales
*	messagebox("VA A ACTUALIZAR "+transform(reccount('mwkcontrolo'))+" DIETAS DE HCE")
	Do Form frmnutri29 To fhultimovale
	Do sp_busco_ultfechanut
	fechatope = Nvl(mwkUfan.Fecha_UAct_Alim,Ctot("01/01/2100"))
Endif
If myip= '172.16.1.7'
	*Set Step On
Endif
mfechanull = Ctot("01/01/1900")
mret =SQLExec(mcon1, "select VAL_codadmision, VAL_fechasolicitud" + ;
	", pia_cantsolicitada,pia_codprest,pia_secuen_carga,nombre "+;
	", VAL_fechacargasoli,VAL_horacargasolic , VAL_codvaleasist " + ;
	", VAL_operadorcarga,VAL_medicosolicit,VAL_observaciones,VAL_codsector " + ;
	" from pacientes,valesasist " + ;
	" left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist "+;
	" left outer join prestadores on valesasist.VAL_prestador = prestadores . id "+;
	" where  PAC_codadmision = VAL_codadmision and "+;
	" VAL_fechasolicitud>= ?fechalimite and " + ;
	" VAL_codsector <> 'AMB' and VAL_codsector<> 'GUA' "+;
	" and VAL_codservvale = 9400 ", "mwktotval01")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DE CURSOR, AVISAR A SISTEMAS", 13,"Validacion")
Endif
mret =SQLExec(mcon1, "select tnd_nroVale from TabNutDetalle "+;
	" where TND_FHoraCarga >= ?fechaant  ", "mwkvales")

mret =	SQLExec(mcon1, "select pre_codprest,pre_descriprest,pre_especialidad " + ;
	" from prestacions " + ;
	" where pre_codservicio=9400  and PRE_fechapasiva is null " , "mwkpres")
If mret<1
	=Aerr(eros)
	Messagebox(eros(2))
Endif
mret =	SQLExec(mcon1, "select TNP_codPrest,TNP_codfactu,TNP_factura,TNP_Dieta "+;
	" from TabNutPrest " , "mwkTNprest")
If mret<1
	=Aerr(eros)
	Messagebox(eros(2))
Endif
Select *,tdieta(Nvl(TNP_Dieta,0)+1) As cpodieta,;
	ctot(Dtoc(VAL_fechacargasoli)+" "+Left(Ttoc(VAL_horacargasolic,2),8)) As mfhc;
	from mwktotval01 ;
	left Join mwkpres On pre_codprest = pia_codprest ;
	left Join mwkTNprest On pia_codprest = TNP_codPrest ;
	where VAL_codvaleasist Not In (Select tnd_nroVale From mwkvales) ;
	and Left(Nvl(VAL_observaciones,''),6) = "*V.A.*"  ;
	and Ctot(Dtoc(VAL_fechacargasoli)+" "+Left(Ttoc(VAL_horacargasolic,2),8))<= fechatope ;
	into Cursor mwktotval1a

Select *,tdieta(Nvl(TNP_Dieta,0)+1) As cpodieta,;
	ctot(Dtoc(VAL_fechacargasoli)+" "+Left(Ttoc(VAL_horacargasolic,2),8)) As mfhc;
	from mwktotval01 ;
	left Join mwkpres On pre_codprest = pia_codprest ;
	left Join mwkTNprest On pia_codprest = TNP_codPrest ;
	where VAL_codvaleasist Not In (Select tnd_nroVale From mwkvales) ;
	and Left(Nvl(VAL_observaciones,''),6) # "*V.A.*" And  VAL_codadmision Not In(Select IH_admision From mwkctrladm)  ;
	and Ctot(Dtoc(VAL_fechacargasoli)+" "+Left(Ttoc(VAL_horacargasolic,2),8))<= fechatope ;
	and  VAL_codadmision Not In (Select IH_admision From mwkayunos) ;
	into Cursor mwktotval1b

&&and  VAL_codadmision not in(select ih_admision from mwkctrladm)

If Reccount('mwktotval1a')>0
	Select * From mwktotval1a Union All Select * From mwktotval1b;
		into Cursor mwktotval1
Else
	Select * From mwktotval1b;
		into Cursor mwktotval1
Endif

Select * From mwktotval1 ;
	where Nvl(TNP_Dieta,0) < 9 ;
	order By VAL_codadmision, VAL_codvaleasist, cpodieta, VAL_fechacargasoli, VAL_horacargasolic;
	, VAL_codvaleasist ,pia_secuen_carga ;
	group By VAL_codadmision , cpodieta, VAL_fechacargasoli, pia_codprest ;
	into Cursor mwktotval

Select mwktotval
Go Top
mfhora = sp_busco_fecha_serv('DT')
horaproceso = Hour(mfhora)*100 + Minute(mfhora)
Select mwktotval
Go Top
Do While !Eof('mwktotval')
	mcodadm		= mwktotval.VAL_codadmision
	mvale 		= mwktotval.VAL_codvaleasist
	mdieta		= tdieta(Nvl(mwktotval.TNP_Dieta,0)+1)
***** Car 17/02/2012
	mtiposer = Iif(Nvl(mwktotval.TNP_Dieta,0) = 6, 9, 0)
	If !Used("mwkusuario")
		Create Cursor mwkusuario (idusuario c(20),codigovax N(7),Password c(10),Id N(2),nivel N(2),sector c(30),nomape c(30))
		Insert Into mwkusuario Values ("CFUNES",54035,'',146,1,'SISTEMAS',"Carmencita")
	Endif

	mcodvax	= mwkusuario.codigovax
	mret =SQLExec(mcon1, "select * from TabNutPaciente "+;
		"where TNP_codadmision = ?mcodadm and TNP_Fecha = ?mfechahoy "+;
		" and TNP_CodServ = ?mtiposer","mwkexistepac")
	If Reccount("mwkexistepac")>0
		mid= mwkexistepac.Id
		If Nvl(tnp_modi,0)=1 Or !lsigue_coc
			madapt = TNP_Observaciones
		Else
			madapt = ''
		Endif
		mret =SQLExec(mcon1, "update TabNutDetalle set TND_fecBaja = ?mfechabaja "+;
			" where TND_idPaciente = ?mid and TND_fecBaja = ?mfechanull ")
		If mret<1
			=Aerr(eros)
			Messagebox(eros(2))
		Endif
		If lsigue_coc
			mret =SQLExec(mcon1, "Update TabNutPaciente set TNP_CodFact = '' "+;
				", TNP_Observaciones = '' where id = ?mid")
		Else
			mret =SQLExec(mcon1, "Update TabNutPaciente set TNP_CodFact = '' "+;
				", TNP_Observaciones = ?madapt where id = ?mid")
		Endif

	Else
		mret =SQLExec(mcon1, "insert into TabNutPaciente (TNP_codadmision"+;
			",TNP_Fecha,TNP_CodServ,TNP_CodFact,TNP_Observaciones,TNP_Usuario )"+;
			" values (?mcodadm,?mfechahoy,?mtiposer,'','',?mcodvax )")
		If mret<1
			=Aerr(eros)
			Messagebox(eros(2))
		Endif
		mret =SQLExec(mcon1, "select * from TabNutPaciente "+;
			"where TNP_codadmision = ?mcodadm and TNP_Fecha = ?mfechahoy "+;
			" and TNP_CodServ = ?mtiposer","mwkexistepac")
		If mret<1
			=Aerr(eros)
			Messagebox(eros(2))
		Endif
		If Reccount("mwkexistepac")>0
			mid= mwkexistepac.Id
		Else
			Messagebox("esto esta mal")
			Messagebox("codadm= "+mcodadm+" Fecha="+Dtoc(mfechahoy)+" CS="+Str(mtiposer))
		Endif
	Endif

	Do While !Eof('mwktotval') And 	mcodadm	= mwktotval.VAL_codadmision And ;
			mvale = mwktotval.VAL_codvaleasist And ;
			mdieta	= tdieta(Nvl(mwktotval.TNP_Dieta,0)+1)
		mfechacarga = Ctot(Dtoc(mwktotval.VAL_fechacargasoli)+" "+Left(Ttoc(mwktotval.VAL_horacargasolic,2),8))
		mpresta		= mwktotval.pia_codprest
		mvale 		= mwktotval.VAL_codvaleasist
		mdieta 		= tdieta(Nvl(mwktotval.TNP_Dieta,0)+1)
		mobserva	= Nvl(mwktotval.VAL_observaciones,'')
		musu_carga 	= mwktotval.VAL_operadorcarga
		mmedico		= mwktotval.VAL_medicosolicit
		mcant 		= mwktotval.pia_cantsolicitada
		If Nvl(mwktotval.TNP_Dieta,0) # 6
			mcant = 1
		Endif
		fhlimite 	= Iif(mfechacarga > fhlimite, mfechacarga, fhlimite )
		horactr 	= Val(Left(Ttoc(mwktotval.VAL_horacargasolic,2),2))
		mth	= Iif( horactr<11,0,1)
		mtd = Nvl(mwktotval.TNP_Dieta,0)>0
*endif
*!*		if TNP_Dieta = 4
*!*			mtiposer = iif( horactr>7 and horactr<16,6,5)
*!*		endif
		mret =SQLExec(mcon1, "insert into TabNutDetalle "+;
			"( TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga"+;
			",TND_observa, TND_fecbaja,TND_Cantidad, TND_Hora,TND_usuario )"+;
			" values (?mid, ?mpresta, ?mvale, ?mfechacarga, "+;
			"?mobserva,?mfechanull,?mcant,?horaproceso,?musu_carga )")

		If mret<1
			=Aerr(eros)
			Messagebox(eros(2))
		Endif
		Skip 1 In mwktotval
	Enddo
Enddo


Select Distinct VAL_codadmision,Nvl(TNP_Dieta,0) As TNP_Dieta From mwktotval Where Nvl(TNP_Dieta,0) = 0 Into Cursor mwkauxi1
Select mwkauxi1
Go Top
Do While !Eof('mwkauxi1')
	mcodadm = Alltrim(mwkauxi1.VAL_codadmision)
	mdieta  = mwkauxi1.TNP_Dieta
	mbusca= " and pac_codadmision = '" + mcodadm + "' "
	Do sp_busco_dieta With mfechahoy, mdieta, mbusca
	Select mwknutdieta.*,pre_descriprest ;
		from mwknutdieta Left Join mwkpres On pre_codprest = tnd_codprest ;
		group By pre_descriprest;
		into Cursor mwknutdieta1
	Select mwknutdieta1
	midpac = mwknutdieta1.TND_idPaciente

	mfhingreso = Ctot(Dtoc(PAC_fechaadmision)+" "+Ttoc(PAC_horaadmision,2))

	cmpres 	= ''
	mcodfac = ''
	ind_cf 	= 0
	Store '' To cf
	Do While !Eof('mwknutdieta1')
		mcodfac = Alltrim(mwknutdieta1.TNP_CodFactu)
		If !Empty(mcodfac) And Ascan(cf,mcodfac) = 0
			ind_cf 		= ind_cf +1
			cf(ind_cf)	= mcodfac
		Endif
		descriprest = Nvl( mwknutdieta1.pre_descriprest, '' )
		cmpres = cmpres + Iif(!Empty(cmpres ),"+",'') +;
			iif(!Empty( descriprest), Proper(Iif(At("DIETA",descriprest)=1;
			,Alltrim(Strtran(descriprest,"DIETA ",""));
			,Alltrim(descriprest)));
			,'')
		Skip 1 In mwknutdieta1
	Enddo
	mcf = ''
	If ind_cf>0
		For ind = 1 To ind_cf
			mcf= mcf + Alltrim(cf(ind))+" "
		Next
	Endif
	cmpres = Iif(Len(cmpres)>250,Left(cmpres,246)+"...",cmpres)
	Do sp_actualizo_tab_nut_pac With 2,mcodadm,mdieta,cmpres,mcf,midpac
	mtiposer = 2
	mret =SQLExec(mcon1, "select * from TabNutPaciente "+;
		"where TNP_codadmision = ?mcodadm and TNP_Fecha = ?mfechahoy "+;
		" and TNP_CodServ = ?mtiposer","mwkexistepac")
	If Reccount("mwkexistepac")>0
		mid= mwkexistepac.Id
		If Nvl(tnp_modi,0)=1 Or !lsigue_coc
			madapt = TNP_Observaciones
		Else
			madapt = ''
		Endif
		If lsigue_coc
			mret =SQLExec(mcon1, "Update TabNutPaciente set TNP_CodFact = ?mcf "+;
				", TNP_Observaciones ='' where id = ?mid")
		Else
			mret =SQLExec(mcon1, "Update TabNutPaciente set TNP_CodFact = ?mcf  "+;
				", TNP_Observaciones = ?madapt where id = ?mid")
		Endif
	Endif
	If horaproceso <1100 Or (horaproceso <1300  And mfhingreso >= horalimite )
		mtiposer = 1
		mret =SQLExec(mcon1, "select * from TabNutPaciente "+;
			"where TNP_codadmision = ?mcodadm and TNP_Fecha = ?mfechahoy "+;
			" and TNP_CodServ = ?mtiposer","mwkexistepac")
		If Reccount("mwkexistepac")>0
			mid= mwkexistepac.Id
			If Nvl(tnp_modi,0)=1 Or !lsigue_coc
				madapt = TNP_Observaciones
			Else
				madapt = ''
			Endif
			If lsigue_coc
				mret =SQLExec(mcon1, "Update TabNutPaciente set TNP_CodFact = ?mcf "+;
					", TNP_Observaciones ='' where id = ?mid")
			Else
				mret =SQLExec(mcon1, "Update TabNutPaciente set TNP_CodFact = ?mcf  "+;
					", TNP_Observaciones = ?madapt where id = ?mid")
			Endif

		Endif
	Endif
	Skip 1 In mwkauxi1
Enddo
**** dieta comun

mtiposer = 0
mret =SQLExec(mcon1,"select * from TabNutPaciente "+;
	"where TNP_Fecha = ?mfechahoy "+;
	" and TNP_CodServ = ?mtiposer ","mwkexistepac0")
Select * From mwkexistepac0 Where Empty(TNP_Observaciones) Into Cursor mwkctrlpac

If Reccount("mwkctrlpac")>0
	Select mwkctrlpac
	Do While !Eof('mwkctrlpac')
		mcodadm = Alltrim(mwkctrlpac.tnp_codadmision)
		mbusca= " and pac_codadmision = '" + mcodadm + "' "
		Do sp_busco_dieta With mfechahoy, mtiposer, mbusca
		Select mwknutdieta.*,pre_descriprest ;
			from mwknutdieta Left Join mwkpres On pre_codprest = tnd_codprest ;
			group By pre_descriprest;
			into Cursor mwknutdieta1
		Select mwknutdieta1
		midpac = mwknutdieta1.TND_idPaciente
		cmpres 	= ''
		mcodfac = ''
		ind_cf 	= 0
		Store '' To cf
		Do While !Eof('mwknutdieta1')
			mcodfac = Alltrim(mwknutdieta1.TNP_CodFactu)
			If !Empty(mcodfac) And Ascan(cf,mcodfac) = 0
				ind_cf 		= ind_cf +1
				cf(ind_cf)	= mcodfac
			Endif
			descriprest = Nvl( mwknutdieta1.pre_descriprest, '' )
			cmpres = cmpres + Iif(!Empty(cmpres ),"+",'') +;
				iif(!Empty( descriprest), Proper(Iif(At("DIETA",descriprest)=1;
				,Alltrim(Strtran(descriprest,"DIETA ",""));
				,Alltrim(descriprest)));
				,'')
			Skip 1 In mwknutdieta1
		Enddo
		mcf = ''
		If ind_cf>0
			For ind = 1 To ind_cf
				mcf= mcf + Alltrim(cf(ind))+" "
			Next
		Endif
		cmpres = Iif(Len(cmpres)>250,Left(cmpres,246)+"...",cmpres)
		Do sp_actualizo_tab_nut_pac With 2,mcodadm,mtiposer,cmpres,mcf,midpac
		Select mwkctrlpac
		Skip 1 In mwkctrlpac
	Enddo
Endif
&& DIETAS ESPECIALES
mtiposer = 9
mret =SQLExec(mcon1,"select * from TabNutPaciente "+;
	"where TNP_Fecha = ?mfechahoy "+;
	" and TNP_CodServ = ?mtiposer ","mwkexistepac0")
Select * From mwkexistepac0 Where Empty(TNP_Observaciones) Into Cursor mwkctrlpac

If Reccount("mwkctrlpac")>0
	Select mwkctrlpac
	Do While !Eof('mwkctrlpac')
		mcodadm = Alltrim(mwkctrlpac.tnp_codadmision)
		mbusca= " and pac_codadmision = '" + mcodadm + "' "
		Do sp_busco_dieta With mfechahoy, mtiposer, mbusca
		Select mwknutdieta.*,pre_descriprest ;
			from mwknutdieta Left Join mwkpres On pre_codprest = tnd_codprest ;
			GROUP By pre_descriprest ;
			into Cursor mwknutdieta1
		Select mwknutdieta1
		midpac = mwknutdieta1.TND_idPaciente
		If midpac =0
			Skip 1
			midpac = mwknutdieta1.TND_idPaciente
		Endif
		cmpres 	= ''
		mcodfac = ''
		ind_cf 	= 0
		Store '' To cf
		Do While !Eof('mwknutdieta1')
			mcodfac = Alltrim(mwknutdieta1.TNP_CodFactu)
			If !Empty(mcodfac) And Ascan(cf,mcodfac) = 0
				ind_cf 		= ind_cf +1
				cf(ind_cf)	= mcodfac
			Endif
			descriprest = Nvl( mwknutdieta1.pre_descriprest, '' )
			cmpres = cmpres + Iif(!Empty(cmpres ),"+",'') +;
				iif(!Empty( descriprest), Proper(Iif(At("DIETA",descriprest)=1;
				,Alltrim(Strtran(descriprest,"DIETA ",""));
				,Alltrim(descriprest)));
				,'')
			Skip 1 In mwknutdieta1
		Enddo
		mcf = ''
		If ind_cf>0
			For ind = 1 To ind_cf
				mcf= mcf + Alltrim(cf(ind))+" "
			Next
		Endif
		cmpres = Iif(Len(cmpres)>250,Left(cmpres,246)+"...",cmpres)
		Do sp_actualizo_tab_nut_pac With 2,mcodadm,mtiposer,cmpres,mcf,midpac
		Select mwkctrlpac
		Skip 1 In mwkctrlpac
	Enddo
Endif
mret =SQLExec(mcon1, "select TabNutPaciente.*,TND_idPaciente from TabNutPaciente "+;
	" left join TabNutDetalle on TabNutPaciente.id = TND_idPaciente "+;
	"where TNP_Fecha = ?mfechahoy "+;
	" and TNP_CodServ = 0 ","mwkctrsiddet")
Select mwkctrsiddet.*,in_idevol From  mwkctrsiddet Left Join mwkIntNutsectotal On tnp_codadmision = IH_admision;
	where Isnull(TND_idPaciente) Into Cursor mwkelimino
Select mwkelimino
Scan
	midevol = in_idevol
	mcodadmision = tnp_codadmision
	mid = Id
	Do sp_grabo_evol_int_nut With midevol,'',3,Ctod("01/01/1900"), mcodadmision,fhlimitec
	mret =SQLExec(mcon1, "update TabNutPaciente set TNP_Fecha = '1900-01-01' where id = ?mid ")
Endscan
If Reccount('mwkIntNut')=0
	Do sp_grabo_new_fua With fhlimite
Endif
&& actualizacion de vales de guardia
If lvalesGUA=1
	Do sp_busco_ultvalenut_amb
Endif
