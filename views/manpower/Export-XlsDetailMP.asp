<!--#include file="../../init.asp"-->
<% 
  if session("PP2D") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
  ' header data
  data_cmd.commandText = "SELECT dbo.DLK_T_ManPowerH.*, dbo.DLK_M_WebLogin.UserName, dbo.GLB_M_Agen.AgenName FROM dbo.DLK_T_ManPowerH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ManPowerH.MP_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ManPowerH.MP_Updateid = dbo.DLK_M_WebLogin.UserID WHERE DLK_T_ManPowerH.MP_ID = '"& id &"' AND MP_AktifYN = 'Y'"

  set data = data_cmd.execute
  ' detail data
  data_cmd.commandText = "SELECT dbo.HRD_M_Karyawan.Kry_Nama, dbo.DLK_M_WebLogin.UserName, dbo.DLK_T_ManPowerD.* FROM dbo.DLK_T_ManPowerD LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ManPowerD.MP_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.HRD_M_Karyawan ON dbo.DLK_T_ManPowerD.MP_Nip = dbo.HRD_M_Karyawan.Kry_NIP WHERE LEFT(MP_ID,4) = '"& left(data("MP_ID"),4) &"' AND RIGHT(MP_ID,7)= '"& RIGHT(data("MP_ID"),7) &"'"
  ' response.write data_cmd.commandText & "<br>"
  set ddata = data_cmd.execute

  Response.ContentType = "application/vnd.ms-excel"
  Response.AddHeader "content-disposition", "filename=DetailManPower "&id&" .xls"
%>
<table width="100%">
  <tr>
    <th colspan="6" align="center">DETAIL DATA MANPOWER</th>
  </tr>
  <tr>
    <th colspan="6" align="center"><%= left(id,2) %>-<%= mid(id,3,2) %>/<%= mid(id,5,4) %>/<%= right(id,3)  %></th>
  </tr>
  <tr>
    <td colspan="6">&nbsp</td>
  </tr>
  <tr>
    <td>Cabang :</td>
    <td colspan="2"><%= data("AgenName") %></td>
    <td>No.Produksi :</td>
    <td >
      <%= left(data("MP_PDHID"),2) %>-<%= mid(data("MP_PDHID"),3,3) %>/<%= mid(data("MP_PDHID"),6,4) %>/<%= right(data("MP_PDHID"),4)  %>
    </td>
  </tr>
  <tr>
    <td>Tanggal :</td>
    <td colspan="2"><%= cdate(data("MP_Date")) %></td>
    <td>Update ID :</td>
    <td >
      <%= data("username")  %>
    </td>
  </tr>

  <tr>
    <th style="background-color: #808080;color:#fff;">No</th>
    <th style="background-color: #808080;color:#fff;">Nip</th>
    <th style="background-color: #808080;color:#fff;">Nama</th>
    <th style="background-color: #808080;color:#fff;">Salary</th>
    <th style="background-color: #808080;color:#fff;">Deskripsi</th>
    <th style="background-color: #808080;color:#fff;">UpdateID</th>
  </tr>
  <% 
  no = 0
  do while not ddata.eof
  no = no + 1

  ' cek data masuk karyawan
  data_cmd.commandText = "SELECT TW_Tahun, TW_Bulan, (TW_01 + TW_02 + TW_03 + TW_04 + TW_05 + TW_06 + TW_07 + TW_08 + TW_09 + TW_10 + TW_11 + TW_12 + TW_13 + TW_14 + TW_15 + TW_16 + TW_17 + TW_18 + TW_19 + TW_20	 + TW_21 + TW_22 + TW_23 + TW_24 + TW_25 + TW_26 + TW_27 + TW_28 + TW_29 + TW_30 + TW_31) as hari FROM DLK_T_TWMP WHERE TW_MPID = '"& ddata("MP_ID") &"' GROUP BY TW_Bulan, TW_Tahun, TW_01 + TW_02 + TW_03 + TW_04 + TW_05 + TW_06 + TW_07 + TW_08 + TW_09 + TW_10 + TW_11 + TW_12 + TW_13 + TW_14 + TW_15 + TW_16 + TW_17 + TW_18 + TW_19 + TW_20	 + TW_21 + TW_22 + TW_23 + TW_24 + TW_25 + TW_26 + TW_27 + TW_28 + TW_29 + TW_30 + TW_31 ORDER BY TW_Bulan, TW_Tahun"

  set jhari = data_cmd.execute
  %>
  <tr>
    <th scope="row"><%= no %></th>
    <td><%= ddata("MP_Nip") %></td>
    <td><%= ddata("Kry_Nama") %></td>
    <td><%= replace(formatcurrency(ddata("MP_Salary")),"$","") %></td>
    <td><%= ddata("MP_Deskripsi") %></td>
    <td><%= ddata("username") %></td>
  </tr>
  <tr >
    <td></td>
    <td style="background-color: #0000a0;color:#fff;">Tahun</td>
    <td style="background-color: #0000a0;color:#fff;">Bulan</td>
    <td style="background-color: #0000a0;color:#fff;" colspan="2">Hari</td>
  </tr>
  <% do while not jhari.eof %>
    <tr>  
      <td></td>
      <td><%= jhari("TW_Tahun") %></td>
      <td><%= MonthName(jhari("TW_bulan")) %></td>
      <td colspan="2"><%= jhari("hari") %></td>
    </tr>
  <% 
    response.flush
    jhari.movenext
    loop
  response.flush
  ddata.movenext
  loop
  %>
</table>
    