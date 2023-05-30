<!--#include file="../../init.asp"-->
<% 
  if session("MQ2C") = false then 
    Response.Redirect("./")
  end if

  id = Request.QueryString("id")
  call header("aktif")
%>
<!--#include file="../../navbar.asp"-->
<%      
  call query("UPDATE DLK_T_UnitCustomerH SET TFK_AktifYN = 'N' WHERE TFK_ID = '"& id &"'")
  call alert("PENERIMAAN UNIT DENGAN NOMOR "& id &"", "berhasil non aktifkan", "success","index.asp") 
call footer() 
%>