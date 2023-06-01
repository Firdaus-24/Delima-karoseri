<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_invrepair.asp"-->
<% 
  
  if session("MK4A") = false then
    Response.Redirect("./")
  end if


  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT AgenName, AgenID FROM dbo.GLB_M_Agen WHERE (AgenAktifYN = 'Y') ORDER BY AgenName"
  ' response.write data_cmd.commandText & "<br>"
  set agendata = data_cmd.execute

  call header("Tambah Invoice Repair")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mb-3 mt-3 text-center">
      <h3>FORM TAMBAH INVOICE REPAIR</h3>
    </div>
  </div>
  <form action="inv_add.asp" method="post" onsubmit="validasiForm(this,event,'Invoice Repair','warning')">
    <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
        <label for="agen" class="col-form-label">Cabang / Agen</label>
      </div>
      <div class="col-lg-4 mb-3">
        <select class="form-select" aria-label="Default select example" id="agenRepairMkt" name="agen" required>
          <option value="">Pilih</option>
          <% do while not agendata.eof %>
          <option value="<%= agendata("AgenID") %>"><%=agendata("AgenName") %></option>
          <% 
          agendata.movenext
          loop
          %>
        </select>
      </div>
      <div class="col-lg-2 mb-3">
        <label for="ophid" class="col-form-label">No P.O</label>
      </div>
      <div class="col-lg-4 mb-3 inv-repairmkt-lama">
        <select class="form-select" aria-label="Default select example" name="lpo-repair" id="lpo-repair" > 
          <option value="" readonly disabled>Pilih Cabang dahulu</option>
        </select>
      </div>
      <div class="col-lg-4 inv-repairmkt-baru">
        <!-- kontent po -->
      </div>
    </div>
    <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
        <label for="tgl" class="col-form-label">Tanggal</label>
      </div>
      <div class="col-lg-4 mb-3">
        <input type="text" id="tgl" name="tgl" value="<%= date %>" onfocus="(this.type='date')" class="form-control" required>
      </div>
      <div class="col-lg-2 mb-3">
        <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
      </div>
      <div class="col-lg-4 mb-3">
        <input type="text" id="tgljt-repair" name="tgljt" class="form-control" onfocus="(this.type='date')">
      </div>
    </div>
    <div class="row">
      <div class="col-lg-2 mb-3">
        <label for="customer" class="col-form-label">Customer</label>
      </div>
      <div class="col-lg-4 mb-3">
        <div class="input-group ">
          <input type="hidden" class="form-control" id="custid-repair" name="customer" required>
          <input type="text" class="form-control" id="custname-repair" name="custname" required>
        </div>
      </div>
      <div class="col-lg-2 mb-3">
        <label for="uangmuka" class="col-form-label">Uang Muka Terbayar</label>
      </div>
      <div class="col-lg-4 mb-3">
        <div class="input-group ">
          <input type="hidden" class="form-control" id="tw-repair" name="tw" required>
          <input type="text" class="form-control" id="uangmuka-repair" name="uangmuka" required>
        </div>
      </div>
    </div>
    <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
        <label for="diskon" class="col-form-label">Diskon All</label>
      </div>
      <div class="col-lg-4 mb-3">
        <div class="input-group ">
          <input type="number" class="form-control" id="diskon-repair" name="diskon" required>
          <span class="input-group-text" >%</span>
        </div>
      </div>
      <div class="col-lg-2 mb-3">
        <label for="ppn" class="col-form-label">PPn</label>
      </div>
      <div class="col-lg-4 mb-3">
        <div class="input-group ">
          <input type="number" class="form-control" id="ppn-repair" name="ppn" required>
          <span class="input-group-text" >%</span>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-lg-2 mb-3">
        <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-10 mb-3">
        <div class="form-floating">
          <textarea class="form-control" id="keterangan-repair" name="keterangan" placeholder="Description" style="height: 100px" required></textarea>
          <label for="keterangan">Description</label>
        </div>
      </div>
    </div>
    <div class="row">
        <div class="col-lg-12 text-center mb-3">
          <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
          <button type="submit" class="btn btn-primary">Save</button>
        </div>
    </div>
  </form>
</div>  
<% 
  if request.ServerVariables("REQUEST_METHOD") = "POST" then
    call tambahInv()
  end if
  call footer()
%>