Criterios para realizar cirugia en CPC:
- Edad > 16 años
- Cirugía de complejidad menor y mediana (ver anexo)
- No debe requerir internación
- Postoperatorio Ambulatorio o en Recuperación Postanestésica 2 hs
- No debe requerir Anatomía Patológica intraoperatoria
- No debe requerir Hemoderivados
- No debe tener Alergia al Látex



$lcsql = "SELECT count(Guardia.codestado) as pacientes
From SQLUser.Guardia Guardia
INNER Join SQLUser.PRESTACIONS Prestacions On Guardia.codprest = Prestacions.PRE_codprest
And Prestacions.PRE_especialidad = '$mCodEsp'
Where Guardia.fechahoraing >= DATEADD('dd',-1,CURRENT_DATE)
And Guardia.fechahoraing <= '$mFechaReg'
And Guardia.codestado = 1
And Guardia.nroregistrac <> $mNroReg";

$lcsql2 = "SELECT count( Zabguardiadom.codestado) AS pacientes2
From SQLUser.ZabGuardiaDom Zabguardiadom
INNER Join SQLUser.PRESTACIONS Prestacions
On Zabguardiadom.codprest = Prestacions.PRE_codprest
And Prestacions.PRE_especialidad = '$mCodEsp'
Where Zabguardiadom.codestado = 1
And Zabguardiadom.nroregistrac <> $mNroReg
And Zabguardiadom.fechahoraing >= DATEADD('dd',-1,CURRENT_DATE)
And Zabguardiadom.fechahoraing <= '$mFechaReg'";
