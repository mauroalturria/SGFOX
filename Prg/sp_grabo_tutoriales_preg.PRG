Lparameter mpreg1, mprov1

mpreg = mpreg1
mmedi = mwkmedicogua.id
mnomb = mwkmedicogua.nombre
mfech = sp_busco_fecha_serv("DT")
mrese = ''
midre = 0
mesta = 1 && P/responder
mprov = mprov1 && 1 = Guardia

mret = sqlexec(mcon1,"insert into TabVTutorial (TVT_pregunta,TVT_codmed,TVT_nombremed,TVT_fechapreg,"+;
	"TVT_respesc,TVT_idvideo,TVT_idestado,TVT_idproviene)"+;
	" values (?mpreg,?mmedi,?mnomb,?mfech,?mrese,?midre,?mesta,?mprov)")

If mret < 0
	Messagebox("EN EL REGISTRO DE LA PREGUNTA"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Else
	Messagebox("SU PREGUNTA HA SIDO REGISTRADA"+chr(10)+"A LA BREVEDAD SE EVALUARA SU RESOLUCION",48,"Validación")
Endif
