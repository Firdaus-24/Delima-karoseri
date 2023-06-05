<!--#include file="../init.asp"-->
<%    
    cabang = trim(Request.Form("cabang"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_OrPemH.OPH_ID FROM dbo.DLK_T_OrPemH WHERE (dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y') AND (dbo.DLK_T_OrPemH.OPH_AgenID = '"& cabang &"') AND NOT EXISTS(SELECT DLK_T_InvPemH.IPH_OPHID FROM DLK_T_InvPemH WHERE DLK_T_InvPemH.IPH_OPHID = DLK_T_OrPemH.OPH_ID AND DLK_T_InvPemH.IPH_AktifYN = 'Y') GROUP BY dbo.DLK_T_OrPemH.OPH_ID ORDER BY dbo.DLK_T_OrPemH.OPH_ID"
    'response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute
%>
<select class="form-select" aria-label="Default select example" id="ophidFaktur" name="ophid" onchange="getValuePO(this.value)" required>
    <option value="">Pilih</option>
    <% do while not data.eof %>
                <option value="<%= data("OPH_ID") %>"><%= left(data("OPH_ID"),2) %>-<% call getAgen(mid(data("OPH_ID"),3,3),"") %>/<%= mid(data("OPH_ID"),6,4) %>/<%= right(data("OPH_ID"),4) %></option>
    <%  
    data.movenext
    loop
    %>
</select>