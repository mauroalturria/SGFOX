Parameters dat_vale1, item_vale1,codserv,paccateg,codadmision,habitacion,cama,mvale

If Used('VAPDUPHead1')
	Use In vapduphead1
Endif

If Used('VAPDUPHead2')
	Use In vapduphead2
Endif

If Used('VAPDUPPres3')
	Use In vapduppres3
Endif

If Used('VapDUPInsu4')
	Use In vapdupinsu4
Endif

Select * From vaphead1 Where 1 = 2 Into Cursor dvaphead1
Use Dbf('dVapHead1') In 0 Again Alias vapduphead1
Select vapduphead1

Select * From vaphead2 Where 1 = 2 Into Cursor dvaphead2
Use Dbf('dVapHead2') In 0 Again Alias vapduphead2
Select vapduphead2

Select * From vappres3 Where 1 = 2 Into Cursor dvappres3
Use Dbf('dVapPres3') In 0 Again Alias vapduppres3
Select vapduppres3

Select * From vapinsu4 Where 1 = 2 Into Cursor dvapinsu4
Use Dbf('dVapInsu4') In 0 Again Alias vapdupinsu4
Select vapdupinsu4

mcodpun = Val(dat_vale1(25))
mnvale  = Val(dat_vale1(1))
mcodigovax = Val(dat_vale1(23))

Select mwkusuariosall
Locate For codigovax = mcodigovax
If Found()
	mnombreoperador = mwkusuariosall.nomape
Else
	mnombreoperador = mwkusu.nomape
Endif
If Used('mwkvalobs')
	Use In mwkvalobs
Endif

mret = SQLExec(mcon1,"select * from TabValObs where TVO_Codpun=?mcodpun","mwkvalobs")

If mret < 0
	Messagebox("ERROR EN BUSQUEDA, MAESTRO DE VALES OBSERV.",48,"Validacion")
Else
	If Reccount('mwkvalobs')=0
		mobser2 = ''
	Else
		mobser2 = Alltrim(mwkvalobs.tvo_obser)
	Endif
	Use In mwkvalobs
Endif

If Len(Alltrim(mobser2))>0
	dat_vale1(15) = dat_vale1(15) + ' - ' + mobser2
Endif
*!*	select mwkconsu3
*!*	locate for val_codvaleasist = mnvale

murgencia  = Iif(dat_vale1(14)='N',0,1)
mfechasoli = Ctod(dat_vale1(4))
*mcantidad  = GETWORDCOUNT(codserv,",")
lncantipal = 0
lnfin      = 10

lncantipal = OCCURS(",",codserv)
For i = 1 To lncantipal+1
	If i <= lncantipal
		lnposfinal = Atc(",",codserv,i)
		If i = 1
			mcodservic = Substr(codserv,1,lnposfinal-1)&&mwkconsu3.ser_codserv
		Else
			lnposf = lnposfinal - 1
			lnposi = lnposfinalant + 1
			nreturn=(lnposf-lnposi)+1
			mcodservic = Substr(codserv,lnposi,nreturn)
		Endif
	ELSE
		IF lncantipal=0
		lnposfinal = 0
		mcodservic = Substr(codserv,1)
		ELSE 
			lnposf = lnposfinal - 1
			mcodservic = Substr(codserv,lnposf+2)
		ENDIF 
	Endif
	mcodservic = Val(mcodservic)
	Insert Into vapduphead1 (pun,nrovale,seqverif,fechasolic,horasolic,urgencia;
		,idoperador,nomoperador,idprstdor,nomprstdor,;
		comentario,bono,mnemoserv,idserv,nomserv,nroprotoc,orddup) ;
		values (Val(dat_vale1(25)),Val(dat_vale1(1)),Val(dat_vale1(24));
		,mfechasoli,dat_vale1(5),murgencia,mcodigovax,mnombreoperador,;
		dat_vale1(20),dat_vale1(21),dat_vale1(15),dat_vale1(22),dat_vale1(2);
		,mcodservic,dat_vale1(3),dat_vale1(16),'D')
	lnposfinalant = lnposfinal
Next

mret=SQLExec(mcon1,"select val_tipopaciente,val_codsector,val_codadmision,val_habitacion,"+;
	" val_cama from valesasist where val_codvaleasist=?mnvale","mwkdatovale")
If mret<1
	Messagebox('ERROR DE GENERACION DE CURSOR, REINTENTE',16,'VALIDACION')
	RETURN .f.
Endif
Select mwkdatovale
Go Top
mtipopac = mwkdatovale.val_tipopaciente
mcodadmi = mwkdatovale.val_codadmision
mcodsect = mwkdatovale.val_codsector
mcodhab  = mwkdatovale.val_habitacion
mcodcam  = mwkdatovale.val_cama
maislado = paccateg
If Used('mwkdsector')
	Use In mwkdsector
Endif
If Used('mwkdatovale')
	Use In mwkdatovale
Endif
mret=SQLExec(mcon1,"select * from SECTORES where SEC_codsector=?mCodSect","mwkdsector")

If mret < 0
	Messagebox('ERROR DE GENERACION DE CURSOR, REINTENTE',16,'VALIDACION')
	Return
Endif

Select mwkdsector
mdessect = mwkdsector.sec_descripsec

Insert Into vapduphead2 (tipopac,nroadm,nombrepac,sexo,edad,nrohclinica;
	,codsector,nomsector,habitacion,cama,;
	codcontrato,nomcontrato,nroafiliado,Categoria  ) ;
	values (mtipopac,mcodadmi,dat_vale1(11),dat_vale1(9),Val(dat_vale1(10));
	,dat_vale1(8),mcodsect,mdessect,;
	mcodhab,mcodcam,Val(dat_vale1(12)),dat_vale1(13),dat_vale1(7), maislado )

For mind = 1 To Alen(item_vale1,1)
	If !Empty(item_vale1(mind,1))
		midescri = item_vale1(mind,3)
		micantid = Val(item_vale1(mind,2))
		If dat_vale1(2)='FA' && mwkconsu3.ser_codserv = 5410  && Farmacia
			micodigo = item_vale1(mind,1)
			Insert Into vapdupinsu4 (tiporeg,codinsumo,descinsumo,cantidad);
				values (4,micodigo,midescri,micantid)
		Else
			micodigo = Val(item_vale1(mind,1))
			Insert Into vapduppres3 (codprest,descprest,cantidad);
				values (micodigo,midescri,micantid)
		Endif
	Endif
Endfor

If Reccount('VapDupPres3') >0
	Select * From vapduppres3, vapduphead1, vapduphead2 Into Cursor mwklistadup
Else
	Select * From vapdupinsu4, vapduphead1, vapduphead2 Into Cursor mwklistadup
Endif

Return
