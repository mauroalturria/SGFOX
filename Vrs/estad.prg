create table estad (aniomes c(6),canti n(4))
FOR I =1 to 52	
	nam = alias(i)
	if !empty(nam)
		select &nam
	*	set step on
		if left(nam,1)="A"
			mcant = cant
			insert into estad (aniomes ,canti ) values (substr(nam,2,6),mcant)
		endif	
	endif	
next i