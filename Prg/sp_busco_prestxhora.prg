parameters mfechad, mfechah, mbusco, mbusco2

*!*	mfechad = cTod("11/08/2009")
*!*	mfechah = mfechad
*!*	mbusco = ""

mfd = prg_dtoc(mfechad )
mfh = prg_dtoc(mfechah+1)
mfd1 = prg_dtoc(mfechad - 1)

mret = sqlexec(mcon1, "select fecpasiva,codent as codentexc,tpopac  from entidexclu "+;
	"where tpopac = 'GUA' union select fecpasiva,codent as codentexc,tpopac  from entidexclu "+;
	"where tpopac = 'INT' and codent not in ( select codent from entidexclu "+;
	"where tpopac = 'GUA')","mwkentex")

mret = sqlexec(mcon1, "select GuardiaVale.Protocolo, Guardia.fechahoraing, " + ;
	" Guardia.fechahoraate, Guardia.codestado, Guardia.id, Guardia.prioridad, " + ;
	" Guardia.CodEnt, Guardia.nroregistrac, GuardiaVale.codmed, GuardiaVale.CodServ, " + ;
	" Prestacions.Pre_CodPrest, Prestacions.Pre_descriprest, NroVale, " + ;
	" ValesAsist.val_horasolicitud, ValesAsist.val_fechasolicitud,presinsuvas.PIA_cantsolicitada " + ;
	" from presinsuvas " + ;
	" Inner Join ValesAsist on ValesAsist.valesasist = presinsuvas.pia_valesasist " + ;
	" Inner Join GuardiaVale on GuardiaVale.NroVale = ValesAsist.val_codvaleasist " + ;
	" Inner Join Guardia on Guardia.Protocolo = GuardiaVale.Protocolo " + ;
	" Inner Join Prestacions on Prestacions.Pre_CodPrest = presinsuvas.Pia_CodPrest " + ;
	" where Guardia.fechahoraing >= ?mfd and " + ;
	" Guardia.fechahoraing < ?mfh " + mbusco, "mwkguardia1a")

if mret<1
	=aerr(eros)
	messagebox(eros(3))
	canc
endif

If !Empty(mbusco2) 
	lRunSql = "Select * From mwkguardia1a " + mbusco2 + " group by nrovale into cursor mwkguardia1 "
	&lRunSql
else
	Select * From mwkguardia1a group by nrovale into cursor mwkguardia1 
Endif 

select val_fechasolicitud as fecha ,Left(val_horasolicitud,2) as hora ,;
	sum(PIA_cantsolicitada) as cantidad, pre_descriprest, Pre_CodPrest as codprest;
	from mwkguardia1;
	group by Pre_CodPrest, fecha, hora;
	order by pre_descriprest, fecha, hora ;
	into cursor mwkguardia

if used("mwkguardia1") 
	use in mwkguardia1 
endif
if used("mwkguardia01") 
	use in mwkguardia01 
endif