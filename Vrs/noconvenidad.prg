Modify View medprestaconv  
Modify View guardiaprestac
Modify View prestacion
Select * FROM medprestaconv  Union All Select * From prestalabo  Union All Select * From;
guardiaprestac Into Cursor preaatall
Select * From preaatall Group By pre_codprest Into Cursor prestacompleto Readwrite
Select * From prestacompleto Where pre_codprest Not In(Select codigo From conv79) ;
ORDER By pre_codservicio,pre_especialidad,pre_descriprest Into Cursor presta



Select Distinct pc_codent From presta_noconv Into Cursor enti
Select * From enti,prestacompleto Into Cursor univer
Browse Last
Select * From univer Where Transform(pc_codent,'9999')+Transform(pre_codprest,'999999999');
NOT In (Select Transform(pc_codent,'9999')+Transform(pc_codprest,'999999999') From presta_noconv );
INTO Cursor convenidas


Requery('presta_noconv')
Select * From prestacompleto Where pre_codprest Not In(Select codigo From conv66) ;
ORDER By pre_codservicio,pre_especialidad,pre_descriprest Into Cursor prestanoconv

Select Id, CodAmbito,Date()-1 As PC_FechaVigDesde, PC_FechaVigHasta,;
818 As  PC_codent, pre_codprest As PC_codprest,;
PC_incluidaAMB, PC_incluidaGUA,;
PC_incluidaINT;
FROM presta_noconv,prestanoconv Into Cursor nuevos

Select presta_noconv

Append From Dbf('nuevos')



mient = 34
Requery('prestac_noconv')
SELECT * FROM prestac_noconv WHERE pc_codprest in (SELECT codigo FROM conv34) INTO CURSOR saco

UPDATE prestac_noconv SET pc_fechavighasta = DATE()-1  WHERE pc_codprest in (SELECT pc_codprest FROM saco)

Select * From prestacompleto Where pre_codprest Not In(Select codigo From conv34) ;
ORDER By pre_codservicio,pre_especialidad,pre_descriprest Into Cursor prestanoconv

Select * From presta Where !Inlist(pre_codprest , 42030892 , 42010315, 42010306,   42010305,42010323, 42010313, 42010327, 42010326) ;
AND  pre_codprest Not In (Select pc_codprest From prestac_noconv ) Into Cursor agrego

Requery('presta_noconv')
Select Id, CodAmbito,Date() As PC_FechaVigDesde, PC_FechaVigHasta,;
34 As  PC_codent, pre_codprest As PC_codprest,;
PC_incluidaAMB, PC_incluidaGUA,PC_incluidaINT;
FROM presta_noconv,agrego Into Cursor nuevos

Select presta_noconv

Append From Dbf('nuevos')