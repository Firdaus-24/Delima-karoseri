<!--#include file="../../init.asp"-->
<%  
   if session("FN2A") = false then
      Response.Redirect("index.asp")
   end if
   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   call header("Form Bank") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM TAMBAH MASTER BANK</h3>
        </div>
    </div>
    <form action="bank_add.asp" method="post" onsubmit="validasiForm (this,event,'Master Bank','info')">
      <div class="row  mb-3 mt-3 d-flex justify-content-center">
         <div class="col-sm-2">
            <label for="nama" class="form-label">Nama</label>
         </div>
         <div class="col-sm-5">
            <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" maxlength="50" required>
         </div>
      </div>
      <div class="row mb-3 d-flex justify-content-center">
         <div class="col-sm-2">
            <label for="keterangan" class="form-label">Keterangan</label>
         </div>
         <div class="col-sm-5">
            <input type="text" class="form-control" name="keterangan" id="keterangan" autocomplete="off" maxlength="50">
         </div>
      </div>
      <div class="row text-center">
         <div class="col-sm">
            <button type="submit" class="btn btn-primary">Tambah</button>
               <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
         </div>
      </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
   nama = trim(Request.Form("nama"))
   keterangan = trim(Request.Form("keterangan"))

   data_cmd.CommandText = "SELECT * FROM GL_M_Bank WHERE UPPER(Bank_Name) = '"& ucase(nama) &"'"

   set data = data_cmd.execute

   if data.eof then
      data_cmd.CommandText = "SELECT MAX(Bank_ID + 1) as id FROM GL_M_Bank"

      set id = data_cmd.execute

      call query("INSERT INTO GL_M_Bank (Bank_ID, Bank_Name, Bank_Keterangan, Bank_UpdateID, Bank_UpdateTime, Bank_AktifYN) VALUES ('"& id("id") &"','"& nama &"', '"& keterangan &"', '"& session("userid") &"', '"& now &"', 'Y')")   

      call alert("MASTER BANK", "berhasil ditambahkan", "success","index.asp") 
   else
      call alert("MASTER BANK", "sudah terdaftar", "success","index.asp") 
   end if
   
end if
call footer() 
%>