<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_invrepair.asp"-->
<% 
  if (session("MK4A") = false AND session("MK4A") <>  "") OR (session("MK4B") = false AND session("MK4B")) then
    Response.Redirect("./")
  end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.MKT_T_InvRepairH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Customer.custNama FROM dbo.MKT_T_InvRepairH LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.MKT_T_InvRepairH.INV_CustID = dbo.DLK_M_Customer.custId LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.MKT_T_InvRepairH.INV_Agenid = dbo.GLB_M_Agen.AgenID WHERE INV_AktifYN = 'Y' AND INV_ID = '"& id &"'"
  ' response.write data_cmd.commandText & "<br>"
  set data = data_cmd.execute

  ' detail invoice
  data_cmd.commandText = "SELECT dbo.DLK_M_Class.ClassName, dbo.DLK_M_Brand.BrandName, dbo.MKT_T_InvRepairD.IRD_INVID, dbo.MKT_T_InvRepairD.IRD_Qtysatuan,dbo.MKT_T_InvRepairD.IRD_Harga, dbo.MKT_T_InvRepairD.IRD_Diskon, dbo.MKT_T_InvRepairD.IRD_Keterangan, dbo.MKT_T_InvRepairD.IRD_UpdateId, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_WebLogin.UserName FROM dbo.MKT_T_InvRepairD LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.MKT_T_InvRepairD.IRD_UpdateId = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.MKT_T_InvRepairD.IRD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.MKT_T_InvRepairD.IRD_BrandID = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.DLK_M_Class ON dbo.MKT_T_InvRepairD.IRD_ClassID = dbo.DLK_M_Class.ClassID WHERE LEFT(dbo.MKT_T_InvRepairD.IRD_INVID,13) = '"& data("INV_ID") &"' ORDER BY dbo.MKT_T_InvRepairD.IRD_INVID"

  set ddata = data_cmd.execute

  ' get data po 
  data_cmd.commandtext = "SELECT dbo.DLK_M_Class.ClassName, dbo.DLK_M_Brand.BrandName, dbo.MKT_T_OrjulRepairD.ORD_ID, dbo.MKT_T_OrjulRepairD.ORD_Qtysatuan, dbo.MKT_T_OrjulRepairD.ORD_Harga, dbo.MKT_T_OrjulRepairD.ORD_Diskon, dbo.MKT_T_OrjulRepairD.ORD_Keterangan, dbo.MKT_T_OrjulRepairD.ORD_UpdateId, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_WebLogin.UserName FROM dbo.MKT_T_OrjulRepairD LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.MKT_T_OrjulRepairD.ORD_UpdateId = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.MKT_T_OrjulRepairD.ORD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.MKT_T_OrjulRepairD.ORD_BrandID = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.DLK_M_Class ON dbo.MKT_T_OrjulRepairD.ORD_ClassID = dbo.DLK_M_Class.ClassID WHERE LEFT(dbo.MKT_T_OrJulRepairD.ORD_ID,13) = '"& data("INV_ORHID") &"' ORDER BY dbo.MKT_T_OrjulRepairD.ORD_ID"

  set orrepair = data_cmd.execute

  ' data satuan
  data_cmd.commandTExt = "SELECT Sat_ID, Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama"
  set datasatuan = data_cmd.execute

  call header("Tambah Invoice Repair")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>FORM DETAIL INVOICE REPAIR</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%= LEFT(id,2) &"-"& mid(id,3,3) &"/"& mid(id,6,4) &"/"&  right(id,4) %></h3>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="agen" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="" name="" value="<%= data("AgenName") %>"  class="form-control" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="ophid" class="col-form-label">No P.O</label>
    </div>
    <div class="col-lg-4 mb-3 inv-repairmkt-lama">
      <input type="text" id="" name="" value="<%= left(data("INV_ORHID"),2) %>-<%= mid(data("INV_ORHID"),3,3) %>/<%= mid(data("INV_ORHID"),6,4) %>/<%= right(data("INV_ORHID"),4) %>"  class="form-control" readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="" name="" value="<%= Cdate(data("INV_Date")) %>"  class="form-control" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="" class="col-form-label">Tanggal Jatuh Tempo</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="" name="" <% if  Cdate(data("INV_JTDate")) <> Cdate("1900-01-01") then %> value="<%= Cdate(data("INV_JTDate")) %>" <% end if %> class="form-control" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="customer" class="col-form-label">Customer</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="text" class="form-control" id="" name="custname" value="<%= data("custNama") %>" readonly>
      </div>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="uangmuka" class="col-form-label">Uang Muka Terbayar</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="text" class="form-control" id="uangmuka-repair" name="uangmuka" value="<%= replace(formatcurrency(data("INV_Uangmuka")),"$","Rp. ") %>" readonly>
      </div>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="diskon" class="col-form-label">Diskon All</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="number" class="form-control" id="diskon-repair" name="diskon" value="<%= data("Inv_DiskonAll") %>" readonly>
        <span class="input-group-text" >%</span>
      </div>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="ppn" class="col-form-label">PPn</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="number" class="form-control" id="" name="ppn" value="<%= data("Inv_PPN") %>" readonly>
        <span class="input-group-text" >%</span>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" class="form-control" id="" name="ppn" value="<%= data("INV_Keterangan") %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="timework" class="col-form-label">Lama Pengerjaan</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="text" class="form-control" id="" name="ppn" value="<%= data("INV_timework") %>" readonly>
        <span class="input-group-text" >Hari</span>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center d-flex justify-content-between">
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalInvRepair">Tambah Rincian</button>
      <a href="./" type="button" class="btn btn-danger">Kembali</a>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <table class="table table-hover">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">ID</th>
            <th scope="col">Class</th>
            <th scope="col">Brand</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
            <th scope="col">Harga</th>
            <th scope="col">Diskon</th>
            <th scope="col">UpdateID</th>
            <th scope="col" class="text-center">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <% 
          do while not ddata.eof 
          %>
            <tr>
              <th>
                <%= left(ddata("IRD_INVID"),2) %>-<%= mid(ddata("IRD_INVID"),3,3) %>/<%= mid(ddata("IRD_INVID"),6,4) %>/<%= mid(ddata("IRD_INVID"),10,4) %>/<%= right(ddata("IRD_INVID"),3)  %>
              </th>
              <td>
                <%= ddata("className") %>
              </td>
              <td>
                <%= ddata("brandName") %>
              </td>
              <td>
                <%= ddata("IRD_Qtysatuan")%>
              </td>
              <td>
                <%= ddata("sat_Nama")%>
              </td>
              <td>
                <%= replace(formatCurrency(ddata("IRD_Harga")),"$","")%>
              </td>
              <td>
                <%= ddata("IRD_Diskon")%>
              </td>
              <td>
                <%= ddata("username")%>
              </td>
              <td class="text-center">
                <% if session("MK2C") = true then %>
                <div class="btn-group" role="group" aria-label="Basic example">
                <a href="aktifd.asp?id=<%= ddata("IRD_INVID") %>&p=sod_add" class="btn badge text-bg-danger" onclick="deleteItem(event,'Detail Nomor Sales Order')">Delete</a>
                <% end if %>
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
<!-- Modal -->
<div class="modal fade" id="modalInvRepair" tabindex="-1" aria-labelledby="modalInvRepairLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modalInvRepairLabel">Rincian Detail</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="invd_add.asp?id=<%= id %>" method="post" onsubmit="validasiForm(this,event,'Tambah Detail Invoice Repair','warning')">

      <div class="modal-body">
        <input type="hidden" value="<%= id %>" name="id">
        <div class="row">
          <div class="col-sm mb-4 overflow-auto" style="height:15rem;">
            <table class="table table-hover" style="font-size:12px;">
              <thead class="bg-secondary text-light">
                <tr>
                  <th scope="col">Class</th>
                  <th scope="col">Brand</th>
                  <th scope="col" class="text-center">Pilih</th>
                </tr>
              </thead>
              <tbody>
                <% 
                do while not orrepair.eof 
                %>
                  <tr>
                    <td>
                      <%= orrepair("className") %>
                    </td>
                    <td>
                      <%= orrepair("brandName") %>
                    </td>
                    <td class="text-center">
                      <input class="form-check-input" type="radio" id="ordid" name="ordid" value="<%= orrepair("ORD_ID") %>" required>
                    </td>
                  </tr>
                <% 
                orrepair.movenext
                loop
                %>
              </tbody>
            </table>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-3 mb-3">
            <label class="form-check-label" for="qty">
              Quantity
            </label>
          </div>
          <div class="col-sm-6 mb-3">
            <input type="number" name="qty" id="qty" class="form-control" required>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-3 mb-3">
            <label class="form-check-label" for="satuan">
                Satuan
            </label>
          </div>
          <div class="col-sm-9 mb-3">
            <select class="form-select" aria-label="Default select example" name="satuan" name="satuan" required>
              <option value="">Pilih</option>
              <% Do While not datasatuan.eof%>
              <option value="<%= datasatuan("Sat_ID") %>"><%= datasatuan("Sat_Nama") %></option>
              <% 
              datasatuan.movenext
              loop
              %>   
            </select>
          </div>
        </div>
        <div class="row">
            <div class="col-sm-3 mb-3">
              <label class="form-check-label" for="harga">
                  Harga
              </label>
            </div>
            <div class="col-sm-9 mb-3">
              <input type="text" name="harga" id="harga-invrepair" class="form-control" onchange="settingFormatRupiah(this.value, 'harga-invrepair')" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3 mb-3">
              <label class="form-check-label" for="diskon">
                  Diskon
              </label>
            </div>
            <div class="col-sm-6 mb-3">
              <input type="number" name="diskon" id="diskon" class="form-control">
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3 mb-3">
              <label class="form-check-label" for="keterangan">
                  Keterangan
              </label>
            </div>
            <div class="col-sm-9 mb-3">
              <div class="form-floating">
          <textarea class="form-control" id="keterangan" name="keterangan" placeholder="Description" style="height: 100px" required></textarea>
          <label for="keterangan">Description</label>
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
</div>  
<% 
  if request.ServerVariables("REQUEST_METHOD") = "POST" then
    call detailInvoice()
  end if
  call footer()
%>