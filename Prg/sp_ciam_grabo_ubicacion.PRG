*
* Grabación de Centros Asistenciales
*
Lparameters  mnom,mpci,mloc,mcdp,mdir,mtel,mubi,mck1,mck2,mck3,mck4,mlocdes,;
mbris

mfnull = ctod("01/01/1900")

mret = sqlexec(mcon1,"insert into TabCiamUbica "+;
	"(TCU_nombre,  TCU_direccion,  TCU_localdes, TCU_telef,  TCU_obser,"+;
	"TCU_idcodpostal,TCU_idprovincia,TCU_idlocal,TCU_usofrec,TCU_tipou,"+;
	"TCU_tipop,TCU_tipob,TCU_tipot,TCU_tipifica,TCU_fecpasiva,TCU_bristol)"+;
	" values "+;
	"(?mnom,?mdir,?mlocdes,?mtel,'',?mcdp,?mpci,?mloc,0,?mck1,?mck2,?mck3,"+;
	"?mck4,?mubi,?mfnull,?mbris)")

If mret < 0
	Messagebox("EN ALTA DE CENTROS ASISTENCIALES"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
