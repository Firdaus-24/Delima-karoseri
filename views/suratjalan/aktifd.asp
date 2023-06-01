<!--#include file="../../init.asp"-->
<% 
   if session("ENG8C") = false then
      Response.Redirect("index.asp")
   end if

  id = Request.QueryString("id")
  p = Request.QueryString("p")
  strid = left(id,10)

  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("DELETE DLK_T_SuratJalanD WHERE SJD_ID = '"& id &"'")
  call alert("DETAIL TRANSAKSI DENGAN "&id&" ", "berhasil hapus", "success", p&".asp?id="&strid) 
call footer() 
%>