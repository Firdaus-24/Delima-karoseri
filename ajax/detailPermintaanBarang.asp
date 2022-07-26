<!--#include file="../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))
    set data =  Server.CreateObject ("ADODB.Command")
    data.ActiveConnection = mm_delima_string

    data.commandtext = "SELECT * FROM DLK_T_Memo_D WHERE memoId = '"& id &"'"
    set data = data.execute

    a = array(data("memoID"),data("memoItem"),data("memoSpect"),data("memoQtty"),data("memoHarga"),data("memoSatuan"),data("memoKeterangan"),data("memoAktifYN"))

    for each x in a
        response.write(x & ",")
    next
%>