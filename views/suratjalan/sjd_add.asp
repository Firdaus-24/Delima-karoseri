<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_suratjalan.asp"-->
<% 
  if session("ENG8A") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT dbo.DLK_T_SuratJalanH.*, dbo.DLK_M_Customer.custNama,  dbo.GLB_M_Agen.AgenName FROM dbo.DLK_T_SuratJalanH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_SuratJalanH.SJ_AgenID = dbo.GLB_M_Agen.AgenID  LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.DLK_T_SuratJalanH.SJ_CustID = dbo.DLK_M_Customer.custId WHERE (DLK_T_SuratJalanH.SJ_AktifYN = 'Y') AND (DLK_T_SuratJalanH.SJ_ID = '"& id &"')"

  set data = data_cmd.execute

  data_cmd.commandText = "SELECT dbo.DLK_T_SuratJalanD.SJD_TFKID, dbo.DLK_T_SuratJalanD.SJD_Keterangan, dbo.DLK_T_UnitCustomerD1.TFK_Merk, dbo.DLK_T_UnitCustomerD1.TFK_Type, dbo.DLK_T_UnitCustomerD1.TFK_Nopol, dbo.DLK_T_UnitCustomerD1.TFK_Norangka, dbo.DLK_T_UnitCustomerD1.TFK_NoMesin, dbo.DLK_T_SuratJalanD.SJD_ID, dbo.DLK_M_Brand.BrandName FROM dbo.DLK_T_SuratJalanD INNER JOIN dbo.DLK_T_UnitCustomerD1 ON dbo.DLK_T_SuratJalanD.SJD_TFKID = dbo.DLK_T_UnitCustomerD1.TFK_ID LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.DLK_T_UnitCustomerD1.TFK_Merk = dbo.DLK_M_Brand.BrandID WHERE LEFT(SJD_ID,10) = '"& data("SJ_ID") &"' ORDER BY SJD_ID"
  '  response.write data_cmd.commandText & "<br>"
  set ddata = data_cmd.execute

  ' cek data kedatangan unit
  data_cmd.commandTExt = "SELECT dbo.DLK_T_UnitCustomerD1.TFK_ID, dbo.DLK_T_UnitCustomerD1.TFK_Date, dbo.DLK_T_UnitCustomerD1.TFK_Merk, dbo.DLK_T_UnitCustomerD1.TFK_Type, dbo.DLK_T_UnitCustomerD1.TFK_Nopol, dbo.DLK_T_UnitCustomerD1.TFK_Norangka, dbo.DLK_T_UnitCustomerD1.TFK_NoMesin, dbo.DLK_T_UnitCustomerD1.TFK_Color, dbo.DLK_T_UnitCustomerD1.TFK_UpdateID, dbo.DLK_T_UnitCustomerD1.TFK_UpdateTime, dbo.DLK_M_Brand.BrandName FROM dbo.DLK_T_UnitCustomerH RIGHT OUTER JOIN dbo.DLK_T_UnitCustomerD1 ON dbo.DLK_T_UnitCustomerH.TFK_ID = LEFT(dbo.DLK_T_UnitCustomerD1.TFK_ID, 17) LEFT OUTER JOIN DLK_M_Brand ON DLK_T_UnitCustomerD1.TFK_Merk = DLK_M_Brand.BrandID WHERE (dbo.DLK_T_UnitCustomerH.TFK_CustID = '"& data("SJ_CustID") &"') AND NOT EXISTS(SELECT SJD_TFKID FROM DLK_T_SuratJalanD WHERE SJD_TFKID = dbo.DLK_T_UnitCustomerD1.TFK_ID) " 

  set dunit = data_cmd.execute

  
  call header("Detail SuratJalan") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>DETAIL SURAT JALAN</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3>
        <%= "Delima-DKI-" & left(id,3) %>/<%= mid(id,4,4) %>/<%= right(id,3)  %>
      </h3>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="agen" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="agen" name="agen" value="<%= data("agenName") %>" class="form-control" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" value="<%= cdate(data("SJ_Date")) %>" class="form-control" readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="customer" class="col-form-label">Customer</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="agen" name="agen" value="<%= data("custnama") %>" class="form-control" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="tgljt" class="col-form-label">Update ID</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgljt" name="tgljt" class="form-control" value="<%= data("SJ_UpdateiD") %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-10 mb-3">
      <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off"  value="<%= data("SJ_Keterangan") %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center d-flex justify-content-between">
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalDetailSuratJalan">Tambah Rincian</button>
      <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <table class="table table-hover">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">No</th>
            <th scope="col">Brand</th>
            <th scope="col">Type</th>
            <th scope="col">No.Chasist</th>
            <th scope="col">No.Mesin</th>
            <th scope="col">No.Polisi</th>
            <th scope="col">PDI</th>
            <th scope="col">Keterangan</th>
            <th scope="col" class="text-center">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <% 
          no = 0
          do while not ddata.eof 
          no = no + 1

          ' cek data PDI
          data_cmd.commandTExt = "SELECT PDI_ID FROM DLK_T_PreDevInspectionH WHERE PDI_TFKID = '"& ddata("SJD_TFKID") &"' AND PDI_AktifYN = 'Y'"
          set datapdi = data_cmd.execute
          %>
          <tr>
            <th>
              <%= no %>
            </th>
            <td>
              <%= ddata("brandName") %>
            </td>
            <td>
              <%= ddata("TFK_TYpe") %>
            </td>
            <td>
              <%= ddata("TFK_NOrangka") %>
            </td>
            <td>
              <%= ddata("TFK_Nomesin") %>
            </td>
            <td>
              <%= ddata("TFK_Nopol") %>
            </td>
            <td>
              <% if not datapdi.eof then %>
                <a href="<%= url %>views/pdi/detail.asp?id=<%= datapdi("PDI_ID") %>" style="text-decoration:none;color:black;" target="_blank"> 
                  <%= left(datapdi("PDI_ID"),3) &"-"& MID(datapdi("PDI_ID"),4,3) &"/"& MID(datapdi("PDI_ID"),7,4) &"/"& right(datapdi("PDI_ID"),3) %>
                </a>
              <% else %>
                -
              <% end if %>
            </td>
            <td>
              <%= ddata("SJD_Keterangan") %>
            </td>
            <td class="text-center">
                <div class="btn-group" role="group" aria-label="Basic example">
                <a href="aktifd.asp?id=<%= ddata("SJD_ID") %>&p=sjd_add" class="btn badge text-bg-danger" onclick="deleteItem(event,'Detail Nomor Sales Order')">Delete</a>
            </td>
          </tr>
          <% 
          
          ddata.movenext
          loop
          %>
        </tbody>
      </table>
    </div>
  </div>   
</div>  
<% 
  If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    call detailsurat() 
  end if
  call footer() 
%>
<!-- Modal -->
<div class="modal fade" id="modalDetailSuratJalan" tabindex="-1" aria-labelledby="modalDetailSuratJalanLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="modalDetailSuratJalanLabel">Rincian unit datang</h1>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <form action="sjd_add.asp?id=<%= data("SJ_ID") %>" method="POST" onsubmit="validasiForm(this,event,'Tambah Detail Surat Jalan','warning')">
          <input type="hidden" value="<%= data("SJ_ID") %>" name="strid">
          <div class="row">
              <div class="col-sm-12 mb-4 overflow-auto" style="height:15rem;font-size:14px;">
              <table class="table table-hover" >
                <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                    <tr>
                      <th scope="col">Merk</th>
                      <th scope="col">Type</th>
                      <th scope="col">No.Polisi</th>
                      <th scope="col">Pilih</th>
                    </tr>
                </thead>
                <tbody>
                  
                    <% 
                    do while not dunit.eof 
                    %>
                    <tr>
                      <td><%= dunit("BrandName")  %> </td>
                      <td><%= dunit("TFK_Type") %></td>
                      <td><%= dunit("TFK_NOpol") %></td>
                      <td>
                          <input class="form-check-input" type="radio" name="tfkid" id="tfkid" value="<%= dunit("TFK_ID") %>" required>
                      </td>
                    </tr>
                    <% 
                    response.flush
                    dunit.movenext
                    loop
                    %>
                </tbody>
              </table>
              </div>
              
          </div>
          <hr>
          <div class="row">
            <div class="col-sm-12 mb-3">
              <div class="form-floating">
                <textarea class="form-control" placeholder="Leave a comment here" id="keterangan" name="keterangan" style="height: 100px" maxlength="50"></textarea>
                <label for="keterangan">Keterangan</label>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-primary">Save</button>
          </form>
        </div>
    </div>
  </div>
