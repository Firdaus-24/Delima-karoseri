<!--#include file="../../init.asp"-->
<% 
  if session("PP6C") = false then
    Response.Redirect("./")
  end if
  id = trim(Request.QueryString("id"))
  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE DLK_T_BOMRepairH SET bmraktifyn = 'N' WHERE bmrid = '"& id &"'")
  call alert("B.O.M Repair No. "& id &"", "berhasil non aktifkan", "success","./") 
  call footer() 
%>