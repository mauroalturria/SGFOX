create cursor mails(codigo n(10),nombre c(50),mail c(50))

append from c:\desaguemes\mailprest.txt delimited with tab
select mails
scan
    mid = codigo
    mimail = mail
    requery('prestamail')
    if reccount('prestamail')>0
        update prestamail set emailcorp = mimail
    else
    set step on
    endif
endscan
