****
* Denuncia de Obito observaciones 
*****
Parameters mtipo,mbusco,lomitefin
If Vartype(lomitefin)#"N"
	lomitefin = 0
Endif
mjoin = ''
If lomitefin=1
	mjoin = " inner join pacinternad on pin_codadmision  = pacientes.pac_codadmision "
Endif

mdtF    = sp_busco_fecha_serv('DT')
mfecnul = Ctod("01/01/1900")
If mtipo = 1
	mbusco = " where  PO_Estado<50 "+iif(lomitefin=0,"", " and PO_FechaCierre = ?mfecnul ")+Iif(!Empty(mbusco)," and " +mbusco,'')
Else
	mbusco = Iif(!Empty(mbusco)," where " +mbusco,'') + " and PO_Estado<50 "
Endif
mret=SQLExec(mcon1,"SELECT	Tabpacobito.*,prestadores.nombre,prestadores.matriculas,"+;
	"TabMedExterno.nombre as nombreE,TabMedExterno.matricula as matriculasE,pacientes.* "+;
	" ,ent_codent,ent_descrient "+;
	"from Tabpacobito "+;
	" inner join pacientes on pacientes.pac_codadmision = Tabpacobito.PO_admision "+;
	mjoin+;
	" inner join coberturas on pacientes.pac_codadmision = coberturas.COB_pacientes "+;
	" inner join entidades on entidades.ent_codent = coberturas.COB_codentidad "+;
	" LEFT OUTER join prestadores on Tabpacobito.po_codmed = prestadores.id "+;
	" LEFT OUTER join TabMedExterno on Tabpacobito.po_codmed = TabMedExterno.id "+;
	mbusco+;
	" group by Tabpacobito.id order by PO_FechaIngreso ","mwkobito")
If mret < 0
	=Aerr(eros)
	Messagebox("No se puede acceder a algunos Datos" + eros(3),0+64,"Usuario")
Endif
	mjoin = " inner join pacinternad on pin_codadmision  = pacientes.pac_codadmision "
