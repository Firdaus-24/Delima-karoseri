<!--#include file="../../init.asp"-->
<% 
   if session("ENG3A") = false then 
      Response.Redirect("index.asp")
   end if 

   call header("Tambah Class")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-sm-12 text-center mt-3 mb-3">
         <h3>TAMBAH DATA MASTER CLASS</h3>
      </div>
   </div>
   <form action="cls_add.asp" method="post" onsubmit="validasiForm(this,event,'Data Master Class','warning')">
      <div class="row p-2">
         <div class="col-sm-4 mb-3 ">
				<label>Class Name :</label>
				<input name="nama" id="nama" type="text" class="form-control" maxlength="20" required>
			</div>
         <div class="col-sm-8 mb-3 ">
				<label>Class Keterangan</label>
				<input name="keterangan" id="keterangan" type="text" class="form-control" maxlength="50" required>
			</div>
      </div>
      <div class="row">
         <div class="col-sm-12 text-center mt-3 mb-3">
            <button type="button" onclick="window.location.href='index.asp'" class="btn btn-danger">Kembali</button>
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
      nama = trim(Request.Form("nama"))
      keterangan = trim(Request.Form("keterangan"))

      set data_cmd =  Server.CreateObject ("ADODB.Command")
      data_cmd.ActiveConnection = mm_delima_string

      data_cmd.CommandText = "SELECT * FROM DLK_M_Class WHERE ClassName = '"& nama &"' AND CLassKeterangan = '"& keterangan &"'"

      set data = data_cmd.execute

      if data.eof then
         call query ("exec sp_addDLK_M_Class '"& nama &"', '"& keterangan &"', '"& session("userid") &"', '"& now &"'")
         call alert("MATER CLASS", "berhasil di tambahkan", "success","cls_add.asp") 
      else
         call alert("MATER CLASS", "sudah terdaftar", "error","cls_add.asp") 
      end if
   end if
   call footer()
%>