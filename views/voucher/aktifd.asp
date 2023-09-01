<!--#include file="../../init.asp"-->
<% 
  ' if session("MK1C") = false then
  '   Response.Redirect("./")
  ' end if

  id = trim(Request.QueryString("id"))
  strid = left(id,13)

  call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
  call query("DELETE DLK_T_VoucherD WHERE VCH_VCHID = '"& id &"'")
  call alert("DETAIL VOUCHER", "berhasil hapus", "success",Request.ServerVariables("HTTP_REFERER")) 
call footer() 
%>