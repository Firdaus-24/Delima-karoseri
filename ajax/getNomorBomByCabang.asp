<!--#include file="../init.asp"-->
<%    
   cabang = trim(Request.form("cabang"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string
    
   data_cmd.commandText = "SELECT dbo.DLK_T_ProduksiD.PDD_ID, dbo.DLK_T_ProduksiH.PDH_ID FROM dbo.DLK_T_ProduksiH RIGHT OUTER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_T_ProduksiH.PDH_ID = LEFT(dbo.DLK_T_ProduksiD.PDD_ID, 13) WHERE (dbo.DLK_T_ProduksiH.PDH_Approve1 = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_Approve2 = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_AktifYN = 'Y') AND PDH_AgenID = '"& cabang &"' AND NOT EXISTS(SELECT MO_PDDID FROM DLK_T_MaterialOutH WHERE MO_AktifYN = 'Y' AND MO_PDDID = PDD_ID) ORDER BY dbo.DLK_T_ProduksiD.PDD_ID ASC"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute
%>
<select class="form-select" aria-label="Default select example" id="pddid" name="pddid" required>
    <option value="">Pilih</option>
    <% do while not data.eof %>
    <option value="<%= data("PDD_ID") %>"><%= left(data("PDD_id"),2) %>-<%= mid(data("PDD_id"),3,3) %>/<%= mid(data("PDD_id"),6,4) %>/<%= mid(data("PDD_id"),10,4) %>/<%= right(data("PDD_id"),3) %></option>
    <% 
    data.movenext
    loop
    %>
</select>