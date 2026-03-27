for j= 1 to 500
	select tabgcproc  &&& solo tipo = 2
	locate for id = j
	if found()
		for i = 1 to 200
			select * from tabgcgupo where idgrupo = i and iddocumento=j into cursor esta
			if reccount('esta')=0
				insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values (i,ctod("01/01/1900"),j)
			endif
		next i
	endif
next j

for j= 198 to 198
	for i = 1 to 197
		select * from tabgcgupo where idgrupo = i and iddocumento=j into cursor esta
		if reccount('esta')=0
			insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values (i,ctod("01/01/1900"),j)
		endif
	next i
next j

&&&agrego pg

for i = 1 to 300
for ht = 521 to 1500
	insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values (i,ctod("01/01/1900"),ht)
next ht
next i
