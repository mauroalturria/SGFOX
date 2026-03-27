public mcon1
do sp_conexion
mcpathact = allt(sys(5))+sys(2003)
cd "h:\datos\todos\datos\"
*cd "C:\temp\"

cantdbf = adir(misdbfs,"*.dbf")
create cursor allamar (hclin c(8),numdoc n(15),paciente c(50),telefono c(50),fechatur t,medico  c(50))
for uu=1 to cantdbf 
	if  upper(misdbfs(uu,1)) # ".DBF"
		use (misdbfs(uu,1)) in 0 shared
		select (misdbfs(uu,1))
		cvar = alltrim(strtran(misdbfs(uu,1),".DBF",""))+ ".te"
		scan
			mid = id_turno
			mret = sqlexec(mcon1, 'select * from turnos where id  = ?mid  ' ,"control")
			select (misdbfs(uu,1))
			if control.horatur>datetime()
				if control.afiliado # id_afiliad and control.tipoturno<9 
					if type(cvar)="C"
						pacienteREG_telefonos	= &cvar
					else
						pacienteREG_telefonos	= ""
					endif

					mafi=id_afiliad
					mmed = control.codmed
					mret = sqlexec(mcon1, 'select REG_nrohclinica, REG_numdocumento, ' + ;
					'REG_nombrepac,REG_telefonos ' + ;
					'from registracio where registracio = ?mafi ' ,"paciente")
					if reccount("paciente")=0
						mret = sqlexec(mcon1, 'select  nrodocumento, nombre ,telefono ' + ;
							'from preregistracio where afiliado = ?mafi ' ,"paciente")
						if reccount("paciente")=0
							if type(cvar)#"C"
								pacienteREG_telefonos	= "Sin TE"
							endif
							pacienteREG_nrohclinica		= "Prereg"
							pacienteREG_numdocumento 	= 0
							pacienteREG_nombrepac		= "NN - Reservar turno"
		
						else
							if type(cvar)#"C"
								pacienteREG_telefonos	= paciente.telefono
							endif
							pacienteREG_nrohclinica		= "Prereg"
							pacienteREG_numdocumento	= paciente.nrodocumento
							pacienteREG_nombrepac		= paciente.nombre 
						endif
					else
						pacienteREG_nrohclinica		= paciente.REG_nrohclinica
						pacienteREG_numdocumento	= paciente.REG_numdocumento
						pacienteREG_nombrepac		= paciente.REG_nombrepac
						if type(cvar)#"C"
							pacienteREG_telefonos	= paciente.REG_telefonos
						endif
					endif
					mret = sqlexec(mcon1, 'select nombre from prestadores where id = ?mmed ','medi')
					controlhoratur	= control.horatur
					medinombre		= medi.nombre
					insert into allamar (hclin ,numdoc,paciente ,telefono,fechatur ,medico );
						values (pacienteREG_nrohclinica,pacienteREG_numdocumento,pacienteREG_nombrepac,;
							pacienteREG_telefonos, controlhoratur,medinombre)
				endif				
			else
				select (misdbfs(uu,1))
				delete
			endif				
		endscan
		use in  (misdbfs(uu,1))
	endif
endfor
cd &mcpathact 
=sqldiscon(mcon1)
select allamar 
copy to allamar type xls
browse
