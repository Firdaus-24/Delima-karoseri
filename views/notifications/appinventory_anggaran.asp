<!--#include file="../../init.asp"-->
<%
  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = " SELECT TOP 1 ( SELECT COUNT(memoID) as memo1 FROM DLK_T_Memo_H where memoinventoryYN = 'N' AND memoAktifYN = 'Y' and memobmid = '' AND memobmrid = '') as memo1, (SELECT COUNT(memoID) as memo2 FROM DLK_T_Memo_H where memoinventoryYN = 'N' AND memoAktifYN = 'Y' and memobmid <> '') as memo2,  (SELECT COUNT(memoID) as memo3 FROM DLK_T_Memo_H where memoinventoryYN = 'N' AND memoAktifYN = 'Y'  AND memobmrid <> '') as memo3 from DLK_T_Memo_H where memoAktifYN = 'Y'"
  set data = data_cmd.execute

  response.ContentType = "application/json;charset=utf-8"
  response.write "{"   
    response.write """MEMO""" & ":" & """" & data("memo1") &  """" & ","
    response.write """PROJECT""" & ":" & """" & data("memo2") &  """" & ","
    response.write """REPAIR""" & ":" & """" & data("memo3") &  """" 
  response.write "}"
%>