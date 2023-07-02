<!--#include file="../../init.asp"-->
<% 
        if session("PP8C") = false then 
                Response.Redirect("./")
        end if

        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_Memo_H SET MemoAktifYN = 'N' WHERE MemoId = '"& id &"'")
        call alert("BARANG DENGAN ID "&id&" ", "berhasil non aktifkan", "success",request.ServerVariables("HTTP_REFERER")) 
call footer() 
%>