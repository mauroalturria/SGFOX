Hola:
Esto es lo que he encontrado sobre la fecha Julina en un libro muy antiguo,
pero puede ser de ayuda:

José Scaliger propuso, en 1582, una escala de tiempo continua, de 7980 años
julianos de 365,25 días, que comienza el 1 de enero del año 4713 a. de C.
A esta escala de tiempo la llamó "período julino" en honor de su padre
Julio.
Para obtener el día juliono (DJ) de un año A de nuestro calendario basta con
aplicar las siguiente reglas:

1.- Se calcula el producto (4712 + A) * 365,25
2.- Si el resultado es un número entero se le resta 1, y si es decimal, se
toma su parte entera.
3.- Si el año es siguiente al de la reforma gregoriana (04/10/1582) se
tienen que realizar las siguientes operaciones a continuación del anterior:

        1583 <= A <= 1700 ............... Se resta 10 (*)
        1701 <= A >= 1800 ............... Se resta 11
        1801 <= A >= 1900 ............... Se resta 12
        1901 <= A >= 2100 ............... Se resta 13
        2101 <= A <= 2200 ................ Se resta 14 , etc.

(*) Se bebe restar 10 cuando A >= 1583, y también si a = 1582, siempre que
se verifique M > 10 ó M = 10 y D >= 15

4.- Se suma el resultado, el número de días transcurridos desde el comienzo
del año A.

Para determinar el día de la semana basta con dividir por 7 el día juliano
DJ, y según sea el resto, se harán estas asignaciones:
0 ......... Lunes
1 ......... Martes
2 ......... Miércoles
3 ......... Jueves
4 ......... Viernes
5 ......... Sábado
6 ......... Domingo

qdia = cTOD("14/07/2006")
DJ = FLOOR(((YEAR(qdia)-1846)*365.25)-.01)+ qdia -(ctod("01/01/"+transf(year(qdia),"9999"))-1)
messagebox(transform(dj))

?sys(1)
