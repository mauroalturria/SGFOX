*
* Analisis de exminados con respuesta correcta
*
Lparameters mltema, mlpreg, mlresp, mlranio, mlreven

If used('mwkrespok')
	Use in mwkrespok
Endif

mwhere = "TBE_p"+alltrim(str(mlpreg))

mret = sqlexec(mcon1,"select TBE_apellido,TBE_nombre,TBE_especialidad,TBE_puntaje"+;
	" from TabResProfExa "+;
	" where TBE_anio=?mlranio and TBE_evento=?mlreven and TBE_tema=?mltema"+;
	" and " + mwhere +"=?mlresp order by TBE_puntaje desc","mwkrespok")

If mret < 0
	Messagebox("EN CONSULTA DE EXAMINADOS CON RESPUESTA CORRECTA",16,"ERROR")
Endif


