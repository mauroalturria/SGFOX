*
* Preguntas x Tema
*
Lparameters ltema

mtema = ltema

mret = sqlexec(mcon1,"select TRT_preguntanro,TRT_respA,TRT_respB,TRT_respC,TRT_respD,"+;
	"TRT_respE,TRT_respblanco,TRT_respdobles,TRT_correcta,TRT_Idpregorg,TRT_tema,"+;
	"TRT_grupo,nvl(TRA_preguntanro,'0') as TRT_anulada"+;
	" from TabResTemas left outer join TabResAnu"+;
	" on TRA_preguntanro=TRT_preguntanro and TRA_tema=?mtema and TRA_anio=?mranio and TRA_evento=?mreven"+;
	" where TRT_tema=?mtema and TRT_anio=?mranio and TRT_evento=?mreven order by TRT_preguntanro","mwkpreguntas")

If mret <= 0
	Messagebox("EN CONSULTA DE PREGUNTAS POR TEMA",16,"ERROR")
Else
	mret = sqlexec(mcon1,"select TRE_t1preguntanro,TRE_t2preguntanro from TabResExa"+;
		" where TRE_anio=?mranio and TRE_evento=?mreven and TRE_autores=?mrautores "+;
		iif(mtema="1","order by TRE_t1preguntanro","order by TRE_t2preguntanro"),"mwkaniant")
	If mret < 0
		Messagebox("EN CONSULTA DE PREGUNTAS EXAMEN AÑO PASADO",16,"ERROR")
	Endif
Endif
