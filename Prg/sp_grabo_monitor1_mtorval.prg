Parameters dat_vale1, item_vale1

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
		mobser2 = Alltrim(Nvl(mwkvalobs.tvo_obser,''))
	Endif
	Use In mwkvalobs
Endif
midaut  =0
If Len(Alltrim(mobser2))>0
	dat_vale1(15) = dat_vale1(15) + ' - ' + mobser2
Endif
If Left(dat_vale1(15),11)='AUT.AC Nro:'
	If At(",",dat_vale1(15))>0
		midaut = Val(Substr(dat_vale1(15),12,At(",",dat_vale1(15))-12))
	Else
		midaut = Val(Substr(dat_vale1(15),12))
	Endif
Else
	mposac = At("AC N:",dat_vale1(15))
	If mposac >0
		If At(",",dat_vale1(15))>0 And At(",",dat_vale1(15)) > mposac
			midaut = Val(Substr(dat_vale1(15),mposac +5,(At(",",dat_vale1(15))-mposac -5)))
		Else
			midaut = Val(Substr(dat_vale1(15),mposac +5))
		Endif
	Endif
Endif

Select mwkconsu3
Locate For val_codvaleasist = mnvale
murgencia  = Iif(dat_vale1(14)='N',0,1)
mfechasoli = Ctod(dat_vale1(4))
mcodservic = Nvl(mwkconsu3.ser_codserv,0)

Insert Into vapduphead1 (pun,nrovale,seqverif,fechasolic,horasolic,urgencia;
	,idoperador,nomoperador,idprstdor,nomprstdor,;
	comentario,bono,mnemoserv,idserv,nomserv,nroprotoc,orddup) ;
	values (Val(dat_vale1(25)),Val(dat_vale1(1)),Val(dat_vale1(24));
	,mfechasoli,dat_vale1(5),murgencia,mcodigovax,mnombreoperador,;
	dat_vale1(20),dat_vale1(21),dat_vale1(15),dat_vale1(22),dat_vale1(2);
	,mcodservic,dat_vale1(3),dat_vale1(16),'D')

mtipopac = mwkconsu3.val_tipopaciente
mcodadmi = mwkconsu3.val_codadmision
mcodsect = mwkconsu3.val_codsector
mcodhab  = mwkconsu3.val_habitacion
mcodcam  = mwkconsu3.val_cama
maislado = Nvl(mwkconsu3.pac_categoria,'')
If Used('mwkdsector')
	Use In mwkdsector
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
	codcontrato,nomcontrato,nroafiliado,Categoria,nrodocumento  ) ;
	values (mtipopac,mcodadmi,dat_vale1(11),dat_vale1(9),Val(dat_vale1(10));
	,dat_vale1(8),mcodsect,mdessect,;
	mcodhab,mcodcam,Val(dat_vale1(12)),dat_vale1(13),dat_vale1(7), maislado,Val(dat_vale1(28)) )
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
			clado = prg_busco_dato_estsolic(mcodadmi ,midaut ,micodigo,mnvale ,1)
			Insert Into vapduppres3 (codprest,descprest,cantidad,codlado);
				values (micodigo,midescri,micantid,clado)
		Endif
	Endif
Endfor

If Reccount('VapDupPres3') >0
	Select * From vapduppres3, vapduphead1, vapduphead2 Into Cursor mwklistadup
Else
	Select * From vapdupinsu4, vapduphead1, vapduphead2 Into Cursor mwklistadup
Endif

Return

