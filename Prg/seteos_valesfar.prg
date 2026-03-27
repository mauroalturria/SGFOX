****
**  Seteos del sistema
****

Public mcon1, midusu, mpassw,mcon1,myip,mxambito 
mxambito = 1

set ansi on
set bell off
set cent on
set compatible off
set conf on 
set date to french
set decimal to 2
set dele on
set exact on
set exclu off
set fdow to 1   
set hours to 24
set near on
set notify off
set path to Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set status bar off
set talk off
set sysmenu off
public vec_vale(31,3), dat_vale(30), item_vale(151,3), dat_fac(20), mversion, msel_datos(20,4),dat_cose(13)
dime vec_vale(31,3), dat_vale(30), item_vale(151,3), dat_fac(20), msel_datos(20,4),dat_cose(13)

do seteos_ip
myip = IPAddress()
do sp_busco_server_namespaces
on error =aerr(eros)
mfile = justpath(SYS(16,0))+"\inicio\ini.txt"
mcadcon = filetostr(mfile)
on error
if type('mcadcon') = "C"
	mDatabase 	= mline(mcadcon,3)
	mDatabase 	=alltrim(substr(mDatabase,at("=",mDatabase)+1))
	if !empty('mDatabase')
		select mwktabcfg
		replace olespaces with mDatabase 	
	endif	
endif	
	create cursor vales ;
	(dat_vale_01 c(50),dat_vale_02 c(50),dat_vale_03 c(50),dat_vale_04 c(50);
	,dat_vale_05 c(50),dat_vale_06 c(50),dat_vale_07 c(50),dat_vale_08 c(50);
	,dat_vale_09 c(50),dat_vale_10 c(50),dat_vale_11 c(50),dat_vale_12 c(50);
	,dat_vale_13 c(50),dat_vale_14 c(50),dat_vale_15 c(50),dat_vale_16 c(50);
	,dat_vale_17 c(50),dat_vale_18 c(50),dat_vale_19 c(50),dat_vale_20 c(50);
	,dat_vale_21 c(50),dat_vale_22 c(50),dat_vale_23 c(50),dat_vale_24 c(50),dat_vale_25 c(50);
	,item_vale_11 c(50), item_vale_12 c(50), item_vale_13 c(50);
	,item_vale_21 c(50), item_vale_22 c(50), item_vale_23 c(50);
	,item_vale_31 c(50), item_vale_32 c(50), item_vale_33 c(50);
	,item_vale_41 c(50), item_vale_42 c(50), item_vale_43 c(50);
	,item_vale_51 c(50), item_vale_52 c(50), item_vale_53 c(50);
	,item_vale_61 c(50), item_vale_62 c(50), item_vale_63 c(50);
	,item_vale_71 c(50), item_vale_72 c(50), item_vale_73 c(50);
	,item_vale_81 c(50), item_vale_82 c(50), item_vale_83 c(50);
	,item_vale_91 c(50), item_vale_92 c(50), item_vale_93 c(50);
	,item_vale_101 c(50), item_vale_102 c(50), item_vale_103 c(50);
	,item_vale_111 c(50), item_vale_112 c(50), item_vale_113 c(50);
	,item_vale_121 c(50), item_vale_122 c(50), item_vale_123 c(50);
	,item_vale_131 c(50), item_vale_132 c(50), item_vale_133 c(50);
	,item_vale_141 c(50), item_vale_142 c(50), item_vale_143 c(50);
	,item_vale_151 c(50), item_vale_152 c(50), item_vale_153 c(50);
	,item_vale_161 c(50), item_vale_162 c(50), item_vale_163 c(50);
	,item_vale_171 c(50), item_vale_172 c(50), item_vale_173 c(50);
	,item_vale_181 c(50), item_vale_182 c(50), item_vale_183 c(50);
	,item_vale_191 c(50), item_vale_192 c(50), item_vale_193 c(50);
	,item_vale_201 c(50), item_vale_202 c(50), item_vale_203 c(50);
	,item_vale_211 c(50), item_vale_212 c(50), item_vale_213 c(50);
	,item_vale_221 c(50), item_vale_222 c(50), item_vale_223 c(50);
	,item_vale_231 c(50), item_vale_232 c(50), item_vale_233 c(50);
	,item_vale_241 c(50), item_vale_242 c(50), item_vale_243 c(50);
	,item_vale_251 c(50), item_vale_252 c(50), item_vale_253 c(50);
	,item_vale_261 c(50), item_vale_262 c(50), item_vale_263 c(50);
	,item_vale_271 c(50), item_vale_272 c(50), item_vale_273 c(50);
	,item_vale_281 c(50), item_vale_282 c(50), item_vale_283 c(50);
	,item_vale_291 c(50), item_vale_292 c(50), item_vale_293 c(50);
	,item_vale_301 c(50), item_vale_302 c(50), item_vale_303 c(50);
	,item_vale_311 c(50), item_vale_312 c(50), item_vale_313 c(50);
	,item_vale_321 c(50), item_vale_322 c(50), item_vale_323 c(50);
	,item_vale_331 c(50), item_vale_332 c(50), item_vale_333 c(50);
	,item_vale_341 c(50), item_vale_342 c(50), item_vale_343 c(50);
	,item_vale_351 c(50), item_vale_352 c(50), item_vale_353 c(50);
	,item_vale_361 c(50), item_vale_362 c(50), item_vale_363 c(50);
	,item_vale_371 c(50), item_vale_372 c(50), item_vale_373 c(50);
	,item_vale_381 c(50), item_vale_382 c(50), item_vale_383 c(50);
	,item_vale_391 c(50), item_vale_392 c(50), item_vale_393 c(50);
	,item_vale_401 c(50), item_vale_402 c(50), item_vale_403 c(50);
	,urgencia c(20), habita c(40),cuantos n(2))
	
	create cursor valesctrl ( nrovale n(10) ) 
	if !used("mwkusuario")
		create cursor mwkusuario (idusuario c(20),codigovax n(7),password c(10),id n(2),nivel n(2),sector c(30),nomape c(30))
		insert into mwkusuario values ("CFUNES",54035,'',146,1,'SISTEMAS',"Carmencita")
	endif

	do form frmvales	&& 
	read event
