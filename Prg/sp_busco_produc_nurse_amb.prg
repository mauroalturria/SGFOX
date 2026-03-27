****
** Busco evoluciones de enfermeria por rango de fechas
****

parameter mfecdes,mfechas,musu,mopcion,mfiltro
mbusco  = ''
if musu >0
	mbusco  = ' and ean_usuario = ?musu '
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
mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif 


mret = sqlexec(mcon1, "SELECT TabambEvolnurse .*,idusuario,nomape from TabambEvolnurse "+;
	"inner join tabambulatorio on Tabambulatorio.protocolo = Tabambevolnurse.EAN_proto  " + ;
	"inner join tabusuario on TabambEvolnurse.ean_usuario = tabusuario.codigovax  " + ;
	" where ean_fechah >= ?mf1 and  ean_fechah < ?mf2 "+mbusco + mccpoamb +;
	"", "mwkEvolNur01")
if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
endif
select ean_evolNurse, iif(at('C.S.V.',ean_evolNurse)> 0,1,0) as c0,ttod(ean_fechaH) as fechaev,ean_fechaH,val(substr(ean_parAdmF,1,1)) as a1, val(substr(ean_parAdmF,2,1)) as a2,;
	val(substr(ean_parAdmF,3,1)) as a3, val(substr(ean_parAdmF,4,1)) as a4, val(substr(ean_parAdmF,5,1)) as a5, ;
	val(substr(ean_parAdmF,6,1)) as a6, val(substr(ean_parAdmF,7,1)) as a7, val(substr(ean_parAdmF,8,1)) as a8, ;
	val(substr(ean_parAdmF,9,1)) as a9, val(substr(ean_parAdmF,10,1)) as a10, val(substr(ean_parAdmF,11,1)) as a11, ;
	ean_parAlerg,ean_parAlergQue, ean_parFreCard, ean_parFreResp, ean_parGluc,ean_parPeso,;
	val(substr(ean_parOtros,1,1)) as p1, val(substr(ean_parOtros,2,1)) as p2,val(substr(ean_parOtros,3,1)) as p3,  ;
	iif(at('C.S.V.',ean_evolNurse)> 0,0,1) as p4, ;
	ean_parSatur, ean_parTemAxl,ean_parTemBuc, ean_parTensDia, ean_parTensSis,;
	ean_proto, ean_usuario,idusuario,nomape from mwkEvolNur01 into cursor mwkEvolNur0

select * from mwkEvolNur0 &mfiltro  into cursor mwkEvolNur01

if mopcion = 1
	select fechaev,sum(c0) as c0, sum(a1) as a1, sum(a2) as a2,sum(a3) as a3, sum(a4) as a4, sum(a5) as a5, ;
		sum(a6) as a6, sum(a7) as a7, sum(a8) as a8, sum(a9) as a9, sum(a10) as a10, sum(a11) as a11, ;
		sum(p1) as p1, sum(p2) as p2,sum(p3) as p3, sum(p4) as p4, ean_usuario,idusuario,nomape ;
		from mwkEvolNur01 group by fechaev into cursor mwkEvolNur
		
	select fechaev,ean_fechaH,ean_proto, ean_usuario,idusuario,nomape ;
		from mwkEvolNur01 group by ean_proto into cursor mwkEvolNurcp0

	select count(1) as cantp, fechaev,ean_proto, ean_usuario,idusuario,nomape ;
		from mwkEvolNurcp0  group by fechaev  into cursor mwkEvolNurcp

	select mwkEvolNur.*,cantp from mwkEvolNur,mwkEvolNurcp ;
	where mwkEvolNur.fechaev = mwkEvolNurcp.fechaev ;
	into cursor mwkprodnur
	
else
	select fechaev,sum(c0) as c0, sum(a1) as a1, sum(a2) as a2,sum(a3) as a3, sum(a4) as a4, sum(a5) as a5, ;
		sum(a6) as a6, sum(a7) as a7, sum(a8) as a8, sum(a9) as a9, sum(a10) as a10, sum(a11) as a11, ;
		sum(p1) as p1, sum(p2) as p2,sum(p3) as p3, sum(p4) as p4, ean_usuario,idusuario,nomape ;
		from mwkEvolNur01 group by fechaev,ean_usuario  into cursor mwkEvolNur
		
		
	select fechaev,sum(c0) as c0, sum(a1) as a1, sum(a2) as a2,sum(a3) as a3, sum(a4) as a4, sum(a5) as a5, ;
		sum(a6) as a6, sum(a7) as a7, sum(a8) as a8, sum(a9) as a9, sum(a10) as a10, sum(a11) as a11, ;
		sum(p1) as p1, sum(p2) as p2,sum(p3) as p3, sum(p4) as p4, ean_usuario,idusuario,nomape,ean_proto ;
		from mwkEvolNur01 group BY ean_proto,idusuario INTO CURSOR mwkEvolNurdet
		
		select * from dias left join mwkEvolNurdet on fecha = fechaev ;
		ORDER BY nomape asc into cursor mwkEvolNurdet 
		
	select fechaev,ean_fechaH,ean_proto, ean_usuario,idusuario,nomape ;
		from mwkEvolNur01 group by ean_proto,ean_usuario into cursor mwkEvolNurcp0

	select count(1) as cantp, fechaev ,ean_proto, ean_usuario,idusuario,nomape ;
		from mwkEvolNurcp0  group by fechaev ,ean_usuario into cursor mwkEvolNurcp

	select mwkEvolNur.*,cantp from mwkEvolNur,mwkEvolNurcp ;
	where mwkEvolNur.fechaev = mwkEvolNurcp.fechaev and  ;
	mwkEvolNur.ean_usuario = mwkEvolNurcp.ean_usuario ;
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
	
