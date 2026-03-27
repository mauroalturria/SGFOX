*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
do sp_conexion
select vales
scan
	nval = vale
	mret = sqlexec(mcon1,"select * from guardiavale  where nrovale = ?nval ","GV")
	nprot = protocolo
	mret = sqlexec(mcon1,"select * from guardia,guardiavale "+;
	"  where Guardia.protocolo = ?nprot and codserv = 8000 and Guardia.protocolo = Guardiavale.protocolo" ,"GUA")
	mcodmed = gua.codmed1
	mprest = gua.codprest
	select vales
	replace codmed with mcodmed,codprest with mprest,proto with nprot
endscan
do sp_desconexion