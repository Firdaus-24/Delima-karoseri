<!--#include file="../../Connections/cargo.asp"-->

<% 
    id = Request.QueryString("d")
    ajuan = Request.QueryString("p")
    url = Request.QueryString("url")

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_String

    data_cmd.commandText = "SELECT * FROM DLK_T_IncRepairH WHERE IRH_ID = '"& id &"' AND IRH_AktifYN = 'Y'"

    set data = data_cmd.execute

    if not data.eof then
      if ajuan = 1 then
        data_cmd.commandText = "UPDATE DLK_T_IncRepairH SET IRH_Approve1 = 'Y' WHERE IRH_ID = '"& id &"'"
        data_cmd.execute
      elseif ajuan = 2 then
        data_cmd.commandText = "UPDATE DLK_T_IncRepairH SET IRH_Approve2 = 'Y' WHERE IRH_ID = '"& id &"'"
        data_cmd.execute
      elseif ajuan = 3 then
        data_cmd.commandText = "UPDATE DLK_T_IncRepairH SET IRH_Approve3 = 'Y' WHERE IRH_ID = '"& id &"'"
        data_cmd.execute
      else
        Response.Redirect("https://mail.google.com/")
      end if
    end if

    Response.Redirect("https://mail.google.com/")
%>