<!--#include file="../../init.asp"-->
<% 
        if session("M1C") = false then
                Response.Redirect("index.asp")
        end if
        id = trim(Request.QueryString("id"))
        call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
        call query("UPDATE DLK_M_Barang SET Brg_AktifYN = 'N' WHERE Brg_ID = '"& id &"'")
        call alert("BARANG DENGAN ID "& id &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>