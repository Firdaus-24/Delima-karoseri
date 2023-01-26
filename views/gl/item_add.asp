<!--#include file="../../init.asp"-->
<% 
   call header("Tambah Item")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-sm-12 text-center mt-3 mb-3">
         <h3>FORM TAMBAH ITEM </h3>
      </div>
   </div>
   <form action="item_add.asp" method="post">
      <div class="row">
         <div class="col-sm-4 mb-3">
            <label for="type" class="form-label">Type Item</label>
            <select class="form-select" aria-label="Default select example" name="titem" id="titem" required>
               <option value="">Pilih</option>
               <option value="C">Cash</option>
               <option value="B">Bank</option>
               <option value="M">Memorial</option>
            </select>
         </div>   
         <div class="col-sm-4 mb-3">
            <label for="type" class="form-label">Type Kategori</label>
            <select class="form-select" aria-label="Default select example" name="tkategori" id="tkategori" required>
               <option value="">Pilih</option>
               <option value="C">Cash</option>
               <option value="B">Bank</option>
               <option value="M">Memorial</option>
            </select>
         </div>   
      </div>
   </form>
</div>   
<% call footer() %>