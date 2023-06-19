<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_bomrepair.asp"-->
<% 
   if session("PP6A") = false then
      Response.Redirect("./")
   end if

   set data =  Server.CreateObject ("ADODB.Command")
   data.ActiveConnection = mm_delima_string

   ' get agen / cabang
   data.commandText = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE agenAktifYN = 'Y' ORDER BY AgenName ASC"
   set pcabang = data.execute    

   call header("From B.O.M Repair") 
%>

<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-lg-12 mb-3 mt-3 text-center">
         <h3>FORM TAMBAH B.O.M REPAIR</h3>
      </div>
   </div>
   <form action="bmr_add.asp" method="post" onsubmit="validasiForm(this,event,'Master B.O.M Repair','warning')">
      <div class="row">
         <div class="col-sm-2">
            <label for="tgl" class="col-form-label">Tanggal</label>
         </div>
         <div class="col-sm-4 mb-3">
            <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Date() %>" onfocus="(this.type='date')" required>
         </div>
         <div class="col-sm-2">
            <label for="cabang" class="col-form-label">Cabang</label>
         </div>
         <div class="col-sm-4 mb-3">
            <select class="form-select" aria-label="Default select example" name="cabang" id="bmrcabang" required> 
               <option value="">Pilih</option>
               <% do while not pcabang.eof %>
               <option value="<%= pcabang("agenID") %>"><%= pcabang("AgenName") %></option>
               <%  
               pcabang.movenext
               loop
               %>
            </select>
         </div>
      </div>
      <div class="row">
         <div class="col-sm-2">
            <label for="pdrid" class="col-form-label">No. Produksi</label>
         </div>
         <div class="col-sm-4 mb-3">
            <select class="form-select" aria-label="Default select example" name="pdrid" id="pdrid-repair" required> 
               <option value="" readonly disabled>Pilih cabang dahulu</option>
            </select>
         </div>
         <div class="col-sm-2">
            <label for="irhid" class="col-form-label">No.Incomming Unit</label>
         </div>
         <div class="col-sm-4 mb-3">
            <input type="hidden" id="irhid-bomrepair" class="form-control" name="irhid" readonly>
            <input type="text" id="labelirhid-bomrepair" class="form-control" name="irhid" readonly>
         </div>
      </div>
      <div class="row">
         <div class="col-sm-2">
            <label for="cust" class="col-form-label">Customer</label>
         </div>
         <div class="col-sm-4 mb-3">
            <input type="text" id="cust-bomrepair" class="form-control" name="cust" readonly>
         </div>
         <div class="col-sm-2">
            <label for="brand" class="col-form-label">Brand</label>
         </div>
         <div class="col-sm-4 mb-3">
            <input type="text" id="brand-bomrepair" class="form-control" name="brand" readonly>
         </div>
      </div>
      <div class="row">
         <div class="col-sm-2">
            <label for="type" class="col-form-label">Type</label>
         </div>
         <div class="col-sm-4 mb-3">
            <input type="text" id="type-bomrepair" class="form-control" name="type" readonly>
         </div>
         <div class="col-sm-2">
            <label for="nopol" class="col-form-label">No.Polisi</label>
         </div>
         <div class="col-sm-4 mb-3">
            <input type="text" id="nopol-bomrepair" class="form-control" name="nopol" readonly>
         </div>
      </div>
      <div class="row">
         <div class="col-sm-2">
            <label for="tmanpower" class="col-form-label">Total Man Power</label>
         </div>
         <div class="col-sm-4 mb-3">
            <input type="number" id="tmanpower" class="form-control" name="tmanpower" required>
         </div>
         <div class="col-sm-2">
            <label for="salary" class="col-form-label">Anggaran Manpower</label>
         </div>
         <div class="col-sm-4 mb-3">
            <input type="text" class="form-control" name="salary" id="salary-bomrepair" onchange="settingFormatRupiah(this.value, 'salary-bomrepair')" autocomplete="off" required>
         </div>
      </div>
      <div class='row'>
         <div class="col-sm-2">
            <label for="keterangan" class="col-form-label">Keterangan</label>
         </div>
         <div class="col-sm-10 mb-3">
            <input type="text" class="form-control" name="keterangan" id="keterangan" maxlength="100" autocomplete="off">
         </div>
      </div>
      <!-- end button -->
      <div class="row">
         <div class="col-lg-12 text-center">
            <button type="button" onclick="window.location.href='./'" class="btn btn-danger">Kembali</button>
            <button type="submit" class="btn btn-primary">Tambah</button>
         </div>
      </div>
   </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
   call tambah()
end if
call footer() 
%>