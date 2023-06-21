<!--#include file="../../Connections/cargo.asp"-->

<% 
    id = Request.QueryString("d")
    ajuan = Request.QueryString("p")
    url = Request.QueryString("url")

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_String

    data_cmd.commandText = "SELECT * FROM DLK_T_BOMRepairH WHERE bmrid = '"& id &"' AND bmraktifyn = 'Y'"

    set data = data_cmd.execute

    if not data.eof then
      if ajuan = 1 then
        data_cmd.commandText = "UPDATE DLK_T_BOMRepairH SET bmrApprove1 = 'Y' WHERE bmrid = '"& id &"'"
        data_cmd.execute
      elseif ajuan = 2 then
        data_cmd.commandText = "UPDATE DLK_T_BOMRepairH SET bmrApprove2 = 'Y' WHERE bmrid = '"& id &"'"
        data_cmd.execute
      else
        Response.Redirect("https://mail.google.com/")
      end if
    end if

    Response.Redirect("https://mail.google.com/")
%>