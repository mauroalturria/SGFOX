CLEAR
DEFINE WINDOW wPrimaria1 ;
   FROM 26, 2 TO 33, 50 ;
   TITLE "Primaria1"         && Ventana primaria.
ACTIVATE WINDOW wPrimaria1 
DEFINE WINDOW wPrimaria ;
   FROM 26, 65 TO 33, 116 ;
   TITLE "Primaria"         && Ventana primaria.
ACTIVATE WINDOW wPrimaria 
WAIT WINDOW 'Presione una tecla para borrar la ventana'
RELEASE WINDOW wPrimaria1 ,wPrimaria 
CLEAR


