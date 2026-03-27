*****************************************
**Busco cant de registros
*****************************************
parameter vcampo_C, vtabla, Vcond

mret=sqlexec(mcon1," SELECT count(" + allt(vcampo_C) +") as Cant FROM " + vtabla +;
				   " " + vCond ,"MwkCanReg")
					
if mret < 0
	messagebox('Error de Cursor. REINTENTE',16,'Validacion')
	do prg_cancelo
endif					

