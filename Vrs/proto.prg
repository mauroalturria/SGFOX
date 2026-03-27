create cursor protos (proto c (10),tipo c (1))
cuantos = adir(lista, "c:\temphce\086*.pdf")
for i = 1 to cuantos
	miprot = left(lista(i,1),10)
	mlen = substr(lista(i,1),12,1)
	insert into protos values (miprot,mlen)
next 
cuantos = adir(lista, "c:\temphce\087*.pdf")
for i = 1 to cuantos
	miprot = left(lista(i,1),10)
	mlen = substr(lista(i,1),12,1)
	insert into protos values (miprot,mlen)
next 
cuantos = adir(lista, "c:\temphce\088*.pdf")
for i = 1 to cuantos
	miprot = left(lista(i,1),10)
	mlen = substr(lista(i,1),12,1)
	insert into protos values (miprot,mlen)
next 
cuantos = adir(lista, "c:\temphce\089*.pdf")
for i = 1 to cuantos
	miprot = left(lista(i,1),10)
	mlen = substr(lista(i,1),12,1)
	insert into protos values (miprot,mlen)
next 