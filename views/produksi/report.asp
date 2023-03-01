<!--#include file="../../init.asp"-->
<% 
  noprod = trim(Request.Form("noprod"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.CommandText = "SELECT PDH_ID FROM DLK_T_ProduksiH WHERE PDH_Approve1 = 'Y' AND PDH_Approve2 = 'Y' AND PDH_AktifYN = 'Y' AND NOT EXISTS(SELECT PFH_PDHID FROM DLK_T_ProdFinishH WHERE PFH_PDHID = PDH_ID AND PFH_AktifYN = 'Y') ORDER BY PDH_ID ASC"

  set data = data_cmd.execute

  call header("Report Produksi")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm-12 mt-3 mb-3 text-center">
      <h3>LAPORAN TRANSAKSI PRODUKSI</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-1">
      <label for="noprod" class="col-form-label">No.Produksi</label>
    </div>
    <div class="col-sm-4">
      <select class="form-select" aria-label="Default select example" name="noprod" id="noprod" required>
      <option value="">Pilih</option>
      <% do while not data.eof %>
        <option value="<%= data("PDH_ID") %>"><%= left(data("PDH_ID"),2) %>-<%= mid(data("PDH_ID"),3,3) %>/<%= mid(data("PDH_ID"),6,4) %>/<%= right(data("PDH_ID"),4)  %></option>
      <% 
      Response.flush
      data.movenext
      loop
      %>
      </select>
    </div>
    <div class="col-sm-2">
      <button type="submit" class="btn btn-primary">Refresh</button>
    </div>
  </div>
</div>


<% call footer() %>