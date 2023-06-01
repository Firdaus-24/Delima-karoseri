<!--#include file="../init.asp"-->
<% 
  nama = trim(ucase(Request.Form("nama")))
  cabang = trim(Request.Form("cabang"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT Kry_nama,Kry_Nip, Kry_SttKerja FROM HRD_M_Karyawan WHERE Kry_AktifYN = 'Y' AND Kry_Nama LIKE '%"& nama &"%' AND Kry_AgenID = '"& cabang &"'"
  set data = data_cmd.execute
%>
  <% 
  angka = 0
  do while not data.eof
  angka = angka + 1

  ' cek status kerja
  if data("Kry_SttKerja") = 1 then
    sttkerja = "Borongan"
  elseif data("Kry_SttKerja") = 2 then
    sttkerja = "Harian"
  elseif data("Kry_SttKerja") = 3 then
    sttkerja = "Kontrak"
  elseif data("Kry_SttKerja") = 4 then
    sttkerja = "Magang"
  else
    sttkerja = ""
  end if
  %>
  <tr>
    <td><%= angka %></td>
    <td><%= data("Kry_Nip") %></td>
    <td><%= data("Kry_Nama") %></td>
    <td><%= sttkerja %></td>
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
