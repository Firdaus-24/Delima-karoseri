<!--#include file="../../init.asp"-->
<% 
   if session("INV2A") = false then
      Response.Redirect("./")
   end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string
   
   ' agen / cabang
   data_cmd.commandTExt = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenNAme ASC"

   set agen = data_cmd.execute

   ' agen / cabang
   data_cmd.commandTExt = "SELECT OPH_ID FROM DLK_T_Orpemh WHERE OPH_Aktifyn = 'Y' AND (SELECT ISNULL(SUM(OPD_QtySatuan),0) as qtypo FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = DLK_T_Orpemh.OPH_ID) - (SELECT ISNULL(SUM(MR_Qtysatuan),0) as qtymr FROM DLK_T_MaterialReceiptD2 WHERE LEFT(MR_OPDOPHID,13) = DLK_T_Orpemh.OPH_ID) <> 0 ORDER BY OPH_ID ASC"

   set datapo = data_cmd.execute

   call header("Proses Incomming")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
   <div class="row">
      <div class="col-lg-12 mb-3 mt-3 text-center">
         <h3>FORM PROSES INCOMMING</h3>
      </div>
   </div>
   <form action="income_add.asp" method="post" onsubmit="return validasiForm(this,event,'PROSES INCOMMING', 'info')">
      <div class="row">
         <div class="col-lg-2 mb-3">
            <label for="cabang" class="col-form-label">Cabang / Agen</label>
         </div>
         <div class="col-lg-4 mb-3">
            <select class="form-select" aria-label="Default select example" id="cabang" name="cabang" required>
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
            <label for="tgl" class="col-form-label">Tanggal</label>
         </div>
         <div class="col-lg-4 mb-3">
            <input type="text" id="tgl" name="tgl" class="form-control" value="<%= date() %>" onfocus="(this.type='date')" required>
         </div>
      </div>
      <div class="row">
         <div class="col-lg-2 mb-3">
            <label for="ophidmr" class="col-form-label">No. Purchase</label>
         </div>
         <div class="col-lg-4 mb-3">
            <select class="form-select" aria-label="Default select example" id="ophidmr" name="ophidmr" onchange="getVendorMR(this.value)" required>
               <option value="">Pilih</option>
               <% do while not datapo.eof %>
               <option value="<%= datapo("OPH_ID") %>"><%= left(datapo("OPH_ID"),2) %>-<%= mid(datapo("OPH_ID"),3,3)%>/<%= mid(datapo("OPH_ID"),6,4) %>/<%= right(datapo("OPH_ID"),4) %></option>
               <% 
               Response.flush
               datapo.movenext
               loop
               %>
            </select>
         </div>
         <div class="col-lg-2 mb-3">
            <label for="venid" class="col-form-label">Vendor</label>
         </div>
         <div class="col-lg-4 mb-3">
            <input type="hidden" id="venidmr" name="venidmr" class="form-control" readonly>
            <input type="text" id="venname" name="venname" class="form-control" required>
         </div>
      </div>
      <div class="row align-items-center">
         <div class="col-lg-2 mb-3">
            <label for="keterangan" class="col-form-label">Keterangan</label>
         </div>
         <div class="col-lg-10 mb-3">
            <input type="text" id="keterangan" name="keterangan" class="form-control" autocomplete="off" maxlength="50" required>
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
      cabang = trim(Request.Form("cabang"))
      tgl = trim(Request.Form("tgl"))
      ophidmr = trim(Request.Form("ophidmr"))
      venidmr = trim(Request.Form("venidmr"))
      keterangan = trim(Request.Form("keterangan"))

      data_cmd.commandTExt = "SELECT * FROM DLK_T_MaterialReceiptH WHERE MR_AgenID = '"& cabang &"' AND MR_Date = '"& tgl &"' AND MR_OPHID = '"& ophidmr &"' AND MR_aktifYN = 'Y'"

      set data = data_cmd.execute

      if data.eof then
         data_cmd.commandTExt = "sp_AddDLK_T_MaterialReceiptH '"& cabang &"', '"& ophidmr &"', '"& venidmr &"', '"& tgl &"', '"& keterangan &"', '"& session("userid") &"', '"& now &"'"
         ' response.write data_cmd.commandText & "<br>"
         set id = data_cmd.execute

         strid = id("ID")

         call alert("PROSES INCOMMING HEADER", "berhasil ditambahkan", "success","incomed_add.asp?id="&strid) 
      else
         call alert("PROSES INCOMMING HEADER", "sudah terdaftar", "warning","./") 
      end if
   end if
   call footer()
%>