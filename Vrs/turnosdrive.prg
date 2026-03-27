CREATE CURSOR franjas (dia c(10),desde c(5),hasta c(5),horas n(2),nombre c(50),codmed n(5),tipo c(20))
APPEND FROM c:\desaguemes\libro1.txt DELIMITED WITH tab
SELECT * FROM franjas WHERE codmed>0 ORDER BY codmed,dia,desde INTO CURSOR franjasmed
UPDATE franjas SET desde = ALLTRIM(desde)+":00" WHERE AT(':',desde)=0
UPDATE franjas SET hasta = ALLTRIM(hasta)+":00" WHERE AT(':',hasta)=0
UPDATE franjas SET desde = "0"+ALLTRIM(desde)  WHERE LEN(ALLTRIM(desde))=4
UPDATE franjas SET hasta = "0"+ALLTRIM(hasta )  WHERE LEN(ALLTRIM(hasta ))=4
