select * from turnos where codmed=90 and afiliado=0
 and tipoturNO=9 and usuarioobserva='MRO_MASIVA'
 and fechatur>=to_date("03/06/2005","dd/mm/yyyy")
 and diasem=6 
 
 para los viernes primero que son PE controlar que no exista el turno
 para los miercoles verificar que si es hora no 15 30 45 es sobreturno