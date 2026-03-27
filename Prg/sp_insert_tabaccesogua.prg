****
** control de accesos a pacientes de guarda HCE
****
parameter mpcodCIE9, mpcodestado, mpcodmedcie9, mpdiagnostico,mpprotocolo, mpusuario 
if vartype(mpusuario) # "N"
	mpusuario = 0
ENDIF
mpdiagnostico = iif( vartype(mpdiagnostico)="C",alltrim(mpdiagnostico),'')
mpdiagnostico = mpdiagnostico +IIF(LEN(mpdiagnostico)<20," @ "+TRANSFORM(_screen.Height)+"x"+TRANSFORM(_screen.width),"")
mipc =  SYS(0)
mipc = ALLTRIM(left(left(mipc,at("#",mipc)-1)+myip,50))
mpdiagnostico = alltrim(mipc)+"-"+mpdiagnostico
mdiag = separo(mpdiagnostico)
mpfechaMod = sp_busco_fecha_serv('DT')
mret = sqlexec(mcon1, "insert into TabGuardia ( codCIE9 , codestado , codmedcie9 , diagnostico , fechaMod , protocolo , usuario ) "+;
	"values( ?mpcodCIE9 , ?mpcodestado , ?mpcodmedcie9 , "+mdiag +" , ?mpfechaMod , ?mpprotocolo , ?mpusuario )")

function separo(miobserv)
	local mtexto, mtexdos
	if len(alltrim(miobserv))>250
		mtexto = left(alltrim(miobserv),250)
		mtexdos = substr(alltrim(miobserv),251,250)
	else
		mtexto = alltrim(miobserv)
		mtexdos = ""
	endif
	return "{fn CONCAT('"+ mtexto+"','"+ mtexdos +"' )}"
