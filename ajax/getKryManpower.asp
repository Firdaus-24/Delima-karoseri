<!--#include file="../init.asp"-->
<% 
  nama = trim(ucase(Request.Form("nama")))
  cabang = trim(Request.Form("cabang"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT Kry_nama,Kry_Nip FROM HRD_M_Karyawan WHERE Kry_AktifYN = 'Y' AND Kry_Nama LIKE '%"& nama &"%' AND Kry_AgenID = '"& cabang &"'"
  set data = data_cmd.execute
%>
  <% 
  angka = 0
  do while not data.eof
  angka = angka + 1
  %>
  <tr>
    <td><%= angka %></td>
    <td><%= data("Kry_Nip") %></td>
    <td><%= data("Kry_Nama") %></td>
    <td class="text-center">
      <div class="form-check">
        <input class="form-check-input" type="radio" value="<%= data("Kry_Nip") %>" id="kryNip" name="kryNip" required>
      </div>
    </td>
  </tr>
  <% 
  response.flush
  data.movenext
  loop
  %>
