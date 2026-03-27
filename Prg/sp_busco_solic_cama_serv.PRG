****
* Solicitud de Cambio de Cama
*****
Parameters  mxadmis,mxhclin
* MOPCION 1-ALTA-2 MODIFICACION
*morigen 1- guardia 2-pisos

*mdtF    = sp_busco_fecha_serv('DT')
mfecnul = Ctod("01/01/1900")

TEXT To lcsql Textmerge Noshow Pretext 7
		SELECT SC_Admision ,SC_CodMed , SC_Codcie10 , SC_Estado , SC_fechaSol , SC_Observa , SC_Protocolo ,
		 SC_SecAgrup ,SC_SecOrigen , SC_Servicio,tabcie10.descrip,nomape from ZabIntSolCama inner join pacientes  on SC_Admision = pac_codadmision
		inner join tabcie10 on SC_Codcie10=tabcie10.id
		inner join tabusuario on SC_CodMed =idcodmed
		where (pac_codhce = ?mxhclin or SC_Admision = ?mxadmis)
		and SC_estado = 1
ENDTEXT
If !Prg_EjecutoSql(lcSql,"mwkservsec")
	Messagebox("ERROR AL buscar los datos de solicitud de cama",16,"ERROR")
	Return .F.
Endif


