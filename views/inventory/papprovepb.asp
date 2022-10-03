<!--#include file="../../init.asp"-->
<% call header("Approve Permintaan") %>
<!--#include file="../../navbar.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_Memo_H WHERE MemoID = '"& id &"' AND memoAktifYN = 'Y' AND memoApproveYN = 'N'"
    set data = data_cmd.execute

    if not data.eof then
        call query("UPDATE DLK_T_Memo_H SET memoApproveYN = 'Y', memoPermintaan = 1 WHERE memoID = '"& id &"'")
        value = 1
    else
        value = 2
    end if

    if value = 1 then
        call alert("APPROVE PERMINTAAN BARANG", "berhasil di approve", "success","approvepb.asp") 
    elseif value = 2 then
        call alert("APPROVE PERMINTAAN BARANG", "tidak terdaftar", "warning","approvepb.asp")
    else
        value = 0
    end if
%>
<% call footer() %>