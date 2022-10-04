<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_Memo_H SET MemoAktifYN = 'N' WHERE MemoId = '"& id &"'")
        call alert("BARANG DENGAN ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>