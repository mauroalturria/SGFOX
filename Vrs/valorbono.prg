Select cambio
Set Step On
Scan
	Update tabbono Set importe = cambio.valor,usuario = 'CARMENA',fechagraba = Datetime(),fecvigend = Ctod("01/11/2022");
		where Id = cambio.id_a

Endscan