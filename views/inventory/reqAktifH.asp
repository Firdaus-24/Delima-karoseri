<!--#include file="../../init.asp"-->
<% 
        if session("INV1C") = false then 
                Response.Redirect("index.asp")
        end if

        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_Memo_H SET MemoAktifYN = 'N' WHERE MemoId = '"& id &"' AND memobmrid = '' AND memobmid = '' ")
        call alert("BARANG DENGAN ID "&id&" ", "berhasil non aktifkan", "success","reqAnggaran.asp") 
call footer() 
%>