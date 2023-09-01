<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_produksi.asp"-->
<% 
   if session("ENG1A") = false then
      Response.Redirect("./")
   end if

   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' agen / cabang
   data_cmd.commandTExt = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenNAme ASC"

   set agen = data_cmd.execute

   ' sales order 
   data_cmd.commandTExt = "SELECT MKT_T_OrjulH.OJH_ID FROM MKT_T_OrjulH WHERE MKT_T_OrjulH.OJH_AktifYN = 'Y' AND NOT EXISTS (SELECT PDH_OJHID FROM DLK_T_ProduksiH WHERE PDH_AktifYN = 'Y' AND PDH_OJHID = MKT_T_OrjulH.OJH_ID) ORDER BY OJH_Date ASC"

   set salesorder = data_cmd.execute

   call header("Form Produksi")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
   <div class="row">
      <div class="col-lg-12 mb-3 mt-3 text-center">
         <h3>FORM TAMBAH PRODUKSI</h3>
      </div>
   </div>
   <form action="prod_add.asp" method="post" onsubmit="validasiForm(this,event,'FORM Produksi','info')" style="background-color:rgba(192,192,160,0.2);border-radius:10px;padding:10px;">
      <div class="row">
         <div class="col-lg-2 mb-3">
            <label for="prodagen" class="col-form-label">Cabang / Agen</label>
         </div>
         <div class="col-lg-4 mb-3">
            <select class="form-select" aria-label="Default select example" id="prodagen" name="agen" required>
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
            <label for="salesOrderProduksi" class="col-form-label">No Sales Order</label>
         </div>
         <div class="col-lg-4 mb-3">
            <select class="form-select" aria-label="Default select example" id="salesOrderProduksi" name="salesOrderProduksi" required>
               <option value="">Pilih</option>
               <% do while not salesorder.eof %>
               <option value="<%= salesorder("OJH_ID") %>"><%= left(salesorder("OJH_ID") ,2) %>-<%= mid(salesorder("OJH_ID") ,3,3) %>/<%= mid(salesorder("OJH_ID") ,6,4) %>/<%= right(salesorder("OJH_ID") ,4) %></option>
               <% 
               salesorder.movenext
               loop
               %>
            </select>
         </div>
         <div class="col-lg-2 mb-3">
            <label for="model" class="col-form-label">Model</label>
         </div>
         <div class="col-sm-4 mb-3">
            <div class="form-check form-check-inline">
               <input class="form-check-input" type="radio" name="model" id="modelL" value="L" required>
               <label class="form-check-label" for="modelL">Regular</label>
            </div>
            <div class="form-check form-check-inline">
               <input class="form-check-input" type="radio" name="model" id="modelP" value="P">
               <label class="form-check-label" for="modelP">Project</label>
            </div>
            <div class="form-check form-check-inline">
               <input class="form-check-input" type="radio" name="model" id="modelS" value="S">
               <label class="form-check-label" for="modelS">Sub Part</label>
            </div>
         </div>
      </div>
      <div class="row">
         <div class="col-lg-2 mb-3">
            <label for="tgla" class="col-form-label">Start Date</label>
         </div>
         <div class="col-lg-4 mb-3">
            <input type="date" id="tgla" name="tgla" class="form-control" required>
         </div>
         <div class="col-lg-2 mb-3">
            <label for="tgle" class="col-form-label">End Date</label>
         </div>
         <div class="col-lg-4 mb-3">
            <input type="date" id="tgle" name="tgle" class="form-control" required>
         </div>
      </div>      
      <div class="row">
         <div class="col-lg-2 mb-3">
            <label for="prototype" class="col-form-label">Prototype</label>
         </div>
         <div class="col-sm-4 mb-3">
            <div class="form-check form-check-inline">
               <input class="form-check-input" type="radio" name="prototype" id="prototypeY" value="Y" required>
               <label class="form-check-label" for="prototypeY">Yes</label>
            </div>
            <div class="form-check form-check-inline">
               <input class="form-check-input" type="radio" name="prototype" id="prototypeN" value="N">
               <label class="form-check-label" for="prototypeN">No</label>
            </div>
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
            <a href="./" type="button" class="btn btn-danger">Kembali</a>
            <button type="submit" class="btn btn-primary">Save</button>
         </div>
      </div>
   </form>
   <div class='contentDetailSoProduksi' style="background-color:rgba(192,192,160,0.2);border-radius:10px;padding:10px;margin-top:10px;">
   
   </div>
</div>  


<% 
   if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
      call tambahProduksiH()
   end if
   call footer()
%>