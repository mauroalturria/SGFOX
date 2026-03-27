* armo la cabecera de anamnesis

parameters miedit,lctabanam,lctabint,lctabveop

if vartype(lctabanam)#"C"
	lctabanam = 'mwkanam'
endif
if vartype(lctabint)#"C"
	lctabint= 'mwkinterna'
endif
if vartype(lctabveop)#"C"
	lctabveop= 'mwkevolprot'
endif
miedit= 'Ingreso a '+nvl(&lctabint..ih_secagrup,'')+chr(13)
mingreso = ''
select (lctabveop)
go top

mddescie = ''
if used('mwkCie9i')
	select mwkcie9i
	locate for id = nvl(&lctabveop..ih_motingreso ,1)
	if !found()
		select mwkcie9a
		locate for id = nvl(&lctabveop..ih_motingreso ,1)
	endif
	mddescie = descrip
endif
mhoraing = nvl(&lctabveop..ih_fechahoraing,mwkfecserv.fechahora)

mimedico = &lctabveop..ih_codmed
select mwkmedicoint
mimedant = mwkmedicoint.id
locate for id = mimedico
cnmed = mwkmedicoint.nombre
cnmlmat = mwkmedicoint.matricula

locate for id = mimedant
select (lctabveop)
go top
if !used('mwkprocede')
	do sp_busco_estados with 25,' and tipo = 2 order by estado ','mwkprocede'
endif

select mwkprocede
locate for id = nvl(&lctabveop..ih_procedencia ,1)
if eof()
	go top
endif


if reccount(lctabanam )>0
	select (lctabanam )
	mhoraing = nvl(ia_fechahora,mhoraing)

	miedit= miedit+transform(mhoraing )+ ' '+alltrim(cnmed)+" M.N.:"+ transform(cnmlmat)+chr(13)
	if used ('mwkreingre')
		miedit= miedit+'Procedencia: ' + alltrim(mwkprocede.descrip)+" Reingreso:"+ iif(reccount('mwkreingre')>0, "Si","No")+;
			" post cx:"+ iif(nvl(ia_postcx,0) = 1, "Si","No")+chr(13)
	else
		miedit= miedit+'Procedencia: ' + alltrim(mwkprocede.descrip)+;
			" post cx:"+ iif(nvl(ia_postcx,0) = 1, "Si","No")+chr(13)
	endif
	miedit= miedit+'Motivo de Ingreso: ' + alltrim(mddescie )+chr(13)+chr(13)
Endif

Return miedit
