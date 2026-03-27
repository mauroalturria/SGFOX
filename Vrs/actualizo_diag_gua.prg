*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
do sp_conexion
mret = sqlexec(mcon1, "select  ID , Codigo , Componente , Criterio , "+;
	"DescrAbrev , Descripcion , Excluye , Incluye "+;
	" from  TabCiap2E order by DescrAbrev ", "mwkCiap2e")
select admision
go top
scan
	nadmi = admision
	mret = sqlexec(mcon1,"select PAC_descripdiagegr, PAC_descripdiagn,PAC_fechaadmision, "+;
		"pac_codhci,pac_denuncia,pac_horaadmision  " + ;
		"FROM pacientes  "+ ;
		" where PAC_codadmision = ?nadmi " + ;
		"", "mwkbuspacie")

	if reccount( "mwkbuspacie")>0
		mtfing = ctot(dtoc(PAC_fechaadmision)+" "+left(ttoc(pac_horaadmision, 2), 5)) - 24 * 3600 * 2 &&(2 dias antes)
		mtfhoy = ctot(dtoc(PAC_fechaadmision)+" "+left(ttoc(pac_horaadmision, 2), 5)) 
		mbusca = " guardia.fechahoraing >= ?mtfing and guardia.fechahoraing <= ?mtfhoy and guardia.nroregistrac = "+alltrim(str(pac_codhci))
		do sp_busco_protocolo_paciente with mbusca,0,,'protocolo,codprest'
		if reccount( "mwkguardia")>0

			select mwkguardia
			go top
			select mwkCiap2e
			locate for id= mwkguardia.codcie9
			if found()
				mcod = mwkCiap2e.codigo 			
				mc  = mwkCiap2e.DescrAbrev
				select admision
				replace descripcio  with mc,codigo with mcod
			endif
		endif
	endif
	select admision
endscan
do sp_desconexion