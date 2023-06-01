<!--#include file="../../init.asp"-->
<% 
  cabang = trim(Request.form("cabang"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT PDH_ID FROM dbo.DLK_T_ProduksiH WHERE (PDH_Approve1 = 'Y') AND (PDH_Approve2 = 'Y') AND (PDH_AktifYN = 'Y') AND (PDH_AgenID = '"&cabang&"') AND (NOT EXISTS (SELECT MP_PDHID FROM dbo.DLK_T_ManPowerH WHERE (MP_PDHID = dbo.DLK_T_ProduksiH.PDH_ID))) ORDER BY PDH_ID"

  set data = data_cmd.execute

%>
<option value="">Pilih</option>
<% do while not data.eof %>
<option value="<%= data("PDH_ID") %>"><%= left(data("PDH_ID"),2) %>-<%= mid(data("PDH_ID"),3,3) %>/<%= mid(data("PDH_ID"),6,4) %>/<%= right(data("PDH_ID"),4)  %></option>
<% 
Response.flush
data.movenext
loop
%>