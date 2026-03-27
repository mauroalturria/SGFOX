************************
* AUTOR: Claudia Antoniow
************************
* Fecha : 20/06/2003
************************
*Fecha Ultima Modif: 20/06/2003
*******************************

Parameters vr_tabla, vr_campo, vr_valores, mret 


if vr_campo=''
	isql = 'Insert Into ' + vr_tabla +' values (' + vr_valores + ')' 
	mret = sqlexec(mcon1,isql)
else
	isql = 'Insert Into ' + vr_tabla +'(' + vr_campo + ') values (' + vr_valores + ')' 
			 
	mret = sqlexec(mcon1,isql)
endif

if mret < 0
	messagebox('No se Pudo agregar datos a ' + vr_tabla ,16,'Valiacion')
	mret = 0
endif	
return mret