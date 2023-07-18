<!--#include file="../../init.asp"-->
<%
   if session("MQ5") = false then
    Response.Redirect("../")
  end if
  id = trim(Request.form("id"))
  
  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' cek data incomming unit
  data_cmd.commandTExt = "SELECT dbo.DLK_T_IncRepairD.IRD_Img, dbo.DLK_T_IncRepairH.IRH_ID, dbo.DLK_T_IncRepairD.IRD_IRHID FROM dbo.DLK_T_IncRepairH RIGHT OUTER JOIN dbo.DLK_T_IncRepairD ON dbo.DLK_T_IncRepairH.IRH_ID = LEFT(dbo.DLK_T_IncRepairD.IRD_IRHID, 13) WHERE LEFT(IRD_IRHID,13) = '"& id &"' ORDER BY dbo.DLK_T_IncRepairD.IRD_IRHID"
  ' Response.Write data_cmd.commandTExt
  set data = data_cmd.execute

  do while not data.eof
  Response.Write  "<tr><td>"& data("IRD_Img") &"</td></tr>"
  Response.flush
  data.movenext
  loop
%>