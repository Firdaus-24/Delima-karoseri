<!--#include file="../../init.asp"-->
<% 
  if session("PP2C") = false then
    Response.Redirect("index.asp")
  end if

  id = Request.QueryString("id")
  p = Request.QueryString("p")
  strid = left(id,4) & right(id,7)

  call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
  call query("DELETE DLK_T_ManpowerD WHERE MP_ID = '"& id &"'")
  call alert("DETAIL MANPOWER DENGAN NO "&id&" ", "berhasil hapus", "success", p&".asp?id="&strid) 
call footer() 
%>