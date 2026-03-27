Parameters toForm, tcCodSec, tnCodHab, tnCodCam


Local lbResu  
lbResu = .f.
* Busco Cama según el sector
lcSQL = "Select * from habitacions where HAB_Sectores = ?tcCodSec AND HAB_Codpaciente = '0'"

If !Prg_EjecutoSql(lcSQL,'mwkHabitaRN')
	Return .F.
Endif

If Reccount("mwkHabitaRN") == 0
	Messagebox("NO HAY CAMAS LIBRES",48,"VALIDACION")
	Return .F.
Endif 

mcodusu	= Alltrim(Str(mwkusuario_sec.codigovax,6,0))
midusua = mwkusuario_sec.idusuario
mfecha  = sp_busco_fecha_serv('DT') && Fecha

*** Reservo la cama:

mgraba	= '1'
mcate = "C"
maccion = 'R'
mnroad  = ''

With toForm

	Select mwkHabitaRN
	Scan All
		
		If !prg_olevism_reset(.olevism)
			Exit 
		Endif 

		.olevism.mserver	= Allt(mwktabcfg.OLEServer)
		.olevism.namespace	= Allt(mwktabcfg.olespaces)

		mhabita = Alltrim(mwkHabitaRN.HAB_CODHABITACION) && '442'
		mcama	= Alltrim(mwkHabitaRN.HAB_codcama) && '11'

		Wait Window "Buscando Habitación: " + mhabita + " , Cama: " + mcama Nowait 

		.olevism.Code = "D ACTCAMA^RTN005(" + mgraba + ',"'+ tcCodSec + '","'+ ;
			mhabita +'","' + mcama + '","' + mcate + '","' + ;
			+ maccion + '","' + mnroad + '","' + mcodusu + '")'

		.olevism.execflag = 1

		mmsgerr = .olevism.errorname

		If !Empty(mmsgerr)
			Do sp_insert_tabCtrlErr With .olevism.Code, mmsgerr , midusua, .Name
			Messagebox ("ERROR EN LA GRABACION. AVISAR A SISTEMAS  U R G E N T E  !!!", 48, 'Validacion')
			Exit 
		Endif
		
		If Val(.olevism.P0) == 94 && Cama ocupada
			Select mwkHabitaRN
			Loop 
		Endif 
		
		If .olevism.P0 <> ''
			mcoderr = Round(Val(.olevism.P0), 0)
			Do sp_busco_texto_error With mcoderr
			Messagebox(Alltrim(mwktaberror.textoerror), 48, 'Validacion')
			Exit 
		Else
			lbResu = .t.
			tnCodHab = mhabita
			tnCodCam = mcama
			Exit && todo ok	
		Endif
	 
		Select mwkHabitaRN
	Endscan 	

	.olevism.mserver	= ""
	.olevism.namespace	= ""

Endwith

Return (lbResu)