USE c:\desaguemes\franjadis.dbf IN 0 EXCLUSIVE
UPDATE franjadis SET hdes= TRANSFORM(VAL(hdes),"@L 99")+":00" WHERE AT(":",hdes)=0
UPDATE franjadis SET hhas= TRANSFORM(VAL(hhas),"@L 99")+":00" WHERE AT(":",has)=0
UPDATE franjadis SET hdes= TRANSFORM(VAL(hdes),"@L 99")+":00" WHERE AT(":",hdes)=0
UPDATE franjadis SET hhas= TRANSFORM(VAL(hhas),"@L 99")+":00" WHERE AT(":",hhas)=0
SELECT franjadis.*, nombre FROM franjadis, prestadores WHERE codmed = id INTO CURSOR adis

UPDATE franjadis SET hhdes =VAL(STRTRAN(hdes,":","")),hhhas =VAL(STRTRAN(hhas":",""))
UPDATE franjadis SET hhdes =VAL(STRTRAN(hdes,":","")),hhhas =VAL(STRTRAN(hhas,":",""))

SELECT * FROM franjadis,franja WHERE franja.codmed = franjadis.codmed;
 AND franjadis.dia = franja.diasem AND  (hhdes<hhmmhas and hhhas>hhmmdes) ORDER BY franja.codmed INTO CURSOR arreglo

SELECT hhdes,hhhas,franja.* FROM franjadis,franja WHERE franja.codmed = franjadis.codmed AND;
 franjadis.dia = franja.diasem AND  (hhdes<hhmmhas and hhhas>hhmmdes) ORDER BY franja.codmed INTO CURSOR arreglo2
 
SELECT * FROM arreglo2 WHERE !(hhdes=hhmmdes AND hhhas = hhmmhas) OR (hhdes<hhmmdes AND hhhas>hhmmhas) INTO CURSOR arreglo

 
SELECT * FROM medpresta WHERE STR(codmed)+STR(diasem)+STR(hhmmdes) ;
in ( SELECT   STR(codmed)+STR(diasem)+STR(hhmmdes) FROM arreglo) INTO CURSOR bajapres
BROWSE LAST
SELECT * FROM medpresta WHERE transform(codmed,"@L 9999")+STR(diasem)+STR(hhmmdes) ;
in ( SELECT   transform(codmed,"@L 9999")+STR(diasem)+STR(hhmmdes) FROM arreglo) INTO CURSOR bajapres
SELECT 169
BROWSE LAST
SELECT * FROM medpresta WHERE transform(codmed,"@L 9999")+STR(diasem)+STR(hhmmdes) ;
in ( SELECT   transform(codmed_b,"@L 9999")+STR(diasem)+STR(hhmmdes) FROM arreglo) INTO CURSOR bajapres
BROWSE LAST
SELECT * FROM medpresta WHERE id in (SELECT id FROM bajapres)
UPDATE medpresta SET fecvigenh = CTOD("21/07/2020") WHERE id in (SELECT id FROM bajapres)
SELECT 83
BROWSE LAST
UPDATE franja SET fecvigenh = CTOD("01/01/2100") WHERE id in (SELECT id FROM bajapres)
SELECT * FROM franja WHERE    id in (SELECT id FROM bajapres)
UPDATE medpresta SET fecvigenh = CTOD("01/01/2100") WHERE id in (SELECT id FROM bajapres)
BROWSE LAST
SELECT 171
BROWSE LAST
SELECT * FROM bajapres ORDER BY fecvigenh
SELECT * FROM medpresta WHERE transform(codmed,"@L 9999")+STR(diasem)+STR(hhmmdes);
 in ( SELECT   transform(codmed_b,"@L 9999")+STR(diasem)+STR(hhmmdes) FROM arreglo) INTO CURSOR bajapres
SELECT * FROM medpresta WHERE transform(codmed,"@L 9999")+STR(diasem)+STR(hhmmdes);
 in ( SELECT   transform(codmed_b,"@L 9999")+STR(diasem)+STR(hhmmdes) FROM baja) INTO CURSOR bajapres
BROWSE LAST
UPDATE medpresta SET fecvigenh = CTOD("21/07/2020") WHERE id in (SELECT id FROM bajapres2)
SELECT 167
BROWSE LAST
UPDATE franja SET fecvigenh = CTOD("21/07/2020") WHERE id in (SELECT id FROM baja)
SELECT baja.*,nombre FROM baja,prestadores  WHERE codmed = id INTO CURSOR adista
SELECT baja.*,nombre FROM baja,prestadores  WHERE codmed_b = id INTO CURSOR adista
SELECT baja.*,nombre FROM baja,prestadores  WHERE codmed_b = prestadores.id INTO CURSOR adista
 
SELECT franjadis.*, nombre FROM franjadis, prestadores WHERE codmed_b = id INTO CURSOR adis
SELECT franjadis.*, nombre FROM franjadis, prestadores WHERE codmed  = id INTO CURSOR adis
BROWSE LAST
SELECT 172
BROWSE LAST
COPY TO adista_uno TYPE xl5
USE tipoturno AGAIN IN 0
SELECT Tipoturno
BROWSE LAST
MODIFY VIEW tipoturno
SELECT 125
BROWSE LAST
SELECT * FROM arreglo WHERE hhdes=hhmmdes AND hhhas >= hhmmhas INTO CURSOR baja2
BROWSE LAST
SELECT 169
BROWSE LAST
UPDATE franja SET fecvigenh = CTOD("21/07/2020") WHERE id in (SELECT id FROM baja2)
SELECT baja.*,nombre FROM baja,prestadores  WHERE codmed_b = prestadores.id INTO CURSOR adista_dos
BROWSE LAST
COPY TO adista_dos TYPE xl5
BROWSE LAST
SELECT 169
BROWSE LAST
SELECT 169
BROWSE LAST
SELECT * FROM arreglo WHERE hhdes=hhmmdes INTO CURSOR arre1
BROWSE LAST
SELECT 177
BROWSE LAST
SELECT 177
BROWSE LAST
ON ERROR
SELECT 177
BROWSE LAST
USE DBF('baja2') AGAIN IN 0 ALIAS nuevaf
SELECT 150
BROWSE LAST
UPDATE nuevaf SET hhmmhas = hhdes
SELECT * FROM nuevaf WHERE hhmmhas = hhmmdes
UPDATE nuevaf SET horahasta = CTOT("01/01/1900 "+TRANSFORM(hhmmhas,"99:99))
UPDATE nuevaf SET horahasta = CTOT("01/01/1900 "+TRANSFORM(hhmmhas,"99:99"))
UPDATE nuevaf SET fecvigend = CTOD("22/07/2020")
UPDATE franja SET fecvigenh = CTOD("21/07/2020") WHERE id in (SELECT id FROM nuevaf)
USE DBF('bajapres2') AGAIN IN 0 ALIAS nuevam
BROWSE LAST
SELECT * FROM medpresta WHERE transform(codmed,"@L 9999")+STR(diasem)+STR(hhmmdes);
 in ( SELECT   transform(codmed,"@L 9999")+STR(diasem)+STR(hhmmdes) FROM baja2) INTO CURSOR bajapres2
SELECT 161
USE
SELECT 179
SELECT medpresta.* FROM medpresta WHERE transform(medprestacodmed,"@L 9999")+STR(medprestadiasem)+STR(medprestahhmmdes);
 in ( SELECT   transform(baja2.codmed,"@L 9999")+STR(baja2.diasem)+STR(baja2.hhmmdes) FROM baja2) INTO CURSOR bajapres2
SELECT medpresta.* FROM medpresta WHERE transform(medpresta.codmed,"@L 9999")+STR(medpres.tadiasem)+STR(medpresta.hhmmdes);
 in ( SELECT   transform(baja2.codmed,"@L 9999")+STR(baja2.diasem)+STR(baja2.hhmmdes) FROM baja2) INTO CURSOR bajapres2
SELECT medpresta.* FROM medpresta WHERE transform(medpresta.codmed,"@L 9999")+STR(medpresta.diasem)+STR(medpresta.hhmmdes);
 in ( SELECT   transform(baja2.codmed,"@L 9999")+STR(baja2.diasem)+STR(baja2.hhmmdes) FROM baja2) INTO CURSOR bajapres2
SELECT hhdes,hhhas,medpresta.* FROM medpresta,baja2 WHERE transform(medpresta.codmed,"@L 9999")+STR(medpresta.diasem)+STR(medpresta.hhmmdes);
 = transform(baja2.codmed,"@L 9999")+STR(baja2.diasem)+STR(baja2.hhmmdes)   INTO CURSOR bajapres2
SELECT hhdes,hhhas,medpresta.* FROM medpresta,baja2 WHERE transform(medpresta.codmed,"@L 9999")+STR(medpresta.diasem)+STR(medpresta.hhmmdes);
 = transform(baja2.codmed,"@L 9999")+STR(baja2.diasem)+STR(baja2.hhmmdes) GROUP BY medpresta.id  INTO CURSOR bajapres2
BROWSE LAST
USE DBF('bajapres2') AGAIN IN 0 ALIAS nuevam
UPDATE nuevam SET hhmmhas = hhdes,hdesde1 = CTOT("01/01/1900 "+TRANSFORM(hhmmhas,"99:99")),hhasta1 = CTOT("01/01/1900 "+TRANSFORM(hhmmhas,"99:99")),fecvigend = CTOD("22/07/2020")
SELECT 161
BROWSE LAST
USE
USE DBF('bajapres2') AGAIN IN 0 ALIAS nuevam
BROWSE LAST
USE
SELECT 175
BROWSE LAST
SELECT hhdes,hhhas,medpresta.* FROM medpresta,baja2 WHERE transform(medpresta.codmed,"@L 9999")+STR(medpresta.diasem)+STR(medpresta.hhmmdes);
 = transform(baja2.codmed,"@L 9999")+STR(baja2.diasem)+STR(baja2.hhmmdes) GROUP BY medpresta.id  INTO CURSOR bajapres2
BROWSE LAST
USE DBF('bajapres') AGAIN IN 0 ALIAS nuevam
SELECT 161
BROWSE LAST
USE
SELECT 175
USE
SELECT hhdes,hhhas,medpresta.* FROM medpresta,baja1 WHERE transform(medpresta.codmed,"@L 9999")+STR(medpresta.diasem)+STR(medpresta.hhmmdes);
 = transform(baja1.codmed,"@L 9999")+STR(baja1.diasem)+STR(baja1.hhmmdes) GROUP BY medpresta.id  INTO CURSOR bajapres2
BROWSE LAST
USE DBF('bajapres2') AGAIN IN 0 ALIAS nuevam
SELECT 161
BROWSE LAST
UPDATE medpresta SET fecvigenh = CTOD("21/07/2020") WHERE id in (SELECT id FROM nuevam)
SELECT 83
BROWSE LAST
APPEND FROM DBF('nuevaf')
SELECT 109
APPEND FROM DBF('nuevam')
BROWSE LAST
USE
APPEND FROM DBF('nuevam')
SELECT 161
UPDATE nuevaf SET hhmmhas = hhhas,horahasta = CTOT("01/01/1900 "+TRANSFORM(hhhas,"99:99")), fecvigend = CTOD("22/07/2020") where  hhdes=hhmmdes AND hhhas<hhmmhas
UPDATE nuevaf SET horahasta = CTOT("01/01/1900 "+TRANSFORM(hhmmhas,"99:99"))
UPDATE nuevaf SET fecvigend = CTOD("22/07/2020")
UPDATE franja SET fecvigenh = CTOD("21/07/2020") WHERE id in (SELECT id FROM nuevaf)
SELECT * FROM nuevaf WHERE hhdes=hhmmdes AND hhhas<hhmmhas
UPDATE nuevaf SET hhmmdes = hhhas,horadesde = CTOT("01/01/1900 "+TRANSFORM(hhhas,"99:99")), fecvigend = CTOD("22/07/2020") where hhdes=hhmmdes AND hhhas<hhmmhas

UPDATE nuevaf SET hhmmhas = hhhas,horahasta = CTOT("01/01/1900 "+TRANSFORM(hhhas,"99:99")), fecvigend = CTOD("22/07/2020") where  hhdes=hhmmdes AND hhhas<hhmmhas
SELECT * FROM nuevaf WHERE fecvigenh >CTOD("22/07/2020")

SELECT * FROM nuevam WHERE   hhdes>=hhmmdes AND  hhhas>hhmmhas AND fecvigenh > CTOD("22/07/2020")
UPDATE nuevaf SET imparchivo = 2,hhmmhas = hhdes,horahasta = CTOT("01/01/1900 "+TRANSFORM(hhdes,"99:99"));
, fecvigend = CTOD("22/07/2020") WHERE fecvigenh > CTOD("22/07/2020") AND hhhas<>hhmmdes AND hhdes<>hhmmhas


SELECT * FROM nuevaf WHERE  fecvigenh > CTOD("22/07/2020") AND fecvigend< CTOD("22/07/2020") INTO CURSOR mixtos
USE DBF('mixtos') AGAIN IN 0 ALIAS mixtosf
UPDATE mixtosf SET  imparchivo = 3,hhmmdes = hhhas,horadesde = CTOT("01/01/1900 "+TRANSFORM(hhhas,"99:99")), fecvigend = CTOD("22/07/2020") ;
where  hhhas<hhmmhas
SELECT hhdes,hhhas,medpresta.* FROM medpresta,baja1 WHERE transform(medpresta.codmed,"@L 9999")+STR(medpresta.diasem)+STR(medpresta.hhmmdes);
 = transform(baja1.codmed,"@L 9999")+STR(baja1.diasem)+STR(baja1.hhmmdes) GROUP BY medpresta.id  INTO CURSOR bajapres2
BROWSE LAST
USE DBF('bajapres2') AGAIN IN 0 ALIAS nuevam

UPDATE nuevam SET hhmmhas = hhdes,hhasta1 = CTOT("01/01/1900 "+TRANSFORM(hhdes,"99:99")),horahasta = CTOT(TRANSFORM(hhdes,"99:99")+":00");
, fecvigend = CTOD("22/07/2020") WHERE  hhhas>hhmmhas AND  hhhas<>hhmmdes and hhmmdes < hhdes

UPDATE nuevam SET hhmmdes = hhhas,hdesde1 = CTOT("01/01/1900 "+TRANSFORM(hhhas,"99:99")),horadesde = CTOT(TRANSFORM(hhhas,"99:99")+":00");
, fecvigend = CTOD("22/07/2020") WHERE  hhhas<hhmmhas AND  hhhas<>hhmmdes and hhmmdes > hhdes 

USE DBF('mixtosm3') AGAIN IN 0 ALIAS mixtosmn3


UPDATE mixtosmn3 SET   hhmmdes = hhhas,hdesde1 = CTOT("01/01/1900 "+TRANSFORM(hhhas,"99:99")),horadesde = CTOT(TRANSFORM(hhhas,"99:99")+":00");
, fecvigend = CTOD("22/07/2020");
where  hhhas<hhmmhas

UPDATE nuevam SET hhmmhas = hhdes,hhasta1 = CTOT("01/01/1900 "+TRANSFORM(hhdes,"99:99")),horahasta = CTOT(TRANSFORM(hhdes,"99:99")+":00");
, fecvigend = CTOD("22/07/2020") WHERE id in (select id from mixtosm )

UPDATE mixtosmn3 SET hhmmhas = hhdes,hhasta1 = CTOT("01/01/1900 "+TRANSFORM(hhdes,"99:99")),horahasta = CTOT(TRANSFORM(hhdes,"99:99")+":00");
, fecvigend = CTOD("22/07/2020")  

UPDATE medpresta SET fecvigenh = CTOD("21/07/2020") WHERE id in (SELECT id FROM nuevam) 


SELECT faltaf.hhmmdes as hd,faltaf.hhmmhas as hdh, arreglo.* FROM arreglo,faltaf WHERE arreglo.codmed = faltaf.codmed AND;
 faltaf.diasem = arreglo.diasem AND faltaf.hhmmdes= arreglo.hhmmdes ORDER BY arreglo.codmed,arreglo.diasem,arreglo.hhmmdes ;
 GROUP BY arreglo.id  INTO CURSOR arreglom
 
UPDATE arrefmm SET hhmmhas = hdh,horahasta = CTOT("01/01/1900 "+TRANSFORM(hdh,"99:99"));
, fecvigend = CTOD("22/07/2020") 

SELECT sobraf.hhmmdes as hd,sobraf.hhmmhas as hdh, arreglo.* FROM arreglo,sobraf WHERE arreglo.codmed = sobraf.codmed AND;
 sobraf.diasem = arreglo.diasem AND sobraf.hhmmdes= arreglo.hhmmdes ORDER BY arreglo.codmed,arreglo.diasem,arreglo.hhmmdes ;
 GROUP BY arreglo.id  INTO CURSOR arreglom
 
 SELECT sobraf.hhmmdes as hd,sobraf.hhmmhas as hdh,sobraf.fecvigend as fvd,sobraf.fecvigenh as fvh,  medpresta.* FROM medpresta,sobraf WHERE medpresta.codmed = sobraf.codmed  AND medpresta.diasem =sobraf.diasem AND (medpresta.hhmmdes =sobraf.hhmmdes ;
or medpresta.hhmmhas =sobraf.hhmmhas) AND medpresta.fecvigenh = CTOD("21/07/2020") INTO CURSOR arremf


USE DBF('cambio') AGAIN IN 0 ALIAS nuevo
hdd = 1700
hdh= 1800
 
  fvd = CTOD("22/07/2020")
   fvh = CTOD("01/01/2100")
UPDATE nuevo SET hhmmhas = hdh,hhasta1 = CTOT("01/01/1900 "+TRANSFORM(hdh,"99:99")),horahasta = TRANSFORM(hdh,"99:99")+":00";
 ,hhmmdes = hdd,hdesde1 = CTOT("01/01/1900 "+TRANSFORM(hdd,"99:99")),horadesde = TRANSFORM(hdd,"99:99")+":00";
, fecvigend = fvd, fecvigenh = fvh
SELECT medpresta
APPEND FROM DBF('nuevo')
REQUERY('medpresta')


SELECT arreglo 
SCAN
IF duracion_a<>'00:00:04'
midura = duracion_a
mid = id_b
UPDATE medpresta SET duracion = midura WHERE id = mid
endif
ENDSCAN
REQUERY('medpresta')


********baja franjas
SELECT bajas
SCAN

mimed = codmed
midia = diasem
mihd = hhmmdes
mihh = hhmmhas
mifecd = fecvigend
mifech = fecvigenh
UPDATE  franja SET fecvigenh =  ctod("22/02/2021"),usuario = "*"+usuario  WHERE mimed = codmed AND;
midia = diasem and mihd = hhmmdes AND mihh = hhmmhas AND ;
mifecd = fecvigend AND mifech = fecvigenh
UPDATE   medpresta SET fecvigenh =  ctod("22/02/2021"),cantidad = 3 WHERE mimed = codmed AND;
midia = diasem and mihd = hhmmdes AND mihh = hhmmhas AND ;
mifecd = fecvigend AND mifech = fecvigenh
endscan