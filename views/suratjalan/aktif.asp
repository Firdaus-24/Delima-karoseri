<!--#include file="../../init.asp"-->
<% 
  if session("ENG8C") = false then 
    Response.Redirect("../index.asp")
  end if

  id = Request.QueryString("id")
  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE DLK_T_SuratJalanH SET SJ_AktifYN = 'N' WHERE SJ_ID = '"& id &"'")
  call alert("SURAT JALAN DENGAN ID "& id &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>