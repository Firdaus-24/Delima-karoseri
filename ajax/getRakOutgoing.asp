<!--#include file="../init.asp"-->
<% 
   brgid = trim(Request.Form("brgid"))

   set data_cmd = Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT dbo.DLK_M_Rak.Rak_nama, dbo.DLK_M_Rak.Rak_ID FROM dbo.DLK_T_MaterialReceiptD2 RIGHT OUTER JOIN dbo.DLK_M_Rak ON dbo.DLK_T_MaterialReceiptD2.MR_RakID = dbo.DLK_M_Rak.Rak_ID GROUP BY dbo.DLK_M_Rak.Rak_nama, dbo.DLK_M_Rak.Rak_ID, dbo.DLK_T_MaterialReceiptD2.MR_Item HAVING (dbo.DLK_T_MaterialReceiptD2.MR_Item = '"& brgid &"')"

   set data = data_cmd.execute
%>
<select class="form-select" aria-label="Default select example" name="rak" id="rak" required>
   <option value="">Pilih</option>
   <% do while not data.eof %>
      <option value="<%= data("Rak_ID") %>"><%= data("Rak_Nama") %></option>
   <% 
   data.movenext
   loop
   %>
</select>