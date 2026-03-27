****
** Busco evoluciones de enfermeria por rango de fechas
****

parameter mfecdes,mfechas,musu,mopcion,mfiltro
mbusco  = ''
if musu >0
	mbusco  = ' and EGN_usuario = ?musu '
endif
mf1 = prg_dtoc(mfecdes)
mf2 = prg_dtoc(mfechas+1)
if used('dias')
	use in dias
endif
create cursor dias (fecha D, diasem n )
for i = 0 to mfechas - mfecdes
	mdias = mfecdes + i
	insert into dias ( fecha,diasem  ) values ( mdias, dow(mdias) )
next

mret = sqlexec(mcon1, "SELECT TabGuaEvolnurse .*,idusuario,nomape from TabGuaEvolnurse "+;
	"left join tabusuario on EGN_usuario = codigovax  " + ;
	" where egn_fechah >= ?mf1 and  egn_fechah < ?mf2 "+mbusco +;
	"", "mwkEvolNur01")
if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
endif
select EGN_evolNurse, iif(at('C.S.V.',EGN_evolNurse)> 0,1,0) as c0,ttod(EGN_fechaH) as fechaev,EGN_fechaH,val(substr(EGN_parAdmF,1,1)) as a1, val(substr(EGN_parAdmF,2,1)) as a2,;
	val(substr(EGN_parAdmF,3,1)) as a3, val(substr(EGN_parAdmF,4,1)) as a4, val(substr(EGN_parAdmF,5,1)) as a5, ;
	val(substr(EGN_parAdmF,6,1)) as a6, val(substr(EGN_parAdmF,7,1)) as a7, val(substr(EGN_parAdmF,8,1)) as a8, ;
	val(substr(EGN_parAdmF,9,1)) as a9, val(substr(EGN_parAdmF,10,1)) as a10, val(substr(EGN_parAdmF,11,1)) as a11, ;
	EGN_parAlerg,EGN_parAlergQue, EGN_parFreCard, EGN_parFreResp, EGN_parGluc,EGN_parPeso,;
	val(substr(EGN_parOtros,1,1)) as p1, val(substr(EGN_parOtros,2,1)) as p2,val(substr(EGN_parOtros,3,1)) as p3,  ;
	val(substr(EGN_parOtros,4,1)) as p4, val(substr(EGN_parOtros,5,1)) as p5,val(substr(EGN_parOtros,6,1)) as p6,  ;
	val(substr(EGN_parOtros,7,1)) as p7, val(substr(EGN_parOtros,8,1)) as p8,val(substr(EGN_parOtros,9,1)) as p9,  ;
	val(substr(EGN_parOtros,10,1)) as p10, val(substr(EGN_parOtros,11,1)) as p11,val(substr(EGN_parOtros,12,1)) as p12,  ;
	val(substr(EGN_parOtros,13,1)) as p13, val(substr(EGN_parOtros,14,1)) as p14,val(substr(EGN_parOtros,15,1)) as p15,  ;
	EGN_parSatur, EGN_parTemAxl,EGN_parTemBuc, EGN_parTemRct,EGN_parTensDia, EGN_parTensSis,;
	EGN_proto, EGN_usuario,idusuario,nomape from mwkEvolNur01 into cursor mwkEvolNur0

select * from mwkEvolNur0 &mfiltro  into cursor mwkEvolNur01

if mopcion = 1
	select fechaev,sum(c0) as c0, sum(a1) as a1, sum(a2) as a2,sum(a3) as a3, sum(a4) as a4, sum(a5) as a5, ;
		sum(a6) as a6, sum(a7) as a7, sum(a8) as a8, sum(a9) as a9, sum(a10) as a10, sum(a11) as a11, ;
		sum(p1) as p1, sum(p2) as p2,sum(p3) as p3, sum(p4) as p4, sum(p5) as p5,sum(p6) as p6,  ;
		sum(p7) as p7, sum(p8) as p8,sum(p9) as p9, sum(p10) as p10, sum(p11) as p11,sum(p12) as p12,  ;
		sum(p13) as p13, sum(p14) as p14,sum(p15) as p15, EGN_usuario,idusuario,nomape ;
		from mwkEvolNur01 group by fechaev into cursor mwkEvolNur
		
	select fechaev,EGN_fechaH,EGN_proto, EGN_usuario,idusuario,nomape ;
		from mwkEvolNur01 group by EGN_proto into cursor mwkEvolNurcp0

	select count(1) as cantp, fechaev,EGN_proto, EGN_usuario,idusuario,nomape ;
		from mwkEvolNurcp0  group by fechaev  into cursor mwkEvolNurcp

	select mwkEvolNur.*,cantp from mwkEvolNur,mwkEvolNurcp ;
	where mwkEvolNur.fechaev = mwkEvolNurcp.fechaev ;
	into cursor mwkprodnur
	
else
	select fechaev,sum(c0) as c0, sum(a1) as a1, sum(a2) as a2,sum(a3) as a3, sum(a4) as a4, sum(a5) as a5, ;
		sum(a6) as a6, sum(a7) as a7, sum(a8) as a8, sum(a9) as a9, sum(a10) as a10, sum(a11) as a11, ;
		sum(p1) as p1, sum(p2) as p2,sum(p3) as p3, sum(p4) as p4, sum(p5) as p5,sum(p6) as p6,  ;
		sum(p7) as p7, sum(p8) as p8,sum(p9) as p9, sum(p10) as p10, sum(p11) as p11,sum(p12) as p12,  ;
		sum(p13) as p13, sum(p14) as p14,sum(p15) as p15, EGN_usuario,idusuario,nomape ;
		from mwkEvolNur01 group by fechaev,EGN_usuario  into cursor mwkEvolNur
		
	select fechaev,EGN_fechaH,EGN_proto, EGN_usuario,idusuario,nomape ;
		from mwkEvolNur01 group by EGN_proto,EGN_usuario into cursor mwkEvolNurcp0

	select count(1) as cantp, fechaev ,EGN_proto, EGN_usuario,idusuario,nomape ;
		from mwkEvolNurcp0  group by fechaev ,EGN_usuario into cursor mwkEvolNurcp

	select mwkEvolNur.*,cantp from mwkEvolNur,mwkEvolNurcp ;
	where mwkEvolNur.fechaev = mwkEvolNurcp.fechaev and  ;
	mwkEvolNur.EGN_usuario = mwkEvolNurcp.EGN_usuario ;
	into cursor mwkprodnur
endif
if used ('mwkEvolNurcp0')
	use in mwkEvolNurcp0
endif
if used ('mwkEvolNurcp')
	use in mwkEvolNurcp
endif
if used ('mwkEvolNur')
	use in mwkEvolNur
endif
if used ('mwkEvolNur01')
	use in mwkEvolNur01
endif
if used ('mwkEvolNur0')
	use in mwkEvolNur0
endif
select * from dias left join mwkprodnur on fecha = fechaev  into cursor mwklista
if used ('mwkprodnur')
	use in mwkprodnur
endif
	
