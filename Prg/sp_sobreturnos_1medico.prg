*****************************
* Genera Sobre Turnos
* AUTOR:Claudia Antoniow
*****************************
* FECHA:13/02/2002
*****************************
Parameters vr_thorad, vr_thorah
mndiasem  = Dow(mdmasX)
mncanttur = 1
mnporc    = 0

If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif

mret = SQLExec(mcon1,"SELECT codmed,diasem,horadesde,horahasta,porcentaje,cantidad "+;
	"FROM tabsobretoA " +;
	" WHERE &mccpoamb Diasem = ?mndiasem AND Cantidad >0 and tipoturno = 2" +;
	" AND Codmed = ?mncodmed and ?mdmasx between fvigend and fvigenh "+;
	" GROUP BY diasem,Horadesde,cantidad " +;
	" ORDER BY diasem,Horadesde,cantidad ","MWKSobre")


Sele MWKSobre
Go Top
Do While !Eof('MWKsobre')

	mncodmed  = MWKSobre.codmed
	mnporc    = MWKSobre.cantidad
	mtfechatur= mdmasX
	thora     = Ttoc(MWKSobre.Horadesde,2)
	thorad = MWKSobre.Horadesde
	thorah = MWKSobre.Horahasta
	Do Case
		Case vr_thorad = Ctot('00:00:00')
			thorad    = MWKSobre.Horadesde
			mnporc    = proporcional_horas(MWKSobre.cantidad,MWKSobre.Horadesde,MWKSobre.Horahasta,vr_thorad,'')
		Case vr_thorah = Ctot('00:00:00')
			mnporc    = proporcional_horas(MWKSobre.cantidad,MWKSobre.Horadesde,MWKSobre.Horahasta,'',vr_thorah)
			thorah = MWKSobre.Horahasta
		Otherwise
			mnporc    = proporcional_horas(MWKSobre.cantidad,MWKSobre.Horadesde,MWKSobre.Horahasta,vr_thorad,vr_thorah)
			thorad    = vr_thorad
			thorah = vr_thorah
	Endcase
	If (Ttoc(MWKSobre.Horahasta-1,2)< Ttoc(thorad ,2) Or Ttoc(MWKSobre.Horadesde,2)>Ttoc(thorah ,2))
		Skip 1 In MWKSobre
		If Eof('MWKSobre')
			Exit
		Else
			Loop
		Endif
	Endif



	If mnporc >0
		If !(Isnull(thorad) And Isnull(thorah))
			Do sp_valido_sobretur.prg
			Sele MWKExisteTurno
			Go Top
			If Eof('MWKExisteTurno') Or Bof('MWKExisteTurno')
				If mnporc = 0
					mnporc =MWKSobre.cantidad
				Endif
				Do sp_datos_sobretur.prg
				Sele MwkPorcSOfer
				Go Top
				If !Eof('MwkPorcSOfer') Or !Bof('MwkPorcSOfer')
					If MwkPorcSOfer.Cantur >0
						Do sp_cargo_sobretur With 2, mnporc, thorad, thorah
					Endif
				Endif
			Endif
		Endif
	Endif
	If Used('MWKExisteTurno')
		Sele MWKExisteTurno
		Use
	Endif
	If Used('MwkPorcSOfer')
		Sele MwkPorcSOfer
		Use
	Endif
	If Used('MWKHorasTr')
		Sele MWKHorasTr
		Use
	Endif

	Skip 1 In MWKSobre
Enddo



Function proporcional_horas
Parameter vr_cant,vr_Horad,vr_Horah,vr_ohorad,vr_ohorah
vr_prop_calc= .15
If Type('vr_ohorad')="T"
	If vr_ohorad = Ctot('00:00:00')
		vr_tot_minH = Hour(vr_Horah)*60 + Minute(vr_Horah)
		vr_tot_minD = Hour(vr_Horad)*60 + Minute(vr_Horad)
		vr_choras    = vr_tot_minH - vr_tot_minD
		If vr_choras > 0
			vr_prop = vr_cant /(vr_choras/60)

			If vr_prop > 0
				If Type('vr_ohorah')<>"T"
					vr_ohorah = vr_Horah
				Endif
				vr_tot_min1 = Hour(vr_ohorah)*60 + Minute(vr_ohorah)
				vr_choras1  = vr_tot_min1 - vr_tot_minD
				vr_prop_calc= (vr_choras1/60) * vr_prop
			Else
				vr_prop_calc = 0
			Endif
		Else
			vr_prop_calc = 0
		Endif
	Endif
Endif


If Type('vr_ohorah')="T"
	If vr_ohorah = Ctot('00:00:00')
		vr_tot_minH = Hour(vr_Horah)*60 + Minute(vr_Horah)
		vr_tot_minD = Hour(vr_Horad)*60 + Minute(vr_Horad)
		vr_choras   = vr_tot_minH - vr_tot_minD
		If vr_choras > 0
			vr_prop = vr_cant /(vr_choras/60)

			If vr_prop > 0
				If Type('vr_ohorad')<>"T"
					vr_ohorad = vr_Horad
				Endif
				vr_tot_min1  = Hour(vr_ohorad)*60 + Minute(vr_ohorad)
				vr_choras1   = vr_tot_minH  - vr_tot_min1
				vr_prop_calc = (vr_choras1/60) * vr_prop
			Else
				vr_prop_calc = 0
			Endif
		Else
			vr_prop_calc = 0
		Endif
	Endif
Endif

If	Round(vr_prop_calc,0)>= 0.5
	Return Round(vr_prop_calc,0)
Else
	If Round(vr_prop_calc,1)>= 0.1
		Return 1
	Else
		Return 0
	Endif
Endif
Endfunc
