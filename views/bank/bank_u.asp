<!--#include file="../../init.asp"-->
<%  
   if session("FN2B") = false then
      Response.Redirect("index.asp")
   end if

   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM GL_M_Bank WHERE bank_ID = '"& id &"' AND Bank_aktifyn = 'Y'"

   set data = data_cmd.execute
   

   call header("Form Bank") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM TAMBAH MASTER BANK</h3>
        </div>
    </div>
    <form action="bank_u.asp?id=<%= id %>" method="post" onsubmit="validasiForm (this,event,'Master Bank','info')">
         <input type="hidden" class="form-control" name="id" id="id" autocomplete="off" maxlength="50" value="<%= data("Bank_id") %>" required>
        <div class="row  mb-3 mt-3">
            <div class="col-sm-2">
               <label for="nama" class="form-label">Nama</label>
            </div>
            <div class="col-sm-5">
               <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" maxlength="50" value="<%= data("Bank_Name") %>" required>
            </div>
            <div class="col-sm-2">
               <label for="kota" class="form-label">kota</label>
            </div>
            <div class="col-sm-3">
               <input type="text" class="form-control" name="kota" id="kota" autocomplete="off" maxlength="50" value="<%= data("Bank_Kota") %>" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2 ">
               <label for="email" class="form-label">Email</label>
            </div>
            <div class="col-sm-5">
               <input type="email" class="form-control" name="email" id="email" autocomplete="off" value="<%= data("Bank_Email") %>" required>
            </div>
            <div class="col-sm-2">
               <label for="phone" class="form-label">Phone</label>
            </div>
            <div class="col-sm-3 mb-3">
               <input type="tel" class="form-control" name="phone" id="phone" autocomplete="off" value="<%= data("Bank_phone") %>" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="alamat" class="form-label">Alamat</label>
            </div>
            <div class="col-sm-10 mb-3">
               <input type="text" class="form-control" name="alamat" id="alamat" autocomplete="off" value="<%= data("Bank_address") %>" maxlength="255" required>
            </div>
        </div>
        <div class="row text-center">
            <div class="col-lg">
               <button type="submit" class="btn btn-primary">Update</button>
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

   data_cmd.CommandText = "SELECT * FROM GL_M_Bank WHERE UPPER(Bank_Name) = '"& ucase(nama) &"' AND UPPER(Bank_kota) = '"& ucase(kota) &"' AND Bank_Phone = '"& phone &"' AND Bank_email = '"& email &"' AND Bank_address = '"& alamat &"' AND Bank_aktifYN = 'Y'"

   set ddata = data_cmd.execute

   if ddata.eof then
      call query("UPDATE GL_M_Bank SET Bank_name = '"& nama &"', Bank_Address = '"& alamat &"', Bank_kota = '"& kota &"', Bank_Phone = '"& phone &"', Bank_Email = '"& email &"', Bank_UpdateID  = '"& session("userid") &"', Bank_UpdateTime = '"& now &"' WHERE Bank_ID = '"& trim(Request.Form("id")) &"'")   

      call alert("MASTER BARANG", "berhasil update", "success","index.asp") 
   else
      call alert("MASTER BARANG", "sudah terdaftar", "success","index.asp") 
   end if
   
end if
call footer() 
%>