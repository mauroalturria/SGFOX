************************
* AUTOR: Claudia Antoniow
************************
* Fecha : 20/06/2003
************************
*Fecha Ultima Modif: 20/06/2003
*******************************

*************************************************************
* Trae Tabla ordenada por Id ,el where ae ingresa por parametro
* vr_condicion y el nombre de la tabla tambien
**************************************************************
Parameter vr_Condicion ,vr_tablalist, vr_cursor


mret = sqlexec(mcon1," SELECT * FROM " + vr_tablalist +" " + vr_Condicion, vr_cursor)

if mret < 0
	messagebox('ERROR DE CURSOR '+ vr_cursor + ', REINTENTE',16,'VALIDACION')
	mret  = 0
endif