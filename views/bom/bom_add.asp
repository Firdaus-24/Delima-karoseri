<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_bom.asp"-->
<% 
   set data =  Server.CreateObject ("ADODB.Command")
   data.ActiveConnection = mm_delima_string

   ' get agen / cabang
   data.commandText = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE agenAktifYN = 'Y' ORDER BY AgenName ASC"
   set pcabang = data.execute    

   ' get kode akun
   data.commandText = "SELECT CA_id, CA_Name FROM GL_M_ChartAccount WHERE CA_AktifYN = 'Y' ORDER BY CA_Name ASC"
   set kodeakun = data.execute    

   call header("From B.O.M") 
%>

<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-lg-12 mb-3 mt-3 text-center">
         <h3>FORM TAMBAH B.O.M</h3>
      </div>
   </div>
   <form action="bom_add.asp" method="post" onsubmit="validasiForm(this,event,'Master B.O.M','warning')">
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
            <select class="form-select" aria-label="Default select example" name="cabang" id="bomcabang" required> 
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
            <label for="bombrg" class="col-form-label">Barang</label>
         </div>
         <div class="col-sm-4 mb-3 bombrg">
            <select class="form-select" aria-label="Default select example" name="bombrg" id="bombrg" required> 
               <option value="" readonly disabled>Pilih cabang dahulu</option>
            </select>
         </div>
         <div class="col-sm-2">
            <label for="approve" class="col-form-label">Approve Y/N</label>
         </div>
         <div class="col-sm-4 mb-3">
            <div class="form-check form-check-inline">
               <input class="form-check-input" type="radio" name="approve" id="approveY" value="Y" required>
               <label class="form-check-label" for="approveY">Yes</label>
            </div>
            <div class="form-check form-check-inline">
               <input class="form-check-input" type="radio" name="approve" id="approveN" value="N">
               <label class="form-check-label" for="approveN">No</label>
            </div>
         </div>
      </div>
      <div class="row">
         <div class="col-sm-2">
            <label for="keterangan" class="col-form-label">Keterangan</label>
         </div>
         <div class="col-sm-10 mb-3 keterangan">
            <input type="text" class="form-control" name="keterangan" id="keterangan" maxlength="50" autocomplete="off" required>
         </div>
      </div>
      <!-- end button -->
      <div class="row">
         <div class="col-lg-12 text-center">
            <button type="button" onclick="window.location.href='index.asp'" class="btn btn-danger">Kembali</button>
            <button type="submit" class="btn btn-primary">Tambah</button>
         </div>
      </div>
   </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
   call tambahbomH()
end if
call footer() 
%>