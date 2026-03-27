******************************
* AUTOR: Claudia C. Antoniow
******************************
* Fecha :30/10/2003
********************
parameter v_nrbono, vr_codbon, vr_serie

if type('vr_serie')#"C"
	vr_serie =''
endif
Do sp_busco_estados With 7,' and tipo = 74','mwkfechasap'
select mwkfechasap
go top 
mfecini = date(mwkfechasap.subestado,mwkfechasap.propietario,mwkfechasap.estado)
mfeclim = prg_dtoc(mfecini)
if vr_serie =''
	st_vr_serie =" (BonoSerie IS Null or BonoSerie = '') "
else
	st_vr_serie = ' BonoSerie  =?vr_serie '
endif

mret = sqlexec(mcon1," SELECT DF.*, F.tpocte FROM TabdetalleFac as DF, TabFacturas as F "+;
	" WHERE DF.NroFactura = F.nrocte and DF.tipobono =?vr_codbon "+;
	" AND ?v_nrbono BETWEEN DF.BonoDesde AND DF.BonoHasta  "+;
	" and fechagraba>=?mfeclim AND " + st_vr_serie ,"MWKVendido")
if mret < 0
	messagebox('ERROR DE CURSOR MWKVendido, AVISAR A SISTEMAS',16,'VALIDACION')
	mret = 0
else
	if eof("MWKVendido")
		mret = sqlexec(mcon1," SELECT DF.*, F.tpocte FROM TabdetalleFachist as DF, TabFacturas as F "+;
			" WHERE DF.NroFactura = F.nrocte and DF.tipobono =?vr_codbon "+;
			" AND ?v_nrbono BETWEEN DF.BonoDesde AND DF.BonoHasta "+;
			" and fechagraba>=?mfeclim AND " + st_vr_serie ,"MWKVendido")
		if mret < 0
			messagebox('ERROR DE CURSOR MWKVendido, AVISAR A SISTEMAS',16,'VALIDACION')
			mret = 0
		endif
	endif
	Select * from MWKVendido Where tpocte =5 into cursor MwknotaCre
endif


