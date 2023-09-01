<!--#include file="../../init.asp"-->
<% 
  id =  trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' data header
  data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.DLK_T_VoucherH.* FROM dbo.DLK_T_VoucherH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_VoucherH.VCH_Agenid = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_VoucherH.VCH_AktifYN = 'Y') AND (dbo.DLK_T_VoucherH.VCH_id = '"& id &"')"

  set data = data_cmd.execute

  if data.eof then
    Response.Redirect("./")
  end if

  ' detail
  data_cmd.commandTExt = "SELECT dbo.DLK_T_VoucherD.*, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_TypeBarang.T_Nama FROM dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID RIGHT OUTER JOIN dbo.DLK_T_VoucherD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_VoucherD.VCH_Item LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_VoucherD.VCH_Satid = dbo.DLK_M_SatuanBarang.Sat_ID WHERE LEFT(DLK_T_VoucherD.VCH_VCHID,13) = '"& data("VCH_ID") &"' ORDER BY Brg_Nama, T_Nama ASC"

  set ddata = data_cmd.execute

  call header("Detail Voucher")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>DETAIL VOUCHER</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%=left(id,2) %>-<%= mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,4)%></h3>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="agen" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <select class="form-select" aria-label="Default select example" id="agen" name="agen" disabled>
        <option value="<%=data("VCH_Agenid")%>"><%=data("agenname")%></option>
      </select>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="tprod" class="col-form-label">Type Produksi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="cktprod" id="cktprod1" value="N" onchange="RemoveDesableVoucher($(this).val())" <%if data("VCH_Type") = "N" then %>checked <%end if%>  disabled>
        <label class="form-check-label" for="cktprod1">
            New Produksi
        </label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="cktprod" value="R" id="cktprod2"  onchange="RemoveDesableVoucher($(this).val())" <%if data("VCH_Type") = "R" then %>checked <%end if%> disabled>
        <label class="form-check-label" for="cktprod2">
            Produksi Repair
        </label>
      </div>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="pdhid" class="col-form-label">New Produksi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <select class="form-select" aria-label="Default select example" id="voucherAddpdhid" name="pdhid" <%if data("VCH_PDDID") = "" then%> disabled <%end if%> disabled>
        <%if data("VCH_PDDID") = "" then%>
          <option value="">Pilih</option>
        <%else%>
          <option value="<%= data("VCH_PDDID") %>"><%= left(data("VCH_PDDID"),2) %>-<%= mid(data("VCH_PDDID"),3,3) %>/<%= mid(data("VCH_PDDID"),6,4) %>/<%= mid(data("VCH_PDDID"),10,4) %>/<%= right(data("VCH_PDDID"),3) %></option>
        <%end if%>
      </select>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" value="<%= Cdate(data("VCH_Date")) %>" onfocus="(this.type='date')" class="form-control" disabled>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="pdrid" class="col-form-label">Repair Produksi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <select class="form-select" aria-label="Default select example" id="voucherAddpdrid" name="pdrid" <%if data("VCH_PDRID") = "" then%> disabled <%end if%> disabled>
        <%if data("VCH_PDRID") = "" then%>
          <option value="">Pilih</option>
        <%else%>
          <option value="<%= data("VCH_PDRID") %>"><%= LEFT(data("VCH_PDRID"),3) &"-"& MID(data("VCH_PDRID"),4,2) &"/"& RIGHT(data("VCH_PDRID"),3) %></option>
        <%end if%>
      </select>
    </div>
    <div class="col-lg-2 mb-3">
        <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-4 mb-3">
        <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="100" value="<%=data("VCH_Keterangan")%>" autocomplete="off" disabled>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 text-center mb-3 d-flex justify-content-between">
      <%if session("PP9D") =  true then%>
      <div class="btn-group" role="group" aria-label="Basic example">
        <button type="button" class="btn btn-secondary" onclick="window.open('export-voucher.asp?id=<%=id%>', '_self')">Export</button>
      </div>
      <%end if%>
      <a href="./" type="button" class="btn btn-danger">Kembali</a>
    </div>
  </div>
  <div class='row'>
    <div class='col-lg-12 mb-3'>
      <h5 class="text-center">DAFTAR PERMINTAAN</h5>
      <table class="table table-bordered table-hover" style="font-size:14px;">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">No</th>
            <th scope="col">Kategori</th>
            <th scope="col">Jenis</th>
            <th scope="col">Barang</th>
            <th scope="col">Type</th>
            <th scope="col">Quantity</th>
            <th scope="col">Satuan</th>
          </tr>
        </thead>
        <tbody>
          <%
          no = 0
          do while not ddata.EOF
          no = no + 1
          %>
          <tr>
            <th scope="row"><%=no%></th>
            <td><%=ddata("kategorinama")%></td>
            <td><%=ddata("JenisNama")%></td>
            <td><%=ddata("Brg_Nama")%></td>
            <td><%=ddata("T_Nama")%></td>
            <td><%=ddata("VCH_Qtysatuan")%></td>
            <td><%=ddata("sat_nama")%></td>
          </tr>
          <%
          Response.flush
          ddata.movenext
          loop
          %>
        </tbody>
      </table>
    </div>
  </div>
</div>  
<% 

   call footer()
%>