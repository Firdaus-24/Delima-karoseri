<!--#include file="../../init.asp"-->
<% 
  if session("PP4C") = false then
    Response.Redirect("index.asp")
  end if

  id = Request.QueryString("id")

  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
   call query("UPDATE DLK_T_BB_ProsesH SET BP_AktifYN = 'N' WHERE BP_ID = '"& id &"'")
   call alert("HEADER BEBAN PROSES DENGAN ID "&id&" ", "berhasil dihapus", "success","index.asp") 
call footer() 
%>