public mcon1
do sp_conexion
mcpathact = allt(sys(5))+sys(2003)
cd "h:\datos\todos\datos\"


cantdbf = adir(misdbfs,"*.dbf")
create cursor allamar (hclin c(8),numdoc n(15),paciente c(50),telefono c(50),fechatur t,medico  c(50))
for uu=1 to cantdbf 
	use (misdbfs(uu,1)) in 0 shared
	select (misdbfs(uu,1))
	scan
		mid = id_turno
		mret = sqlexec(mcon1, 'select * from turnos where id  = ?mid  ' ,"control")
		select (misdbfs(uu,1))
		if control.afiliado # id_afiliad and control.tipoturno<9
			mafi=id_afiliad
			mmed = control.codmed
			mret = sqlexec(mcon1, 'select REG_nrohclinica, REG_numdocumento, ' + ;
			'REG_nombrepac,REG_telefonos ' + ;
			'from registracio where registracio = ?mafi ' ,"paciente")
			if reccount("paciente")=0
				mret = sqlexec(mcon1, 'select  0 as REG_nrohclinica, nrodocumento as REG_numdocumento, ' + ;
					'preregistra.nombre as REG_nombrepac,preregistra.telefono as  REG_telefonos ' + ;
					'from preregistracio where afiliado = ?mafi ' ,"paciente")
			endif
			mret = sqlexec(mcon1, 'select nombre from prestadores where id = ?mmed ','medi')
			pacienteREG_nrohclinica= paciente.REG_nrohclinica
			pacienteREG_numdocumento=paciente.REG_numdocumento
			pacienteREG_nombrepac=paciente.REG_nombrepac
			pacienteREG_telefonos=paciente.REG_telefonos
			controlhoratur=control.horatur
			medinombre = medi.nombre
			insert into allamar (hclin ,numdoc,paciente ,telefono,fechatur ,medico );
				values (pacienteREG_nrohclinica,pacienteREG_numdocumento,pacienteREG_nombrepac,;
					pacienteREG_telefonos, controlhoratur,medinombre)
		endif				
	endscan
	use in  (misdbfs(uu,1))
endfor

cd &mcpathact 
=sqldiscon(mcon1)

