*
* Busqueda de solicitudes de interconsulta
*
Lparameters mdesde, mhasta,mbusco

*Lparameters mlidinter
if vartype(mbusco)#"C"
	mbusco = ''
endif
if mhasta< sp_busco_fecha_serv("DD")
	mfecha = " TGI_fechasol >= ?mdesde and TGI_fechasol <= ?mhasta "
else
	mfecha = " TGI_fechasol >= ?mdesde "
endif	
Use in select("mwkinterdat")

mret = sqlexec(mcon1,"SELECT id, nombre,codesp  FROM prestadores  " + ;
	"where dguardia = 1 " +;
	" union  select id , nombre,'    ' as codesp  from tabmedexterno " + ;
	" where gerenciadora = 0 "  +;
	"order by nombre", "mwkMedicoguall" )

mret = sqlexec(mcon1,"select TGI_fechasol,TGI_horasol,TGI_codmed,TGI_codprest,"+;
	"TGI_estado,TGI_fechasol,TGI_horasol,"+;
	"TGI_protocolo,TGI_ubicacion,REG_nombrepac,"+;
	"AFI_nroafiliado,REG_nrohclinica,ENT_descrient,"+;
	"tipoest, "+;
	"prestacions.PRE_descriprest,"+;
	"servicios.ser_descripserv,TabGuaIC.id as lid,"+;
	"tabestados.descrip as lestado"+;
	" from TabGuaIC"+;
	" join guardia on guardia.protocolo = TabGuaIC.TGI_protocolo"+;
	" join tabtipoaltas on guardia.codestado = tabtipoaltas.id "+;
	" join prestacions on prestacions.PRE_codprest = TGI_codprest"+;
	" join registracio on REG_nroregistrac = guardia.nroregistrac"+;
	" join afiliacion on afiliacion.registracio = guardia.nroregistrac"+;
	" and afiliacion.AFI_codentidad = guardia.codent"+;
	" join entidades on entidades.ENT_codent = guardia.codent"+;
	" join servicios on ser_codserv = prestacions.PRE_codservicio"+;
	" join tabestados  on propietario = 2 and tipo = 6 and tabestados.estado = TGI_estado"+;
 	" where "+ mfecha  + mbusco,"mwkinterdat0")
	
*	" where TabGuaIC.id = ?mlidinter","mwkinterdat")

If mret < 0
	Messagebox("EN LA CONSULTA DE SOLICITUDES DE INTERCONSULTA"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

select mwkinterdat0.*,mwkMedicoguall.nombre as lnombre;
	from mwkinterdat0,mwkMedicoguall;
	where mwkMedicoguall.id = TGI_codmed;
	into cursor mwkinterdat
Return .T.











