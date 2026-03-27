*
* Armado de cursores Provincias, Localidades
*

if used('mwkTabPcia')
  use in mwkTabPcia
endif

&& Despues hay que cambiarla por TabPcia cuando Nico migre los datos

mret = sqlexec(mcon1,"select ID as pciaID,* from TabPcia1"+;
" order by descrip","mwkTabPcia")
if mret < 0
  messagebox("ERROR EN CURSOR DE PROVINCIAS",0+48,"Validación")
  return
endif

if used('mwkTabLoca')
  use in mwkTabLoca
endif

&& Despues hay que cambiarla por TabLoca cuando Nico migre los datos

mret = sqlexec(mcon1,"select * from TabLoca1"+;
" order by descrip","mwkTabLoca")
if mret < 0
  messagebox("ERROR EN CURSOR DE LOCALIDADES",0+48,"Validación")
  return
endif
  