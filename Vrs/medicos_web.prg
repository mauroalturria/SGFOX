mcon1 = SqlConnect("REAL_172_16_1_2")

mfecpasiva = cTod('01/01/1900')
mfechoy  = date()

?SqlExec(mcon1,"select prestadores.nombre, codesp, " + ;
	"nvl(TabEstudios.descrip,'') "  + ;
	 "from prestadores "  + ;
	 "left join TabEstudios on TabEstudios.Id = prestadores.coduniv " + ;
	 "where Web = 'S' and (fecpasiva = ?mfecpasiva or fecpasiva = ?mfechoy) " + ;
	 "order by Nombre " ,"csalida")

Sele csalida
copy to c:\medicos_web type xl5
