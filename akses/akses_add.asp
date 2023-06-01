<!--#include file="../Connections/cargo.asp"-->
<!--#include file="../url.asp"-->
<!--#include file="../functions/md5.asp"-->
<!--#include file="../functions/func_alert.asp"-->
<% 
   ' cek hakakses 
   if Ucase(session("username")) <> "DAUSIT" AND Ucase(session("username")) <> Ucase("ADMINISTRATOR") then
      Response.Redirect(url&"login.asp")
   end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT AgenName, AgenID FROm GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"
   set agendata = data_cmd.execute

   server.Execute("../header.asp")
   response.write "<title>Form Hak Kases</title><body>"
%>
<!--#include file="../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-sm-12 text-center mt-3 mb-3">
         <h3>FORM TAMBAH USER</h3>
      </div>
   </div>
   <form action="akses_add.asp" method="post">
      <div class="mb-3 row">
         <label for="nama" class="col-sm-2 col-form-label offset-sm-1">Name</label>
         <div class="col-sm-8">
               <input type="text" class="form-control" id="nama" name="nama" autocomplete="off" maxlength="30" autofocus required>
         </div>
      </div>
      <div class="mb-3 row">
         <label for="realname" class="col-sm-2 col-form-label offset-sm-1">Real Name</label>
         <div class="col-sm-8">
            <input type="text" class="form-control" id="realname" name="realname" autocomplete="off" maxlength="100" required>
         </div>
      </div>
      <div class="mb-3 row">
         <label for="agen" class="col-sm-2 col-form-label offset-sm-1">Cabang/agen</label>
         <div class="col-sm-8">
               <select class="form-select" aria-label="Default select example" name="agen" id="agen" required>
                  <option value="">Pilih</option>
                  <% do while not agendata.eof %>
                     <option value="<%= agendata("agenID") %>"><%= agendata("agenName") %></option>
                  <% 
                  agendata.movenext
                  loop
                  %>
               </select>
         </div>
      </div>
      <div class="mb-3 row">
         <label for="password" class="col-sm-2 col-form-label offset-sm-1">Password</label>
         <div class="col-sm-8">
            <input type="password" class="form-control" id="password" name="password" autocomplete="off" maxlength="300" required>
         </div>
      </div>
      <div class="mb-3 row">
         <label for="email" class="col-sm-2 col-form-label offset-sm-1">email</label>
         <div class="col-sm-8">
            <input type="email" class="form-control" id="email" name="email" autocomplete="off" maxlength="70" required>
         </div>
      </div>
      <div class="row">
         <div class="col-lg text-center">
               <button type="submit" class="btn btn-primary">Tambah</button>
               <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
         </div>
      </div>
   </form>
</div>
<% 
   if Request.ServerVariables("REQUEST_METHOD") = "POST" then
      nama = Ucase(trim(Request.Form("nama")))
      realname = trim(Request.Form("realname"))
      agen = trim(Request.Form("agen"))
      password = md5(trim(Request.Form("password")))
      email = trim(Request.Form("email"))

      data_cmd.commandText = "SELECT * FROM DLK_M_WebLogin WHERE username = '"& nama &"' AND realName = '"& realname &"' AND serverID = '"& agen &"' AND UserAktifYN = 'Y'"

      set addData = data_cmd.execute

      if not addData.eof then
         call alert("USER", "sudah terdaftar", "warning","index.asp") 
      else
         data_cmd.commandText = "exec sp_ADDDLK_M_WebLogin '"& nama &"', '"& password &"', '"& agen &"', '"& realName &"', '"& now &"', '"& email &"', '"& now &"'"

         set p = data_cmd.execute

         id = p("ID")

         call alert("USER", "berhasil di tambahkan", "success","pakses_add.asp?id="&id) 
      end if
   end if

   server.execute("../footer.asp")
%>