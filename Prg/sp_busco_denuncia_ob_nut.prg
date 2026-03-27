****
* Denuncia de Obito
*****
parameters mtipo,mbusco,lomitefin
mdtF    = sp_busco_fecha_serv('DT')
mdflimite = prg_dtoc(mdtF - 12*3600)
mfecnul = ctod("01/01/1900")
mbusco = " where  PO_FechaCierre= '1900-01-01' and PO_Estado<50 and PO_FechaIngreso>= ?mdflimite "+iif(!empty(mbusco)," and " +mbusco,'')
mret=SQLExec(mcon1,"SELECT	Tabpacobito.*,pacientes.* "+;
	"from Tabpacobito "+;
	" inner join pacientes on pacientes.pac_codadmision = Tabpacobito.PO_admision "+;
	" inner join pacinternad on pin_codadmision  = pacientes.pac_codadmision " +;
	mbusco+;
	" group by Tabpacobito.id order by PO_FechaIngreso ","mwkobito01")
if mret < 0
	=aerr(eros)
	messagebox("No se puede acceder a algunos Datos" + eros(3),0+64,"Usuario")
endif
mret=SQLExec(mcon1,"SELECT	TRR_AdmDest, TRR_AdmOrig "+;
	"from Tabrelreg inner join pacinternad on TRR_AdmDest = pin_codadmision "+;
	" inner join pacientes on pacientes.pac_codadmision = pin_codadmision  "+;
	" where PAC_sectorinternac = 'NUR' " +;
	" group by TRR_AdmOrig ","mwkintconj")
if mret < 0
	=aerr(eros)
	messagebox("No se puede acceder a algunos Datos" + eros(3),0+64,"Usuario")
endif
select mwkobito01.* from mwkobito01 ;
	where PO_admision  not in (select TRR_AdmOrig  from mwkintconj);
	into cursor mwkobito
