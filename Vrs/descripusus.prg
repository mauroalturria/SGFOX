SELECT arreglo
SCAN
micod = codigovax_a
mides = descr
UPDATE tabusuario SET descrip = mides WHERE codigovax = micod
endscan