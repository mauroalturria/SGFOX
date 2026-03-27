mcon1 = SQLConnect("conec01")
public mcon3, mc,ant,ef
TEXT To ef Textmerge Noshow Pretext 7
ANESTESIA GENERAL. RASURADO PARCIAL CON MAQUINA ELECTRICA. DECUBITO DORSAL, CABECERA LATERALIZADA A IZQUIERDA, MAYFIELD.
ASEPSIA Y ANTISEPSIA. COLOCACION DE CAMPOS ESTERILES SEGUN TECNICA. INSICION FRONTOTEMPORAL DERECHA. DISECCION SUBFALCIAL. CRANEOTOMIA PTERIONAL DERECHA. BAJO MAGNIFICACION CON MICROSCOPIO SE REALIZA APERTURA DURAL. SE EVIDENCIA CEREBRO TENSO CON HSA. DISECCION SUBFRONTAL Y LIBERACION DE LCR DE CISTERNAS BASALES. SE IDENTIFICA NERVIO OLFATORIO DERECHO Y NERVIO OPTICO DERECHO. ARTERIA CAROTIDA DERECHA, ESPACIO OPTICO-CAROTIDEO E INTEROPTICO. APERTURA DE PORCION MEDIAL DE CISTERNA SILVIANA. SE IDENTIFICA M1 Y A1 DERECHA, HEUBNER. SE RESECA GIRUS RECTUS. SE IDENTIFICA OPTICO IZQUIERDO Y A1 IZQUIERDA. VISUALIZACION DE ACIGOS. SE IDENTIFICA ANEURISMA A1, AXILA DISTAL Y PROXIMAL CON ARTERIA DE MENOR DIAMETRO SALIENDO PREVIO A LA AXILA PROXIMAL. SE REALIZA CLIPADO DEFINITIVO CON CLIP RECTO DE 5 MM, RESPETANDO ACIGOS DISTAL Y EVIDENCIANDO COLAPSO DE ANEURISMA. LAVADO Y HEMOSTASIA PROLIJA. CIERRE DURAL HERMETICO CON PLASTICA DE DURAMADRE. SE RECOLOCA PLAQUETA OSEA Y SE RELLENA AGUJEROS DE TREPANO CON CEMENTO OSEO. CIERRE POR PLANOS. PIEL CON NYLON. VENDAJE.
NOTA ACLARIATORIA: SE ABRE CLIP RECTO TRASNITORIO DE 7MM PARA PROBARSE EN CAROTIDA EN CASO DE RESANGRADO DE SACO ANEURISMATICO Y NO SE UTILIZA. 
SE PRUEBA CLIP SEMICURVO DE 5MM PARA CLIPADO DE ANEURISMA PERO POR FORMA DE CLIP, NO SE PUEDE REALIZAR CLIPADO POR LO QUE NO SE PUEDE DEJAR CLIPADO. 
ENDTEXT
mret=sqlexec(mcon1," update  Tabquiroproto set tqp_descciru =?ef  "+;
	" where id =  121354")
SET STEP ON
*ef= CHR(13)+"22/05/2019 12:20 GONZALEZ LUIS MARIA M.N.:68508 "+CHR(13)+"Aclaración: el paciente llegó a nuestra Institución derivado desde el Hospital de Bahía Blanca "
*!*	mret=sqlexec(mcon1," update  tabinthce  set ih_resumen = ?ef where id =     131073")

*!*	mret=sqlexec(mcon1," update  Tabautprevias set apv_observaciones =?ef  "+;
*!*		" where id =      822968")
*!*	mret=sqlexec(mcon1," update  TabAmbEvolMed set EAM_evol =?ef  "+;
*!*		" where id =      4829978")

*!*	mret=sqlexec(mcon1," update  tabintanam set ia_impdiag=?ef  "+;
*!*		" where id =                104357")
	***eg_evolhist = ?mevolh "+; &&EG_motConsulta = ?mc , 
*!*	mievol = "Debido al tiempo de evolucion e impresion quirurgica se decide con acuerdo del dr Selandari, jefe de servicio de pediatria "+;
*!*	" comenzar tto empirico con cefalexina 2 gr por dia por 10 dias + "+;
*!*	"ibuprofeno 400 mg cada 6 hs y crioterapia y citar para eco y control clinico el sabado por la mañana."
*!*	mret=sqlexec(mcon1," update  TabGuaEvolmed set EGM_evol = ?mievol"+;
*!*	" where id =  2173662")

do sp_desconexion
set step on


*!*	mret=sqlexec(mcon1," select ih_resumen  from tabinthce  where id =     84631","cambio")
*!*	mires = cambio.ih_resumen
*!*	mret=sqlexec(mcon1," update  tabinthce  set ih_resumen = ?mires where id =     84638 ")

*!*	do sp_desconexion
*!*	set step on


*!*	mret=sqlexec(mcon1," select ie_patologia from Tabintepi where id =  851438","cambio")
*!*	mires = cambio.ie_patologia
*!*	mret=sqlexec(mcon1," update  tabinthce  set ih_resumen = ?mires where id =        79913")

*!*	do sp_desconexion
*!*	set step on