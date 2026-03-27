

mimpiva = ' Sin discriminar '

mvale = dat_fac(1)
.olevism.Code = "D DATVALE^SP001(" +  mvale + ")"
.olevism.execflag = 1
mmsgerr = .olevism.errorname
If !Empty(mmsgerr)
	Select mwkusuario
	Go Top
	midusua     = mwkusuario.idusuario
	Do sp_insert_tabCtrlErr With .olevism.Code, mmsgerr , midusua, .Name
Endif
mok		= .olevism.P0
mresp1	= .olevism.P1
mresp2	= .olevism.P2
nroitem = 0

If Empty(mok)
	Do prg_separo_datosvale With mresp1, mresp2, nroitem
	cletra = Strtran(Left(dat_vale(15),3),"()","")
	If Used('mwkZabIvaCondicion')
		Select mwkZabIvaCondicion
		Locate For ZIC_EquipvSAP = cletra
		If !Found()
			Go Top
		Endif
		miva = ZIC_Porcentaje
	Else
		Do Case
		Case cletra="E"
			miva = 0
			mimpiva = '0% $'
		Case cletra="G"
			miva = 10.5
			mimpiva = '10.5% $'
		Case cletra="J"
			miva = 21
			mimpiva = '21% $'
		Case cletra="K"
			miva = 27
			mimpiva = '27% $'
		Otherwise
			miva = 0
			mimpiva = '0% $'
		Endcase
	Endif
	mimpiva = mimpiva +Transform(Round(Val(dat_fac(9))/(1+miva/100),2))
Endif
