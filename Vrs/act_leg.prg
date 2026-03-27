COPY TO prestadores
USE
USE c:\desaguemes\prestadores.dbf IN 0 EXCLUSIVE

SELECT * FROM prestadores,legajos  WHERE (cuil = leg_cuit AND VAL(cuil )>0) OR (VAL(expression_4) =leg_nrodoc AND VAL(expression_4)>0) INTO CURSOR cosas
SELECT cosas 
SCAN
	mid = id
	mileg = leg_id
	UPDATE prestadores SET nrolegajo = mileg WHERE id = mid
endscan
SELECT * FROM prestadores,legajos  ;
	WHERE (cuil = leg_cuit AND VAL(cuil )>0) OR (VAL(SUBSTR(cuil,4,8)) =leg_nrodoc AND VAL(cuil)>0) INTO CURSOR cosas
SELECT * FROM prestadores,campus  ;
	WHERE (cuil = cuit AND VAL(cuil )>0) OR ( nrodoc= VAL(SUBSTR(cuil,4,8)) AND VAL(SUBSTR(cuil,4,8))>0) INTO CURSOR cosas2
SELECT * FROM prestadores,view6  ;
	WHERE (cuil = sf_cuil AND VAL(cuil )>0) OR ( VAL(sf_dni)= VAL(SUBSTR(cuil,4,8)) AND VAL(SUBSTR(cuil,4,8))>0) INTO CURSOR cosas3
	
UPDATE prestadores SET cuil = nvl(cuil,'')
UPDATE prestadores SET nrodoc = VAL(SUBSTR(cuil,4,8))
SELECT cosas
SCAN
	mid = id
	mileg = leg_id
	UPDATE prestadores SET nrolegajo = mileg WHERE id = mid
ENDSCAN
SELECT cosas2
SCAN
	mid = id
	mileg = legajo
	UPDATE prestadores SET nrolegajo = mileg WHERE id = mid AND ISNULL(nrolegajo)
ENDSCAN
SELECT cosas3
SCAN
	mid = id
	mileg = VAL(sf_legajo)
	UPDATE prestadores SET nrolegajo = mileg WHERE id = mid AND ISNULL(nrolegajo)
ENDSCAN

SELECT * FROM prestadores WHERE nrolegajo = 0 INTO CURSOR sl
SELECT * FROM sl,campusn WHERE ape = apellido AND nom = nombre INTO CURSOR joinss
SELECT * FROM sl,campusn WHERE ape = apellido AND nom =campusn.nombre INTO CURSOR joinss
BROWSE LAST
SELECT * FROM sl,campusn WHERE ape = apellido INTO CURSOR joins
BROWSE LAST
SELECT * FROM sl,campusn WHERE ape = apellido AND id NOT in (SELECT id FROM joinss) INTO CURSOR joins

SELECT * FROM tabusuario LEFT JOIN prestadores ON idcodmed = prestadores.id WHERE idcodmed#351 AND (idcodmed in (SELECT idmed FROM medico) OR idcodmed in (SELECT tai_codmed FROM ambu) ) ;
ORDER BY fecexpira INTO CURSOR activo

SELECT activo
SCAN
	mid = codigovax 
	mileg = NVL(nrolegajo,0)
	midoc = IIF(!ISNULL(cuil),VAL(SUBSTR(cuil,4,8)),0)
	UPDATE tabusuario SET leg_id = mileg WHERE codigovax = mid AND NVL(leg_id,0)=0
	UPDATE tabusuario  SET nrodocumento= midoc  WHERE codigovax = mid AND NVL(nrodocumento,0)=0
ENDSCAN


SELECT tabusuario
SCAN
	mid = codigovax 
	mileg = NVL(leg_id,0)
	midoc = NVL(nrodocumento,0)
	UPDATE tabusuario350 SET leg_id = mileg WHERE codigovax = mid AND NVL(leg_id,0)=0
	UPDATE tabusuario350 SET nrodocumento= midoc  WHERE codigovax = mid AND NVL(nrodocumento,0)=0
ENDSCAN

	UPDATE tabusuario_med SET nrodocumento= VAL(SUBSTR(cuil,4,8))
	UPDATE tabusuario_med SET leg_id = nrolegajo 
	
SELECT legajos
SCAN
	mid = id 
	mileg = VAL(sf_legajo)
	UPDATE tabusuario SET leg_id = mileg WHERE id = mid  
ENDSCAN


SELECT *,VAL(SUBSTR(sf_cuil,4,8)) as docu FROM succes WHERE VAL(SUBSTR(sf_cuil,4,8))>0 INTO CURSOR succ
BROWSE LAST
SELECT *,INT(VAL(SUBSTR(sf_cuil,4,8))) as docu FROM succes WHERE VAL(SUBSTR(sf_cuil,4,8))>0 INTO CURSOR succ
BROWSE LAST
SELECT * FROM tabusuario,succ   WHERE leg_id #VAL(sf_legajo) AND nrodocumento = docu  ORDER BY nrodocumento  INTO CURSOR legajos
BROWSE LAST
MODIFY VIEW prestacion
SELECT * FROM legajos GROUP BY nrodocumento HAVING COUNT(id)>1 INTO CURSOR dobles
SELECT * FROM legajos where nrodocumento in(SELECT nrodocumento  FROM dobles) INTO CURSOR doblesdoc
BROWSE LAST
