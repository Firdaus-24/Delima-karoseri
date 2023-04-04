<!--#include file="../../init.asp"-->
<% 
  if session("MQ3C") = false then
    Response.Redirect("index.asp")
  end if
  id = Request.QueryString("id")
call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE DLK_T_PreDevInspectionH SET PDI_AktifYN = 'N' WHERE PDI_ID = '"& id &"'")
  call alert("Pre Delivery Inspection No "& id &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>