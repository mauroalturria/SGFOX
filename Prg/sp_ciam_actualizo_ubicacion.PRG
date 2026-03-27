*
* Actualización de Centros Asistenciales
*
Lparameters  mnom,mpci,mloc,mcdp,mdir,mtel,mubi,mck1,mck2,mck3,mck4,mlocdes,midn,;
mbris

mret = sqlexec(mcon1,"update TabCiamUbica set "+;
	"TCU_nombre      = ?mnom,"    +;
	"TCU_direccion   = ?mdir,"    +;
	"TCU_localdes    = ?mlocdes," +;
	"TCU_telef       = ?mtel,"    +;
	"TCU_idcodpostal = ?mcdp,"    +;
	"TCU_idprovincia = ?mpci,"    +;
	"TCU_idlocal     = ?mloc,"    +;
	"TCU_tipou       = ?mck1,"    +;
	"TCU_tipop       = ?mck2,"    +;
	"TCU_tipob       = ?mck3,"    +;
	"TCU_tipot       = ?mck4,"    +;
	"TCU_tipifica    = ?mubi,"    +;
	"TCU_bristol     = ?mbris "   +;
	"where Id = ?midn")

If mret < 0
=aerror(merror)
	Messagebox(merror(3)+chr(10)+"EN ACTUALIZACION DE CENTROS ASISTENCIALES"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
