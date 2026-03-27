lparameters mbussec
mfecnul = ctod("01/01/1900")
mfecdia = sp_busco_fecha_serv("DD") -1
mret = sqlexec(mcon1, "select EIS_fechaH ,EIS_tiposcore ,EIS_valor, PIN_codadmision from TabIntScorNur"+;
	" inner join TabintHCE on  tabintHCE.id = TabIntScorNur.EIS_idevol" + ;
	" inner join pacinternad on  tabintHCE.IH_admision = pacinternad.PIN_codadmision " + ;
	" inner join pacientes on pin_codadmision  = pac_codadmision " +;
	" where EIS_tiposcore = 1 and pac_sectorinternac = ?mbussec and EIS_fechaH >= ?mfecdia order by id "  , "mwkevolNurScor")

mvalor = "iif(mwkEscMorse1.EIS_valor >50 ,Rgb(255,210,210),"+;
	"iif(mwkEscMorse1.EIS_valor<24 ,Rgb(236,255,236),Rgb(255,255,157)) )"

mbusco = " and pac_sectorinternac = '"+allt(mbussec)+"' "
do sp_busco_tabintnut with 4,  mbusco +" order by IH_admision,INA_fechaHoraIni desc " ;
	,'mwkIntNutsusp'
select * from mwkIntNutsusp group by IH_admision into cursor mwkNutsusp
msql = "select pac_sectorinternac,alltrim(PAC_habitacion) + '-' + alltrim(PAC_cama) as cama "+;
	"  , PAC_nombrepaciente,PRE_descriprest,IN_observa,IIF(ISNULL(INA_fechaHoraIni),ctot('  /  /    '),INA_fechaHoraIni) as INA_fechaHoraIni " + ;
	" ,IN_fechaHoraIni,IIF(ISNULL(INA_fechaHoraIni),ctot('  /  /    '),INA_fechaHoraMod) "+;
	" from mwkIntNut left join mwkNutsusp on mwkIntNut .IH_admision = mwkNutsusp.IH_admision "+;
	" order by pac_sectorinternac,cama  into cursor mwkIntNutsec"

mret = sqlexec(mcon1, "select IFA_admision , IFA_codmed , IFA_fechaPA , PIN_codadmision from TabIntFPA "+;
	" inner join pacinternad on  TabIntFPA.IFA_admision = pacinternad.PIN_codadmision " + ;
	" inner join pacientes on pin_codadmision  = pac_codadmision " +;
	" where pac_sectorinternac = ?mbussec and IFA_pasivado  = ?mfecnul order by TabIntFPA.id "  , "mwkfpa")

