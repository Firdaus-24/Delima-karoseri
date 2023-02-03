<!--#include file="../../init.asp"-->
<% 
        if session("M6C") = false then 
                Response.Redirect("index.asp")
        end if
        id = Request.QueryString("id")
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_M_satuanbarang SET Sat_aktifYN = 'N' WHERE Sat_Id = '"& id &"'")
        call alert("SATUAN BARANG DENGAN ID "&id&" ", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>