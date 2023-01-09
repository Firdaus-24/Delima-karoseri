<!--#include file="../init.asp"-->
<%    
    cabang = trim(Request.Form("cabang"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_OrPemH.OPH_ID, SUM(dbo.DLK_T_OrPemD.OPD_QtySatuan) AS qtypo FROM dbo.DLK_T_OrPemH LEFT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13) WHERE (dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y') AND (dbo.DLK_T_OrPemH.OPH_AgenID = '"& cabang &"') GROUP BY dbo.DLK_T_OrPemH.OPH_ID ORDER BY dbo.DLK_T_OrPemH.OPH_ID"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute
%>
<select class="form-select" aria-label="Default select example" id="ophidFaktur" name="ophid" onchange="getValuePO(this.value)" required>
    <option value="">Pilih</option>
    <% do while not data.eof 
        ' cek qty po dengan penerimaan barang
        data_cmd.commandTExt = "SELECT dbo.DLK_T_InvPemH.IPH_OPHID, SUM(dbo.DLK_T_InvPemD.IPD_QtySatuan) AS qtyterima FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) WHERE (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_OPHID = '"& data("OPH_ID") &"') GROUP BY dbo.DLK_T_InvPemH.IPH_OPHID ORDER BY dbo.DLK_T_InvPemH.IPH_OPHID"

        set invoice = data_cmd.execute

        
        if not invoice.eof then
            if Cint(data("qtypo")) > Cint(invoice("qtyterima")) then
    %>
                <option value="<%= data("OPH_ID") %>"><%= left(data("OPH_ID"),2) %>-<% call getAgen(mid(data("OPH_ID"),3,3),"") %>/<%= mid(data("OPH_ID"),6,4) %>/<%= right(data("OPH_ID"),4) %></option>
    <%  
            end if
        else 
    %>
        <option value="<%= data("OPH_ID") %>"><%= left(data("OPH_ID"),2) %>-<% call getAgen(mid(data("OPH_ID"),3,3),"") %>/<%= mid(data("OPH_ID"),6,4) %>/<%= right(data("OPH_ID"),4) %></option>
    <%      
        end if
    data.movenext
    loop
    %>
</select>