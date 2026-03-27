*****
**  Ingreso una Pregistracion a la base
*****
do sp_conexion
mret = sqlexec(mcon1, "select * from preregistra where id = 55793","Datos")
select datos
mnroafi= afiliado
mcoddocu= coddocu
mcodent= codent
mloca= codloca
mpcia= codpcia
mcodpos= codpostal
mdomici= direccion
mfecha= fechaalta
mdatet= fechahora
mfecnac= fechanac
mnomb= nombre
mnrodoc= nrodocumento
mtel= telefono
midusu= usuario
msexo = sexo
set step on

mret = sqlexec(mcon1, "insert into preregistra (afiliado, coddocu, codent, codloca, " + ;
					"codpcia, codpostal, direccion, fechaalta, fechahora, fechanac, " + ;
					"nombre, nrodocumento, telefono, usuario, sexo) " + ;
					"values(?mnroafi, ?mcoddocu, ?mcodent, ?mloca, ?mpcia, ?mcodpos, " + ;
					"?mdomici, ?mfecha, ?mdatet, ?mfecnac, ?mnomb, ?mnrodoc, ?mtel, " + ;
					"?midusu, ?msexo)")
						
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
endif
do sp_desconexion						
