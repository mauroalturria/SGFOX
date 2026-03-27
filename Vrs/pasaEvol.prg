Select ambevolshadow
Set Step On
Use ambevolmed Again In 0
Use ambevolmedhis Again In 0 
SCAN 
mproto = ambevolshadow.EA_protocolo
	REQUERY('ambevolmedhis')
	SELECT ambevolmed 
	APPEND FROM DBF('ambevolmedhis')
Endscan