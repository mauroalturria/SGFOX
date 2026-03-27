****
** Busco datos del protocolo quirurgico IQB
****
Parameter mopcion, mfecdes, mfechas, mbusco, mcursor

mwhere  = Iif(Vartype(mfecdes)="D"," PAC_fechaalta>= ?mfecdes and PAC_fechaalta<= ?mfechas ","")
mwhere  = mwhere + Iif(Vartype(mbusco)#"C", ' ',mbusco)
mcursor = Iif(Empty(mcursor),'mwkQuiroIQB',mcursor)
mwhereq = ''

If Vartype(mfecdes) = "D"
	mfecdesq = mfecdes - 2
	mwhereq  = " FechaQuirof >= ?mfecdesq and FechaQuirof <= ?mfechas"+;
		" and TabQuirofano.estado <> 31 "  &&and TipoPacte = 4
Endif

Do Case
Case mopcion = 1  &&&planilla
	mret = SQLExec(mcon1, " SELECT TabQuirofano.id,TabQuirofano.Estado , FechaQuirof ,"+;
		" Nroregistrac , PacNombre ,tabEstados.descrip,TabQuirofano.operacion "+;
		" FROM TabQuirofano " + ;
		" left join tabprotquir on tabprotquir.quirofano = tabquirofano.id "+;
		" left join tabEstados on tabEstados.id = TabQuirofano.estado "+;
		" where " + mwhereq , "mwkpquir00")

	If mret<1
		=Aerr(eros)
		Messagebox(eros(3))
	Endif

	mbusco1	= " and pac_fechaadmision >= ?mfecdesq and PAC_fechaalta between  ?mfecdesq and ?mfechas "

	mret = SQLExec(mcon1, "select " + ;
		"TabProtQuir.*, Pacientes.Pac_codhci,PAC_fechaadmision,PAC_fechaalta " + ;
		"from TabProtQuir ,pacientes " + ;
		"where pac_codadmision = Codadmision and PAC_tipopac = 1 "+;
		"and TipoPac = 1"+ mbusco1 , "mwkpacint01")

	Select * From mwkpquir00 Left Join mwkpacint01 ;
		on( mwkpacint01.Pac_codhci = Nroregistrac  ;
		and Between(fechaQuirof,PAC_fechaadmision,PAC_fechaalta));
		group By mwkpquir00.Id Into Cursor mwkpquir

	mret = SQLExec(mcon1, "select TQI_admision, TQI_fechahora, TQI_usuario,TQI_tipoPac,"+;
		"TQI_estadoGral, PAC_nombrepaciente, PAC_codhce, PAC_codadmision,TabquirofanoIQB.id,"+;
		"PAC_edad, PAC_sexo, PAC_telefresponsab, PAC_fechaadmision,  TQI_receptor,"+;
		"PAC_fechaalta, PAC_horaalta,  PAC_descripdiagn, PAC_observalta,REG_telefonos "+;
		" ,TabQuirofano.estado ,tabEstados.descrip,TabQuirofano.operacion "+;
		" from TabquirofanoIQB inner join Pacientes on TQI_admision = Pac_codadmision "+;
		" inner join REGISTRACIO on pac_codhci = registracio "+;
		" inner join TabProtQuir on TabProtQuir.codadmision  = TQI_admision  "+;
		" left join TabQuirofano on TabProtQuir.quirofano = TabQuirofano.id  "+;
		" left join tabEstados on tabEstados.id = TabQuirofano.estado "+;
		" where "+mwhere+" order by TQI_admision,TabquirofanoIQB.id ", 'mwkQuiroIQBant' )


*!*		select * from mwkQuiroIQBant ;
*!*				where TQI_admision NOT  in ( select Codadmision from mwkpquir );
*!*				into cursor &mcursor


*!*		Select mwkQuiroIQBant.* ;
*!*			From mwkQuiroIQBant   ;
*!*			Inner Join mwkpquir On TQI_admision <> Codadmision ;
*!*			into Cursor &mcursor


	Select mwkQuiroIQBant.*, Nvl(TQI_admision,Space(10)) As ladmi;
		From mwkQuiroIQBant;
		INTO Cursor mwkQuiroIQBant

	Select mwkpquir.*, Nvl(Codadmision,Space(10)) As ladmi;
		FROM mwkpquir;
		INTO Cursor mwkpquir

	Select mwkQuiroIQBant.* From mwkQuiroIQBant ;
		left Join mwkpquir;
		on  mwkpquir.ladmi <> mwkQuiroIQBant.ladmi ;
		into Cursor &mcursor


Case mopcion = 2 &&datos de Paciente
	If Vartype(mfecdes)="D"
		mf1 = prg_dtoc(mfecdes)
		mf2 = prg_dtoc(mfechas+1)
		mwherepq = " FechaHoraQuir >= ?mf1 and FechaHoraQuir< ?mf2 "
	Else
		mf1 = prg_dtoc(sp_busco_fecha_serv("DD"))
		mwherepq = " FechaHoraQuir >= ?mf1  "
	Endif

	mret = SQLExec(mcon1, " SELECT TabQuirofano.id,TabQuirofano.Estado , FechaQuirof ,"+;
		" Nroregistrac , PacNombre ,tabEstados.descrip,TabQuirofano.servicio,TabQuirofano.operacion,"+;
		" tabprotquir.descripdiagn,tabprotquir.codadmision "+;
		" FROM tabprotquir " + ;
		" left join TabQuirofano on tabprotquir.quirofano = tabquirofano.id "+;
		" left join tabEstados on tabEstados.id = TabQuirofano.estado "+;
		" where " + mwherepq , "mwkpquir")

	If mret<1
		=Aerr(eros)
		Messagebox(eros(3))
	Endif

	mret = SQLExec(mcon1, "select  TQI_fechahora, TQI_usuario, TQI_receptor, TQI_cumpleIA, "+;
		"TQI_entendioIA, TQI_fiebre, TQI_dolor, TQI_masdolor, TQI_sangrado, TQI_supura, "+;
		"TQI_nauseas, TQI_liquido, TQI_solido, TQI_miccion, TQI_evacuacion, TQI_inflamacion,"+;
		"TQI_estadoGral, TQI_preguntas,TQI_comentario, TQI_horaLiquidos, TQI_deambula, "+;
		"TQI_admision, TQI_dolorcabeza,  TQI_quirofano, TQI_tipoPac,PAC_nombrepaciente, "+;
		"PAC_codhce, PAC_codadmision,PAC_edad, PAC_sexo, PAC_telefresponsab, PAC_fechaadmision,  "+;
		"PAC_fechaalta, PAC_horaalta,  PAC_descripdiagn, PAC_observalta,REG_telefonos "+;
		" from TabquirofanoIQB inner join Pacientes on TQI_admision = Pac_codadmision "+;
		" inner join REGISTRACIO on pac_codhci = registracio "+;
		" where "+ mwhere +" order by TabquirofanoIQB.id desc","mwkQuiroIQBant" )

	Select * From mwkQuiroIQBant ;
		left Join mwkpquir;
		on  mwkpquir.Codadmision = mwkQuiroIQBant.PAC_codadmision  ;
		into Cursor &mcursor

Endcase

If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
