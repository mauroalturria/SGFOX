*
* Buscar Medicos derivados, del paciente
*
lparameters mprotoc

if used('mwkmderiva')
	use in mwkderiva
endif

mret = sqlexec(mcon1,"select TGD_fechader,nombre,TGD_medDer "+;
	" from TabGuaDeriv left join prestadores on TabGuaDeriv.TGD_medDer=prestadores.id"+;
	" where TGD_protocolo=?mprotoc and TGD_estado=1","mwkmderiva")

if mret < 0
	messagebox("EN CONSULTA DE MEDICOS DERIVADOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
endif
