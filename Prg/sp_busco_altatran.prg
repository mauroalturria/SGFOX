****
** BUSCO datos del alta transitoria
****

parameter mcodadmision , mopcion,mfecdes,mfechas

mfecha2 = ctot('01/01/1900')

mwhere = ""

do case

case  mopcion = 1
	mwhere = " where Codadmision= ?mcodadmision and FhIngreso  = ?mfecha2 "

case  mopcion = 2 
	mwhere = " where Codadmision= ?mcodadmision "

case  mopcion = 3
	mwhere = " where FhIngreso = ?mfecha2 "

case  mopcion = 4 && todas desde hasta fecha
	mwhere = " where FhEgreso >= ?mfecdes and FhEgreso <= ?mfechas " 

endcase

mret = sqlexec(mcon1, 'SELECT ID,CodCIE9,Codadmision, PAC_nombrepaciente, ENT_descrient,ENT_nroprestadorexterno,'+;
		'Codmed,Codprest,Destino,Diagnostico,Estado,FhEgreso,FhIngreso,Observaciones,UsuarioSal '+;
		' , PAC_habitacion  , PAC_cama,prestacion ' + ;
		'FROM TabAltaTrans ' + ;
		' left join pacientes on TabAltaTrans.Codadmision = pacientes.PAC_codadmision ' + ;
		' left join entidades on TabAltaTrans.Codent = entidades.ENT_codent ' + ;
		mwhere  ,'mwkaltatran')

if mret < 0 
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	cancel
endif