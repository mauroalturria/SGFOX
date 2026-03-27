lcSQL = "Select * From tabestados Where propietario = 84 And tipo = 1"
SQLExec(mcon1,lcSQL,"mwkSectores1")

lcSQL = "Select * From tabestados Where propietario = 84"
SQLExec(mcon1,lcSQL,"mwkEstados")

lcSQL = "Select * From tabBeepers Where Bee_fechpasiva = '1900-01-01 00:00:0'"
SQLExec(mcon1,lcSQL,"mwkBeepers")
