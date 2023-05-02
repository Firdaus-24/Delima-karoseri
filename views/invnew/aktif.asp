<!--#include file="../../init.asp"-->
<% 
  if session("MK3C") = false then 
    Response.Redirect("../index.asp")
  end if

  id = Request.QueryString("id")
  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE MKT_T_InvJulNewH SET IPH_AktifYN = 'N' WHERE IPH_ID = '"& id &"'")
  call alert("HEADER INVOICE DENGAN ID "& id &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>