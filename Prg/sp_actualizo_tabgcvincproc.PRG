LPARAMETERS mIddoc,mRevision,mPathImagen,mFormato

LOCAL miimagen
LOCAL mUsuario
LOCAL mFecha

* Cargo usuario y fecha en el variables.
mUsuario = mwkUsuario.codigovax
mFecha = sp_busco_fecha_serv("DT")

If Used ('imagen')
	Use In IMAGEN
Endif
If Used ('__DATA')
	Use In __DATA
Endif
If File("C:\temp\imagenes\imagen.dbf")
	Erase ("C:\temp\imagenes\imagen.dbf")
Endif
If File("C:\temp\imagenes\imagen.fpt")
	Erase ("C:\temp\imagenes\imagen.fpt")
Endif

Select 0
Create Table "C:\temp\imagenes\imagen.dbf" Free (foto M)

*  Toma el dato binario del archivo introducido en el memo
Select IMAGEN
Append Blank

miimagen = ''
Do prg_LoadBin With mPathImagen,miimagen
If !Empty(miimagen )
	Replace foto With miimagen
	Use

*  Cambia el campo memo a un tipo general para introducir a sql server
	LL = Fopen("C:\temp\imagenes\imagen.dbf",12)
	Fseek(LL,43)
	Fwrite(LL,'G')
	Fclose(LL)

*  Escribe el dato en sql server
	Use C:\temp\imagenes\IMAGEN.Dbf Alias __DATA
Else
	Create Cursor __DATA (foto M)
Endif

mret = SQLExec(mcon1, "insert into Tabgcvincproc( iddoc , revision , usuario , documento,fecha,formato) " + ;
	"values(?mIddoc, ?mRevision, ?mUsuario ,?__DATA.foto ,?mFecha,?mFormato)")

* Cierro tabla temporal con imagen.
USE IN SELECT("__DATA")

IF mRet < 1
   MESSAGEBOX("Error al intentar insertar documento.",26,"Error")
   On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
   RETURN .f.
ENDIF   


RETURN .T.
