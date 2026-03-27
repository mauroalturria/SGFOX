****
** Busco Evoluciones de Enfermería Ambulatorio, por rango de fechas
****
Parameter mfecdes, mfechas, musu, mopcion, mfiltro

*Set step on

mbusco  = ''
If musu >0
	mbusco  = ' and EAN_usuario = ?musu '
Endif

mf1 = prg_dtoc(mfecdes)
mf2 = prg_dtoc(mfechas+1)

If used('dias')
	Use in dias
Endif

Create cursor dias (fecha D, diasem n )
For i = 0 to mfechas - mfecdes
	mdias = mfecdes + i
	Insert into dias ( fecha,diasem  ) values ( mdias, dow(mdias) )
Next

mret = sqlexec(mcon1, "SELECT TabAmbEvolnurse .*,idusuario,nomape from TabAmbEvolnurse "+;
	"left join tabusuario on TabAmbEvolnurse.EAN_usuario = tabusuario.codigovax  " + ;
	" where ean_fechah >= ?mf1 and  ean_fechah < ?mf2 "+mbusco +;
	"", "mwkEvolNur01")

If mret < 0
	=aerr(eros)
	Messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
Endif

Select EAN_evolNurse, iif(at('C.S.V.',EAN_evolNurse)> 0,1,0) as c0,ttod(EAN_fechaH) as fechaev,;
	EAN_fechaH,val(substr(EAN_parAdmF,1,1)) as a1, val(substr(EAN_parAdmF,2,1)) as a2,;
	val(substr(EAN_parAdmF,3,1)) as a3, val(substr(EAN_parAdmF,4,1)) as a4, val(substr(EAN_parAdmF,5,1)) as a5, ;
	val(substr(EAN_parAdmF,6,1)) as a6, val(substr(EAN_parAdmF,7,1)) as a7, val(substr(EAN_parAdmF,8,1)) as a8, ;
	val(substr(EAN_parAdmF,9,1)) as a9, val(substr(EAN_parAdmF,10,1)) as a10, val(substr(EAN_parAdmF,11,1)) as a11, ;
	EAN_parAlerg,EAN_parAlergQue, EAN_parFreCard, EAN_parFreResp, EAN_parGluc,EAN_parPeso,;
	val(substr(EAN_parOtros,1,1)) as p1, val(substr(EAN_parOtros,2,1)) as p2,val(substr(EAN_parOtros,3,1)) as p3,  ;
	val(substr(EAN_parOtros,4,1)) as p4, val(substr(EAN_parOtros,5,1)) as p5,val(substr(EAN_parOtros,6,1)) as p6,  ;
	val(substr(EAN_parOtros,7,1)) as p7, val(substr(EAN_parOtros,8,1)) as p8,val(substr(EAN_parOtros,9,1)) as p9,  ;
	val(substr(EAN_parOtros,10,1)) as p10, val(substr(EAN_parOtros,11,1)) as p11,val(substr(EAN_parOtros,12,1)) as p12,  ;
	val(substr(EAN_parOtros,13,1)) as p13, val(substr(EAN_parOtros,14,1)) as p14,val(substr(EAN_parOtros,15,1)) as p15,  ;
	EAN_parSatur, EAN_parTemAxl,EAN_parTemBuc, EAN_parTensDia, EAN_parTensSis,;
	EAN_proto, EAN_usuario,idusuario,nomape from mwkEvolNur01 into cursor mwkEvolNur0
	
	*EAN_parTemRct,

Select * from mwkEvolNur0 &mfiltro  into cursor mwkEvolNur01

If mopcion = 1

	Select fechaev,sum(c0) as c0, sum(a1) as a1, sum(a2) as a2,sum(a3) as a3, sum(a4) as a4, sum(a5) as a5, ;
		sum(a6) as a6, sum(a7) as a7, sum(a8) as a8, sum(a9) as a9, sum(a10) as a10, sum(a11) as a11, ;
		sum(p1) as p1, sum(p2) as p2,sum(p3) as p3, sum(p4) as p4, sum(p5) as p5,sum(p6) as p6,  ;
		sum(p7) as p7, sum(p8) as p8,sum(p9) as p9, sum(p10) as p10, sum(p11) as p11,sum(p12) as p12,  ;
		sum(p13) as p13, sum(p14) as p14,sum(p15) as p15, EAN_usuario,idusuario,nomape ;
		from mwkEvolNur01 group by fechaev into cursor mwkEvolNur

	Select fechaev,EAN_fechaH,EAN_proto, EAN_usuario,idusuario,nomape ;
		from mwkEvolNur01 group by EAN_proto into cursor mwkEvolNurcp0

	Select count(1) as cantp, fechaev,EAN_proto, EAN_usuario,idusuario,nomape ;
		from mwkEvolNurcp0  group by fechaev  into cursor mwkEvolNurcp

	Select mwkEvolNur.*,cantp from mwkEvolNur,mwkEvolNurcp ;
		where mwkEvolNur.fechaev = mwkEvolNurcp.fechaev ;
		into cursor mwkprodnur

Else

	Select fechaev,sum(c0) as c0, sum(a1) as a1, sum(a2) as a2,sum(a3) as a3, sum(a4) as a4, sum(a5) as a5, ;
		sum(a6) as a6, sum(a7) as a7, sum(a8) as a8, sum(a9) as a9, sum(a10) as a10, sum(a11) as a11, ;
		sum(p1) as p1, sum(p2) as p2,sum(p3) as p3, sum(p4) as p4, sum(p5) as p5,sum(p6) as p6,  ;
		sum(p7) as p7, sum(p8) as p8,sum(p9) as p9, sum(p10) as p10, sum(p11) as p11,sum(p12) as p12,  ;
		sum(p13) as p13, sum(p14) as p14,sum(p15) as p15, EAN_usuario,idusuario,nomape ;
		from mwkEvolNur01 group by fechaev,EAN_usuario  into cursor mwkEvolNur

	Select fechaev,sum(c0) as c0, sum(a1) as a1, sum(a2) as a2,sum(a3) as a3, sum(a4) as a4, sum(a5) as a5, ;
		sum(a6) as a6, sum(a7) as a7, sum(a8) as a8, sum(a9) as a9, sum(a10) as a10, sum(a11) as a11, ;
		sum(p1) as p1, sum(p2) as p2,sum(p3) as p3, sum(p4) as p4, sum(p5) as p5,sum(p6) as p6,  ;
		sum(p7) as p7, sum(p8) as p8,sum(p9) as p9, sum(p10) as p10, sum(p11) as p11,sum(p12) as p12,  ;
		sum(p13) as p13, sum(p14) as p14,sum(p15) as p15, EAN_usuario,idusuario,nomape,EAN_proto ;
		from mwkEvolNur01 group BY EAN_proto,idusuario INTO CURSOR mwkEvolNurdet

	Select * from dias left join mwkEvolNurdet on fecha = fechaev ;
		ORDER BY nomape asc into cursor mwkEvolNurdet

	Select fechaev,EAN_fechaH,EAN_proto, EAN_usuario,idusuario,nomape ;
		from mwkEvolNur01 group by EAN_proto,EAN_usuario into cursor mwkEvolNurcp0

	Select count(1) as cantp, fechaev ,EAN_proto, EAN_usuario,idusuario,nomape ;
		from mwkEvolNurcp0  group by fechaev ,EAN_usuario into cursor mwkEvolNurcp

	Select mwkEvolNur.*,cantp from mwkEvolNur,mwkEvolNurcp ;
		where mwkEvolNur.fechaev = mwkEvolNurcp.fechaev and  ;
		mwkEvolNur.EAN_usuario = mwkEvolNurcp.EAN_usuario ;
		into cursor mwkprodnur
Endif

If used ('mwkEvolNurcp0')
	Use in mwkEvolNurcp0
Endif
If used ('mwkEvolNurcp')
	Use in mwkEvolNurcp
Endif
If used ('mwkEvolNur')
	Use in mwkEvolNur
Endif
If used ('mwkEvolNur01')
	Use in mwkEvolNur01
Endif
If used ('mwkEvolNur0')
	Use in mwkEvolNur0
Endif

Select * from dias left join mwkprodnur on fecha = fechaev  into cursor mwklista

If used ('mwkprodnur')
	Use in mwkprodnur
Endif