Parameters dat_vale1, item_vale1

Select VapHead1
Zap

Select VapHead2
Zap

Select VapPres3
Zap

mNombreOperador = mwkusu.nomape

mcodpun = val(dat_vale1(25))

If used('mwkvalobs')
	Use in mwkvalobs
Endif

mret = sqlexec(mcon1,"select * from TabValObs where TVO_Codpun=?mcodpun","mwkvalobs")

If mret < 0
	Messagebox("ERROR EN BUSQUEDA, MAESTRO DE VALES OBSERV.",0,"Validacion")
Else
	If reccount('mwkvalobs')=0
		mobser2 = ''
	Else
		mobser2 = alltrim(mwkvalobs.TVO_Obser)
	Endif
	Use in mwkvalobs
Endif

If len(alltrim(mobser2))>0
	dat_vale1(15) = dat_vale1(15) + ' - ' + mobser2
Endif

murgencia  = iif(dat_vale1(14)='N',0,1)
mfechasoli = ctod(dat_vale1(4))
mcodservic = mwkconsu.ser_codserv

Insert into VapHead1 (Pun,NroVale,SeqVerif,FechaSolic,HoraSolic,Urgencia,IdOperador,NomOperador,IdPrstdor,NomPrstdor,;
	Comentario,Bono,MnemoServ,IdServ,NomServ,NroProtoc,OrdDup) ;
	Values (val(dat_vale1(25)),val(dat_vale1(1)),val(dat_vale1(24)),mfechasoli,dat_vale1(5),murgencia,val(dat_vale1(23)),mNombreOperador,;
	dat_vale1(20),dat_vale1(21),dat_vale1(15),dat_vale1(22),dat_vale1(2),mcodservic,dat_vale1(3),dat_vale1(16),'D')

mTipopac = mwkconsu.VAL_tipopaciente
mCodAdmi = mwkconsu.VAL_codadmision
mCodSect = mwkconsu.VAL_codsector
mCodHab  = mwkconsu.VAL_habitacion
mCodCam  = mwkconsu.VAL_cama

If used('mwkdsector')
	Use in mwkdsector
Endif

mret=sqlexec(mcon1,"select * from SECTORES where SEC_codsector=?mCodSect","mwkdsector")

If mret < 0
	Messagebox('ERROR DE GENERACION DE CURSOR, REINTENTE',16,'VALIDACION')
	Return
Endif

Select mwkdsector
mDesSect = mwkdsector.SEC_descripsec

Insert into VapHead2 (TipoPac,NroAdm,NombrePac,Sexo,Edad,NroHClinica,CodSector,NomSector,Habitacion,Cama,;
	CodEntidad,NomEntidad,NroAfiliado) ;
	Values (mTipopac,mCodAdmi,dat_vale1(11),dat_vale1(9),val(dat_vale1(10)),dat_vale1(8),mCodSect,mDesSect,;
	mCodHab,mCodCam,val(dat_vale1(12)),dat_vale1(13),dat_vale1(7))

For mind = 1 to alen(item_vale1,1)

	micodigo = val(item_vale1(mind,1))
	midescri = item_vale1(mind,2)
	micantid = val(item_vale1(mind,3))

	If micodigo > 0
		Insert into VapPres3 (CodPrest,DescPrest,Cantidad) values (micodigo,midescri,micantid)
	Endif

Endfor

Return
