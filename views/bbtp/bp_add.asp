<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_bebanprosesproduksi.asp"-->
<% 
  if session("PP4A") = false then
    Response.Redirect("index.asp")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
  
  ' agen / cabang
  data_cmd.commandTExt = "SELECT AgenName, AgenID FROM DLK_T_ProduksiH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ProduksiH.PDH_AgenID = GLB_M_Agen.AgenId WHERE DLK_T_ProduksiH.PDH_AktifYN = 'Y' GROUP BY AgenName, AgenID ORDER BY AgenNAme ASC"

  set agen = data_cmd.execute

  call header("Form Beban Proses")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mb-3 mt-3 text-center">
      <h3>FORM BEBAN PROSES PRODUKSI</h3>
    </div>
  </div>
  <form action="bp_add.asp" method="post" onsubmit="validasiForm(this,event, 'TRANSAKSI BEBAN PROSES PRODUKSI', 'warning')">
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="fakturagen" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <select class="form-select" aria-label="Default select example" id="cabangbp" name="cabang" required>
        <option value="">Pilih</option>
        <% do while not agen.eof %>
        <option value="<%= agen("AgenID") %>"><%= agen("AgenName") %></option>
        <% 
        agen.movenext
        loop
        %>
      </select>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="pdhid" class="col-form-label">No Produksi</label>
    </div>
    <div class="col-lg-4 mb-3 lbbtplama">
      <select class="form-select" aria-label="Default select example" name="lbbtp" id="lbbtp" > 
        <option value="" readonly disabled>Pilih Cabang dahulu</option>
      </select>
    </div>
    <div class="col-lg-4 lbbtpbaru">
      <!-- kontent po -->
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= date() %>" onfocus="(this.type='date')" required>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off" required>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 text-center">
      <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
      <button type="submit" class="btn btn-primary">Save</button>
    </div>
  </div>
  </form>
</div>  
<% 
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahBebanProses()
  end if
  call footer()
%>
