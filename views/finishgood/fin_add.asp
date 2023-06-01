<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_finishgood.asp"--> 
<% 
   ' if session("PP1A") = false then 
   '    Response.Redirect("index.asp")
   ' end if 
   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenID, dbo.GLB_M_Agen.AgenName FROM dbo.DLK_T_ProduksiH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ProduksiH.PDH_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_ProduksiH.PDH_Approve1 = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_Approve2 = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_AktifYN = 'Y') AND NOT EXISTS(SELECT PFH_PDHID FROM DLK_T_ProdFinishH WHERE PFH_PDHID = dbo.DLK_T_ProduksiH.PDH_ID AND PDH_AktifYN = 'Y') GROUP BY dbo.GLB_M_Agen.AgenID, dbo.GLB_M_Agen.AgenName ORDER BY dbo.GLB_M_Agen.AgenName"

   set getagenid = data_cmd.execute

   call header("Form FinishGood")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-sm-12 text-center mt-3 mb-3">
         <h3>TRANSAKSI FINISH GOOD</h3>
      </div>
   </div>
   <form action="fin_add.asp" method="post" onsubmit="validasiForm(this,event,'Finish good','warning')">
      <div class="row">
         <div class="col-sm-4 mb-3 ">
				<label>Tanggal :</label>
				<input name="tgl" id="tgl" type="text" value="<%= date %>" onfocus="(this.type='date')"  class="form-control" required>
			</div>
         <div class="col-sm-8 mb-3">
				<label>Agen/Cabang :</label>
				<select class="form-select" aria-label="Default select example" name="agen" id="agenFinishGood" required>
               <option value="">Pilih</option>
               <% do while not getagenid.eof %>
                  <option value="<%= getagenid("agenID") %>">
                     <%= getagenid("AgenName") %>
                  </option>
               <% 
               response.flush
               getagenid.movenext
               loop
               %>
            </select>
			</div>
      </div>
      <div class="row">
         <div class="col-sm-4 mb-3 ">
				<label>No Document :</label>
            <select class="form-select" aria-label="Default select example" name="pdhid" id="pdhidFinishGood" required>
               <option value="" disabled>Pilih cabang dahulu</option>
            </select>            
			</div>
         <div class="col-sm-8 mb-3">
				<label>Keterangan :</label>
				<input name="keterangan" id="keterangan" type="text" class="form-control" maxlength="50" autocomplete="off" required>
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
      call tambahfn()
   end if
   call footer()
%>