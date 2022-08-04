<!--#include file="../../init.asp"-->
<% 
        id = Request.QueryString("id")
        databrg = Request.QueryString("databrg")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_Memo_D SET MemoAktifYN = 'N' WHERE MemoId = '"& databrg &"'")
        call alert("BARANG DENGAN ID "&idatabrgd&" ", "berhasil non aktifkan", "success","detailpb.asp?id="&id) 
call footer() 
%>