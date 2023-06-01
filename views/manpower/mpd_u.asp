<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_manpower.asp"-->
<% 
  if session("PP2B") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
  ' header data
  data_cmd.commandText = "SELECT dbo.DLK_T_ManPowerH.*, dbo.DLK_M_WebLogin.UserName, dbo.GLB_M_Agen.AgenName FROM dbo.DLK_T_ManPowerH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ManPowerH.MP_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ManPowerH.MP_Updateid = dbo.DLK_M_WebLogin.UserID WHERE DLK_T_ManPowerH.MP_ID = '"& id &"' AND MP_AktifYN = 'Y'"

  set data = data_cmd.execute
  ' detail data
  data_cmd.commandText = "SELECT dbo.HRD_M_Karyawan.Kry_Nama, dbo.DLK_M_WebLogin.UserName, dbo.DLK_T_ManPowerD.* FROM dbo.DLK_T_ManPowerD LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ManPowerD.MP_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.HRD_M_Karyawan ON dbo.DLK_T_ManPowerD.MP_Nip = dbo.HRD_M_Karyawan.Kry_NIP WHERE LEFT(MP_ID,4) = '"& left(data("MP_ID"),4) &"' AND RIGHT(MP_ID,7)= '"& RIGHT(data("MP_ID"),7) &"' ORDER BY Kry_Nama"
  ' response.write data_cmd.commandText & "<br>"
  set ddata = data_cmd.execute
  ' karyawan data
  data_cmd.commandText = "SELECT kry_Nip,Kry_Nama, Kry_SttKerja FROM HRD_M_Karyawan WHERE Kry_AktifYN = 'Y' AND Kry_agenID = '"& data("MP_AgenID") &"' ORDER BY Kry_Nama ASC"

  set karyawan = data_cmd.execute

  call header("Update Detail ManPower")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm-12 text-center mt-3">
      <h3>UPDATE DETAIL DATA MANPOWER</h3>
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
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalManpower">Tambah Karyawan</button>
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
            <th scope="col" class="text-center">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <% 
          no = 0
          do while not ddata.eof
          no = no + 1
          %>
          <tr>
            <th scope="row"><%= no %></th>
            <td><%= ddata("MP_Nip") %></td>
            <td><%= ddata("Kry_Nama") %></td>
            <td><%= replace(formatcurrency(ddata("MP_Salary")),"$","") %></td>
            <td><%= ddata("MP_Deskripsi") %></td>
            <td><%= ddata("username") %></td>
            <td class="text-center">
              <div class="btn-group" role="group" aria-label="Basic example">
                <% if session("PP2C") =  true then %>
                  <a href="aktifd.asp?id=<%= ddata("MP_ID") %>&p=mpd_u" class="btn badge text-bg-danger" onclick="deleteItem(event,'Karyawan ManPower')">Delete</a>
                <% end if %>
                <% if session("PP2E") =  true then %>
                  <a href="../TW/?id=<%= ddata("MP_ID") %>" class="btn badge text-bg-light">Time Work</a>
                <% end if %>
              </div>
            </td>
          </tr>
          <% 
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

<!-- Modal -->
<div class="modal fade" id="modalManpower" tabindex="-1" aria-labelledby="modalManpowerLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modalManpowerLabel">Daftar Karyawan</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="mpd_u.asp?id=<%= id %>" method="post" onsubmit="validasiForm(this,event,'Detail Manpower','warning')">
      <div class="modal-body">
        <div class="row">
          <div class="col-sm-12 mb-3">
            <input type="hidden" id="id" name="id" class="form-control" autocomplete="off" value="<%= data("MP_ID") %>">
            <input type="hidden" id="cabangManpower" class="form-control" autocomplete="off" value="<%= data("MP_AgenID") %>">
            <input type="text" id="kryManpower" class="form-control" autocomplete="off" placeholder="Cari nama Karyawan">
          </div>
        </div>
        <div class="row">
          <div class="col-sm mb-4 overflow-auto" style="height:15rem;">
            <table class="table table-hover" >
              <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                <tr>
                  <th scope="col">No</th>
                  <th scope="col">Nip</th>
                  <th scope="col">Nama</th>
                  <th scope="col">Status Kerja</th>
                  <th scope="col" class="text-center">Pilih</th>
                </tr>
              </thead>
              <tbody id="contentTblManpower">
                <% 
                angka = 0
                do while not karyawan.eof
                angka = angka + 1

                ' cek status kerja
                if karyawan("Kry_SttKerja") = 1 then
                  sttkerja = "Borongan"
                elseif karyawan("Kry_SttKerja") = 2 then
                  sttkerja = "Harian"
                elseif karyawan("Kry_SttKerja") = 3 then
                  sttkerja = "Kontrak"
                elseif karyawan("Kry_SttKerja") = 4 then
                  sttkerja = "Magang"
                else
                  sttkerja = ""
                end if
                %>
                <tr>
                  <td><%= angka %></td>
                  <td><%= karyawan("Kry_Nip") %></td>
                  <td><%= karyawan("Kry_Nama") %></td>
                  <td><%= sttkerja %></td>
                  <td class="text-center">
                    <div class="form-check">
                      <input class="form-check-input" type="radio" value="<%= karyawan("Kry_Nip") %>" id="kryNip" name="kryNip" required>
                    </div>
                  </td>
                </tr>
                <% 
                response.flush
                karyawan.movenext
                loop
                %>
              </tbody>
            </table>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-2 ">
            <label for="salary">Salary</label>
          </div>
          <div class="col-sm mb-3">
            <input type="number" id="salary" name="salary" class="form-control" autocomplete="off" required>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-2">
            <label for="deskripsi">Deskripsi</label>
          </div>
          <div class="col-sm  mb-3">
            <textarea class="form-control" rows="3" name="deskripsi" id="deskripsi" autocomplete="off" required></textarea>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Save</button>
      </div>
    </div>
    </form>
  </div>
</div>
<% 
  If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    call updatemanpowerD()
  end if
  call footer()
%>