<!--#include file="../../init.asp"-->
<% 
  nama = trim(Request.Form("nama"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT BN_ID, BN_Nama FROM DLK_M_BebanBiaya WHERE BN_AktifYN = 'Y' AND UPPER(BN_Nama) LIKE '%"& ucase(nama) &"%' ORDER BY BN_ID ASC"

  set data = data_cmd.execute

  if not data.eof then
%>

<% do until data.eof %>
  <tr>
    <td><%= data("BN_ID") %></td>
    <td><%= data("BN_Nama") %></td>
    <td>
      <input class="form-check-input" type="radio" name="bnid" id="bnid1" value="<%= data("BN_ID") %>" required>
    </td>
  </tr>
<% 
Response.flush
data.movenext  
loop

else
%>
  <tr rowspan="2">
    <td colspan="3" align="center">DATA TIDAK DITEMUKAN</td>
  </tr>
<% end if %>