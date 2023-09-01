<!--#include file="../../init.asp"-->
<% 
  ' if session("MK1C") = false then
  '   Response.Redirect("./")
  ' end if

  id = trim(Request.QueryString("id"))

  call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE DLK_T_VoucherH SET VCH_Aktifyn = 'N' WHERE VCH_ID = '"& id &"'")
  call alert("DETAIL VOUCHER", "berhasil hapus", "success",Request.ServerVariables("HTTP_REFERER")) 
call footer() 
%>