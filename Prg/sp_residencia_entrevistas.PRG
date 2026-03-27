*
* Datos de Examinados y elegidos para entrevistar
*

if used('mwkentre1')
  use in mwkentre1
endif

mret = sqlexec(mcon1," select TBE_apellido,TBE_nombre,TBE_dni,TBE_especialidad,INS_Universidad,INS_OtraUniv,"+;
"INS_FecNac,INS_FecEgreso,INS_PromSIAR,TBE_puntaje,TBE_incorrectas, TBE_tema "+; 
"from TabResProfexa,TabResInscrip where TBE_entrevista='S' and INS_numero=TBE_dni "+;
"order by TBE_especialidad, TBE_apellido","mwkentre1")

&& and TBE_tema<>'F' 