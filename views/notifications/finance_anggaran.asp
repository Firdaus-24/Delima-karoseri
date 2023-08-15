<!--#include file="../../init.asp"-->
<%
  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT COUNT(memoID) as memo1 FROM DLK_T_Memo_H where memoinventoryYN = 'Y' AND memopurchaseYN = 'Y' AND memoAktifYN = 'Y' AND memoapproveYN = 'N'"
  set data = data_cmd.execute

  response.ContentType = "application/json;charset=utf-8"
  response.write "{"   
    response.write """MEMO""" & ":" & """" & data("memo1") &  """" 
  response.write "}"
%>