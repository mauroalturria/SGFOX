	select * from mwkphorario ;
				where  codesp in ('NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOG', 'ECOI', 'ERGO', 'KINE', 'LABO', 'RADI', 'RESO', 'TOMO') ;
				or !(AT('28010', ALLTRIM(STR(CODprest))) # 1 OR CODprest = 28010602);
				or !AT('20012', ALLTRIM(STR(CODprest)) )# 1 ;
				order by piso, nombre, hdesde1, fechatur, horatur ;
				into cursor mwkphorarios2
	select * from mwkphorarios2 ;
				where codesp not in('LABO', 'PSIC', 'FONI') ;
				order by piso, nombre, hdesde1, fechatur, horatur ;
				into cursor mwkphorario
				