create table turnos (usuario,dia,cant,dem,vales
select turnosaud
go top
dimension pac(24,30),dem(24,30)
store 0 to pac
store 0 to dem
mifecha = fechatomado
mafi = afiliado
mpacientes = 0
mdemora = 0
mdia = dia
mhora = hora
skip
do while !eof()
	do while !eof() and mafi = afiliado and day(mifecha) = day(fechatomado) 
		mifecha = fechatomado
		mhora = hora
		skip
	enddo
	if (fechatomado-mifecha) < 1800
		pac(mhora,mdia ) = pac(mhora,mdia )+ 1
		dem(mhora,mdia )= dem(mhora,mdia )+ fechatomado-mifecha 
	endif
	mifecha = fechatomado
	mhora = hora
	mafi = afiliado
	mdia = dia
	skip
enddo
for h= 1 to 30
for i=1 to 24
	if pac(i,h)>0
		messagebox("dia:"+ transf(h)+" hora: "+ transf(i)+"  pacientes: "+transf(pac(i,h))+"  demora "+transf(dem(i,h) /pac(i,h)/60,"99,9" ))
	endif
next	
next	