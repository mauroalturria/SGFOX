********************************
* AUTOR: Claudia C. Antoniow T.
********************************
* FECHA: 30/03/2003
********************************
* Actulizado: 10/09/2003
********************************



mret=sqlexec(mcon1,"Select codprest, pre_descriprest "+;
	" From medpresta, prestacions     "+;
	" Where codprest = pre_codprest  and PRE_fechapasiva is null  "+;
	" And codmed = ?mncodmed  and diasem = ?mddiasem  "+;
	" And cast(horadesde as char(8))= ?mthrDes "+;
	" And cast(horahasta as char(8))= ?mthrHas ","MwkPrest")


if mret <0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
endif
