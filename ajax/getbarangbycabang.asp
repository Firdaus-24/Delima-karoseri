<!--#include file="../init.asp"-->  
<% 
    cabang = trim(Request.Form("cabang"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_String

    data_cmd.commandText = "SELECT * FROM DLK_M_Barang WHERE Brg_AktifYN = 'Y' AND LEFT(Brg_ID,3) = '"& cabang &"' ORDER BY Brg_Nama ASC"

    set barang = data_cmd.execute

%>
<select class="form-select" aria-label="Default select example" name="barang" id="barang" required> 
    <option value="">Pilih</option>
    <% do while not barang.eof %>
        <option value="<%= barang("Brg_ID") %>"><%= barang("Brg_Nama") %></option>
    <% 
    barang.movenext
    loop
    %>
</select>