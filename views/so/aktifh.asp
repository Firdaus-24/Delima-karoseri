<!--#include file="../../init.asp"-->
<% 
  if session("MK1C") = false then
    Response.Redirect("index.asp")
  end if

  id = Request.QueryString("id")
  call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE DLK_T_OrjulH SET OJH_AktifYN = 'N' WHERE OJH_ID = '"& id &"'")
  call alert("SALES ORDER DENGAN NO "&id&" ", "berhasil hapus", "success", "index.asp") 
call footer() 
%>