<!--#include file="../../init.asp"-->
<% 
        if session("FN1E") = false then
                Response.Redirect("appmemo.asp")
        end if
        id = Request.QueryString("id")
        call header("Appove Memo")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_Memo_H SET MemoApproveYN = 'Y' WHERE Memoid = '"& id &"'")
        call alert("APPROVE ID "&id&" ", "berhasil approve", "success","appmemo.asp") 
call footer() 
%>