<!--#include file="../../init.asp"-->
<% 
        if session("M2C") = false then  
                Response.Redirect("index.asp")
        end if

        id = trim(Request.QueryString("id"))
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_M_Customer SET custAktifYN = 'N' WHERE custID = '"& id &"'")
        call alert("CUSTOMER DENGAN ID "& id &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>