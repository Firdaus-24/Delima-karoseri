<!--#include file="../init.asp"-->
<% 
    cabang = trim(Request.Form("cabang"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_String

    data_cmd.commandText = "SELECT Ven_ID,Ven_Nama FROM DLK_M_Vendor WHERE Ven_AktifYN = 'Y' AND LEFT(Ven_ID,3) = '"& cabang &"' ORDER BY Ven_Nama ASC"    

    set data = data_cmd.execute
%>  
<select class="form-select" aria-label="Default select example" name="venid" id="venid" required> 
        <option value="">Pilih</option>
    <% do while not data.eof %>
        <option value="<%= data("ven_ID") %>"><%= data("Ven_Nama") %></option>
    <%  
    data.movenext
    loop
    %>
</select>
