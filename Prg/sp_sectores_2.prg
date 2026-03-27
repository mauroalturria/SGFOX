****
** busco sectores
****

mret = sqlexec(mcon1, "select  ID , cast(Codigo as integer) as Codigo , Descripcion  from sdep  " + ;
			" where codigo<=9999 " +;
			" order by Descripcion", "mwksector")
select descripcion,id,codigo from mwksector into cursor mwksectores	

