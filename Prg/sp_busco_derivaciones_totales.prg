*** Derivaciones ***
Lparameters mdes, mhas

mdes = Date(Year(mdes),Month(mdes),Day(mdes))
mhas = Date(Year(mhas),Month(mhas),Day(mhas))+1

*!*	Consulta = "SELECT count(tabderivacion.id) as cuenta, tabderivacion.Estado, cast(tabderivacion.fechahora  as date) as fecha " +;
*!*	 "FROM tabderivacion " +;
*!*	 "INNER JOIN tabsectorint ON tabderivacion.codint = tabsectorint.id " +;
*!*	 "inner join TabEstados on tabderivacion.Estado = TabEstados.Estado and TabEstados.Propietario = 81 and tabderivacion.Estado in(0,5) "+;
*!*	 "where exists(select 1 from tabderivacion where tabderivacion.fechahora >= ?mdes and tabderivacion.fechahora < ?mhas) and "+;
*!*	 "tabderivacion.fechahora >= ?mdes " +; && 2016-05-29
*!*	 "and tabderivacion.fechahora < ?mhas " +; && 2016-06-10
*!*	 "group by tabderivacion.Estado " +;
*!*	 "union "+;
*!*	 "SELECT count(tabderivacion.id), tabderivacion.Estado, cast(tabderivacion.fechahora  as date) as fecha "+;
*!*	 "FROM tabderivacion "+;
*!*	 "INNER JOIN tabsectorint ON tabderivacion.codint = tabsectorint.id "+;
*!*	 "inner join TabEstados on tabderivacion.Estado = TabEstados.Estado and TabEstados.Propietario = 81 "+;
*!*	 "where exists(select 1 from tabderivacion where tabderivacion.fechahora >= ?mdes and tabderivacion.fechahora < ?mhas) and "+;
*!*	 "tabderivacion.fechahora >= ?mdes "+; &&'2016-06-04'
*!*	 "and tabderivacion.fechahora < ?mhas "+; &&'2016-06-11'
*!*	 "group by cast(tabderivacion.fechahora  as date), tabderivacion.Estado"

 Consulta = "SELECT count(tabderivacion.id) as cuenta, tabderivacion.Estado, cast(tabderivacion.fechahora  as date) as fecha "+;
 "FROM tabderivacion "+;
 "INNER JOIN tabsectorint ON tabderivacion.codint = tabsectorint.id "+;
 "inner join TabEstados on tabderivacion.Estado = TabEstados.Estado and TabEstados.Propietario = 81 "+;
 "where exists(select 1 from tabderivacion where tabderivacion.fechahora >= ?mdes and tabderivacion.fechahora < ?mhas) and "+;
 "tabderivacion.fechahora >= ?mdes "+; &&'2016-06-04'
 "and tabderivacion.fechahora < ?mhas "+; &&'2016-06-11'
 "group by cast(tabderivacion.fechahora  as date), tabderivacion.Estado"
 

*!*	 Consulta = "SELECT count(tabderivacion.id) as cuenta, tabderivacion.Estado, cast(tabderivacion.fechahora  as date) as fecha "+;
*!*	 "FROM tabderivacion "+;
*!*	 "INNER JOIN tabsectorint ON tabderivacion.codint = tabsectorint.id "+;
*!*	 "inner join TabEstados on tabderivacion.Estado = TabEstados.Estado and TabEstados.Propietario = 81 "+;
*!*	 "where exists(select 1 from tabderivacion where tabderivacion.fechahora >= ?mdes and tabderivacion.fechahora < ?mhas) and "+;
*!*	 "tabderivacion.fechahora >= ?mdes "+; &&'2016-06-04'
*!*	 "and tabderivacion.fechahora < ?mhas "+; &&'2016-06-11'
*!*	 "group by cast(tabderivacion.fechahora  as date), tabderivacion.Estado "+;
*!*	 "union " +;
*!*	 "SELECT count(tabderivacion.id) as cuenta, tabderivacion.Estado, cast(tabderivacion.fechahora  as date) as fecha "+;
*!*	 "FROM tabderivacion "+;
*!*	 "INNER JOIN tabsectorint ON tabderivacion.codint = tabsectorint.id "+;
*!*	 "inner join TabEstados on tabderivacion.Estado = TabEstados.Estado and TabEstados.Propietario = 81 "+;
*!*	 "where exists(select 1 from tabderivacion where tabderivacion.fechahora >= ?mdes2 and tabderivacion.fechahora < ?mhas2) and "+;
*!*	 "tabderivacion.fechahora >= ?mdes2 "+; &&'2016-06-04'
*!*	 "and tabderivacion.fechahora < ?mhas2 "+; &&'2016-06-11'
*!*	 "group by cast(tabderivacion.fechahora  as date), tabderivacion.Estado"

*!*	 Consulta = "SELECT count(tabderivacion.id) as cuenta, tabderivacion.Estado, cast(tabderivacion.fechahora  as date) as fecha "+;
*!*	 "FROM tabderivacion "+;
*!*	 "INNER JOIN tabsectorint ON tabderivacion.codint = tabsectorint.id "+;
*!*	 "inner join TabEstados on tabderivacion.Estado = TabEstados.Estado and TabEstados.Propietario = 81 "+;
*!*	 "where exists(select 1 from tabderivacion where tabderivacion.fechahora >= ?mdes and tabderivacion.fechahora < ?mhas) and "+;
*!*	 "tabderivacion.fechahora >= ?mdes "+;
*!*	 "and tabderivacion.fechahora < ?mhas "+;
*!*	 " or " +;
*!*	 "tabderivacion.fechahora >= ?mdes2 "+; 
*!*	 "and tabderivacion.fechahora < ?mhas2 "+; 
*!*	 "group by cast(tabderivacion.fechahora  as date), tabderivacion.Estado"
 
 
mret = Sqlexec(mcon1,Consulta,"mwkderivaciones")
 
If mret < 1
Messagebox("No se pudo realizar la consulta en Derivaciones",16,"Error")
Endif
 
Select Sum(cuenta) as cuenta, fecha From mwkderivaciones Group By mwkderivaciones.fecha Into Cursor mwkderivacionestotales

*Select Sum(cuenta) as cuenta, fecha From mwkderivaciones Where estado = 1 Group By mwkderivaciones.fecha Into Cursor mwkderivacionestotales

