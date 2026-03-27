PARAMETERS tcNroVale


xparams = "vale=" + TRANSFORM(tcNroVale)
oCryp = Newobject("Encryption","c:\desaguemes\Prg\sglibcrip.PRG")
lcHash_cryp = oCryp.safe_b64encode(xparams)
lclink = "http://172.16.1.200/intranet/lanzador/Prog/wanato/entregas_anato.php?lhash=" + lcHash_cryp

If!prg_url(1,lclink)
	RETURN .f.
ENDIF 
*!*	o = Createobject("Shell.Application")
*!*	o.Open(lclink)
