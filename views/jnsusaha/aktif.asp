<!--#include file="../../init.asp"-->
<% 
  if session("HR8C") = false then 
    Response.Redirect("index.asp")
  end if

  id = Request.QueryString("id")
  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE HRD_M_JnsUsaha SET Ush_AktifYN = 'N' WHERE Ush_ID = '"& id &"'")
  call alert("MASTER JENIS USAHA DENGAN ID "& id &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>