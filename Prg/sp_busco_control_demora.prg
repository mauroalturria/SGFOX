*!*	-------------------------------------------------------
*!*	Parametros
*!*	-------------------------------------------------------
Lparameters mOpcion, mfecdes, mwhere, mtipo

Do sp_busco_prestacion with " and PRE_AgendaTurnos = 'S' "

Select max(PRE_retiroestudios) as demora from mwkprestac into cursor mwkdemo
mfechaini = prg_calcula_diahabil(mfecdes-1,mwkdemo.demora*(-1),"1,7")

Do sp_medicos

&& Obtengo los protocolos
&& Modifico tpestado > 2 a tpestado in ( 1, 2, 4, 5, 7) && 100701

mret = sqlexec(mcon1, "SELECT tpprotocolo, tpregistrac FROM Tabprotocolo"+;
	" Where tpestado in (1, 2, 4, 5, 7) and tpfecharetiro >= ?mfechaini   "+;
	" group by tpprotocolo" ,"mwkanulados")

If mret <=0
	Messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
	Aerror(eros)
	Return .f.
Endif
mcwhere = ''

mjoin = " Join coberturas On cob_pacientes = valesasist.VAL_codadmision " +;
	" Left join entidades On entidades.ent_codent = coberturas.cob_codentidad "

Do case

Case mOpcion = 1  && Guardia
	mcwhere = " and Val_TipoPaciente = 'GUA' "
Case mOpcion = 2  && Ambulatorio
	mcwhere = " and Val_TipoPaciente = 'AMB' "
Case mOpcion = 3  && Internación
	mcwhere = " and Val_TipoPaciente = 'INT' "
	mjoin   = " join histambgua on histambgua.his_codadmision = valesasist.VAL_codadmision "  +;
		" Left join entidades on entidades.ent_codent = histambgua.his_codentidad "
Endcase

&& vales e informes entre las 2 fechas
lnCantDias = mfecdes - mfechaini
ldFecha = mfechaini

If Used("mwkInfo")
	Use In mwkInfo
Endif 

mret = sqlexec(mcon1, "select " + ;
	"Informes.CodMedFirma, " + ;
	"informes.Id, nvl(Estadoinforme,0) as Estadoinforme, Informes.CodPun " + ;
	" from informes " + ;
	" where FechaInforme >= ?mfechaini and informes.TipoArch not in " + prg_ext_sonido(2) + "" + ;
	"", "mwkinfoAUX")

If mret <= 0
	Messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
	Aerror(eros)
	Return .f.
Endif	
	
For I = 0 To lnCantDias
	
	If !Used("mwkInfo")

		mret = sqlexec(mcon1, "select " + ;
			" valesasist.VAL_codadmision, valesasist.VAL_codservvale, " + ;
			" valesasist.VAL_NroProtocolo, Val_CodPun, VAL_fechasolicitud, Pia_CodPrest, " + ;
			" Val_codValeAsist, Val_TipoPaciente, " + ;
			" Prestacions.PRE_descriprest,ENT_descrient, VAL_CodPun  "+;
			" from valesasist " + ;
			mjoin +;
			" left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist " + ;
			" left join Prestacions on Pre_CodPrest = presinsuvas.pia_codprest "+;
			" where VAL_fechasolicitud = ?ldFecha and " + ;
			" Pre_CodPrest not in ( 84020100, 84020101, 18010403, 34100402) " + ;
			mwhere + mcwhere  , "mwkInfo")

			If mret <= 0
				Messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
				Aerror(eros)
				Return .f.
			Endif			
		
	Else

		mret = sqlexec(mcon1, "select " + ;
			" valesasist.VAL_codadmision, valesasist.VAL_codservvale, " + ;
			" valesasist.VAL_NroProtocolo, Val_CodPun, VAL_fechasolicitud, Pia_CodPrest, " + ;
			" Val_codValeAsist, Val_TipoPaciente, " + ;
			" Prestacions.PRE_descriprest,ENT_descrient, VAL_CodPun  "+;
			" from valesasist " + ;
			mjoin +;
			" left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist " + ;
			" left join Prestacions on Pre_CodPrest = presinsuvas.pia_codprest "+;
			" where VAL_fechasolicitud = ?ldFecha and " + ;
			" Pre_CodPrest not in ( 84020100, 84020101, 18010403, 34100402) " + ;
			mwhere + mcwhere  , "mwkValAux")

			If mret <= 0
				Messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
				Aerror(eros)
				Return .f.
			Endif			
			
		Select mwkinfo
		Append From Dbf("mwkValAux")	
		
		Use In mwkValAux
		
	Endif
	ldFecha = ldFecha + 1  
Next 


*!*		mret = sqlexec(mcon1, "select " + ;
*!*			" valesasist.VAL_codadmision, valesasist.VAL_codservvale,Informes.CodMedFirma, " + ;
*!*			" valesasist.VAL_NroProtocolo, Val_CodPun, VAL_fechasolicitud,Pia_CodPrest , " + ;
*!*			" Val_codValeAsist, informes.Id, Val_TipoPaciente, nvl(Estadoinforme,0) as Estadoinforme " + ;
*!*			" ,Prestacions.PRE_descriprest,ENT_descrient "+;
*!*			" from valesasist " + ;
*!*			mjoin +;
*!*			" Left Join informes on Informes.CodPun = valesasist.VAL_CodPun " + ;
*!*			" left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist " + ;
*!*			" left join Prestacions on Pre_CodPrest = presinsuvas.pia_codprest "+;
*!*			" where VAL_fechasolicitud >= ?mfechaini and " + ;
*!*			" Pre_CodPrest not in ( 84020100, 84020101, 18010403, 34100402) and " + ;
*!*			" VAL_fechasolicitud <= ?mfecdes " + ;
*!*			mwhere + mcwhere  , "mwkinfo")



*!*	"TabValObs on TabValObs.TVO_CodPun = valesasist.Val_CodPun "

Select mwkinfo.*,iif(isnull(mwkInfoAUX.id),Val_CodPun,mwkInfoAUX.id) as idinfo, PRE_retiroestudios, ;
	Pre_CodPrest,space(10) as Demorado,mwkMedicosall1.nombre ;
	,prg_calcula_diahabil(VAL_fechasolicitud ,PRE_retiroestudios,"1,7") as fechaentrega, mwkInfoAUX.* ;
	from mwkinfo ;
	join mwkprestac on Pre_CodPrest = Pia_CodPrest ;
	Inner Join mwkInfoAUX On mwkInfo.VAL_CodPun = mwkInfoAUX.CodPun ;
	left join mwkMedicosall1 on mwkMedicosall1.id = mwkInfoAUX.CodMedFirma ;
	where (!inlist(nvl(mwkInfoAUX.Estadoinforme,0),1,2,5) or nvl(mwkInfoAUX.Id,0)=0) ;
	and VAL_NroProtocolo not in (select tpprotocolo from mwkanulados)  ;
	and VAL_NroProtocolo>0 and PRE_retiroestudios>0 and !inlist(Pre_CodPrest,84020100,84020101,18010403,34100402);
	into cursor mwkinfopre

Use In mwkinfoAUX

If used('mwkinfopre')
	If reccount('mwkinfopre')>0
		If mtipo && control tipo = 2
			Select * from mwkinfopre where fechaentrega = mfecdes into cursor mwkinfopre1
		Else
			Select * from mwkinfopre where fechaentrega <= mfecdes into cursor mwkinfopre1
		Endif
	Endif
Endif

Use in mwkinfo
Use in mwkanulados

If used("mwkFeriados")
	Use in mwkFeriados
Endif
