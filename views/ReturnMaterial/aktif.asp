<!--#include file="../../init.asp"-->
<% 
  if session("PP3C") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))

  call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE DLK_T_ReturnMaterialH SET RM_AktifYN = 'N' WHERE RM_ID = '"& id &"'")
  call alert("DETAIL TRANSAKSI DENGAN "&id&" ", "berhasil hapus", "success", "index.asp?id=") 
call footer() 
%>