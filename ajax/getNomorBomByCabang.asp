<!--#include file="../init.asp"-->
<%    
   cabang = trim(Request.Form("cabang"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT dbo.DLK_T_BomH.BMH_ID FROM dbo.DLK_T_BomH WHERE BMH_AktifYN = 'Y' AND BMH_Approve1 = 'Y' AND BMH_Approve2 = 'Y' AND BMH_AgenID = '"& cabang &"' AND NOT EXISTS(SELECT MO_BMHID FROM DLK_T_MaterialOutH WHERE MO_AktifYN = 'Y' AND MO_BMHID = BMH_ID) ORDER BY dbo.DLK_T_BomH.BMH_ID ASC"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute
%>
<select class="form-select" aria-label="Default select example" id="bmhid" name="bmhid" required>
    <option value="">Pilih</option>
    <% do while not data.eof %>
    <option value="<%= data("BMH_ID") %>"><%= left(data("BMH_ID"),2) %>-<% call getAgen(mid(data("BMH_ID"),3,3),"") %>/<%= mid(data("BMH_ID"),6,4) %>/<%= right(data("BMH_ID"),4) %></option>
    <% 
    data.movenext
    loop
    %>
</select>