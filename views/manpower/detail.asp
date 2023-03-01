<!--#include file="../../init.asp"-->
<% 
  ' if session("ENG5A") = false then
  '   Response.Redirect("index.asp")
  ' end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
  ' header data
  data_cmd.commandText = "SELECT dbo.DLK_T_ManPowerH.*, dbo.DLK_M_WebLogin.UserName, dbo.GLB_M_Agen.AgenName FROM dbo.DLK_T_ManPowerH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ManPowerH.MP_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ManPowerH.MP_Updateid = dbo.DLK_M_WebLogin.UserID WHERE DLK_T_ManPowerH.MP_ID = '"& id &"' AND MP_AktifYN = 'Y'"

  set data = data_cmd.execute
  ' detail data
  data_cmd.commandText = "SELECT dbo.HRD_M_Karyawan.Kry_Nama, dbo.DLK_M_WebLogin.UserName, dbo.DLK_T_ManPowerD.* FROM dbo.DLK_T_ManPowerD LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ManPowerD.MP_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.HRD_M_Karyawan ON dbo.DLK_T_ManPowerD.MP_Nip = dbo.HRD_M_Karyawan.Kry_NIP WHERE LEFT(MP_ID,4) = '"& left(data("MP_ID"),4) &"' AND RIGHT(MP_ID,7)= '"& RIGHT(data("MP_ID"),7) &"' ORDER BY Kry_Nama "
  ' response.write data_cmd.commandText & "<br>"
  set ddata = data_cmd.execute
  

  call header("Detail ManPower")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm-12 text-center mt-3">
      <h3>DETAIL DATA MANPOWER</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12 text-center mb-3 labelId">
      <h3><%= left(id,2) %>-<%= mid(id,3,2) %>/<%= mid(id,5,4) %>/<%= right(id,3)  %></h3>
    </div>
  </div>
  <div class="row p-2">
    <div class="col-sm-3 mb-3">
      <label>Cabang :</label>
      <input name="agen" id="agen" type="text" class="form-control" value="<%= data("AgenName") %>" readonly>
    </div>
    <div class="col-sm-3 mb-3">
      <label>No.Produksi :</label>
      <input name="tgl" id="tgl" type="text" class="form-control" value="<%= left(data("MP_PDHID"),2) %>-<%= mid(data("MP_PDHID"),3,3) %>/<%= mid(data("MP_PDHID"),6,4) %>/<%= right(data("MP_PDHID"),4)  %>" readonly>
    </div>
    <div class="col-sm-3 mb-3">
      <label>Tanggal :</label>
      <input name="tgl" id="tgl" type="text" class="form-control" value="<%= cdate(data("MP_Date")) %>" readonly>
    </div>
    <div class="col-sm-3 mb-3">
      <label>Update ID :</label>
      <input name="tgl" id="tgl" type="text" class="form-control" value="<%= data("username") %>" readonly>
    </div>
  </div>  
  <div class="row">
    <div class="col-sm-12 mb-3 d-flex justify-content-between">
      <button type="button" class="btn btn-secondary" onClick="window.open('export-XlsDetailMP.asp?id=<%=id%>','_self')">Export</button>
      <button type="button" onclick="window.location.href='index.asp'" class="btn btn-danger">Kembali</button>
    </div>
  </div>

  <!-- table detail  -->
  <div class="row">
    <div class="col-sm-12">
      <table class="table table-hover">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">No</th>
            <th scope="col">Nip</th>
            <th scope="col">Nama</th>
            <th scope="col">Salary</th>
            <th scope="col">Deskripsi</th>
            <th scope="col">UpdateID</th>
          </tr>
        </thead>
        <tbody>
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
            <td class="bg-primary text-light">Tahun</td>
            <td class="bg-primary text-light">Bulan</td>
            <td class="bg-primary text-light" colspan="3">Hari</td>
          </tr>
          <% do while not jhari.eof %>
            <tr>  
              <td></td>
              <td><%= jhari("TW_Tahun") %></td>
              <td><%= MonthName(jhari("TW_bulan")) %></td>
              <td colspan="3"><%= jhari("hari") %></td>
            </tr>
          <% 
            response.flush
            jhari.movenext
            loop
          response.flush
          ddata.movenext
          loop
          %>
        </tbody>
      </table>
    </div>
  </div>

  <hr style="border-top: 1px dotted red;">
  <footer style="font-size: 10px; text-align: center;">
    <p style="margin:0;padding:0;"> 		
        PT.DELIMA KAROSERI INDONESIA
    </p>
    <p style="text-transform: capitalize; color: #000;margin:0;padding:0;">User Login : <%= session("username") %>  | Cabang : <%= session("cabang") %> | <a href="logout.asp" target="_self">Logout</a></p>
    <p style="margin:0;padding:0;">Copyright MuhamadFirdausIT Division©2022-2023S.O.No.Bns.Wo.Instv</p>
    <p style="margin:0;padding:0;"> V.1 Mobile Responsive 2022 | V.2 On Progres 2023</p>
  </footer>
</div>

<% 
  call footer()
%>