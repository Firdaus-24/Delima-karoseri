<!--#include file="../../init.asp"-->
<% 
        if session("M8C") = false then  
                Response.Redirect("index.asp")
        end if

        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_M_Vendor SET ven_aktifYN = 'N' WHERE Ven_Id = '"& id &"'")
        call alert("VENDOR ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>