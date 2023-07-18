<!--#include file="../../init.asp"-->
<% 
  if session("MQ5C") = false then
    Response.Redirect("./")
  end if
  id = trim(Request.QueryString("id"))

  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE DLK_T_PDIRepairH SET PDIR_AktifYN = 'N' WHERE PDIR_ID = '"& id &"'")
  call alert("PDI Repair dengan No : "&id&" ", str, "success","./") 
call footer() 
%>