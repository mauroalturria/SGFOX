
	Do sp_busco_estados With 26 ,"  order by TIPO,descrip  ","mwkrubros"  &&& sub estados administrativos
midrubro = mwkrecetaserv.idrubro 
Select mwkrubros
Locate For estado =  idrubro
If Eof()
	Go Top
Endif
mdescrubro =mwkrubros.Descrip
Select mwkrecetaserv

And idrubro = midrubro
