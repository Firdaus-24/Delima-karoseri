<!--#include file="../../init.asp"-->
<% 
        id = trim(Request.QueryString("id"))
        strid = left(id,17)
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("DELETE DLK_T_Memo_D WHERE MemoId = '"& id &"'")
        call alert("BARANG DENGAN ID "&id&" ", "berhasil non aktifkan", "success","dapprovepb.asp?id="&strid) 
call footer() 
%>