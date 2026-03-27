PARAMETERS mvale

COPY FILE ("x:\Qepd1a1\Exe\show_anato.exe") to ("c:\Qepd1a1\Exe\show_anato.exe") 

lrun = "Run/n c:\Qepd1a1\Exe\show_anato.exe " + TRANSFORM(mvale)
&lrun 

*!*	mvale      = "36299365"

*!*	xparams = "vale=" + TRANSFORM(mVale)
*!*	oCryp = Newobject("Encryption","c:\desaguemes\Prg\sglibcrip.PRG")
*!*	lcHash_cryp = oCryp.safe_b64encode(xparams)
*!*	lclink = "http://172.16.1.200/intranet/lanzador/Prog/wanato/entregas_anato.php?lhash=" + lcHash_cryp
*!*	o = Createobject("Shell.Application")
*!*	o.Open(lclink)

