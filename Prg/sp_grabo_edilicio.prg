** Grabamos los datos edilicios

Parameters mTabla,mNuevo,mNombre,mDireccion, mIdEdificio, mIdPlanta, mIdArea, mIdSubArea, mIdTipoSubArea

Local mcTabla

mcTabla = ""
mFechaInicio = sp_busco_fecha_serv("DD")
mfechaFin = Iif(mNuevo = 2,mFechaInicio,Ctod('01/01/1900'))

Do Case
Case mTabla = 1  &&edificio

	mcTabla = "TabEeEdificios"
	Do Case
	Case mNuevo = 0
		mret = SQLExec(mcon1,"insert into TabEeEdificios (nombre,domicilio) values(?mNombre,?mDireccion)")
	Case mNuevo = 1
		mret = SQLExec(mcon1,"update TabEeEdificios set nombre = ?mNombre,domicilio = ?mDireccion where id = ?mIdEdificio")
	Endcase

Case mTabla = 2  &&planta

	mcTabla = "TabEePlantasEdificio"
	Do Case
	Case mNuevo = 0
		mret = SQLExec(mcon1,"insert into TabEePlantasEdificio (IdEdificio,nombre) values(?mIdEdificio,?mNombre)")
	Case mNuevo = 1
		mret = SQLExec(mcon1,"update TabEePlantasEdificio set nombre = ?mNombre where id = ?mIdPlanta")
	Endcase

Case mTabla = 3   &&Area

	mcTabla = "TabEeAreasPlanta"
	Do Case
	Case mNuevo = 0
		mret = SQLExec(mcon1,"insert into TabEeAreasPlanta (IdPlanta,nombre,FechaInicio,FechaFin) values(?mIdPlanta,?mNombre,?mFechaInicio,?mFechaFin)")
	Case mNuevo = 1
		mret = SQLExec(mcon1,"update TabEeAreasPlanta set nombre = ?mNombre where id = ?mIdArea")
	Case mNuevo = 2  &&Pasivamos
		mret = SQLExec(mcon1,"update TabEeAreasPlanta set FechaFin = ?mFechaFin where id = ?mIdArea")
	Endcase


Case mTabla = 4   &&SubAreas

	mcTabla = "TabEeSubAreasPlanta"
	Do Case
	Case mNuevo = 0
		mret = SQLExec(mcon1,"insert into TabEeSubAreasPlanta (IdArea,IdTipoSubarea,nombre,FechaInicio,FechaFin) values(?mIdArea,?mIdTipoSubArea,?mNombre,?mFechaInicio,?mFechaFin)")
	Case mNuevo = 1
		mret = SQLExec(mcon1,"update TabEeSubAreasPlanta set IdTipoSubarea = ?mIdTipoSubArea ,nombre = ?mNombre where id = ?mIdSubArea")
	Case mNuevo = 2
		mret = SQLExec(mcon1,"update TabEeSubAreasPlanta set FechaFin = ?mFechaFin where id = ?mIdSubArea")
	Endcase

Case mTabla = 5   &&Asociamos el Tipo de SubArea a la tabla SubAreas

	mcTabla = "TabEeSubAreasPlanta"
	mret = SQLExec(mcon1,"update TabEeSubAreasPlanta set IdTipoSubarea = ?mIdTipoSubArea where id = ?mIdSubArea")

Case mTabla = 6   &&Tipos de SubAreas

	mcTabla = "TabEeTipoSubAreaPlanta"
	Do Case
	Case mNuevo = 0
		mret = SQLExec(mcon1,"insert into TabEeTipoSubAreaPlanta (Descripcion) values(?mNombre)")
	Case mNuevo = 1
		mret = SQLExec(mcon1,"update TabEeTipoSubAreaPlanta set Descripcion = ?mNombre where id = ?mIdTipoSubArea")
	Case mNuevo = 2
		mret = SQLExec(mcon1,"update TabEeTipoSubAreaPlanta set FechaFin = ?mFechafin where id = ?mIdTipoSubArea")
	Endcase

Endcase

If mret<=0
	Messagebox("ERROR EN LA GRABACION DE TABLA : " + mTabla,26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Else
	Return .T.
Endif
