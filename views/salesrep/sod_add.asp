<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_orderrepair.asp"-->
<% 
  if session("MK2A") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT dbo.MKT_T_OrJulrepairH.*, dbo.DLK_M_Customer.custNama,  dbo.GLB_M_Agen.AgenName FROM dbo.MKT_T_OrJulrepairH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.MKT_T_OrJulrepairH.ORH_AgenID = dbo.GLB_M_Agen.AgenID  LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.MKT_T_OrJulrepairH.ORH_CustID = dbo.DLK_M_Customer.custId WHERE (MKT_T_OrJulrepairH.ORH_AktifYN = 'Y') AND (MKT_T_OrJulrepairH.ORH_ID = '"& id &"')"

  set data = data_cmd.execute

  data_cmd.commandText = "SELECT dbo.DLK_M_Class.ClassName, dbo.DLK_M_Brand.BrandName, dbo.MKT_T_OrjulRepairD.ORD_ID, dbo.MKT_T_OrjulRepairD.ORD_Qtysatuan, dbo.MKT_T_OrjulRepairD.ORD_Harga, dbo.MKT_T_OrjulRepairD.ORD_Diskon, dbo.MKT_T_OrjulRepairD.ORD_Keterangan, dbo.MKT_T_OrjulRepairD.ORD_UpdateId, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_WebLogin.UserName FROM dbo.MKT_T_OrjulRepairD LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.MKT_T_OrjulRepairD.ORD_UpdateId = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.MKT_T_OrjulRepairD.ORD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.MKT_T_OrjulRepairD.ORD_BrandID = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.DLK_M_Class ON dbo.MKT_T_OrjulRepairD.ORD_ClassID = dbo.DLK_M_Class.ClassID WHERE LEFT(dbo.MKT_T_OrJulRepairD.ORD_ID,13) = '"& data("ORH_ID") &"' ORDER BY dbo.MKT_T_OrjulRepairD.ORD_ID" ' response.write data_cmd.commandText & "<br>"
  set ddata = data_cmd.execute

  ' get data class 
  data_cmd.commandTExt = "SELECT Classid, ClassName FROM DLK_M_Class WHERE ClassAktifYN  = 'Y' ORDER BY Classid"
  set dataclass = data_cmd.execute

  ' get data brand 
  data_cmd.commandTExt = "SELECT BrandID, BrandName FROM DLK_M_Brand WHERE BRandAktifYN = 'Y' ORDER BY BrandID ASC"
  set databrand = data_cmd.execute

  ' set satuan
  data_cmd.commandTExt = "SELECT Sat_ID, Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama"

  set datasatuan = data_cmd.execute

  call header("Tambah SalesOrder") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>FORM TAMBAH SALES ORDER REPAIR</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3>
        <%= left(id,2) %>-<%= mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,4)  %>
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
      <input type="text" id="tgl" name="tgl" value="<%= cdate(data("ORH_Date")) %>" class="form-control" readonly>
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
      <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgljt" name="tgljt" class="form-control" <% if Cdate(data("ORH_JTDate")) <> Cdate("1/1/1900") then%> value="<%= cdate(data("ORH_JTDate")) %>" <% end if %> readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="diskon" class="col-form-label">Diskon All</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group ">
        <input type="number" id="diskon" name="diskon" value="<%= data("ORH_DiskonAll") %>"  class="form-control" readonly>
        <span class="input-group-text" >%</span>
      </div>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="ppn" class="col-form-label">PPn</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group">
        <input type="number" id="ppn" name="ppn" class="form-control"  value="<%= data("ORH_ppn") %>" readonly>
        <span class="input-group-text" >%</span>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="timeWork" class="col-form-label">Lama Pengerjaan</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group">
        <input type="number" id="timeWork" name="timeWork" class="form-control"  value="<%= data("ORH_timeWork") %>" readonly>
        <span class="input-group-text">/ Hari</span>
      </div>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="uangmuka" class="col-form-label">Uang Muka Terbayar</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="input-group">
        <input type="text" id="uangmuka" name="uangmuka" class="form-control"  value="<%= replace(formatcurrency(data("ORH_uangmuka")),"$","") %>" readonly>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
        <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-10 mb-3">
        <div class="form-floating">
          <textarea class="form-control" id="keterangan" name="keterangan" style="height: 100px" readonly><%= data("ORH_Keterangan") %></textarea>
        </div>
      </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center d-flex justify-content-between">
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalSORepair">Tambah Rincian</button>
      <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
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
                <%= left(ddata("ORD_ID"),2) %>-<%= mid(ddata("ORD_ID"),3,3) %>/<%= mid(ddata("ORD_ID"),6,4) %>/<%= mid(ddata("ORD_ID"),10,4) %>/<%= right(ddata("ORD_ID"),3)  %>
              </th>
              <td>
                <%= ddata("className") %>
              </td>
              <td>
                <%= ddata("brandName") %>
              </td>
              <td>
                <%= ddata("ORD_Qtysatuan")%>
              </td>
              <td>
                <%= ddata("sat_Nama")%>
              </td>
              <td>
                <%= replace(formatCurrency(ddata("ORD_Harga")),"$","")%>
              </td>
              <td>
                <%= ddata("ORD_Diskon")%>
              </td>
              <td>
                <%= ddata("username")%>
              </td>
              <td class="text-center">
                <% if session("MK2C") = true then %>
                <div class="btn-group" role="group" aria-label="Basic example">
                <a href="aktifd.asp?id=<%= ddata("ORD_ID") %>&p=sod_add" class="btn badge text-bg-danger" onclick="deleteItem(event,'Detail Nomor Sales Order')">Delete</a>
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
<div class="modal fade" id="modalSORepair" tabindex="-1" aria-labelledby="modalSORepairLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modalSORepairLabel">Rincian Detail</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="sod_add.asp?id=<%= id %>" method="post" onsubmit="validasiForm(this,event,'Tambah Detail Sales Order Repair','warning')">

      <div class="modal-body">
        <input type="hidden" value="<%= id %>" name="id">
        <div class="row">
          <div class="col-sm-3 mb-3">
            <label class="form-check-label" for="class">Class</label>
          </div>
          <div class="col-sm-9 mb-3">
            <select class="form-select" aria-label="Default select example" name="class" name="class" required>
              <option value="">Pilih</option>
              <% Do While not dataclass.eof%>
              <option value="<%= dataclass("classid") %>"><%= dataclass("classname") %></option>
              <% 
              dataclass.movenext
              loop
              %>   
            </select>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-3 mb-3">
            <label class="form-check-label" for="brand">Brand</label>
          </div>
          <div class="col-sm-9 mb-3">
            <select class="form-select" aria-label="Default select example" name="brand" name="brand" required>
              <option value="">Pilih</option>
              <% Do While not databrand.eof%>
              <option value="<%= databrand("brandid") %>"><%= databrand("brandname") %></option>
              <% 
              databrand.movenext
              loop
              %>   
            </select>
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
              <input type="number" name="harga" id="harga" class="form-control" required>
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
          <textarea class="form-control" id="keterangan" name="keterangan" placeholder="Description" style="height: 100px" maxlength="50"></textarea>
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
<% if request.ServerVariables("REQUEST_METHOD")="POST" then
    call detailrepair() 
  end if 
    
call footer() %>