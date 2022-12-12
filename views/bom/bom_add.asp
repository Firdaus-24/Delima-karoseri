<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_BOM.asp"-->
<% 
   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' agen / cabang
   data_cmd.commandTExt = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenNAme ASC"

   set agen = data_cmd.execute

   call header("Form BOM")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
   <div class="row">
      <div class="col-lg-12 mb-3 mt-3 text-center">
         <h3>FORM TAMBAH B.O.M</h3>
      </div>
   </div>
   <form action="bom_add.asp" method="post" onsubmit="validasiForm(this,event,'FORM B.O.M','info')">
      <div class="row">
         <div class="col-lg-2 mb-3">
            <label for="bomagen" class="col-form-label">Cabang / Agen</label>
         </div>
         <div class="col-lg-4 mb-3">
            <select class="form-select" aria-label="Default select example" id="bomagen" name="agen" required>
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
            <label for="ophid" class="col-form-label">No Product</label>
         </div>
         <div class="col-lg-4 mb-3 lproductlama">
            <select class="form-select" aria-label="Default select example" name="lpo" id="lpo" > 
               <option value="" readonly disabled>Pilih Cabang dahulu</option>
            </select>
         </div>
         <div class="col-lg-4 lproductbaru">
            <!-- kontent product -->
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
            <label for="hari" class="col-form-label">Capacity Day</label>
         </div>
         <div class="col-lg-4 mb-3">
            <input type="number" id="hari" name="hari" class="form-control" required>
         </div>
      </div>
      <div class="row">
         <div class="col-lg-2 mb-3">
            <label for="keterangan" class="col-form-label">Keterangan</label>
         </div>
         <div class="col-lg-4 mb-3">
            <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off" required>
         </div>
         <div class="col-lg-2 mb-3">
            <label for="bulan" class="col-form-label">Capacity Month</label>
         </div>
         <div class="col-lg-4 mb-3">
            <input type="number" id="bulan" name="bulan" class="form-control" required>
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
      call tambahBOMH()
   end if
   call footer()
%>