msg = 'Procedimiento PES. '+chr(10)+chr(10)+;
'1 - Si Ud no es MePes y terminó su intervención, derivar al paciente a MePes. '+chr(10)+'    Recetario: Turno MePes ' +chr(10)+chr(10)+;
'2 - Si Ud lo tiene que recitar, aclarar en recetario: “Turno con Dr... Ud/o profesional de la misma especialidad"' 
mret = sqlexec(mcon1,"update TabRegAdvMed set tram_mensaje = ?msg where id = 6")
=aerr(eros)
messagebox(eros(3))
 - Si Ud no es MePes y terminó su intervención, derivar al paciente a MePes. Recetario: Turno MePes    
 - Si Ud lo tiene que recetar,aclarar en recetario: “Turno con Dr... Ud/o profesional de la misma especialidad"