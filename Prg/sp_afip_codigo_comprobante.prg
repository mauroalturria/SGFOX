Lparameters letra,comprobante

lcletra = Alltrim(Upper(letra))
lccomprobante = Alltrim(Upper(comprobante))
lccodigoafip = ''

* Tipo de comprobantes de AFIP:

*001 	FACTURAS A
*002 	NOTAS DE DEBITO A
*003 	NOTAS DE CREDITO A
*004 	RECIBOS A
*005 	NOTAS DE VENTA AL CONTADO A
*006 	FACTURAS B
*007 	NOTAS DE DEBITO B
*008 	NOTAS DE CREDITO B
*009 	RECIBOS B
*010 	NOTAS DE VENTA AL CONTADO B
*011 	FACTURAS C
*012 	NOTAS DE DEBITO C
*013 	NOTAS DE CREDITO C
*015 	RECIBOS C
*016 	NOTAS DE VENTA AL CONTADO C

Do Case
Case lcletra = 'A' And lccomprobante = 'FC'
	lccodigoafip = '1'
Case lcletra = 'A' And lccomprobante = 'ND'
	lccodigoafip = '2'
Case lcletra = 'A' And lccomprobante = 'NC'
	lccodigoafip = '3'
Case lcletra = 'A' And lccomprobante = 'R'
	lccodigoafip = '4'

Case lcletra = 'B' And lccomprobante = 'FC'
	lccodigoafip = '6'
Case lcletra = 'B' And lccomprobante = 'ND'
	lccodigoafip = '7'
Case lcletra = 'B' And lccomprobante = 'NC'
	lccodigoafip = '8'
Case lcletra = 'B' And lccomprobante = 'R'
	lccodigoafip = '9'

Case lcletra = 'C' And lccomprobante = 'FC'
	lccodigoafip = '11'
Case lcletra = 'C' And lccomprobante = 'ND'
	lccodigoafip = '12'
Case lcletra = 'C' And lccomprobante = 'NC'
	lccodigoafip = '13'
Case lcletra = 'C' And lccomprobante = 'R'
	lccodigoafip = '14'

Otherwise
	lccodigoafip = .F.
Endcase

Return lccodigoafip
