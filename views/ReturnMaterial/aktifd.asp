<!--#include file="../../init.asp"-->
<% 
  if session("PP3C") = false then
    Response.Redirect("index.asp")
  end if

  id = Request.QueryString("id")
  p = Request.QueryString("p")
  strid = left(id,13)

  call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
  call query("DELETE DLK_T_ReturnMaterialD WHERE RM_ID = '"& id &"'")
  call alert("DETAIL TRANSAKSI DENGAN "&id&" ", "berhasil hapus", "success", p&".asp?id="&strid) 
call footer() 
%>