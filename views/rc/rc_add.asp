<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_rc.asp"--> 
<% 
   if session("PP1A") = false then 
      Response.Redirect("index.asp")
   end if 
   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT MO_PDDID FROM dbo.DLK_T_MaterialOutH WHERE MO_AktifYN = 'Y' AND NOT EXISTS(SELECT RC_PDDID FROM DLK_T_RCProdH WHERE RC_PDDID = dbo.DLK_T_MaterialOutH.MO_PDDID AND RC_AktifYN = 'Y') ORDER BY MO_PDDID "

   set getpddid = data_cmd.execute

   call header("Form Penerimaaan")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-sm-12 text-center mt-3 mb-3">
         <h3>TRANSAKSI PENERIMAAN BARANG PRODUKSI</h3>
      </div>
   </div>
   <form action="rc_add.asp" method="post" onsubmit="validasiForm(this,event,'Penerimaan Barang Produksi','warning')">
      <div class="row">
         <div class="col-sm-4 mb-3 ">
				<label>Tanggal :</label>
				<input name="tgl" id="tgl" type="text" value="<%= date %>" onfocus="(this.type='date')"  class="form-control" required>
			</div>
         <div class="col-sm-8 mb-3">
				<label>No Produksi :</label>
				<select class="form-select" aria-label="Default select example" name="pddid" id="pddid" required>
               <option value="">Pilih</option>
               <% do while not getpddid.eof %>
                  <option value="<%= getpddid("MO_PDDID") %>">
                     <%= left(getpddid("MO_PDDid"),2) %>-<%=mid(getpddid("MO_PDDid"),3,3) %>/<%= mid(getpddid("MO_PDDid"),6,4) %>/<%= mid(getpddid("MO_PDDid"),10,4) %>/<%= right(getpddid("MO_PDDid"),3)  %>
                  </option>
               <% 
               response.flush
               getpddid.movenext
               loop
               %>
            </select>
			</div>
      </div>
      <div class="row">
         <div class="col-sm-4 mb-3 ">
				<label>Man Power :</label>
				<input name="mp" id="mp" type="number" class="form-control" required>
			</div>
         <div class="col-sm-8 mb-3">
				<label>Keterangan :</label>
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
      call tambahRC()
   end if
   call footer()
%>