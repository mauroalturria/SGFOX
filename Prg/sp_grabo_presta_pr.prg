*****
***** Grabo prestadores Preregistrados
*****

Parameter morigen, miabm, mid, mestado, msexo, mnombre, mtelefono, mtelCelular, mtelRadio,;
	memail, mcodProf, mmatriculas, mmatProv, mfaltag, mfbajag, mcodEsp,;
	mcodMedCoord, mcodMedreem, mcodMed, mcodUniv, mdomicilio, mhhmmrDes,;
	mhhmmRHas, mnroDoc, mfecPasivag, mfecPasivai, mfecAlta, mfecAltag,; 
	mfecAltai, mfecAltap, mfechaReemp, mfecPasiva, mobserv, mcpostal, mpcia, mloca,;
	mcert, mrnp, mfrnp, mmlp, mfmlp, mvacu, mrecv,mfecvtomat

If vartype(mcodUniv)#"N"
	mcodUniv = 0
Endif
If vartype(mobserv)#"C"
	mobserv = ""
Endif

musuarios =  mwkusuario.codigovax
mfechaMod = sp_busco_fecha_serv("DT")
mfecnul   = ctod("01/01/1900")

If vartype(mfecvtomat)#"D"
	mfecvtomat = mfecnul
Endif
If vartype(mfrnp)#"D"
	mfrnp = mfecnul
ENDIF
If vartype(mfmlp)#"D"
	mfmlp = mfecnul
Endif

Do case

Case morigen = 1
	mdAmbula  = 1
	mdGUardia = 0
	mdInterna = 0
	mfecAlta  = mfaltag
	
Case morigen = 2
	mdAmbula  = 0
	mdGUardia = 1
	mdInterna = 0
	mfecAltag = mfaltag
	
Case morigen = 3 && Nuevo  quirofano
	mdAmbula  = 0
	mdGUardia = 0
	mdInterna = 0
	mfecAlta  = mfaltag	
	
Case morigen = 4
	mdAmbula  = 1
	mdGUardia = 1
	mdInterna = 1
	mfecAlta  = mfaltag
	mfecAltag = mfaltag
	
Endcase

If miabm = 1

	mret = sqlexec(mcon1, "Insert into TabPreregMed ( codMedCoord, codMedreem, codEsp, codMed"+;
		" , codProf, codUniv, dAmbula, dGUardia, dInterna, domicilio, email, estado, fecAlta, fecAltag"+;
		", fecAltai, fecAltap, fechaReemp, fechaMod, fecPasiva, fecPasivag, fecPasivai, hhmmrDes"+;
		", hhmmRHas, matProv, matriculas, nombre, nroDoc, sexo, telCelular, telefono, telRadio"+;
		", usuario, observaciones, codloca, codpcia, codpostal,"+;
		" certespec,inscrnp,fvtornp,segmalapraxis,fvtomalapraxis,certvac,resumencv,FecVtoMatricula)"+;
		" values ( ?mcodMedCoord, ?mcodMedreem"+;
		", ?mcodEsp, ?mcodMed , ?mcodProf"+;
		", ?mcodUniv, ?mdAmbula, ?mdGUardia, ?mdInterna, ?mdomicilio, ?memail, ?mestado,?mfecAlta"+;
		", ?mfecAltag, ?mfecAltai, ?mfecAltap, ?mfechaReemp, ?mfechaMod, ?mfecPasiva, ?mfecPasivag"+;
		", ?mfecPasivai, ?mhhmmrDes, ?mhhmmRHas, ?mmatProv, ?mmatriculas, ?mnombre, ?mnroDoc,?msexo"+;
		", ?mtelCelular, ?mtelefono, ?mtelRadio, ?musuarios, ?mobserv, ?mcpostal, ?mpcia, ?mloca,"+;
		"  ?mcert,?mrnp,?mfrnp,?mmlp,?mfmlp,?mvacu,?mrecv,?mfecvtomat)")

	If mret < 0
		mret = sqlexec(mcon1, "Insert into TabPreregMed ( codMedCoord, codMedreem, codEsp, codMed"+;
			" , codProf, codUniv, dAmbula, dGUardia, dInterna, domicilio, email, estado, fecAlta, fecAltag"+;
			", fecAltai, fecAltap, fechaReemp, fechaMod, fecPasiva, fecPasivag, fecPasivai, hhmmrDes"+;
			", hhmmRHas, matProv, matriculas, nombre, nroDoc, sexo, telCelular, telefono, telRadio"+;
			", usuario, observaciones,FecVtoMatricula ) values ( ?mcodMedCoord, ?mcodMedreem, ?mcodEsp, ?mcodMed , ?mcodProf"+;
			", ?mcodUniv, ?mdAmbula, ?mdGUardia, ?mdInterna, ?mdomicilio, ?memail, ?mestado,?mfecAlta"+;
			", ?mfecAltag, ?mfecAltai, ?mfecAltap, ?mfechaReemp, ?mfechaMod, ?mfecPasiva, ?mfecPasivag"+;
			", ?mfecPasivai, ?mhhmmrDes, ?mhhmmRHas, ?mmatProv, ?mmatriculas, ?mnombre, ?mnroDoc,?msexo"+;
			", ?mtelCelular, ?mtelefono, ?mtelRadio, ?musuarios, ?mobserv,?mfecvtomat )")

	Endif

Else

	mret = sqlexec(mcon1, "Update TabPreregMed set codMedCoord = ?mcodMedCoord , codMedreem = ?mcodMedreem " + ;
		" , codEsp = ?mcodEsp , codMed = ?mcodMed  , codProf = ?mcodProf , codUniv = ?mcodUniv "+;
		" , dAmbula = ?mdAmbula  , dGUardia = ?mdGUardia  , dInterna = ?mdInterna  "+;
		" , domicilio = ?mdomicilio  , email = ?memail  , estado = ?mestado ,fecAlta = ?mfecAlta "+;
		" , fecAltag = ?mfecAltag  , fecAltai = ?mfecAltai  , fecAltap = ?mfecAltap "+ ;
		" , fechaReemp = ?mfechaReemp  , fechaMod = ?mfechaMod  , fecPasiva = ?mfecPasiva "+;
		" , fecPasivag = ?mfecPasivag  , fecPasivai = ?mfecPasivai  , hhmmrDes = ?mhhmmrDes "+;
		" , hhmmRHas = ?mhhmmRHas  , matProv = ?mmatProv  , matriculas = ?mmatriculas "+ ;
		" , nombre = ?mnombre  , nroDoc = ?mnroDoc  , sexo = ?msexo  , telCelular = ?mtelCelular "+;
		" , telefono = ?mtelefono  , telRadio = ?mtelRadio  , usuario = ?musuarios, observaciones = ?mobserv "+;
		" , CodPostal  = ?mcpostal, CodPcia = ?mpcia, CodLoca = ?mloca "+;
		" , certespec  = ?mcert"+;
		" , inscrnp    = ?mrnp"+;
		" , fvtornp    = ?mfrnp"+;
		" , segmalapraxis  = ?mmlp"+;
		" , fvtomalapraxis = ?mfmlp"+;
		" , certvac    = ?mvacu"+;
		" , resumencv  = ?mrecv, FecVtoMatricula = ?mfecvtomat "+;
		" where id = ?mid")

	If mret < 0
	
&&      Esto por si no se crearon los campos
		mret = sqlexec(mcon1, "Update TabPreregMed set codMedCoord = ?mcodMedCoord , codMedreem = ?mcodMedreem  " + ;
			" , codEsp = ?mcodEsp , codMed = ?mcodMed  , codProf = ?mcodProf , codUniv = ?mcodUniv  "+;
			" , dAmbula = ?mdAmbula  , dGUardia = ?mdGUardia  , dInterna = ?mdInterna, FecVtoMatricula = ?mfecvtomat "+;
			" , domicilio = ?mdomicilio  , email = ?memail  , estado = ?mestado ,fecAlta = ?mfecAlta "+;
			" , fecAltag = ?mfecAltag  , fecAltai = ?mfecAltai  , fecAltap = ?mfecAltap "+ ;
			" , fechaReemp = ?mfechaReemp  , fechaMod = ?mfechaMod  , fecPasiva = ?mfecPasiva "+;
			" , fecPasivag = ?mfecPasivag  , fecPasivai = ?mfecPasivai  , hhmmrDes = ?mhhmmrDes "+;
			" , hhmmRHas = ?mhhmmRHas  , matProv = ?mmatProv  , matriculas = ?mmatriculas "+ ;
			" , nombre = ?mnombre  , nroDoc = ?mnroDoc  , sexo = ?msexo  , telCelular = ?mtelCelular "+;
			" , telefono = ?mtelefono  , telRadio = ?mtelRadio  , usuario = ?musuarios, observaciones = ?mobserv "+;
			" where id = ?mid")
	Endif

Endif

If mret<1
	=aerr(eros)
	Messagebox(eros(3))
Endif
