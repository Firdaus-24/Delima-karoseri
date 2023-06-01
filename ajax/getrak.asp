<!--#include file="../init.asp"-->
<% 
    id = trim(Request.form("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT Rak_ID,Rak_nama FROM DLK_M_Rak where LEFT(Rak_ID,3) = '"& id &"' AND NOT EXISTS(SELECT Brg_RakID FROM DLK_M_Barang WHERE Brg_RakID =  Rak_ID) ORDER BY Rak_nama"
    
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