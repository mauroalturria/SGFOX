parameters dat_vale1, item_vale1,mOrdDup 

if vartype(mOrdDup)#"C"
	mOrdDup = "O"
endif
mcodpun    = val(dat_vale1(25))
mnvale     = val(dat_vale1(1))
mcodigovax = val(dat_vale1(23))

select mwkusuariosall
locate for codigovax = mcodigovax
if found()
	mnombreoperador = mwkusuariosall.nomape
else
	mnombreoperador = mwkusu.nomape
endif

if used('mwkvalobs')
	use in mwkvalobs
endif

mret = sqlexec(mcon1,"select * from tabvalobs where tvo_codpun=?mcodpun","mwkvalobs")

if mret < 0
	messagebox("error en busqueda, maestro de vales observ.",48,"validacion")
else
	if reccount('mwkvalobs')=0
		mobser2 = ''
	else
		mobser2 = alltrim(mwkvalobs.tvo_obser)
	endif
	use in mwkvalobs
endif

if len(alltrim(mobser2))>0
	dat_vale1(15) = dat_vale1(15) + ' - ' + mobser2
endif

select mwkconsu6
locate for val_codvaleasist = mnvale
murgencia  = iif(dat_vale1(14)='N',0,1)
mfechasoli = ctod(dat_vale1(4))
mcodservic = mwkconsu6.val_codservvale

insert into vaphead1 (pun,nrovale,seqverif,fechasolic,horasolic,urgencia;
	,idoperador,nomoperador,idprstdor,nomprstdor,;
	comentario,bono,mnemoserv,idserv,nomserv,nroprotoc,orddup) ;
	values (val(dat_vale1(25)),val(dat_vale1(1)),val(dat_vale1(24));
	,mfechasoli,dat_vale1(5),murgencia,mcodigovax,mnombreoperador,;
	dat_vale1(20),dat_vale1(21),dat_vale1(15),dat_vale1(22),dat_vale1(2);
	,mcodservic,dat_vale1(3),dat_vale1(16),mOrdDup)

mtipopac = mwkconsu6.val_tipopaciente
mcodadmi = mwkconsu6.val_codadmision
mcodsect = mwkconsu6.val_codsector
mcodhab  = mwkconsu6.val_habitacion
mcodcam  = mwkconsu6.val_cama

if used('mwkdsector')
	use in mwkdsector
endif

mret = sqlexec(mcon1,"select * from sectores where sec_codsector=?mcodsect","mwkdsector")

if mret < 0
	messagebox('error de generacion de cursor, reintente',16,'validacion')
	return
endif

select mwkdsector
mdessect = mwkdsector.sec_descripsec

insert into vaphead2 (tipopac,nroadm,nombrepac,sexo,edad,nrohclinica;
	,codsector,nomsector,habitacion,cama,;
	codcontrato,nomcontrato,nroafiliado) ;
	values (mtipopac,mcodadmi,dat_vale1(11),dat_vale1(9),val(dat_vale1(10));
	,dat_vale1(8),mcodsect,mdessect,;
	mcodhab,mcodcam,val(dat_vale1(12)),dat_vale1(13),dat_vale1(7))

for mind = 1 to alen(item_vale1,1)
	if !empty(item_vale1(mind,1))
		midescri = item_vale1(mind,3)
		micantid = val(item_vale1(mind,2))
		if upper(dat_vale1(2))='FA' && mwkconsu3.ser_codserv = 5410  && farmacia
			micodigo = item_vale1(mind,1)
			insert into vapinsu4 (tiporeg,codinsumo,descinsumo,cantidad);
				values (4,micodigo,midescri,micantid)
		else
			micodigo = val(item_vale1(mind,1))
			insert into vappres3 (codprest,descprest,cantidad);
				values (micodigo,midescri,micantid)
		endif
	endif
endfor

select * from vaphead1 group by pun  into cursor vaphead1
select * from vaphead2 group by nroadm into cursor vaphead2
select * from vappres3 group by codprest into cursor vappres3
select * from vapinsu4 group by codinsumo into cursor vapinsu4

if reccount('vappres3') >0
	select * from vappres3, vaphead1, vaphead2 into cursor mwklistamvbg
else
	select * from vapinsu4, vaphead1, vaphead2 into cursor mwklistamvbg
endif

return

