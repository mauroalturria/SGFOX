*****
* Busco ingresos al call
****
parameters musuario,lssal
mfecha = '1900-01-01 00:00:00'
mwhere = ''
do case 
case lssal = 1
	mwhere  = mwhere + ' horahasta = ?mfecha '
case musuario>0	
	mwhere  = mwhere + iif(!empty(mwhere),' and ','') + ' usuario = ?musuario '
endcase
mwhere  = iif(!empty(mwhere),' where ','') + mwhere  
mret = SQLEXEC(mcon1," select horadesde,{fn HOUR (horahasta)}*100+{fn minute (horahasta)} as horasal"+;
	",interno,ippuesto,nomape,comentarios,"+;
	" horahasta,usuario,TabAccesoInt.id "+;
	" from TabAccesoInt left join tabusuario on tabusuario.codigovax = TabAccesoInt.usuario "+;
	mwhere + " order by nomape,horadesde ","mwkAccesoInt")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
endif





