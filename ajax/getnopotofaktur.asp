<!--#include file="../init.asp"-->
<%    
    cabang = trim(Request.Form("cabang"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_OrPemH.OPH_ID FROM dbo.DLK_T_OrPemH WHERE OPH_AktifYN = 'Y' AND OPH_AgenID = '"& cabang &"' AND NOT EXISTS(SELECT IPH_OPHID FROM DLK_T_InvPemH WHERE IPH_AktifYN = 'Y' AND IPH_OPHID = OPH_ID) ORDER BY dbo.DLK_T_OrPemH.OPH_ID DESC"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute
%>
<select class="form-select" aria-label="Default select example" id="ophid" name="ophid" required>
    <option value="">Pilih</option>
    <% do while not data.eof %>
    <option value="<%= data("OPH_ID") %>"><%= left(data("OPH_ID"),2) %>-<% call getAgen(mid(data("OPH_ID"),3,3),"") %>/<%= mid(data("OPH_ID"),6,4) %>/<%= right(data("OPH_ID"),4) %></option>
    <% 
    data.movenext
    loop
    %>
</select>