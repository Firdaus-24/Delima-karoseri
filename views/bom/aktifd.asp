<!--#include file="../../init.asp"-->
<% 
if session("ENG2C") = false then
   Response.Redirect("./")
end if
id = trim(Request.QueryString("id"))
p = trim(Request.QueryString("p"))

strid = left(id,12)

call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
call query("DELETE DLK_M_BOMD WHERE BMDBMID = '"& id &"'")
call alert("BARANG DETAIL ITEM "&id&" ", "berhasil hapus", "success", p&".asp?id="&strid) 
call footer() 
%>