<!--#include file="../../init.asp"-->
<% 
  if session("PP4C") = false then
    Response.Redirect("index.asp")
  end if

  id = Request.QueryString("id")
  p = Request.QueryString("p")
  strid = left(id,12)

  call header("aktif")
 %>
<!--#include file="../../navbar.asp"-->
<%      
   call query("DELETE DLK_T_BB_ProsesD WHERE BP_ID = '"& id &"'")
   call alert("DETAIL TRANSAKSI DENGAN "&id&" ", "berhasil hapus", "success", p&".asp?id="&strid) 
call footer() 
%>