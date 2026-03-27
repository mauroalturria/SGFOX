*!*	 	Create Cursor Docu (Docu N(13))
*!*	 	Append From c:\desaguemes\Docu.txt Delimited With Tab
Use c:\desaguemes\docute.Dbf In 0 Exclusive
*Use c:\desaguemes\docu.Dbf In 0 Exclusive
Select docute
Zap
Pack
SET STEP ON
Append From Dbf('docu')

Dimension mTiposTel[20]
*SET STEP ON
mTiposTel[1] = "PART1   "
mTiposTel[2] = "PART2   "
mTiposTel[3] = "LABORAL "
mTiposTel[4] = "CELULAR "
mTiposTel[5] = "MENSAJE "
mTiposTel[6] = "NO TIENE"
mTiposTel[7] = "WHATSAPP"
mTiposTel[9] = "RESP.INT"
Select docute
Use registel Again In 0
Select registel
mfecpas = Ctod("01/01/1900")

Select docute

mtipotel1=0
mnro1=''
mobs1=''
mtipotel2=0
mnro2=''
mobs2=''
mtipotel3=0
mnro3=''
mobs3=''
mtipotel4=0
mnro4=''
mobs4=''
Scan
	mireg = nreg

	Wait Windows Transform(Recno()) Nowait
	Requery('REGISTEL')
	If Reccount('REGISTEL')>0
		ir = 1
		mimail = Nvl(registel.reg_email,"NO TIENE")
		mitel = registel.REG_telefonos
		mireg = registel.REG_nroregistrac
		Select registel
		Scan
			If Val(Nvl(registel.trt_numero,''))>0 And Val(Nvl(registel.trt_numero,''))#Val(mitel) And Nvl(registel.trt_pasiva,Date()) = mfecpas
				mctt ="mtipotel"+Transform(ir)
				mcnr ="mnro"+Transform(ir)
				mobs ="mobs"+Transform(ir)
				mit = registel.TRT_tipo
				mit = Iif(mit=0,1,mit)
				&mctt = mTiposTel(mit)
				&mcnr = registel.trt_numero
				&mobs = Nvl(registel.TRT_Observacion,'')
				ir=ir+1
				If ir>4
					Exit
				Endif
			Endif
		Endscan
		Select docute
		Replace reg_telef With NVL(mitel,''),email With NVL(mimail,''),nreg WITH mireg
		For uu= 1 To ir-1
			mctt ="mtipotel"+Transform(uu)
			mcnr ="mnro"+Transform(uu)
			mobs ="mobs"+Transform(uu)
			mdtt ="tipotel"+Transform(uu)
			mdnr ="nro"+Transform(uu)
			mdobs ="obs"+Transform(uu)

			Replace &mdtt With &mctt,&mdnr With &mcnr ,&mdobs With &mobs

		Next
	Endif

Endscan
Select docute
Copy To tele Type Xl5


*!*	SET FILTER TO EMPTY(reg_telef)
*!*	Scan
*!*		MIREG = PAC_CODHCI
*!*		WAIT windows TRANSFORM(RECNO()) nowait
*!*		Requery('regishc')
*!*		If Reccount('regishc')>0
*!*			ir = 1
*!*
*!*			mitel = regishc.REG_telefonos
*!*			Select docute
*!*			Replace reg_telef With mitel
*!*		Endif

*Endscan

Set Filter To
