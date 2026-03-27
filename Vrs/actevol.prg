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
ef ="FCF 130 X MIN SIN CONT T.ART 120 / 60 SIN GENITORRAGIA NI AMNIORREA"
*mevolh = "11/10/2013 20:51:28 - MONAJE MAIRA GI -> SOLICITO EVALUACION POR CIRUGIA INFANTIL "+chr(10)+;
*!*		"11/10/2013 21:11:11 - MONAJE MAIRA GI -> ES EVALUADO POR CIRUGIA INFANTIL QUE POR ANTECEDENTES"+;
*!*		" (HERNIA OPERADA ) Y EL EXAMEN, QUE INCLUYO REFLEJO CREMASTERIANO POSITIVO, LE IMPRESIONA"+;
*!*		" DE CAUSA INFECCIOSA, SOLICITANDO SEDIMENTO URINARIO Y ECOGRAFIA TESTICULAR. "+chr(10)+;
*!*		"11/10/2013 21:17:52 - MONAJE MAIRA GI -> ."+chr(10)+;
*!*		"11/10/2013 22:52:47 - LABORDE BRENDA  -> .SEDIMENTO FRESCO  "+chr(10)+;
*!*		"MICROSCOPIA  "+chr(10)+;
*!*		"LEUCOCITOS  1  POR CAMPO      Hasta 5 x cpo."+chr(10)+;
*!*		"CELULAS  +         "+chr(10)+;
*!*		"Se recibe sedimento urinario normal."+chr(10)+;
*!*		"Se aguarda comunicacion con ecografista infantil."
mret=sqlexec(mcon1," update  TabGuaEvol set EG_exFisico =?ef "+; &&EG_motConsulta = ?mc , eg_evolhist = ?mevolh "+
" "+;
	" where EG_protocolo = '2027923-13'")
*!*	mievol = "Debido al tiempo de evolucion e impresion quirurgica se decide con acuerdo del dr Selandari, jefe de servicio de pediatria "+;
*!*	" comenzar tto empirico con cefalexina 2 gr por dia por 10 dias + "+;
*!*	"ibuprofeno 400 mg cada 6 hs y crioterapia y citar para eco y control clinico el sabado por la mañana."
*!*	mret=sqlexec(mcon1," update  TabGuaEvolmed set EGM_evol = ?mievol"+;
*!*	" where id =  2173662")

do sp_desconexion

