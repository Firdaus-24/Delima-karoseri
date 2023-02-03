<!--#include file="../../init.asp"-->
<% 
        if session("HR4C") = false then
                Response.Redirect("index.asp")
        end if
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE GLB_M_Agen SET AgenAktifYN = 'N' WHERE AgenID = '"& id &"'")
        call alert("CABANG / AGEN", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>