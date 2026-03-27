****
** busco tabcmdfrm
****

parameter mcmd

mret = sqlexec(mcon1, "select * from tabcmdfrm where cmdnombre=?mcmd ","mwkcmdfrm")
