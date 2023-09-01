<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_voucher.asp"-->
<% 
  if (session("PP9A") = false  OR session("PP9A") = "") AND (session("PP9B") = false OR session("PP9B") = "") then
    Response.Redirect("./")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT AgenName, AgenID FROM dbo.GLB_M_Agen WHERE (AgenAktifYN = 'Y') ORDER BY AgenName"
  ' response.write data_cmd.commandText & "<br>"
  set agendata = data_cmd.execute

  ' New Produksi
  data_cmd.commandText = "SELECT dbo.DLK_T_ProduksiD.PDD_ID, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_ProduksiH INNER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_T_ProduksiH.PDH_ID = LEFT(dbo.DLK_T_ProduksiD.PDD_ID, 13) LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_ProduksiD.PDD_Item = dbo.DLK_M_Barang.Brg_Id WHERE (dbo.DLK_T_ProduksiH.PDH_Approve2 = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_Approve1 = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_AktifYN = 'Y') AND NOT EXISTS (SELECT PDI_PDDID FROM DLK_T_PreDevInspectionH where PDI_AktifYN = 'Y' AND PDI_PDDID = DLK_T_ProduksiD.PDD_ID ) GROUP BY dbo.DLK_T_ProduksiD.PDD_ID, dbo.DLK_M_Barang.Brg_Nama ORDER BY dbo.DLK_T_ProduksiD.PDD_ID"
  set newproduksi = data_cmd.execute
  ' repair Produksi
  data_cmd.commandText = "SELECT PDR_ID FROM DLK_T_ProduksiRepair where PDR_AktifYN = 'Y' AND NOT EXISTS (SELECT PDIR_PDRID FROM DLK_T_PDIRepairH where PDIR_AktifYN = 'Y' AND PDIR_PDRID = DLK_T_ProduksiRepair.PDR_ID) ORDER BY PDR_ID ASC"
  set repair = data_cmd.execute

  call header("Tambah Voucher")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mb-3 mt-3 text-center">
      <h3>FORM TAMBAH VOUCHER</h3>
    </div>
  </div>
  <form action="vc_add.asp" method="post" onsubmit="validasiForm(this,event,'VOUCHER','warning')">
    <div class="row align-items-center">
      <div class="col-lg-2 mb-3">
        <label for="agen" class="col-form-label">Cabang / Agen</label>
      </div>
      <div class="col-lg-4 mb-3">
        <select class="form-select" aria-label="Default select example" id="agen" name="agen" required>
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
         <label for="tprod" class="col-form-label">Type Produksi</label>
      </div>
      <div class="col-lg-4 mb-3">
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="cktprod" id="cktprod1" value="N" onchange="RemoveDesableVoucher($(this).val())"  required>
            <label class="form-check-label" for="cktprod1">
               New Produksi
            </label>
         </div>
         <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="cktprod" value="R" id="cktprod2"  onchange="RemoveDesableVoucher($(this).val())">
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
        <select class="form-select" aria-label="Default select example" id="voucherAddpdhid" name="pdhid" disabled required>
            <option value="">Pilih</option>
            <% do while not newproduksi.eof %>
            <option value="<%= newproduksi("PDD_ID") %>"><%= left(newproduksi("PDD_ID"),2) %>-<%= mid(newproduksi("PDD_ID"),3,3) %>/<%= mid(newproduksi("PDD_ID"),6,4) %>/<%= mid(newproduksi("PDD_ID"),10,4) %>/<%= right(newproduksi("PDD_ID"),3) %> || <%=newproduksi("brg_nama")%></option>
            <% 
            Response.flush
            newproduksi.movenext
            loop
            %>
        </select>
      </div>
      <div class="col-lg-2 mb-3">
        <label for="tgl" class="col-form-label">Tanggal</label>
      </div>
      <div class="col-lg-4 mb-3">
        <input type="text" id="tgl" name="tgl" value="<%= date %>" onfocus="(this.type='date')" class="form-control" required>
      </div>
    </div>
   <div class="row">
      <div class="col-lg-2 mb-3">
        <label for="pdrid" class="col-form-label">Repair Produksi</label>
      </div>
      <div class="col-lg-4 mb-3">
        <select class="form-select" aria-label="Default select example" id="voucherAddpdrid" name="pdrid" disabled required>
            <option value="">Pilih</option>
            <% do while not repair.eof %>
            <option value="<%= repair("PDR_ID") %>"><%= LEFT(repair("PDR_ID"),3) &"-"& MID(repair("PDR_ID"),4,2) &"/"& RIGHT(repair("PDR_ID"),3)%></option>
            <% 
            Response.flush
            repair.movenext
            loop
            %>
        </select>
      </div>
      <div class="col-lg-2 mb-3">
         <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-4 mb-3">
         <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="100" autocomplete="off">
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 text-center mb-3">
         <button type="submit" class="btn btn-primary">Save</button>
         <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
      </div>
   </div>
   </form>
</div>  
<% 
   if request.ServerVariables("REQUEST_METHOD") = "POST" then
      call tambah()
   end if
   call footer()
%>