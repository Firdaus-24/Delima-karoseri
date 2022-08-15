<!--#include file="../init.asp"-->
<% 
    agen = trim(Request.QueryString("p"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT "
%>