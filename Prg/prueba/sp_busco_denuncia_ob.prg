****
* Denuncia de Obito
*****
parameters mtipo,mbusco

mdtF    = sp_busco_fecha_serv('DT')
mfecnul = ctod("01/01/1900")
if mtipo = 1
	mbusco = " where  PO_FechaCierre = ?mfecnul "+iif(!empty(mbusco)," and " +mbusco,'')
else
	mbusco = iif(!empty(mbusco)," where " +mbusco,'')
endif
mret=sqlexec(mcon1,"SELECT	Tabpacobito.*,prestadores.nombre,prestadores.matriculas,"+;
	"TabMedExterno.nombre as nombreE,TabMedExterno.matricula as matriculasE,pacientes.* "+;
	" ,ent_codent,ent_descrient,PAC_sectorinternac,PAC_habitacion, PAC_cama "+;
	"from Tabpacobito "+;
	" inner join pacientes on pacientes.pac_codadmision = Tabpacobito.PO_admision "+;
	" inner join coberturas on pacientes.pac_codadmision = coberturas.COB_pacientes "+;
	" inner join entidades on entidades.ent_codent = coberturas.COB_codentidad "+;
	" LEFT OUTER join prestadores on Tabpacobito.po_codmed = prestadores.id "+;
	" LEFT OUTER join TabMedExterno on Tabpacobito.po_codmed = TabMedExterno.id "+;
	mbusco+;
	" group by Tabpacobito.id order by PO_FechaIngreso ","mwkobito")
if mret < 0
	=aerr(eros)
	messagebox("No se puede acceder a algunos Datos" + eros(3),0+64,"Usuario")
endif
