*!*
*!*	busco ValesAsist
*!*	---------------------------------------------------------------------------------------
Parameter mOpcion, mCodValeAsist

Do Case
Case mOpcion = 1 && Un Vale
	mret = SQLExec(mcon1, "Select ValesAsist .*,pac_codambito from ValesAsist "+;
		" inner join pacientes on Pacientes.PAC_codadmision = Valesasist.VAL_codadmision "+;
		" Where Val_CodValeAsist = ?mCodValeAsist", "mwkValeAsist")
Case Inlist(mOpcion, 2,3) && prestaciones de Un Vale
	mret = SQLExec(mcon1, "Select pre_descriprest,CAST(0 as integer) as sel,val_horasolicitud ,VAL_FHSolicitud "+;
		" from presinsuvas,valesasist "+;
		" inner join Prestacions on Prestacions.Pre_CodPrest = presinsuvas.PIA_codprest "+;
		" Where val_codservvale <> 5410 and  Presinsuvas.PIA_VALESASIST = Valesasist.VALESASIST and "+;
		" val_CodValeAsist = ?mCodValeAsist ", "mwkValeprest")
	If mOpcion=2
		Return (mwkValeprest.pre_descriprest)
	Else
		Return (Ttoc(mwkValeprest.VAL_FHSolicitud))
	Endif
Case Inlist(mOpcion, 4) && prestaciones de Un Vale
	mret = SQLExec(mcon1, "Select presinsuvas.PIA_codprest "+;
		" from presinsuvas,valesasist "+;
		" Where  Presinsuvas.PIA_VALESASIST = Valesasist.VALESASIST and "+;
		" val_CodValeAsist = ?mCodValeAsist ", "mwkValeprest")

	Return ( mwkValeprest.PIA_codprest )

Endcase

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
Endif
