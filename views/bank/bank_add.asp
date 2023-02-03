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
        <div class="row  mb-3 mt-3">
            <div class="col-sm-2">
               <label for="nama" class="form-label">Nama</label>
            </div>
            <div class="col-sm-5">
               <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" maxlength="50" required>
            </div>
            <div class="col-sm-2">
               <label for="kota" class="form-label">kota</label>
            </div>
            <div class="col-sm-3">
               <input type="text" class="form-control" name="kota" id="kota" autocomplete="off" maxlength="50" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2 ">
               <label for="email" class="form-label">Email</label>
            </div>
            <div class="col-sm-5">
               <input type="email" class="form-control" name="email" id="email" autocomplete="off" required>
            </div>
            <div class="col-sm-2">
               <label for="phone" class="form-label">Phone</label>
            </div>
            <div class="col-sm-3 mb-3">
               <input type="tel" class="form-control" name="phone" id="phone" autocomplete="off" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="alamat" class="form-label">Alamat</label>
            </div>
            <div class="col-sm-10 mb-3">
               <input type="text" class="form-control" name="alamat" id="alamat" autocomplete="off" maxlength="255" required>
            </div>
        </div>
        <div class="row text-center">
            <div class="col-lg">
               <button type="submit" class="btn btn-primary">Tambah</button>
                <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
            </div>
        </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
   nama = trim(Request.Form("nama"))
   kota = trim(Request.Form("kota"))
   email = trim(Request.Form("email"))
   phone = trim(Request.Form("phone"))
   alamat = trim(Request.Form("alamat"))

   data_cmd.CommandText = "SELECT * FROM GL_M_Bank WHERE UPPER(Bank_Name) = '"& ucase(nama) &"' AND UPPER(Bank_kota) = '"& ucase(kota) &"' AND Bank_Phone = '"& phone &"'"

   set data = data_cmd.execute

   if data.eof then
      data_cmd.CommandText = "SELECT MAX(Bank_ID + 1) as id FROM GL_M_Bank"

      set id = data_cmd.execute

      call query("INSERT INTO GL_M_Bank (Bank_ID, Bank_name,  Bank_Address, Bank_kota, Bank_Phone, Bank_Email, Bank_AccCode, Bank_UpdateID, Bank_UpdateTime, Bank_AktifYN, Bank_ItemIDKredit, Bank_ItemIDTT) VALUES ('"& id("id") &"','"& nama &"', '"& alamat &"', '"& kota &"', '"& phone &"', '"& email &"', '', '"& session("userid") &"', '"& now &"', 'Y', '', '')")   

      call alert("MASTER BARANG", "berhasil ditambahkan", "success","index.asp") 
   else
      call alert("MASTER BARANG", "sudah terdaftar", "success","index.asp") 
   end if
   
end if
call footer() 
%>