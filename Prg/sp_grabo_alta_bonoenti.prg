******************************
* AUTOR: Claudia C. Antoniow
******************************
* Fecha :09/10/2003
********************
parameter v_usu, v_codent, v_fechaHora, v_idbono, v_fecdesde, v_fechasta

mret=sqlexec(mcon1,"INSERT INTO TabBonoEnti ( Usuario , codent , fechagraba "+;
	", fecvigend , fecvigenh , idbono) values (?v_usu, ?v_codent, "+;
	"?v_fechaHora, ?v_fecdesde, ?v_fechasta, ?v_idbono) ")
	
if mret < 0
	messagebox('ERROR AL ACTUALIZAR LOS DATOS, AVISAR A SITEMAS',16,'VALIDACION')
	mret = 0
	do prg_cancelo
endif
