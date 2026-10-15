* sp_busco_datosDerivPapel
* Carmensuchi, 1/10/2026
Lparameters mAfiliado ,nIdTurno,nnrovale,mbusco

Local mFecha,mCentro,nCodMed,mMatricula,mMedico,nSector,mAfiliado, nCodent, nCodReserva
If Vartype(nnrovale)<>"N"
	nnrovale=0
Endif
If Vartype(nIdTurno)<>"N"
	nIdTurno=0
Endif
If Vartype(mAfiliado )<>"N"
	mAfiliado =0
Endif
If Vartype(mbusco)<>"C"
	mbusco = ''
Endif
If nIdTurno>0
	mbusco = mbusco +' and TDP_IdTurno = ?nIdTurno '
Endif
If nnrovale>0
	mbusco =  mbusco +' and nrovale = ?nnrovale'
Endif
If mAfiliado >0
	mbusco = mbusco + ' and  TDP_Afiliado=?mAfiliado '
Endif

mret = SQLExec(mcon1,"select * from  ZabTurnosDerivPapel where 1=1 "+mbusco+ " order by id ","mwkctrderiv")

If mret < 0
	Messagebox("ERROR GRABAR DATOS DE LA DERIVACION EN PAPEL",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()

Endif
If mAfiliado >0
	Use In Select('mwkDatosMedDeriv')
	Create Cursor mwkDatosMedDeriv(nombre c(50),matricula c(15), IdCodMed N(15), Centro N(3), Sector N(3),Observa c (50),codprest N(10))
	If Reccount("mwkctrderiv")>0
		Select mwkctrderiv
		Go Bott
		Insert Into mwkctrderiv(nombre ,matricula , IdCodMed , Centro , Sector ,Observa ,codprest) Values ;
			( mwkctrderiv.TDP_Medico,mwkctrderiv.TDP_Matricula,mwkctrderiv.TDP_CodMed,mwkctrderiv.TDP_Centro, mwkctrderiv.TDP_Sector,mwkctrderiv.Observa)
	Endif
Endif
