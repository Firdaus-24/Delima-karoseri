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
  call query("UPDATE MKT_T_InvRepairH SET INV_AktifYN = 'N' WHERE INV_ID = '"& id &"'")
  call alert("INVOICE CUSTOMER DENGAN NO "& id &"", "berhasil non aktifkan", "success","./") 
call footer() 
%>