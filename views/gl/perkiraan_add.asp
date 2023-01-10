<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_perkiraan.asp"-->
<% 
   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT K_ID, K_Name FROM GL_M_Kelompok WHERE K_aktifYN = 'Y' ORDER BY K_ID ASC"

   set dkel = data_cmd.execute

   call header("From Perkiraan")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-sm-12 text-center mt-3 mb-3">
         <h3>TAMBAH DATA KODE PERKIRAAN</h3>
      </div>
   </div>
   <form action="perkiraan_add.asp" method="post" onsubmit="validasiForm(this,event,'Data Kode Perkiraan','warning')">
      <div class="row p-2">
         <div class="col-sm-3 mb-3 p-0">
				<label>Kode Account :</label>
				<input name="kode" id="kode" type="text" class="form-control" size="10" required>
			</div>
         <div class="col-sm-3 mb-3 p-0">
				<label>Nama Account :</label>
				<input name="nama" id="nama" type="text" class="form-control" size="50" required>
			</div>
         <div class="col-sm-3 mb-3 p-0">
				<label>UP Account :</label>
				<input name="upacount" id="upacount" type="text" class="form-control" size="10">
			</div>
         <div class="col-sm-3 mb-3 p-0">
				<label>Kelompok :</label>
				<select class="form-select" aria-label="Default select example" name="kelompok" id="kelompok" required>
               <option value="">Pilih</option>
               <% do while not dkel.eof %>   
               <option value="<%= dkel("K_ID") %>"><%= dkel("K_ID") &" - "& dkel("K_Name") %></option>
               <% dkel.movenext
               loop %>
            </select>
			</div>
      </div>
      <div class="row">
         <div class="col-sm-4 mb-3">
				<label>Jenis :</label>
            <div class="row">
               <div class="col-sm">
                  <div class="form-check form-check-inline">
                     <input class="form-check-input" type="radio" name="jenis" id="jenisD" value="D" required>
                     <label class="form-check-label" for="jenisD">Debet</label>
                  </div>
                  <div class="form-check form-check-inline">
                     <input class="form-check-input" type="radio" name="jenis" id="jenisK" value="K">
                     <label class="form-check-label" for="jenisK">Kredit</label>
                  </div>
               </div>
            </div>
         </div>
         <div class="col-sm-4 mb-3">
				<label>Type :</label>
            <div class="row">
               <div class="col-sm">
                  <div class="form-check form-check-inline">
                     <input class="form-check-input" type="radio" name="tipe" id="tipeD" value="H" required>
                     <label class="form-check-label" for="tipeD">Header</label>
                  </div>
                  <div class="form-check form-check-inline">
                     <input class="form-check-input" type="radio" name="tipe" id="tipeK" value="D">
                     <label class="form-check-label" for="tipeK">Detail</label>
                  </div>
               </div>
            </div>
         </div>
         <div class="col-sm-4 mb-3">
				<label>Golongan :</label>
            <div class="row">
               <div class="col-sm">
                  <div class="form-check form-check-inline">
                     <input class="form-check-input" type="radio" name="golongan" id="golonganD" value="N" required>
                     <label class="form-check-label" for="golonganD">Neraca</label>
                  </div>
                  <div class="form-check form-check-inline">
                     <input class="form-check-input" type="radio" name="golongan" id="golonganK" value="LR">
                     <label class="form-check-label" for="golonganK">Laba Rugi</label>
                  </div>
               </div>
            </div>
         </div>
      </div>
      <div class="row">
         <div class="col-sm-12 text-center mt-3 mb-3">
            <button type="button" onclick="window.location.href='perkiraan.asp'" class="btn btn-danger">Kembali</button>
            <button type="submit" class="btn btn-primary">Save</button>
         </div>
      </div>
   </form>
   <hr style="border-top: 1px dotted red;">
   <footer style="font-size: 10px; text-align: center;">
      <p style="margin:0;padding:0;"> 		
         PT.DELIMA KAROSERI INDONESIA
      </p>
      <p style="text-transform: capitalize; color: #000;margin:0;padding:0;">User Login : <%= session("username") %>  | Cabang : <%= session("cabang") %> | <a href="logout.asp" target="_self">Logout</a></p>
      <p style="margin:0;padding:0;">Copyright MuhamadFirdausIT Division©2022-2023S.O.No.Bns.Wo.Instv</p>
      <p style="margin:0;padding:0;"> V.1 Mobile Responsive 2022 | V.2 On Progres 2023</p>
   </footer>
</div>
<% 
   If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
      call tambahPerkiraan()
   end if
   call footer()
%>