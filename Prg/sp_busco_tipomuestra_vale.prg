LPARAMETERS nVale,mValeAsist,cOrigenPaciente

If cOrigenPaciente = "INT"


	mret = SQLExec(mcon1,"select a.EP_codprest as codprest, " +;
		"a.EP_cantidad as cantidad, " +;
		"a.EP_codmuestra, " +;
		"b.pre_codservicio, " +;
		"nvl(c.BAC_codigomuestra,'     ') as codmuestra " +;
		"from TabEstudiosSolic as a " +;
		"left join Prestacions as b on a.EP_codprest = b.pre_codprest " +;
		"left join tabbacteriotipomuestra as c on a.EP_codmuestra = c.id " +;
		"where EP_vale = ?nVale","mwkpiaplexus")

	If mret < 0
		Messagebox("Error al recuperar ITEMS del vale : " + Transform(nVale),16,"TABESTUDIOSSOLIC")
		Return .F.
	Endif

*   A veces no hay grabado items en TabEstudiosSolic. Son vales pedidos por Caché.
	Select mwkpiaplexus
	Go Top

	If Reccount() = 0

		mret = SQLExec(mcon1,"select a.pia_codinsumo as codprest,a.pia_cantsolicitada as cantidad,a.pia_codmuestrapx,nvl(c.BAC_codigomuestra,'     ') as codmuestra,b.pre_codservicio " +;
			"from Presinsuvas as a " +;
			"left join Prestacions as b on a.pia_codinsumo = b.pre_codprest " +;
			"left join tabbacteriotipomuestra as c on a.pia_codmuestrapx = c.id " +;
			"where a.pia_valesasist = ?mValeAsist","mwkpiaplexus")

		If mret < 0
			Messagebox("Error al recuperar ITEMS del vale : " + Transform(nVale),16,"PRESINSUVAS - INT")
			Return .F.
		Endif

	Endif

	Select mwkpiaplexus
	Go Top

	If Reccount() = 0
		Messagebox("No se encontraron los ITEMS para este vale. Avise a Sistemas.",16,"Items de Vale")
	Endif

Else
	mret = SQLExec(mcon1,"select a.pia_codinsumo as codprest,a.pia_cantsolicitada as cantidad,a.pia_codmuestrapx,nvl(c.BAC_codigomuestra,'     ') as codmuestra,b.pre_codservicio " +;
		"from Presinsuvas as a " +;
		"left join Prestacions as b on a.pia_codinsumo = b.pre_codprest " +;
		"left join tabbacteriotipomuestra as c on a.pia_codmuestrapx = c.id " +;
		"where a.pia_valesasist = ?mValeAsist","mwkpiaplexus")

	If mret < 0
		Messagebox("Error al recuperar ITEMS del vale : " + Transform(nVale),16,"PRESINSUVAS")
		Return .F.
	Endif
ENDIF

RETURN .t.
