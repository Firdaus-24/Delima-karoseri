<!--#include file="../../init.asp"-->
<% 
        if session("ENG2C") = false then
                Response.Redirect("./")
        end if
        id = Request.QueryString("id")
        p = trim(Request.QueryString("p"))

        if p = "N" then
                str = "berhasil dinonaktifkan"
        else
                str = "berhasil di aktifkan"
        end if


        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_M_BOMH SET BMAktifYN = '"& p &"' WHERE BMID = '"& id &"'")
        call alert("MASTER B.O.M "&id&" ", str, "success","./") 
call footer() 
%>