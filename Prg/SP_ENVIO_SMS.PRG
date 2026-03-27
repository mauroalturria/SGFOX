Parameters tnPort, tcDestino, tcTexto, tcResu

Set Step On

LOCAL oExcep as Exception
 
*!*	*!*	tcDestino="61642980"
*!*	tcDestino="48887177"
*!*	tcTexto="SG. prueba 1"
*!*	tnPort = 12
 
oCom = CREATEOBJECT("MSCOMMLib.MSComm")
 
oCom.CommPort = tnPort
oCom.Settings = "9600,N,8,1"
*oCom.Settings = "460800,N,8,1"
 
tcResu=""

TRY
  IF oCom.PortOpen = .F.
      oCom.PortOpen = .T.
  ENDIF
 
 
     oCom.Output ="AT" + CHR(13)
      
     Inkey(.1)
 
*!*	     DO WHILE .T.
*!*	        a=oCom.input()
*!*	        ?a + "_"
*!*	        DO CASE
*!*	        CASE "ERROR" $ a
*!*	              THROW "ENVIANDO AT : "+a + CHR(13)
*!*	             
*!*	        CASE "OK" $ a OR !EMPTY(a)
*!*	              tcResu=tcResu+"ENVIANDO AT : "+ a + CHR(13)
*!*	              EXIT
*!*	        OTHERWISE
*!*	              DOEVENTS
*!*	        Endcase
*!*	     ENDDO

     oCom.Output ="ATZ" + CHR(13)
	 INKEY(.1)
 
*!*	      DO WHILE .T.
*!*	            a=ALLTRIM(oCom.input())
*!*	            DO CASE
*!*	            CASE "ERROR" $ a
*!*	                  THROW "ENVIANDO ATZ : "+a + CHR(13)
*!*	                 
*!*	            CASE "OK" $ a OR !EMPTY(a)
*!*	                  tcResu=tcResu+"ENVIANDO ATZ : "+ a + CHR(13)
*!*	                  EXIT
*!*	            OTHERWISE
*!*	                  DOEVENTS
*!*	            ENDCASE
*!*	      ENDDO
 
 
      oCom.Output ="AT+CMGF=1" + CHR(13)
	  INKEY(.1) 
	  
*!*	      DO WHILE .T.
*!*	            a=ALLTRIM(oCom.input())
*!*	            DO CASE
*!*	            CASE "ERROR" $ a
*!*	                  THROW "CONFIGURANDO MODO TEXTO : "+a + CHR(13)
*!*	                 
*!*	            CASE "OK" $ a OR !EMPTY(a)
*!*	                  tcResu=tcResu+"CONFIGURANDO MODO TEXTO : " + a + CHR(13)
*!*	                  EXIT
*!*	            OTHERWISE
*!*	                  DOEVENTS
*!*	            ENDCASE
*!*	      ENDDO
*!*	 	
 	  oCom.Output ="AT+CSCA=+54079000801" + CHR(13)
INKEY(.1)
 	  
*!*	      DO WHILE .T.
*!*	            a=ALLTRIM(oCom.input())
*!*	            DO CASE
*!*	            CASE "ERROR" $ a
*!*	                  THROW "SERVIDOR : "+a + CHR(13)
*!*	            CASE "OK" $ a OR !EMPTY(a)
*!*	                  tcResu=tcResu+"SERVIDOR :" + a + CHR(13)
*!*	                  EXIT
*!*	            OTHERWISE
*!*	                  DOEVENTS
*!*	            ENDCASE
*!*	      ENDDO
 
 
      *- Número de destino al que enviamos el mensaje
 
      oCom.Output = "AT+CMGS=" +'"'+ tcDestino+'"' + CHR(13)
      INKEY(.1)
      
*!*	      DO WHILE .T.
*!*	            a=ALLTRIM(oCom.input())
*!*	            DO CASE
*!*	            CASE "ERROR" $ a
*!*	                  THROW "TELEFONO DESTINO : "+a + CHR(13)
*!*	            CASE "OK" $ a OR !EMPTY(a)
*!*	                  tcResu=tcResu+"TELEFONO DESTINO :" + a + CHR(13)
*!*	                  EXIT
*!*	            OTHERWISE
*!*	                  DOEVENTS
*!*	            ENDCASE
*!*	      ENDDO
     
 
      *-  Texto que queremos enviar (acabado con CTRL + Z)
 
      oCom.Output = tcTexto + CHR(26)+CHR(13)
 	INKEY(.1)
 
*!*	      DO WHILE .T.
*!*	            a=ALLTRIM(oCom.input())
*!*	            DO CASE
*!*	            CASE "ERROR" $ a
*!*	                  THROW "ENVIANDO MENSAJE : "+a + CHR(13)
*!*	            CASE "OK" $ a OR !EMPTY(a)
*!*	                  tcResu=tcResu+"ENVIANDO MENSAJE : "+a + CHR(13)
*!*	                  EXIT
*!*	            OTHERWISE
*!*	                  DOEVENTS
*!*	            ENDCASE
*!*	      ENDDO
      tcResu=tcResu+"MENSAJE ENVIADO"
CATCH TO oExcep
      tcResu=tcResu+oExcep.Message+CHR(13)
FINALLY
      IF oCom.PortOpen
            oCom.PortOpen = .F.
      ENDIF
     
*      WAIT "terminado " WINDOW  Nowait && TIMEOUT 3
Endtry

*!*	_cliptext = tcResu
*!*	?tcResu