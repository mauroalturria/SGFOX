for i= 1 to 115
	for j= 1 to 50
		select * from tabgcgupo where idgrupo= j and iddocumento= i into cursor mwkctr
		if reccount('mwkctr')=0
			insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values ( j,ctod("01/01/1900"),i)
		endif
	next j
next i
set step on

for i= 1 to 113
	insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values ( 43,ctod("01/01/1900"),i)
next i
for i= 1 to 113
	insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values ( 44,ctod("01/01/1900"),i)
next i
for i= 1 to 113
	insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values ( 45,ctod("01/01/1900"),i)
next i
for i= 1 to 113
	insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values ( 46,ctod("01/01/1900"),i)
next i
for i= 1 to 113
	insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values ( 47,ctod("01/01/1900"),i)
next i
for i= 1 to 113
	insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values ( 48,ctod("01/01/1900"),i)
next i
for i= 1 to 113
	insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values ( 49,ctod("01/01/1900"),i)
next i
for i= 1 to 113
	insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values ( 50,ctod("01/01/1900"),i)
next i

for i= 1 to 50
	insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values ( i,ctod("01/01/1900"),114)
next i
for i= 1 to 50
	insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values ( i,ctod("01/01/1900"),115)
next i
for i= 1 to 50
	insert into tabgcgupo (idgrupo,fecactiva,iddocumento) values ( i,ctod("01/01/1900"),115)
next i
