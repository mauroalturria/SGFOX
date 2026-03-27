lparameters mot,motadd,mfechahora,mObservaciones 

mret = SQLEXEC(mcon1,"select MAX(fechasolucion) AS fecsolu from tabmantenimiento where otadd = ?motadd or id = ?motadd ","mwkvalidOtAdd")
mfecsolu = TTOD(fecsolu) +  15
mfechaGarantia = TTOD(mfechahora) 
IF mfecsolu < mfechaGarantia 
   MESSAGEBOX("NO PUEDE AÑADIRSE OTRA ORDEN YA QUE VENCIÓ LA GARANTIA",48,"Validación")
   RETURN 
ENDIF 
if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
ENDIF

mret = sqlexec(mcon1," insert into tabmantadd(idot,otadd,fechahora,Observaciones )"+; 
" values(?mot,?motadd,?mfechahora,?mObservaciones ) ")

if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
endif

