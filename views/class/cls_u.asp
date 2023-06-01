<!--#include file="../../init.asp"-->
<% 
   if session("ENG3B") = false then 
      Response.Redirect("index.asp")
   end if 

   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_M_Class WHERE ClassID = '"& id &"' AND ClassAktifYN = 'Y'"
   set data = data_cmd.execute

   call header("Update Class")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-sm-12 text-center mt-3">
         <h3>TAMBAH DATA MASTER CLASS</h3>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 text-center mb-3 labelId">
         <h3><%= id %></h3>
      </div>
   </div>
   <form action="cls_u.asp?id=<%= id %>" method="post" onsubmit="validasiForm(this,event,'Data Master Class','warning')">
      <div class="row p-2">
         <div class="col-sm-4 mb-3 ">
				<label>Class Name :</label>
				<input name="nama" id="nama" type="text" class="form-control" maxlength="20" value="<%= data("className") %>" required>
			</div>
         <div class="col-sm-8 mb-3 ">
				<label>Class Keterangan</label>
				<input name="keterangan" id="keterangan" type="text" class="form-control" maxlength="50" value="<%= data("classKeterangan") %>" required>
			</div>
      </div>
      <div class="row">
         <div class="col-sm-12 text-center mt-3 mb-3">
            <button type="button" onclick="window.location.href='index.asp'" class="btn btn-danger">Kembali</button>
            <button type="submit" class="btn btn-primary">Update</button>
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
      nama = trim(Request.Form("nama"))
      keterangan = trim(Request.Form("keterangan"))

      nama = trim(Request.Form("nama"))
      keterangan = trim(Request.Form("keterangan"))

      data_cmd.CommandText = "SELECT * FROM DLK_M_Class WHERE ClassID = '"& id &"' AND ClassAktifYN = 'Y'"

      set update = data_cmd.execute

      if not update.eof then
         call query ("UPDATE DLK_M_Class SET ClassName = '"& nama &"', ClassKeterangan = '"& keterangan &"', ClassUpdateID = '"& session("userid") &"', ClassUpdateTIme = '"& now &"' WHERE ClassID = '"& id &"'")
         call alert("MATER CLASS", "berhasil di update", "success","index.asp") 
      else
         call alert("MATER CLASS", "sudah terdaftar", "error","index.asp") 
      end if
   end if
   call footer()
%>