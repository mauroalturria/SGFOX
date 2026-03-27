Parameters tnregistrac,tncodprest,tnart,tnhcactual,tningreso,tnproto,tnestada,tninter,;
	tnadmision,tnlabo,tnic,tnmate,tnimag,tnder,tnaccid,tncodigovax,tnfechoramov,tcobser

mret = SQLExec("Insert into tabauditguardia(tag_observaciones, tag_codprest,tag_nroregistrac , tag_CargaFechaHora, tag_art , tag_hca ,"+;
	" tag_ingreso , tag_estada ,tag_inter ,tag_accid ,tag_labo ,tag_ic ,tag_mate , tag_imag ,tag_der , tag_CodigoVax , tag_codadmision ,"+;
	" tag_protocolo) "+;
	" values(?tcobser,?tncodprest,?tnregistrac,?tnfechoramov,?tnart,?tnhcactual,?tningreso,?tnestada,?tninter,"+;
	" ?tnaccid,?tnlabo,?tnic,?tnmate,?tnimag,?tnder,?tncodigovax,?tnadmision,?tnproto)")

If mret < 1
*!*		=Aerror(eros)
*!*		Messagebox(eros(3))
	Do Log_errores With Error(), Message(), Message(1)
	Return .F.
Endif
