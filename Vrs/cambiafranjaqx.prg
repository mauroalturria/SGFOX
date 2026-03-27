Select tabpqfran
SET STEP ON 
Scan
	If PQF_dia<4
		Loop
	Endif
	mPQF_dia = PQF_dia
	mPQF_quirofano = PQF_quirofano
	mPQF_servicio = PQF_servicio
	mPQF_turno = PQF_turno
	Requery('tabpqquiro14')
	Select Id  From tabpqquiro14 Where Mod(pqq_hora,100)=30 Into Cursor controla
	If Reccount('controla')=0
		Update tabpqquiro14 Set pqq_referencia = 1 Where pqq_referencia = 0
		Select tabpqquiro14
		GO TOP
		Requery('tabpqquiro10')
		Select PQQ_estado, PQQ_fecha,pqq_hora+30 As pqq_hora,PQQ_quirofano,1 As pqq_referencia, PQQ_servicio,PQQ_turno;
			FROM tabpqquiro10 Into Cursor nuevo
		Select tabpqquiro10
		Append From Dbf('nuevo')
		Requery('tabpqquiro10')
		Requery  ('tabpqfranserv')
		Select tabpqfranserv
		Append  From Dbf('tabpqfranserv')
		Requery  ('tabpqfranserv')
		Set Step On
		Update tabpqquiro10 Set pqq_referencia = 0 Where pqq_referencia = 1
	Endif
	Select tabpqfran
Endscan

