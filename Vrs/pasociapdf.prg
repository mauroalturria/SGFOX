    	set step on
    	select pasarciap2
scan
    micod = codigo
    mides = descripcio
    requery('ciapdes')
    if reccount('ciapdes')>0

        update ciapdes set descripcion = mides
    else
        set step on
    endif
    select pasarciap
endscan
