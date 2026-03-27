*
* Busco imagen del examen correspondiente al documento del examinado requerido
*
Lparameter mdocumento
If used('ima')
	Use in ima
Endif
If used('__DATA')
	Use in __DATA
Endif
If used ('imagen')
	Use in imagen
Endif
mdocu = mdocumento && mwkresidencia.TBE_dni
mret = sqlexec(mcon1,"select TBE_image as foto from TabResProfexa"+;
" where TBE_dni=?mdocu and TBE_anio = ?mranio and TBE_evento = ?mreven","ima")

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
*           Cambia el campo grneral de tipo memo
	LL = fopen("C:\temp\imagenes\imagen.dbf",12)
	Fseek(LL,43)
	Fwrite(LL,'M')
	Fclose(LL)
*           Graba los datos campo memo en un archivo
	Use "C:\temp\imagenes\imagen.dbf" alias ima
	miresp = ''
	mcimagen = 'examinado'
	If file("C:\temp\imagenes\examinado.tif")
		Erase ("C:\temp\imagenes\examinado.tif")
	Endif
	Do prg_saveBinnb with foto,"C:\temp\imagenes\"+mcimagen,miresp,'TIF'
	mTifDir = miresp
	If used('__DATA')
		Use in __DATA
	Endif
	If used ('imagen')
		Use in imagen
	Endif
	If used('ima')
		Use in ima
	Endif
	
	If OS(1) = "Windows 5.01" or OS(1) = "Windows 6.01"
		mpath = "RUN/N " + "rundll32.exe C:\WINDOWS\system32\shimgvw.dll,ImageView_Fullscreen " + mTifDir
	Else
		mpath = "RUN/N " + "Kodakimg.exe " + mTifDir
	Endif
	&mpath
Else
	Messagebox("PARA MOSTRAR IMAGEN DEL EXAMEN",16,"ERROR")
Endif
Return
