select codigo
for i = 91 to 120
ccod = "I"+transf(i,"@L 9999")
codbar = "*"+ccod+"*"
insert into codigo (codigo,codbarra) values (ccod,codbar)
next