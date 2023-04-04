<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_bebanprosesproduksi.asp"-->
<% 
  if session("PP4A") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
  

  ' header
  data_cmd.commandTExt = "SELECT dbo.GLB_M_Agen.AgenName,  dbo.DLK_T_BB_ProsesH.*, dbo.DLK_M_WebLogin.UserName FROM dbo.DLK_T_BB_ProsesH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_BB_ProsesH.BP_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_BB_ProsesH.BP_AgenID = dbo.GLB_M_Agen.AgenID WHERE BP_ID = '"& id &"' AND BP_AktifYN = 'Y'"

  set data = data_cmd.execute

  ' detail data
  data_cmd.commandTExt = "SELECT dbo.DLK_T_BB_ProsesD.BP_ID, dbo.DLK_M_BebanBiaya.BN_Nama, dbo.DLK_T_BB_ProsesD.BP_Jumlah, dbo.DLK_T_BB_ProsesD.BP_Keterangan, dbo.DLK_M_WebLogin.UserName FROM dbo.DLK_T_BB_ProsesD LEFT OUTER JOIN dbo.DLK_M_BebanBiaya ON dbo.DLK_T_BB_ProsesD.BP_BNID = dbo.DLK_M_BebanBiaya.BN_ID LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_BB_ProsesD.BP_UpdateID = dbo.DLK_M_WebLogin.UserID WHERE LEFT(BP_ID,12) = '"& data("BP_ID") &"' ORDER BY BP_ID ASC"

  set detail = data_cmd.execute

  ' get master beban 
  data_cmd.commandTExt = "SELECT BN_ID, BN_Nama FROM DLK_M_BebanBiaya WHERE BN_AktifYN = 'Y' ORDER BY BN_ID ASC"

  set databeban = data_cmd.execute

  call header("Form Beban Proses")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>FORM BEBAN PROSES PRODUKSI</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%= left(id,2) &"-"& mid(id,3,3) &"/"& mid(id,6,4) &"/"& right(id,3)%></h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="fakturagen" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="cabang" name="cabang" class="form-control" value="<%= data("AgenName") %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="pdhid" class="col-form-label">No Produksi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="pdhid" name="pdhid" class="form-control" value="<%= left(data("BP_PDHID"),2) %>-<%= mid(data("BP_PDHID"),3,3) %>/<%= mid(data("BP_PDHID"),6,4) %>/<%= right(data("BP_PDHID"),4)  %>" readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= Cdate(data("BP_Date")) %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="updateid" class="col-form-label">updateid</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="updateid" name="updateid" class="form-control" value="<%= data("username") %>" autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-10 mb-3">
      <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("BP_Keterangan") %>" autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 d-flex justify-content-between mb-3">
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalBebanProduksi">Rincian</button>
      <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
    </div>
  </div>

  <div class="row">
    <div class="col-sm-12">
      <table class="table table-hover">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">No</th>
            <th scope="col">Nama Beban</th>
            <th scope="col">Jumlah</th>
            <th scope="col">Update ID</th>
            <th scope="col">Keterangan</th>
            <th scope="col" class="text-center">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <% 
          no = 0
          do while not detail.eof 
          no = no + 1
          %>
          <tr>
            <th><%= no %></th>
            <td><%= detail("BN_Nama") %></td>
            <td><%= replace(formatCurrency(detail("BP_Jumlah")),"$","") %></td>
            <td><%= detail("username") %></td>
            <td><%= detail("BP_Keterangan") %></td>
            <td class="text-center">
              <a href="aktifd.asp?id=<%= detail("BP_ID") %>&p=bpd_add" class="btn badge text-bg-danger" onclick="deleteItem(event,'Detail Beban Proses')">Delete</a>
            </td>
          </tr>
          <% 
          Response.flush
          detail.movenext
          loop
          %>
        </tbody>
      </table>
    </div>

  </div>  

</div>  


<!-- Modal -->
<div class="modal fade" id="modalBebanProduksi" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalBebanProduksiLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modalBebanProduksiLabel">Rincian Beban Produksi</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="bpd_add.asp?id=<%= id %>" method="post">
      <div class="modal-body">
        <div class="row">
          <div class="col-sm-2 mb-3">
            <label>Cari</label>
          </div>
          <div class="col-sm-10 mb-3">
             <input type="text" id="keybpd" class="form-control">
             <input type="hidden" id="bpid" name="id" class="form-control" value="<%= data("BP_ID") %>">
          </div>
        </div>

        <div class="row">
          <div class="col-sm-12 mb-3  overflow-auto" style="height:15rem;">
            <table class="table table-striped" >
              <thead class="bg-info" style="position: sticky;top: 0;">
                <tr>
                  <td>No</td>
                  <td>Nama Beban</td>
                  <td>Pilih</td>
                </tr>
              </thead>
              <tbody class="contentBebanProses">
                <% do while not databeban.eof %>
                <tr>
                  <td><%= databeban("BN_ID") %></td>
                  <td><%= databeban("BN_Nama") %></td>
                  <td>
                    <input class="form-check-input" type="radio" name="bnid" id="bnid1" value="<%= databeban("BN_ID") %>" required>
                  </td>
                </tr>
                <% 
                Response.flush
                databeban.movenext  
                loop
                %>
              </tbody>
            </table>
          </div>
        </div>

        <div class="row">
          <div class="col-sm-3 mb-3">
            <label for="jumlah">Jumlah</label>
          </div>
          <div class="col-sm-6 mb-3">
            <input type="number" class="form-control" name="jumlah" id="jumlah" required>
          </div>
        </div>

        <div class="row">
          <div class="col-sm-3 mb-3">
            <label for="keterangan">keterangan</label>
          </div>
          <div class="col-sm-9 mb-3">
            <input type="text" class="form-control" name="keterangan" id="keterangan" autocomplete="off" maxlength="30" required>
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
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call detailBeban()
  end if
  call footer()
%>
