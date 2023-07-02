<!--#include file="../../init.asp"-->
<%
  call header("update header")
  if (session("PP6A") = false) And (session("PP6B") = false) then
    Response.Redirect("./")
  end if

  id = trim(Request.form("idheaderbomrepair"))
  salary = replace(replace(replace(trim(Request.Form("salarydbomrepair")),".",""),",",""),"-","")

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_BOMRepairH WHERE Bmrid = '"& id &"' AND BmrAktifYN = 'Y'"
  ' Response.Write data_cmd.commandTExt
  set data = data_cmd.execute

  if not data.eof then
    call query("UPDATE DLK_T_BOMRepairH SET BmrTotalSalary = '"& salary &"', BmrUpdateid = '"& session("userid") &"' WHERE bmrid = '"& id &"'")
    call alert("HEADER B.O.M REPAIR", "berhasil diupdate", "success",Request.ServerVariables("HTTP_REFERER"))
  else
    call alert("HEADER B.O.M REPAIR", "tidak terdaftar", "error","./")
  end if
  call footer()
%>