<!--#include file="../../init.asp"-->
<% 
  if session("MK2C") = false then
    Response.Redirect("index.asp")
  end if
  id = Request.QueryString("id")
call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE MKT_T_OrJulRepairH SET ORH_AktifYN = 'N' WHERE ORH_ID = '"& id &"'")
  call alert("SALES ORDER REPAIR DENGAN NO "& id &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>