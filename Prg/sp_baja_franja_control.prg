*******************************
* Controla que no haya bloqueos ni PE-ST-SO-RE-GI para la franja
*******************************
Parameters vr_mdvigenh, vr_usu, vr_mfgraba, vr_mfecturnod, vr_mfecturnoh, vr_codmed,;
	vr_diasem, vr_mthorad, vr_mthorah, vr_prestac, vr_id

hhmmD	= Val(Left(vr_mthorad,2) + Substr(vr_mthorad,4,2))
hhmmH	= Val(Left(vr_mthorah,2) + Substr(vr_mthorah,4,2))

mfecnul = Ctod("01/01/1900")

mret = SQLExec(mcon1,"SELECT * FROM tabbloqueoAmb "+;
	" where idfranja = ?vr_id and bloqAnulado = 0 ","MWkctrlbaja")

If Reccount("MWkctrlbaja") > 0
	Messagebox("VERIFIQUE BLOQUEOS VIGENTES ",64, "Baja de franjas")
Endif

If sp_busco_tabsobreto(vr_codmed, 1)

	Select * From mwkhoradoc1 Where diasem = vr_diasem And Left(Ttoc(horadesde,2),5) = Left(vr_mthorad,5) ;
		and Left(Ttoc(horahasta,2),5) = Left(vr_mthorah,5) And fvigend = vr_mfecturnod  ;
		and fvigenh <= vr_mfecturnoh Into Cursor MWkctrlbaja

	If Reccount("MWkctrlbaja")>0
		Messagebox("VERIFIQUE ST-SO VIGENTES ",64, "Baja de franjas")
	Endif

	Select * From mwkhoradoc3 Where diasem = vr_diasem And Left(Ttoc(horadesde,2),5) = Left(vr_mthorad,5) ;
		and Left(Ttoc(horahasta,2),5) = Left(vr_mthorah,5) And fecvigend = vr_mfecturnod  ;
		and fecvigenh <= vr_mfecturnoh Into Cursor MWkctrlbaja

	If Reccount("MWkctrlbaja")>0
		Messagebox("VERIFIQUE PE-PE VIGENTES ",64, "Baja de franjas")
	Endif

	Do sp_busco_reservas_gi_abm With vr_codmed, 1

	Select * From MwkResGI Where diasem = vr_diasem And Left(Ttoc(horadesde,2),5) = Left(vr_mthorad,5) ;
		and Left(Ttoc(horahasta,2),5) = Left(vr_mthorah,5) And fecvigend = vr_mfecturnod  ;
		and fecvigenh <= vr_mfecturnoh Into Cursor MWkctrlbaja

	If Reccount("MWkctrlbaja")>0
		Messagebox("VERIFIQUE RE-GI VIGENTES ",64, "Baja de franjas")
	Endif

Endif
