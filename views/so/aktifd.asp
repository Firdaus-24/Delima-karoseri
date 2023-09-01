<!--#include file="../../init.asp"-->
<% 
  if session("MK1C") = false then
    Response.Redirect("./")
  end if

  id = Request.QueryString("id")
  p = Request.QueryString("p")
  strid = left(id,13)

  call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
  call query("DELETE MKT_T_OrjulD WHERE OJD_OJHID = '"& id &"'")
  call alert("DETAIL SALES ORDER DENGAN NO "&id&" ", "berhasil hapus", "success", p&".asp?id="&strid) 
call footer() 
%>