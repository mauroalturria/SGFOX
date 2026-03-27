*
* Busco Estado para ver quien fue el Firmante
*
Parameters midpres, mestadoactu

If vartype(mestadoactu)#"C"
	mestadoactu = "3,22,2"
Endif

*
* Firmas de Ususarios (Presupuestos)
*
* Tipos : 2 - Director Médico
*         3 - Director Administrativo
*

mctrlfec = sp_busco_fecha_serv('DD') - 1

Use in select("mwkUsuarioDire")
Use in select("mwkUsuarioDire2")
Use in select("mwkUsuarioDire3")

mret = sqlexec(mcon1,"select * from Tabpauditoria"+;
	" left outer join tabusuario on tabusuario.id = Tabpauditoria.usuario"+;
	" where idpres = ?midpres and estadoactual IN ( " + mestadoactu + " ) ","mwkUsuarioDire")

If mret < 0
	=aerr(eros)
	Messagebox(eros(3))
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
	Return .F.
Endif

mret = sqlexec(mcon1,"select * from tabusuariofirma"+;
	" where TUF_fecpasiva > ?mctrlfec and TUF_tipo in (0,2,3)","mwkUsuarioDire2")

If mret < 0
	=aerr(eros)
	Messagebox(eros(3))
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
	Return .F.
Endif


Select * from mwkUsuarioDire ;
	left join mwkUsuarioDire2 on TUF_codigovax = codigovax ;
	into cursor mwkUsuarioDire3
