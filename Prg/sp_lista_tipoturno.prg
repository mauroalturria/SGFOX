************************
* AUTOR: Claudia Antoniow
************************
* Fecha : 27/03/2003
************************
*Fecha Ultima Modif: 27/03/2003
*******************************
* Para Form: frmturno27
******************************
* Trae tipotuno
******************************
Parameter vr_Condicion


mret=sqlexec(mcon1," SELECT * FROM Tabtipoturno " + vr_Condicion +;
				   " ORDER BY tipoturno","MwkTipoturno")

if mret<0
	messagebox('ERROR DE CURSOR Tipo de Turno, REINTENTE',16,'VALIDACION')
	mret=0
endif