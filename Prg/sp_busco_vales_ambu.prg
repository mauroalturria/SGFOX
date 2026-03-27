*
* Busqueda de Pacientes Ambulatorios
*
Lparameters mdesde, mhasta, midmedico, mcCursor

If Vartype(midmedico) # "N"
	midmedico = 0
Endif
If midmedico=0
	Return
Endif

msel_med = " codmed = ?midmedico and "

mbusAmb = " and codmed = "+Transf(midmedico)

If Vartype(mcCursor)# "C"
	mcCursor = "mwkambu"
Endif
mret = SQLExec(mcon1,"select TabAmbulatorio.id,fechaate as fechatur,  fechahoraing as horatur "+;
", Pre_Especialidad as codesp,TabAmbulatorio.codprest,afi_fechabaja, afi_nroafiliado,reg_telefonos,TabAmbulatorio.protocolo as codreserva"+;
",registracio.reg_nrohclinica, registracio.REG_numdocumento,registracio.Reg_email"+;
',registracio.REG_bloq_comen, registracio.reg_nombrepac,reg_fecnacimiento as fechanac  ' + ;
", pre_codservicio  as codserv,fechahoraate as fechatomado,TabAmbulatorio.usuario,TabAmbulatorio.usuario as usuariogenera"+;
" ,Tabambulatorio.codent,Tabambulatorio.codmed,Tabambulatorio.codmed as codmedsoli"+;
",Tabambulatorio.nroregistrac as afiliado,Tabambulatorio.nrovale ,REG_nombrepac as paciente   "+ ;
",TabAmbulatorio.codmed,TabAmbulatorio.codent,TabAmbulatorio.codestado "+ ;
",Pre_CodServicio, TabAmbulatorio.codprest "+ ;
" from TabAmbulatorio"+;
" inner join REgistracio on REG_nroregistrac = TabAmbulatorio.nroregistrac  "+;
" inner join afiliacion ON (Afiliacion.AFI_codentidad =Tabambulatorio.codent "+;
  "  AND  Afiliacion.REGISTRACIO =  TabAmbulatorio.nroregistrac )"+; 
" inner join Prestacions on pre_codprest = TabAmbulatorio.codprest "+ ;
" where fechaate >= ?mdesde and fechaate <= ?mhasta and TabAmbulatorio.demanda = 1"+ ;
" and TabAmbulatorio.codmed=?midmedico " + ;
" group by Tabambulatorio.id","mwkdemanda")
If mret < 0
	Messagebox("EN BUSQUEDA DE AMBULATORIOS DEMANDA" + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

