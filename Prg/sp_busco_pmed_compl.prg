***
*** Generacion de planilla de medicos con complemento
***
parameters mfecturno, mbusco1,mltodo
if type('mltodo')#"N"
	mltodo=1
endif

mret = sqlexec(mcon1, "select turnos.*" + ;
	"from turnos " + ;
	"where " + ;
	"tipoturno < 9 and " + ;
	"fechatur = ?mfecturno and " + ;
	" &mbusco1 "  + ;
	"afiliado > 0 " + ;
	"group by afiliado,codreserva,codmed,codesp  " + ;
	"", "mwkphorario1")
if mret<1
*	'turnos.codmed in (554) and ' 
	=aerr(eros)
	messagebox(eros(2))
endif

select * from mwkphorario1 ;
	left join mwkpesp on codesp = ESP_codesp ;
	left join mwkpmed on codmed = mwkpmed.id ;
	into cursor mwkphorarios
	
if used('mwkphorario1')
	use in  mwkphorario1
endif
if used('mwkphorario4')
	use in  mwkphorario4
endif