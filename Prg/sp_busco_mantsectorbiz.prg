mret = sqlexec(mcon1, "select cast(0 as integer ) as elegido , descripcion,id,codigo" +;
			" from sdep  " + ;
			" where codigo<=9999 and left(descripcion,4)<>'NO U' and descripcion<>'' " +;
			" order by Descripcion", "mwksector")
select elegido ,descripcion,id,codigo from mwksector into cursor mwksectores	
if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif