 do sp_conexion
public mcon3, mc,ant,ef

ef ="Paciente en posiciòn de Lloyd Davies modificada. Antisepsia de piel. Colocaciòn de campos estériles. "+chr(10)+;
	"Incisión supraumbilical. Se coloca trócar de 12 mm. Neumoperitoneo a 12 mm Hg. Resto de trócares en fosa iliaca, "+chr(10)+;
	"hipocondrio derecho y fosa iliaca izquierda bajo visión directal. Se constata tumor retráctil, estenosante, duropétreo en sigmoides, resto de colon sin lesiones. "+chr(10)+;
	"Abordaje medial a lateral. Disecciòn de mesocolon hasta identificar pediculo  mesentérico inferior se coloca hem-o-lock proximal y distal, "+chr(10)+;
	"secciòn con bisturí armónico. Decolamiento parietocólico. Se coloca sutura lineal cortante de 60 mm etchelon flex 5 cm distal al tumor. "+chr(10)+;
	"Secciòn y extracción de pieza quirurgica por incisión de Pfannestiel. Se prepara  cabo distal, se realiza jareta con nylon 2/0, se coloca yunque. "+chr(10)+;
	"Reintroducción de colon a cavidad abdominal. Cierre de aponeurosis con vicryl 1. Neumoperitoneo  a 12 mm Hg. Se confeccióna colorrectoanastomosis "+chr(10)+;
	"terminoterminal con sutura circular nº 29 mm. Prueba neumática negativa. Control de hemostasia satisfactoria. Se coloca sonda de descompresión transrrectal tipo K227. "+chr(10)+;
	"Se retiran trócares bajo visión directa. Cierre de piel con nylon 2/0."
SET STEP ON

mret=sqlexec(mcon1," update  Tabquiroproto set TQP_DescCiru =?ef  "+;
	" where id =              84855")
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