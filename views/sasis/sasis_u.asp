<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_sasis.asp"-->
<% 
   if session("ENG5B") = false then
      Response.Redirect("index.asp")
   end if

   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string
   ' detail data
   data_cmd.commandText = "SELECT dbo.DLK_M_Sasis.*, dbo.DLK_M_Brand.BrandName, dbo.DLK_M_Class.ClassName FROM dbo.DLK_M_Sasis LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.DLK_M_Sasis.SasisBrandID = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.DLK_M_Class ON dbo.DLK_M_Sasis.SasisClassID = dbo.DLK_M_Class.ClassID WHERE SasisAktifYN = 'Y' AND SasisID = '"& id &"'"

   set data = data_cmd.execute


   ' class data
   data_cmd.commandText = "SELECT ClassID, ClassName FROM DLK_M_Class WHERE ClassaktifYN = 'Y' ORDER BY ClassName ASC"

   set dclass = data_cmd.execute
   ' brand data
   data_cmd.commandText = "SELECT brandID, brandName FROM DLK_M_brand WHERE brandaktifYN = 'Y' ORDER BY brandName ASC"

   set dbrand = data_cmd.execute

   call header("Update Model Sasis")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-sm-12 text-center mt-3">
         <h3>UPDATE DATA MODEL SASIS</h3>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-12 text-center mb-3 labelId">
         <h3><%= LEft(data("SasisID"),5) &"-"& mid(data("SasisID"),6,4) &"-"& right(data("SasisID"),3)  %></h3>
      </div>
   </div>
   <form action="sasis_u.asp?id=<%= id %>" method="post" onsubmit="validasiForm(this,event,'Data Master Model Sasis','warning')">
      <input name="id" id="id" type="hidden" class="form-control" value="<%= data("SasisID") %>" maxlength="30" required>
      <div class="row p-2">
         <div class="col-sm-4 mb-3">
				<label>Class Model :</label>
				<select class="form-select" aria-label="Default select example" name="idclass" id="idclass" required>
               <option value="<%= data("SasisClassID") %>"><%= data("className") %></option>
               <% do while not dclass.eof %>
               <option value="<%= dclass("classID") %>"><%= dclass("className") %></option>
               <% 
               dclass.movenext
               loop
               %>
            </select>
			</div>
         <div class="col-sm-4 mb-3">
				<label>Brand :</label>
				<select class="form-select" aria-label="Default select example" name="brand" id="brand" required>
               <option value="<%= data("SasisBrandID") %>"><%= data("BrandName") %></option>
               <% do while not dbrand.eof %>
               <option value="<%= dbrand("brandID") %>"><%= dbrand("BrandName") %></option>
               <% 
               dbrand.movenext
               loop
               %>
            </select>
			</div>
         <div class="col-sm-4 mb-3">
				<label>Type :</label>
				<input name="type" id="type" type="text" class="form-control" value="<%= data("SasisType") %>" maxlength="30" required>
			</div>
      </div>
      <div class="row p-2">
         <div class="col-sm-2 mb-3">
				<label>Long :</label>
				<input name="long" id="long" type="number" class="form-control" value="<%= data("SasisL") %>" required>
			</div>
         <div class="col-sm-2 mb-3">
				<label>Widht :</label>
				<input name="widht" id="widht" type="number" class="form-control" value="<%= data("SasisW") %>" required>
			</div>
         <div class="col-sm-2 mb-3">
				<label>Height :</label>
				<input name="height" id="height" type="number" class="form-control"  value="<%= data("SasisH") %>" required>
			</div>
         <div class="col-sm-6 mb-3">
				<label>Keterangan :</label>
				<input name="keterangan" id="keterangan" type="text" class="form-control" maxlength="100" autocomplete="off"  value="<%= data("SasisKeterangan") %>" required>
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
      <p style="text-transform: capitalize; color: #000;margin:0;padding:0;">User Login : <%= session("username") %>  | Cabang : <%= session("cabang") %> | <a href="<%=url%>logout.asp" target="_self">Logout</a></p>
      <p style="margin:0;padding:0;">Copyright MuhamadFirdausIT Division©2022-2023S.O.No.Bns.Wo.Instv</p>
      <p style="margin:0;padding:0;"> V.1 Mobile Responsive 2022 | V.2 On Progres 2023</p>
   </footer>
</div>
<% 
   If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
      call updateSasis()
   end if
   call footer()
%>