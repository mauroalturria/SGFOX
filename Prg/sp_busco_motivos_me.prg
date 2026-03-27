****
** busco motivos
****

mret = SQLEXEC(mcon1,"Select motivotext, idmotivo "+;
	"from motivos order by motivotext","mwkmotivos1")
if mret < 0
	=aerr(eros)
	messagebox("Los Motivos no estan  disponibles - Informar a Sistemas",0+64,"Conexion")
endif
