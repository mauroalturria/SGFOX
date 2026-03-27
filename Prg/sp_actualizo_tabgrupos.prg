****
** actualizo las tablas de tabgrupo y tabnivel
****

Parameter mdescri, mno, mso, mst, mgi, mes, mps, mre, mpe, mti,mtpo,mte,mhs,midgru,mtl,m17,m18,m19,m20,m21,m22,m23,m24,m25,m26

If midgru = 0

	mret = SQLExec(mcon1, "insert into tabgrupos (descrip) values(?mdescri)")

	mret = SQLExec(mcon1, "select * from tabgrupos where descrip = ?mdescri", "mwkveo")

	mnivel = mwkveo.Id

Else

	mnivel = midgru

	mret = SQLExec(mcon1, "delete from tabnivel where nivel = ?mnivel")

	mret = SQLExec(mcon1, "update tabgrupos set descrip = ?mdescri where id = ?mnivel")

Endif

If mno = 1
	mtp = 0
	mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
		"values(?mnivel, ?mtp)")
Endif
If mso = 1
	mtp = 1
	mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
		"values(?mnivel, ?mtp)")
Endif
If mst = 1
	mtp = 2
	mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
		"values(?mnivel, ?mtp)")
Endif
If mgi = 1
	mtp = 3
	mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
		"values(?mnivel, ?mtp)")
Endif
If mes = 1
	mtp = 4
	mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
		"values(?mnivel, ?mtp)")
Endif
If mps = 1
	mtp = 5
	mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
		"values(?mnivel, ?mtp)")
Endif
If mre = 1
	mtp = 6
	mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
		"values(?mnivel, ?mtp)")
Endif
If mpe = 1
	mtp = 7
	mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
		"values(?mnivel, ?mtp)")
Endif
If mti = 1
	mtp = 8
	mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
		"values(?mnivel, ?mtp)")
Endif
If mtpo = 1
	mtp = 13
	mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
		"values(?mnivel, ?mtp)")
Endif
If mte = 1
	mtp = 14
	mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
		"values(?mnivel, ?mtp)")
Endif
If mhs = 1
	mtp = 15
	mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
		"values(?mnivel, ?mtp)")
Endif
If mtl = 1
	mtp = 16
	mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
		"values(?mnivel, ?mtp)")
Endif
For indx = 17 To 26
	mcpo = 'm'+Transform(indx)
	If Type(mcpo)="N"
		If &mcpo =1
			mtp = indx
			mret = SQLExec(mcon1, "insert into tabnivel(nivel, tipoturno) " + ;
				"values(?mnivel, ?mtp)")
		Endif
	Endif
Next






