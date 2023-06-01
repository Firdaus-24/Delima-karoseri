<!--#include file="../../init.asp"-->
<% 
        if session("INV3C") = false then
                Response.Redirect("index.asp")
        end if
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_T_DelBarang SET DB_aktifYN = 'N' WHERE DB_Id = '"& id &"'")
        call alert("BARANG RUSAK DENGAN ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>