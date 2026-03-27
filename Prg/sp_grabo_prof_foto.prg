***
*	agrega datos de registracio
***
Lparameters midmed,rutaimagen,mtipo
*SET STEP ON 
mfecpas = Ctod("01/01/1900")
mfechamod = sp_busco_fecha_serv("DT")
*!* Foto

If !Empty(rutaimagen)

	mret = SQLExec(mcon1,"select ID FROM TabMedFoto where idmedico = ?midmed and "+;
		" FechaBaja = ?mfecpas and tipo = ?mtipo ","mprofFotoctr")

	Do Case
	Case 	mtipo = 1
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
		Do prg_LoadBin With rutaimagen,miimagen
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
		lcimagen = __DATA.foto
	Otherwise
		lcimagen = rutaimagen
	Endcase

	If Reccount('mprofFotoctr')>0
		mid = mprofFotoctr.Id
		mret = SQLExec(mcon1, "update TabMedFoto set Imagen = ?lcimagen "+;
			" where  Id = ?mid ")
	Else
		mret = SQLExec(mcon1, "insert into TabMedFoto( FechaBaja , FechaToma , IdMedico , Imagen , tipo) " + ;
			"values(?mfecpas, ?mfechamod, ?midmed ,?lcimagen,?mtipo )")
	Endif

	If File(rutaimagen)
		Erase (rutaimagen)
	Endif

Endif
