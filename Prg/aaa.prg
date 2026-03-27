

select mwkusuariosall
locate for codigovax = mcodigovax
if found()
	mnombreoperador = mwkusuariosall.nomape
else
	mnombreoperador = mwkusu.nomape
endif
dat_valem(1)= nrovale
dat_valem(2)	= mnemoserv
dat_valem(3) = nomserv
dat_valem(4) = transf(mfechasoli)
dat_valem(5)	= horasolic
dat_valem(6)	= nroadm
dat_valem(7)	= transf(nroafiliado)
dat_valem(8)	= nrohclinica 
dat_valem(9)	= sexo
dat_valem(10)	= transf(edad)
dat_valem(11)	= nombrepac
dat_valem(12)	= transf(codcontratocodcontrato)
dat_valem(13)	= nomcontrato
dat_valem(14)	= 
dat_valem(15) 	= comentario
dat_valem(16) = nroprotoc 
dat_valem(17)	= 
dat_valem(18)	= 
dat_valem(19)	= 
dat_valem(20) = transf(idprstdor)
dat_valem(21)	= nomprstdor
dat_valem(22)	= bono
dat_valem(23) = mcodigovax 
dat_valem(24)= transf(seqverif)
dat_valem(25) = pun

mcodcam			= cama
mcodhab			= habitacion
mcodigovax= idoperador
mcodsect		= codsector
mcodservic	= idserv
mdessect		= nomsector
mfechasoli, =  fechasolic
murgencia  = iif(dat_valem(14)='N',0,1)
orddup

mind = 1
select vapduppres3
	item_valem(mind,1)	= codprest
	item_valem(mind,2)	=  cantidad
	item_valem(mind,3) 	= descprest
	mind = mind + 1
scan

