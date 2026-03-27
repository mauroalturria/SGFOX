MODIFY VIEW tabinthce
 
SELECT * FROM tabintplplan into CURSOR agregoplan readwrite

UPDATE agregoplan  SET pp_admision = '641370-5',pp_idevol =       263039
APPEND FROM DBF('agregoplan')
 
SELECT * FROM tabintnut into CURSOR agregonut readwrite

UPDATE agregonut SET in_idevol = 263036,in_fechahoraapli = CTOD("01/01/1900")
APPEND FROM DBF('agregonut')
  
SELECT * FROM tabintpmsol into CURSOR agregosol readwrite

UPDATE agregosol SET ps_admision = '641370-5',ps_idevol = 263039
APPEND FROM DBF('agregosol')

 SELECT * from tabintpmagre INTO CURSOR agregoagre readwrite
 
 UPDATE agregoagre SET pa_admision = '641370-5',pa_idevol =      263039
 APPEND FROM DBF('agregoagre')
