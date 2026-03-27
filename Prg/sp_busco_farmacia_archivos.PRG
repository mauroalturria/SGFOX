*
* Busco archivo del examen correspondiente tipo, año y tema
*
Lparameter mlid, mtipo

If used('ima')
	Use in ima
Endif
If used('__DATA')
	Use in __DATA
Endif
If used ('imagen')
	Use in imagen
Endif

mret = sqlexec(mcon1,"select TFD_documento as foto from TabFarmDocs where id = ?mlid","ima")

If mret > 0

	If file("C:\temp\imagenes\imagen.dbf")
		Erase ("C:\temp\imagenes\imagen.dbf")
	Endif
	If file("C:\temp\imagenes\imagen.fpt")
		Erase ("C:\temp\imagenes\imagen.fpt")
	Endif
	Select ima
	Copy to "C:\temp\imagenes\imagen"
	Use in ima

*   Cambia el campo grneral de tipo memo
	LL = fopen("C:\temp\imagenes\imagen.dbf",12)
	Fseek(LL,43)
	Fwrite(LL,'M')
	Fclose(LL)

*   Graba los datos campo memo en un archivo
	Use "C:\temp\imagenes\imagen.dbf" alias ima
	miresp = ''
	mcimagen = 'archivo'
	If file("C:\temp\imagenes\archivo."+mtipo)
		Erase ("C:\temp\imagenes\archivo."+mtipo)
	Endif
	Do prg_saveBinnb with foto,"C:\temp\imagenes\"+mcimagen,miresp,mtipo
	marchi = miresp

	If used('__DATA')
		Use in __DATA
	Endif
	If used ('imagen')
		Use in imagen
	Endif
	If used('ima')
		Use in ima
	Endif
Else
	Messagebox("AL LOCALIZAR ARCHIVO, REQUERIDO"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
Return
