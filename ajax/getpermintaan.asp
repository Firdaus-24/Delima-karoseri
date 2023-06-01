<!--#include file="../init.asp"-->
<% 
    agen = trim(Request.form("agen"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT * FROM DLK_M_Barang WHERE left(Brg_Id,3) = '"& agen &"' ORDER BY Brg_nama ASC"
    ' response.write data_cmd.commandText
    set data = data_cmd.execute

%>

<select class="form-select" aria-label="Default select example" name="brg" id="brg" required> 
        <option value="">Pilih</option>
    <% do while not data.eof %>
        <option value="<%= data("Brg_ID") %>"><%= data("Brg_nama") %></option>
    <%  
    data.movenext
    loop
    %>
</select>
