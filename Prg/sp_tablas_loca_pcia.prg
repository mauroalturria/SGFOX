****
**	Busco solo las Pcias y Localidades
****

If Used('mwkpcia')
	Select mwkpcia
	Use
Endif
If Used('mwkloca')
	Select mwkloca
	Use
Endif



Use In Select("mwkpcia")
mret = SQLExec(mcon1, "select descrip, id from tabpcia " + ;
	"where id<100000 order by descrip", "mwkpcia")

Use In Select("mwkloca")
mret = SQLExec(mcon1, "select descrip, id from tabloca " + ;
	"where id<100000 order by descrip", "mwkloca")

If !Used('mwkcodpostal')
	mret = SQLExec(mcon1,"SELECT codpostal,Tabloca1.descrip,idprovincia , Tabpcia1.descrip as desprov,Tabloca1.id FROM Tabloca1 "+;
		"  INNER JOIN Tabpcia1 ON Tabloca1.idprovincia = Tabpcia1.ID "+;
		" ","mwkcodpostal")
Endif
If mret < 0
	Messagebox('ERROR EN LA GENERACION DEL CURSOR, REINTENTE', 16,'Validacion')
Endif
