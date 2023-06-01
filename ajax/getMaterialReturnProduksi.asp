<!--#include file="../init.asp"-->
<% 
  cabang = trim(Request.Form("cabang"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT PDH_ID FROM DLK_T_ProduksiH WHERE PDH_AktifYN = 'Y' AND NOT EXISTS(SELECT RM_PDHID FROM DLK_T_ReturnMaterialH WHERE RM_AktifYN = 'Y' AND RM_PDHID = PDH_ID) AND PDH_AgenID = '"& cabang &"' ORDER BY PDH_ID"
  ' response.write data_cmd.commandText & "<br>"
  set data = data_cmd.execute

%>
<option value="" >Pilih</option>
<% do while not data.eof %>
  <option value="<%= data("PDH_ID") %>" ><%= left(data("PDH_ID"),2) %>-<%= mid(data("PDH_ID"),3,3) %>/<%= mid(data("PDH_ID"),6,4) %>/<%= right(data("PDH_ID"),4)  %></option>
<% 
response.flush
data.movenext
loop
%>