<!--#include file="../../Connections/cargo.asp"-->

<% 
    id = Request.QueryString("d")

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_String

    data_cmd.commandText = "SELECT * FROM DLK_T_Memo_H WHERE memoID = '"& id &"' AND memoAktifYN = 'Y'"

    set data = data_cmd.execute

    if not data.eof then
        data_cmd.commandText = "UPDATE DLK_T_Memo_H SET memoApproveYN = 'Y' WHERE memoID = '"& id &"'"
        data_cmd.execute
    end if

    Response.Redirect("https://mail.google.com/")
%>