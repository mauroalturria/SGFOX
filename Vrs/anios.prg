,iif(meses<2 and anios = 0,sum(meses),00000000) as aniosneo,count(iif(meses<2 and anios = 0,1,0)) as cuantosneo ;
,iif((anios>0 and anios<16) or meses>2,sum(anios),0000000) as aniosped,count(iif((anios>0 and anios<16) or meses>2,1,0)) as cuantosped ;
 from a2010 into cursor t2010
BROWSE LAST
select *  from a2010 where (anios>0 and anios<16) or meses>2
select *  from a2010 where meses<2 and anios = 0
select iif(anios>15,sum(anios),00000000) as aniosadul,count(iif(anios>15,1,0)) as cuantosadul ;
,sum(iif(meses<2 and anios = 0,meses,00000000) as aniosneo,count(iif(meses<2 and anios = 0,1,0)) as cuantosneo ;
,sum(iif((anios>0 and anios<16) or meses>2,anios,0000000) as aniosped,count(iif((anios>0 and anios<16) or meses>2,1,0)) as cuantosped ;
 from a2010 into cursor t2010
select iif(anios>15,sum(anios),00000000) as aniosadul,count(iif(anios>15,1,0)) as cuantosadul ;
,sum(iif(meses<2 and anios = 0,meses,00000000)) as aniosneo,count(iif(meses<2 and anios = 0,1,0)) as cuantosneo ;
,sum(iif((anios>0 and anios<16) or meses>2,anios,0000000)) as aniosped,count(iif((anios>0 and anios<16) or meses>2,1,0)) as cuantosped ;
 from a2010 into cursor t2010
BROWSE LAST
select *  from a2010 where (anios>0 and anios<16) or meses>2
select *  from a2010 where meses<2 and anios = 0
copy to a2010 type xls
select *  from a2010 where meses<2 and anios = 0
?sum(meses)
?aa
sum meses to aa
?aa
sum anios to aa
?aa
select *  from a2010 where (anios>0 and anios<16) or meses>2
sum anios to aa
?aa
sum meses to aa
?aa
select *  from a2010 where (anios>0 and anios<16) or meses>2
sum meses to aa
?aa
select *,iif(at('meses',edad)>0,0000,val(edad)) as anios,iif(at('meses',edad)>0,val(edad),00) as meses from año2010  where !empty(edad) into cursor a2010
select *,iif(at('meses',edad)>0,0000,val(edad)) as anios,iif(at('meses',edad)>0,val(edad),00) as meses from altas2009 where !empty(edad) into cursor a2009
select *,iif(at('meses',edad)>0,0000,val(edad)) as anios,iif(at('meses',edad)>0,val(edad),00) as meses from alta2008 where !empty(edad) into cursor a2008
select iif(anios>15,sum(anios),00000000) as aniosadul,count(iif(anios>15,1,0)) as cuantosadul ;
,sum(iif(meses<2 and anios = 0,meses,00000000)) as aniosneo,count(iif(meses<2 and anios = 0,1,0)) as cuantosneo ;
,sum(iif((anios>0 and anios<16) or meses>2,anios,0000000)) as aniosped,count(iif((anios>0 and anios<16) or meses>2,1,0)) as cuantosped ;
 from a2010 into cursor t2010
select *  from a2010 where (anios>0 and anios<16) or meses>2
sum meses to aa
?aa
select *  from a2010 where meses<2 and anios = 0
sum meses to aa
?aa
SELECT 12
BROWSE LAST
select *  from a2010 where anios>15
select iif(anios>15,sum(anios),00000000) as aniosadul,sum(iif(anios>15,1,0)) as cuantosadul ;
,sum(iif(meses<2 and anios = 0,meses,00000000)) as aniosneo,sum(iif(meses<2 and anios = 0,1,0)) as cuantosneo ;
,sum(iif((anios>0 and anios<16) or meses>2,anios,0000000)) as aniosped,sum(iif((anios>0 and anios<16) or meses>2,1,0)) as cuantosped ;
 from a2010 into cursor t2010
BROWSE LAST
select iif(anios>15,sum(anios),00000000) as aniosadul,sum(iif(anios>15,1,0)) as cuantosadul ;
,sum(iif(meses<2 and anios = 0,meses,00000000)) as aniosneo,sum(iif(meses<2 and anios = 0,1,0)) as cuantosneo ;
,sum(iif((anios>0 and anios<16) or meses>2,anios,0000000)) as aniosped,sum(iif((anios>0 and anios<16) or meses>2,1,0)) as cuantosped ;
 from a2009 into cursor t2009
copy to a2009
copy to a2009 type xls
SELECT 15
copy to a2009 type xls
select iif(anios>15,sum(anios),00000000) as aniosadul,sum(iif(anios>15,1,0)) as cuantosadul ;
,sum(iif(meses<2 and anios = 0,meses,00000000)) as aniosneo,sum(iif(meses<2 and anios = 0,1,0)) as cuantosneo ;
,sum(iif((anios>0 and anios<16) or meses>2,anios,0000000)) as aniosped,sum(iif((anios>0 and anios<16) or meses>2,1,0)) as cuantosped ;
 from a2008 into cursor t2008
copy to a2008 type xls
select sum(iif(anios>15,anios,00000000) as aniosadul,sum(iif(anios>15,1,0)) as cuantosadul ;
,sum(iif(meses<2 and anios = 0,meses,00000000)) as aniosneo,sum(iif(meses<2 and anios = 0,1,0)) as cuantosneo ;
,sum(iif((anios>0 and anios<16) or meses>2,anios,0000000)) as aniosped,sum(iif((anios>0 and anios<16) or meses>2,1,0)) as cuantosped ;
 from a2008 into cursor t2008
select sum(iif(anios>15,anios,00000000)) as aniosadul,sum(iif(anios>15,1,0)) as cuantosadul ;
,sum(iif(meses<2 and anios = 0,meses,00000000)) as aniosneo,sum(iif(meses<2 and anios = 0,1,0)) as cuantosneo ;
,sum(iif((anios>0 and anios<16) or meses>2,anios,0000000)) as aniosped,sum(iif((anios>0 and anios<16) or meses>2,1,0)) as cuantosped ;
 from a2008 into cursor t2008
BROWSE LAST
select *,iif(at('meses',edad)>0,0000,val(edad)) as anios,iif(at('meses',edad)>0,val(edad),00) as meses from altas2009 where !empty(edad) into cursor a2009
select sum(iif(anios>15,anios,00000000)) as aniosadul,sum(iif(anios>15,1,0)) as cuantosadul ;
,sum(iif(meses<2 and anios = 0,meses,00000000)) as aniosneo,sum(iif(meses<2 and anios = 0,1,0)) as cuantosneo ;
,sum(iif((anios>0 and anios<16) or meses>2,anios,0000000)) as aniosped,sum(iif((anios>0 and anios<16) or meses>2,1,0)) as cuantosped ;
 from a2009 into cursor t2009
select sum(iif(anios>15,anios,00000000)) as aniosadul,sum(iif(anios>15,1,0)) as cuantosadul ;
,sum(iif(meses<2 and anios = 0,meses,00000000)) as aniosneo,sum(iif(meses<2 and anios = 0,1,0)) as cuantosneo ;
,sum(iif((anios>0 and anios<16) or meses>2,anios,0000000)) as aniosped,sum(iif((anios>0 and anios<16) or meses>2,1,0)) as cuantosped ;
 from a2010 into cursor t2010
copy to a2010 type xls
SELECT 15
copy to a2009 type xls
SELECT 13
copy to a2008 type xls
select *  from a2010 where anios>15
sum anios to aa
?aa
do clearall
