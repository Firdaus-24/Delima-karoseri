<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_serahterimaunit.asp"-->
<%  
  if session("MQ2A") = false then
    Response.Redirect("./")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  call header("Tambah Unit")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm-12 mt-3 mb-3 text-center">
      <h3>FROM TAMBAH KEDATANGAN UNIT</h3>
    </div>
  </div>

  <form action="tfk_add.asp" method="post" onsubmit="validasiForm(this,event,'SERAH TERIMA UNIT CUSTOMER','warning')">
    <div class="row align-items-center">
      <div class="col-lg-2 mb-2">
        <label for="tgl" class="col-form-label">Tanggal</label>
      </div>
      <div class="col-lg-4 mb-2">
        <input type="text" id="tgl" name="tgl" value="<%= date %>" class="form-control" onfocus="(this.type='date')" required>
      </div>
      <div class="col-lg-2 mb-2">
        <label for="salesorder" class="col-form-label">Jenis Unit</label>
      </div>
      <div class="col-lg-4 mb-2">
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="jenisUnit" id="baru" value="1" onchange="getSerahTerimaUnitBySO(this.value)" required>
          <label class="form-check-label" for="baru">Baru</label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="jenisUnit" id="repair" value="2" onchange="getSerahTerimaUnitBySO(this.value)">
          <label class="form-check-label" for="repair">Repair</label>
        </div>
      </div>
    </div>
    <div class="row align-items-center">
      <div class="col-lg-2 mb-2">
        <label for="salesorder" class="col-form-label">Sales Order</label>
      </div>
      <div class="col-lg-4 mb-2">
        <select class="form-select" aria-label="Default select example" id="salesorder-serahterimaunit" name="salesorder" onchange="getCustomerSerahTerimaUnit(this.value)" required>
          <option value="" readonly disabled>Pilih jenis unit dahulu</option>
        </select>
      </div>
      <div class="col-lg-2 mb-2">
        <label for="customer" class="col-form-label">Customer</label>
      </div>
      <div class="col-lg-4 mb-2">
        <input type="hidden" id="custid" name="custid" class="form-control" readonly>
        <input type="text" id="customer" name="customer" class="form-control" readonly>
      </div>
    </div>
    <div class="row align-items-center">
      <div class="col-lg-2 mb-2">
        <label for="penerima" class="col-form-label">Penerima</label>
      </div>
      <div class="col-lg-4 mb-2">
        <input type="text" id="penerima" name="penerima" class="form-control" maxlength="50" required>
      </div>
      <div class="col-lg-2 mb-2">
        <label for="penyerah" class="col-form-label">Penyerah</label>
      </div>
      <div class="col-lg-4 mb-2">
        <input type="text" id="penyerah" name="penyerah" class="form-control" maxlength="50" required>
      </div>
      
    </div>
    <div class="row">
      <div class="col-lg-2 mb-2">
        <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-10 mb-2">
        <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="100" autocomplete="off">
      </div>
    </div>
    <div class="row">
      <div class="col-lg-12 mb-2 mt-3 text-center">
        <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
        <button type="submit" class="btn btn-primary">Save</button>
      </div>
    </div>
  </form>
</div>  

<% 
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahSerahterima()
  end if

  call footer() 
%>