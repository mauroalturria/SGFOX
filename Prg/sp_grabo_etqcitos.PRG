*
* Grabación etiqueta de medicamentos citostáticos
*
Parameters mlnropof,mpaciente,mdescri2,msolucio,mobsetq,mobserva,mmanejos,mfecelab,mfecvenc,;
	mlubicacion,mlvia

mfechamov = sp_busco_fecha_serv("DT")
midusua   = mwkusuario.idusuario

mret = sqlexec(mcon1,"insert into TabFarmEtqCitos "+;
	"(TEC_nropof,TEC_nombrepac,TEC_pactivo,TEC_solucion,TEC_obsetq,TEC_obsa,TEC_obsb,TEC_ubica,"+;
	"TEC_via,TEC_fecelab,TEC_fecvenc,TEC_fecpasiva,TEC_fecmov,TEC_idusuario)"+;
	" values "+;
	"(?mlnropof,?mpaciente,?mdescri2,?msolucio,?mobsetq,?mobserva,?mmanejos,?mlubicacion,?mlvia,"+;
	"?mfecelab,?mfecvenc,NULL,?mfechamov,?midusua)")

If mret < 0
	Messagebox("GRABACION DE ETIQUETA, MEDICAMENTOS CITOSTATICOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif
Return .T.
