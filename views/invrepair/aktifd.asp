<!--#include file="../../init.asp"-->
<% 
  if session("MK4C") = false then 
    Response.Redirect("./")
  end if

  id = trim(Request.QueryString("id"))
  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("DELETE MKT_T_InvRepairD WHERE IRD_INVID = '"& id &"'")
  call alert("DETAIL UNIT DENGAN NO "& id &"", "dihapus", "success","invd_add.asp?id="&id) 
call footer() 
%>