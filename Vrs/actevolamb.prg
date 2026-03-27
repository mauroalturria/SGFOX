 do sp_conexion
public mcon3, mc,ant,ef
*!*	mc = "Refiere que ayer cae el ascensor del sanatorio y que todos los que estaban adentro se accidentaron, "+;
*!*		chr(10)+"fue asistido el padre de la nena y refieren que a la nena no, la traen hoy a control porque"+;
*!*		" refieren que ayer nadie la evaluo. Niega perdida de conocimiento o algun sintoma. "+;
*!*		"la traen hoy porque ayer no se dieron cuenta y la mama estaba internada por problemas "+;
*!*		"hast hoy segun relato. El padre no recuerda nada de como estaba ayer su hija, la nena recuerda todo. "+;
*!*		"Ella relata todo, la interrogo y niega dolores, el papa me dice que ayer la nena le refirio "+;
*!*		"dolor de cabeza pero hoy no. Niega sintomas como vomitos, maros , cambio de caracter "+;
*!*		"o movimientos raros. Durmio bien, buen despertar, tolero los alimentos."
ef ="Signos Vitales"+chr(10)+"Estando el paciente descalzo y con ropas livianas , se determina :"+chr(10)+;
"Peso : 83 600 kg"+chr(10)+;
"Circunferencia de cintura :( en cm )"+chr(10)+;
"1. 106.5"+chr(10)+;
"2  106.5"+chr(10)+;
"3. 106.5"+chr(10)+;
""+chr(10)+;
"Luego de permanecer sentado por 5 minutos se realiza la determinación de :"+chr(10)+;
"TA 126/78 mm Hg"+chr(10)+;
"FC 68 por minuto"
SET STEP ON
mret=sqlexec(mcon1," update  TabAMBEvol set Ea_exFisico =?ef "+;
	" where EA_protocolo = '02897952-13'")
	***eg_evolhist = ?mevolh "+; &&EG_motConsulta = ?mc , 
*!*	mievol = "Debido al tiempo de evolucion e impresion quirurgica se decide con acuerdo del dr Selandari, jefe de servicio de pediatria "+;
*!*	" comenzar tto empirico con cefalexina 2 gr por dia por 10 dias + "+;
*!*	"ibuprofeno 400 mg cada 6 hs y crioterapia y citar para eco y control clinico el sabado por la mañana."
*!*	mret=sqlexec(mcon1," update  TabGuaEvolmed set EGM_evol = ?mievol"+;
*!*	" where id =  2173662")
SET STEP ON
do sp_desconexion

