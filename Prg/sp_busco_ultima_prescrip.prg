** Recibimos el Id de evolucion y aFechas, matriz de 2 posiciones.
Lparameters mIdEvol, aFechas

LOCAL mFecPres
LOCAL mFecModif

** Verificamos primero la ultima fecha de Prescripcion
mRet = SQLExec(mcon1,"select MAX(pps_fechora) as pps_fechora from TabIntPmPres where pps_idevol = ?mIdevol","mwkIntPmPres")

If mRet < 0
	Messagebox("No se puede consultar la tabla TABINTPMPRES.Avise a Sistemas.","Blanqueo")
	Return
Endif

** Verifico ultima fecha de modificacion
mfnull = Ctod("01/01/1900")

mret = SQLExec(mcon1,"select Max(ps_fechormodif) As ps_fechormodif from TabIntPmSolu"+;
	" where PS_idevol = ?mIdEvol ","mwkIntPmModif")

If mRet < 0
	Messagebox("No se puede consultar la tabla TABINTPMSOLU.Avise a Sistemas.","Blanqueo")
	Return
Endif

**Select Max(ps_fechormodif) As ps_fechormodif FROM mwkPmSp Into Cursor mwkIntPmModif
Go Top In mwkIntPmPres
	

SELECT mwkIntPmPres	
Go Top
If Vartype(mwkIntPmPres.pps_fechora) = "T"
	mFecPres = TTOC(mwkIntPmPres.pps_fechora)
Else
	mFecPres = ""
Endif

SELECT mwkIntPmModif
GO top
If Vartype(mwkIntPmModif.ps_fechormodif ) = "T"
	mFecModif = TTOC(mwkIntPmModif.ps_fechormodif)
Else
	mFecModif = ""
Endif


Use In Select("mwkIntPmPres")
USE IN SELECT("mwkIntPmModif")

aFechas[1] = mFecPres
aFechas[2] = mFecModif

Return null
