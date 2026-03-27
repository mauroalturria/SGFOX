*
* Elimina ( inicializa a cero Nro. Admision ) en TabHCIArchivo
*

lparameters midar

mret = sqlexec(mcon1,"update TabHCIArchivo set HCI_nroAdm=' ' where id=?midar ")

if mret < 0 
  messagebox("EN ELIMINACION DE LA ADMISION DE ARCHIVO"+chr(10)+;
  "AVISE A SISTEMAS",16,"ERROR")
endif
  