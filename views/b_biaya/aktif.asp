<!--#include file="../../init.asp"-->
<% 
  if session("M12C") = false then
    Response.Redirect("index.asp")
  end if
  id = trim(Request.QueryString("id"))
  p = trim(Request.QueryString("p"))

  if p = "Y" then
    str = "berhasil di aktifkan"
  else
    str = "di nonaktifkan"
  end if

  call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE DLK_M_BebanBiaya SET BN_aktifYN = '"& p &"' WHERE BN_Id = '"& id &"'")
  call alert("MASTER BEBAN BIAYA PRODUKSI ID "&id&" ", str, "success","index.asp") 
call footer() 
%>