 do sp_conexion
public mcon3, mc,ant,ef
ef ="Mot.Cons.:BLASTOMA ANEXIA L"+chr(10)+chr(10)+;
"Antec.:47 años"+chr(10)+;
"AG0 G1C1 CM 10/28 FUM 5/1 MAC Miranda"+chr(10)+;
"AP esquizofrenia risperidona"+chr(10)+;
"eco tv utero en avf OI imagen quistica tabicada de 81x68x59 mm  FSD libre"+chr(10)+;
"Evol.:Paciente que se le solicito marcadores que no realizo."+chr(10)+;
"ca 125 de junio 2017 59."+chr(10)

SET STEP ON

mret=sqlexec(mcon1," update  tabautprevia set apv_reshistclin =?ef  "+;
	" where id =     636880")
	***eg_evolhist = ?mevolh "+; &&EG_motConsulta = ?mc , 
*!*	mievol = "Debido al tiempo de evolucion e impresion quirurgica se decide con acuerdo del dr Selandari, jefe de servicio de pediatria "+;
*!*	" comenzar tto empirico con cefalexina 2 gr por dia por 10 dias + "+;
*!*	"ibuprofeno 400 mg cada 6 hs y crioterapia y citar para eco y control clinico el sabado por la mañana."
*!*	mret=sqlexec(mcon1," update  TabGuaEvolmed set EGM_evol = ?mievol"+;
*!*	" where id =  2173662")

do sp_desconexion

