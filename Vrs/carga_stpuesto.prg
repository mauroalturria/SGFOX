select amb3ss
set step on
mid = 360
scan
	mmaq = alltrim(transf(mid,"999"))+"X"
	mip = alltrim(ip)
	mubicacion = alltrim(upper(ubica))
	mint = val(telefono)
	mpatch  = alltrim(pachera)
	mpuesto = puesto
	insert into tabstpuesto (Maquina, Observaciones, Puesto, Ubicacion, idModelo,;
	  idSector, interno, nombre, nroserie, pachera, ppuesto, rack, solicencia);
	  values (mmaq,'',mip,mubicacion,11,2115,mint,mubicacion ,'',mpatch  ,mpuesto,"AMB3SS",'' )
	mid = mid +1
	select amb3ss
  
endscan