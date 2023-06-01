<!--#include file="../../init.asp"-->
<% 
   agen = trim(Request.form("agen"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_String

   data_cmd.commandTExt = "SELECT dbo.DLK_T_ProduksiH.PDH_ID FROM dbo.DLK_T_ProduksiH WHERE (dbo.DLK_T_ProduksiH.PDH_Approve1 = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_Approve2 = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_AktifYN = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_AgenID = '"& agen &"') AND NOT EXISTS(SELECT PFH_PDHID FROM DLK_T_ProdFinishH WHERE PFH_PDHID = dbo.DLK_T_ProduksiH.PDH_ID AND PDH_AktifYN = 'Y') ORDER BY dbo.DLK_T_ProduksiH.PDH_ID "

   set data = data_cmd.execute
%>
<option value="">Pilih</option>
<% do while not data.eof  %>
   <option value="<%= data("PDH_ID") %>">
      <%= left(data("PDH_ID"),2) %>-<%= mid(data("PDH_ID"),3,3) %>/<%= mid(data("PDH_ID"),6,4) %>/<%= right(data("PDH_ID"),3)  %>
   </option>
<% 
   response.flush
   data.movenext
   loop
%>