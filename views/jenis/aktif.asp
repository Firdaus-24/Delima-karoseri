<!--#include file="../../init.asp"-->
<% 
        if session("M3C") = false then 
                Response.Redirect("index.asp")
        end if
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_M_JenisBarang SET JenisaktifYN = 'N' WHERE JenisId = '"& id &"'")
        call alert("JENIS BARANG DENGAN ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>