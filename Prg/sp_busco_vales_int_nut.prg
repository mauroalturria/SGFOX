****
** busco consumo por paciente
****

parameters madmision
mret =sqlexec(mcon1, "select VAL_fechasolicitud,VAL_codvaleasist" + ;
	", pia_cantsolicitada, pia_codprest " + ;
	" from valesasist " + ;
	" inner join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist "+;
	" inner join Prestacions on  Presinsuvas.PIA_codprest = Prestacions.PRE_codprest "+;
	" where  VAL_codadmision = ?madmision and "+;
	" VAL_estado = 2 and Prestacions.PRE_especialidad = 'DIET' " + ;
	" and VAL_codservvale = 9400 ", "mwkvalnut")