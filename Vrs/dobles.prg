SELECT count ( * ) , codreserva , codmed , codprest, fechatur , nombre 
 from turnos left join prestadores on codmed = prestadores . id 
 where turnos.codesp like "OFT%" group by codprest,codreserva having count ( * ) >1