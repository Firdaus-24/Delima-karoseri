<!--#include file="../../init.asp"-->
<% 
    divisi = trim(Request.Form("divisi"))

    set data =  Server.CreateObject ("ADODB.Command")
    data.ActiveConnection = mm_delima_string
    ' get departement
    data.commandText = "SELECT depNama, depID FROM HRD_M_Departement LEFT OUTER JOIN HRD_M_Divisi ON HRD_M_Departement.depDivID = HRD_M_Divisi.DivID WHERE depAktifYN = 'Y' AND DepDivID = '"& divisi &"' ORDER BY depNama ASC"
    ' response.write data.commandtext & "<br>"
    set departement = data.execute 
%>
  <select class="form-select" aria-label="Default select example" name="departement" id="departement" required> 
    <option value="">Pilih</option>
    <% do while not departement.eof %>
        <option value="<%= departement("depID") %>"><%= departement("depNama") %></option>
    <% 
    departement.movenext
    loop
    %>
  </select>