parameters mfechora,miesp

mfecha = mfechora - 36000
if miesp = 'GINE' or miesp = 'OBST'
	mfil = " and pre_especialidad in ('GINE', 'OBST') "
else
	mfil = " and PRE_especialidad = ?miesp  "
endif
mret = SQLExec(mcon1, "select guardia.codent " + ;
	"from guardia, prestacions, registracio, entidades, afiliacion " + ;
	"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
	"guardia.nroregistrac = afiliacion.registracio and " + ;
	"guardia.codent = afiliacion.AFI_codentidad and " + ;
	"guardia.codprest = prestacions.PRE_codprest and " + ;
	"guardia.codent = entidades.ENT_codent and codestado < 3 and " + ;
	"guardia.codmed = 1 and PRE_codservicio = 8000 and " + ;
	"guardia.fechahoraing >= ?mfecha and guardia.fechahoraing < ?mfechora" +;
	" and guardia.codprest <> 42030723 "+ mfil , "mwkguavip")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
select * from mwkguavip where codent in (select codentexc from mwkentexg ) into cursor mwkctrlpacvip
use in mwkguavip
