<!--#include file="../../init.asp"-->
<% 
   if session("INV2A") = false then
      Response.Redirect("index.asp")
   end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string
   
   ' agen / cabang
   data_cmd.commandTExt = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenNAme ASC"

   set agen = data_cmd.execute

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
      <div class="row align-items-center">
         <div class="col-lg-2 mb-3">
            <label for="type" class="col-form-label">Type</label>
         </div>
         <div class="col-lg-4 mb-3">
            <select class="form-select" aria-label="Default select example" name="type" id="type" required>
               <option value="">Pilih</option>
               <option value="1">Purchase</option>
               <option value="2">Produksi</option>
            </select>
         </div>
         <div class="col-lg-2 mb-3">
            <label for="keterangan" class="col-form-label">Keterangan</label>
         </div>
         <div class="col-lg-4 mb-3">
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
      keterangan = trim(Request.Form("keterangan"))
      tp = trim(Request.Form("type"))

      data_cmd.commandTExt = "SELECT * FROM DLK_T_MaterialReceiptH WHERE MR_AgenID = '"& cabang &"' AND MR_Date = '"& tgl &"' AND MR_Keterangan = '"& keterangan &"' AND MR_aktifYN = 'Y'"

      set data = data_cmd.execute

      if data.eof then
         data_cmd.commandTExt = "sp_AddDLK_T_MaterialReceiptH '"& cabang &"', '"& tgl &"', '"& keterangan &"', '', '"& session("userid") &"', '"& now &"', "& tp &""
         ' response.write data_cmd.commandText & "<br>"
         set id = data_cmd.execute

         strid = id("ID")

         call alert("PROSES INCOMMING HEADER", "berhasil ditambahkan", "success","incomed_add.asp?id="&strid) 
      else
         call alert("PROSES INCOMMING HEADER", "sudah terdaftar", "warning","index.asp") 
      end if
   end if
   call footer()
%>