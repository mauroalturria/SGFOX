****
** estadisticas de reprogramacion
****
lparameters nuevafecha, mMotivo,lotrom
musua = midusu
mhoy  = sp_busco_fecha_serv('DT')
if vartype(lotrom)#"L"
	lotrom = .f.
endif
If VarType(mMotivo)#"N"
	mMotivo = 0
Endif 	

select mwktotrepro
go top
scan
	mfechaturant	= fechatur
	mncodmedant		= codmed
	mcantpac		= pacientes
	mcm = iif(mncodmed = codmed, 1, mncodmed)
	mpaccancel = iif(lotrom,0,mcantpac)
	
	
	mret = sqlexec(mcon1,'insert into turnosreprog (cantidadpac, codmed, codmedrepro, fecharep,'+;
		' fechaturant,fechaturnva, usuario, Motivo,paccancel) values ' +;
		' ( ?mcantpac, ?mncodmedant, ?mcm, ?mhoy, ?mfechaturant,?nuevafecha, ?midusu, ?mMotivo, ?mpaccancel )')
		
	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
		messagebox('ERROR EN LA ACTUALIZACION, AVISAR A SISTEMAS', 48,'Validacion')
		cancel
	endif
endscan
