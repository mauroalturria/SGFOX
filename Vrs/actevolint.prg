 do sp_conexion
public mcon3, mc,ant,ef
ef ="Evolución:"+chr(10)+"CLINICA MEDICA "+chr(10)+;
"Paciente masculino de 85 años de edad con antecedente de Linfoma de Hodking en mediatisno superior hace 11 años"+;
" que requirio tratamiento con QMT + RDT, que intercurre con sindrome de vena cava superior con edema en esclavina"+;
" que requirió stent, poliartritis en tratamiento con corticoide, intercurriendo luego con herpes zoster en miembro"+;
" superior izquierdo secuelado con neurlagia, antecedetente quirurgico de  amigamadelectomia en la niñez, cursa"+;
" internacion por caida desde su propia altura con fractura de oleacraneón y fractura lateral de cadera izquierda."+chr(10)+;
"Al examen fisico, vigil, hemodinamicamente estable. normotenso "+chr(10)+;
"Regular entrada bilateral de aire, murmullo vesicular conservado, sin ruidos agregados,"+chr(10)+;
"Abdomen blando, depresible, no doloroso RHA +."+chr(10)+;
"Labatorio dentro de los paramentros normales."+chr(10)+;
"Paciente en condiciones clinicas para somterse a proceso quirurgico."
efhtml ="<div id = "+'"div5_458090"  class = "comuncss evolucion"  '+"data-estado='1' "+'onclick="_viewdat'+"('div5_458090','mdiv5_458090')"+' " >"'+chr(10)+;
'<i class = "fa fa-user-md" >'+chr(10)+;
'<h1 class = "clsh1" >&nbsp;Evolución </h1>'+chr(10)+chr(10)+;
'"</i>'+chr(10)+;
'<br>'+chr(10)+;
'<div id = "mdiv5_458090"  class = "ocultadiv" >'+chr(10)+;
'CLINICA MEDICA '+chr(10)+;
'<br>Paciente masculino de 85 años de edad con antecedente de Linfoma de Hodking en mediatisno superior hace 11 años que requirio tratamiento con QMT + RDT, que intercurre con sindrome de vena cava superior con edema en esclavina que requirió stent, poliartritis en tratamiento con corticoide, intercurriendo luego con herpes zoster en miembro superior izquierdo secuelado con neurlagia, antecedetente quirurgico de  amigamadelectomia en la niñez, cursa internacion por caida desde su propia altura con fractura de oleacraneón y fractura lateral de cadera izquierda.'+chr(10)+;
'<br>Al examen fisico, vigil, hemodinamicamente estable. normotenso'+chr(10)+;
'<br>Regular entrada bilateral de aire, murmullo vesicular conservado, sin ruidos agregados,'+chr(10)+;
'<br>Abdomen blando, depresible, no doloroso RHA +.'+chr(10)+;
'<br>Labatorio dentro de los paramentros normales.'+chr(10)+;
'<br>Paciente en condiciones clinicas para somterse a proceso quirurgico.'+chr(10)+;
'<br><br>'+chr(10)+;
'</div>'+chr(10)+;
'</div>'+chr(10)+;
'<br>'
SET STEP ON

mret=sqlexec(mcon1," update  TabintEvolmed  set eim_evol =?ef,eim_indicacion =?ef, eim_html =?efhtml  "+;
	" where id =   458090")
	***eg_evolhist = ?mevolh "+; &&EG_motConsulta = ?mc , 
*!*	mievol = "Debido al tiempo de evolucion e impresion quirurgica se decide con acuerdo del dr Selandari, jefe de servicio de pediatria "+;
*!*	" comenzar tto empirico con cefalexina 2 gr por dia por 10 dias + "+;
*!*	"ibuprofeno 400 mg cada 6 hs y crioterapia y citar para eco y control clinico el sabado por la mañana."
*!*	mret=sqlexec(mcon1," update  TabGuaEvolmed set EGM_evol = ?mievol"+;
*!*	" where id =  2173662")

do sp_desconexion

