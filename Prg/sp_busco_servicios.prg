
mret = sqlexec(mcon1," select ser_descripserv,ser_codserv from servicios where ser_codserv in " +;
" (6300,7700,79000,7100,6900,6500,7800,4700,7200,3340,5163) ", "mwkservicios")

if mret<1
   =aerr(eros)
   messagebox(eros(2))
endif