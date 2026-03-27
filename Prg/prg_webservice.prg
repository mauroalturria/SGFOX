lparameters mbusco,lcontrol
with thisform

*!*			msql_reg = "select REG_nombrepac, " + ;
*!*				"REG_numdocumento, AFI_fechabaja, " + ;
*!*				"AFI_nroafiliado,
	.olevism.mserver 	= allt(mwktabcfg.oleserver)
	.olevism.namespace 	= allt(mwktabcfg.olespaces)
	if mbusco = 3
		mdoc =  iif(lcontrol,alltrim(transf(mwkbuspacie1.REG_numdocumento));
			,alltrim(transf(thisform.txtnrodoc.value)))
		mafi = ' '
	else
		mdoc =  '-1'
		mafi = padl(strtran(alltrim(mwkafient1.AFI_nroafiliado)," -/",""),12,"0")
		mafi = left(mafi,7) + "-" + substr(mafi,8)
	endif
	.olevism.code = 'D CONSULTA^RTNPAD('+mdoc+',"'+ mafi + '")'
	.olevism.execflag = 1
	mresp = .olevism.P0					&& Codigo de error
	mnroitem  = 1
	store '' to dat_ws
	do while len(mresp) > 4
		mnroitem  = mnroitem + 1
		mcontad  = atc("|", mresp)
		if mcontad>0
			dat_ws( mnroitem )= alltrim(left( mresp, mcontad - 1  ))
			mresp = substr( mresp, mcontad + 1 )
		else
			dat_ws( mnroitem )= alltrim(mresp)
			mresp= ''
		endif
	enddo

	create cursor mwkdatpadron (NroAfiliado n(20), ApeyNom c(50), ;
		abrevio c(20),Documento n(20), FecIngreso d(8), FecEgreso d(8), ;
		CUIL n(17,2), ent_descrient c(50), FecNac d(8), Codigo n(4), ;
		Domicilio c (50),Localidad c (50), Provincia c(50),Telefono c(50),;
		sexo c(1),plan c(50),tipodocumento n(1),entidad n(4))
	if mnroitem  > 20
		if used('mwkafient1')
			do sp_grabo_WS with mbusco,iif(lcontrol,mwkafient1.AFI_nroafiliado,0);
				, mwkbuspacie1.REG_nombrepac, iif(lcontrol,mwkafient1.AFI_fechabaja,ctod("01/01/1900"));
				,mwkbuspacie1.REG_numdocumento,nvl(mwkbuspacie1.REG_distrito,'0')
		else
			do sp_grabo_WS with mbusco,0, thisform.txtnombre.value , ctod("01/01/1900");
				,thisform.txtnrodoc.value,'0'
		endif
		if !empty(dat_ws(4))
			select mwkdocent
			mtipodoc = alltrim(dat_ws(3))
			mtipoent = 100
			locate for TDE_DescripEnt = mtipodoc and TDE_CodEnt = mtipoent
			ntipodoc = iif(found(),TDE_codigodoc,9)
			mtipodoc = iif(found(),abrevio,"OTRO")
			mapeynom = strtran(dat_ws(5),", ",",")
			mfechapas = iif(dat_ws(19)="B" or dat_ws(20)="B" ,date()-1,ctod("01/01/2100"))
			insert into mwkdatpadron values (val(strtran(dat_ws(6),"-","")), mapeynom, ;
				mtipodoc, val(dat_ws(4)), prg_ctod(dat_ws(9),"D"), mfechapas , ;
				val(strtran(dat_ws[2],"-","")), 'HOMINIS ONLINE', prg_ctod(dat_ws(8),"D"),val(dat_ws(14)),;
				dat_ws(11),dat_ws(12),iif(val(dat_ws(14))<1599,dat_ws(12),"BUENOS AIRES"),;
				dat_ws(13),dat_ws(10),dat_ws(7),ntipodoc,100 )
		else
*		messagebox("",48,"No registra afiliacion")
			select mwkdocent
			mtipodoc = 'Doc. Nac. Ident'
			mtipoent = 100
			locate for TDE_DescripEnt = mtipodoc and TDE_CodEnt = mtipoent
			ntipodoc = iif(found(),TDE_codigodoc,9)
			mtipodoc = iif(found(),abrevio,"OTRO")
			mapeynom = ""
			mfechapas = date()-1
			insert into mwkdatpadron values (0, mapeynom, mtipodoc, 0, mfechapas, mfechapas;
				,0, 'HOMINIS ONLINE',  mfechapas ,0, '','',"BUENOS AIRES",'','','',ntipodoc,100 )
			messagebox("ESTE PACIENTE NO REGISTRA AILIACION EN HOMINIS ONLINE",48,"Validacion Hominis")
		endif
	else
		messagebox("NO HAY COMUNICACION CON PADRON HOMINIS ON LINE. REINTENTE LUEGO",48,"Error de Conexion")
		select mwkdocent
		mtipodoc = 'Doc. Nac. Ident'
		mtipoent = 100
		locate for TDE_DescripEnt = mtipodoc and TDE_CodEnt = mtipoent
		ntipodoc = iif(found(),TDE_codigodoc,9)
		mtipodoc = iif(found(),abrevio,"OTRO")
		mapeynom = ""
		mfechapas = date()-1
		if used('mwkafient1')
			do sp_grabo_WS with mbusco,iif(lcontrol,mwkafient1.AFI_nroafiliado,0);
				, mwkbuspacie1.REG_nombrepac, ;
				iif(lcontrol,nvl(mwkafient1.AFI_fechabaja,ctod("01/01/1900")),;
							ctod("01/01/1900"));
				,mwkbuspacie1.REG_numdocumento,nvl(mwkbuspacie1.REG_distrito,'0')
		else
			do sp_grabo_WS with mbusco,0, thisform.txtnombre.value , ctod("01/01/1900");
				,thisform.txtnrodoc.value,'0'
		endif
		insert into mwkdatpadron values (0, mapeynom, mtipodoc, 0, mfechapas, mfechapas;
			,0, 'HOMINIS ONLINE',  mfechapas ,0, '','',"BUENOS AIRES",'','','',ntipodoc,100 )
	endif
	.olevism.mserver = ""
endwith
dimension dat_ws(20)
