*
* Impresión de protocolos ordenados
*
Public mresplog

mresplog = 0

If !used('mwkusuario')
	Do form frmloguin1 with 'CONSULTAS'
Endif

If mresplog = 0

	marchivo = GETFILE('dbf','Maestro','Imprimir') && protoamb.dbf

	If empty(marchivo)
		Do sp_desconexion
		Close databases
		Wait windows "Proceso cancelado ..." timeout 5
		Return .F.
	Endif
set step on
*!*		Select hclinica,protocolo,;
*!*			replicate('0',11-len(alltrim(hclinica)))+alltrim(hclinica) as hclinica2;
*!*			from c:\protocolos\protoamb into cursor mwkpprotoA

	Select hclinica,protocolo,;
		replicate('0',11-len(alltrim(hclinica)))+alltrim(hclinica) as hclinica2;
		from &marchivo into cursor mwkpprotoA

	Select protocolo,hclinica,hclinica2,;
		left(right(hclinica2,4),2) as ord1,;
		left(right(hclinica2,5),1) as ord2 ;
		from mwkpprotoA into cursor mwkpprotoA2

	Select protocolo,hclinica,ord1,ord2 from mwkpprotoA2;
		order by ord1, ord2, hclinica2 into cursor mwkprotoA3

	Select mwkprotoA3
	Scan all
		Wait window "Protocolo "+mwkprotoA3.protocolo nowait
		Do form c:\desaguemes\scx\frmconsul15Pro with mwkprotoA3.protocolo, 0
		Select mwkprotoA3
	Endscan
	
	Do sp_desconexion
	Close databases
Endif
