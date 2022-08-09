<!--#include file="../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))
    set data =  Server.CreateObject ("ADODB.Command")
    data.ActiveConnection = mm_delima_string

    data.commandtext = "SELECT DLK_T_Memo_D.*, Brg_Id, Brg_Nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID WHERE memoId = '"& id &"'"
    set data = data.execute

    a = array(data("memoID"),data("Brg_Nama"),data("memoSpect"),data("memoQtty"),data("memoHarga"),data("memoSatuan"),data("memoKeterangan"),data("memoAktifYN"),data("Brg_ID"))

    for each x in a
        response.write(x & ",")
    next
%>