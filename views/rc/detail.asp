<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_RC.asp"--> 
<% 
   '  if session("PR2A") = false then
   '      Response.Redirect("index.asp")
   '  end if

   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' get data header
   data_cmd.commandText = "SELECT dbo.DLK_T_RcProdH.*, dbo.DLK_M_WebLogin.username FROM dbo.DLK_T_RcProdH LEFT OUTER JOIN dbo.DLK_M_Weblogin ON dbo.DLK_T_RcProdH.RC_UpdateID = dbo.DLK_M_webLogin.userID WHERE RC_AktifYN = 'Y' AND RC_ID = '"& id &"'"

   set data = data_cmd.execute

   ' get data detail
   data_cmd.commandText = "SELECT dbo.DLK_T_RCProdD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_SatuanBarang.Sat_Nama FROM DLK_T_RCProdD LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_RCProdD.RCD_SatID = DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_RCProdD.RCD_Item = dbo.DLK_M_Barang.Brg_Id INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId WHERE LEFT(dbo.DLK_T_RCProdD.RCD_ID,10) = '"& data("RC_ID") &"' ORDER BY Brg_nama ASC"

   set ddata = data_cmd.execute

   ' get data bom 
   data_cmd.commandText = "SELECT ISNULL(dbo.DLK_M_Brand.BrandName,'') as brand, ISNULL(dbo.DLK_M_Class.ClassName,'') as class, ISNULL(dbo.DLK_M_Sasis.SasisType,'') as type FROM dbo.DLK_M_BOMH INNER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_M_BOMH.BMID = dbo.DLK_T_ProduksiD.PDD_BMID INNER JOIN dbo.DLK_M_Brand INNER JOIN dbo.DLK_M_Sasis INNER JOIN dbo.DLK_M_Class ON dbo.DLK_M_Sasis.SasisClassID = dbo.DLK_M_Class.ClassID ON dbo.DLK_M_Brand.BrandID = dbo.DLK_M_Sasis.SasisBrandID ON dbo.DLK_M_BOMH.BMSasisID = dbo.DLK_M_Sasis.SasisID WHERE (dbo.DLK_T_ProduksiD.PDD_ID = '"& data("RC_PDDID") &"')"
   
   set getsasis = data_cmd.execute

   ' get jenis satuan
   data_cmd.commandText = "SELECT Sat_ID,Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"

   set psatuan = data_cmd.execute

    call header("Detail Transaksi")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-lg-12  mt-3 text-center">
         <h3>DETAIL TRANSAKSI PENERIMAAN BARANG PRODUKSI</h3>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 text-center mb-3 labelId">
         <h3><%= left(id,2) &"-"& mid(id,2,4) &"-"& right(id,4) %></h3>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-4 mb-3 ">
         <label>Tanggal :</label>
         <input name="tgl" id="tgl" type="text" class="form-control" value="<%= cdate(data("RC_Date")) %>" readonly>
      </div>
      <div class="col-sm-4 mb-3">
         <label>No Produksi :</label>
         <input name="pddid" id="pddid" type="text" class="form-control" value="<%= left(data("RC_PDDid"),2)&"-"&mid(data("RC_PDDid"),3,3) &"/"& mid(data("RC_PDDid"),6,4) &"/"& mid(data("RC_PDDid"),10,4) &"/"& right(data("RC_PDDid"),3)  %>" readonly>
      </div>
      <div class="col-sm-4 mb-3 ">
         <label>Update ID :</label>
         <input name="update" id="update" type="text" class="form-control" value="<%= data("username") %>" readonly>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-4 mb-3 ">
         <label>Class :</label>
         <input name="class" id="class" type="text" class="form-control" <% if not getsasis.eof then%> value="<%= getsasis("class") %>" <% end if %> readonly>
      </div>
      <div class="col-sm-4 mb-3">
         <label>Brand :</label>
         <input name="pddid" id="pddid" type="text" class="form-control" <% if not getsasis.eof then%> value="<%= getsasis("brand") %>" <% end if %>readonly>
      </div>
      <div class="col-sm-4 mb-3 ">
         <label>Type :</label>
         <input name="update" id="update" type="text" class="form-control" <% if not getsasis.eof then%> value="<%= getsasis("type") %>" <% end if %> readonly>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-4 mb-3 ">
         <label>Man Power :</label>
         <input name="mp" id="mp" type="number" class="form-control" value="<%= data("RC_MP") %>" readonly>
      </div>
      <div class="col-sm-8 mb-3">
         <label>Keterangan :</label>
         <input name="keterangan" id="keterangan" type="text" class="form-control" value="<%= data("RC_keterangan") %>" maxlength="50" readonly>
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12">
         <div class="d-flex mb-3">
            <% if session("PP1D") = true then  %>
            <div class="me-auto p-2">
               <button type="button" class="btn btn-secondary" onClick="window.open('export-XlsRC.asp?id=<%=id%>','_self')">Export</button>
            </div>
            <% end if %>
            <div class="p-2">
               <a href="index.asp" class="btn btn-danger">Kembali</a>
            </div>
         </div>
      </div>
   </div>
   <!-- table bom -->
   <div class="row">
      <div class="col-sm-12 text-center">
         <h5>DAFTAR PENERIMAAN BARANG</h5>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-12 ">
         
         <table class="table table-hover">
            <thead class="bg-secondary text-light">
               <tr>
                  <th scope="col">Tanggal</th>
                  <th scope="col">Kode</th>
                  <th scope="col">Item</th>
                  <th scope="col">Quantity</th>
                  <th scope="col">Satuan</th>
                  <th scope="col">Penerima</th>
               </tr>
            </thead>
            <tbody>
               <% 
               do while not ddata.eof 
               %>
               <tr>
                  <th>
                     <%= Cdate(ddata("RCD_Date")) %>
                  </th>
                  <th>
                     <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
                  </th>
                  <td>
                     <%= ddata("Brg_Nama") %>
                  </td>
                  <td>
                     <%= ddata("RCD_qtysatuan") %>
                  </td>
                  <td>
                     <%= ddata("Sat_nama") %>
                  </td>
                  <td>
                     <%= ddata("RCD_Received") %>
                  </td>
               </tr>
               <% 
               ddata.movenext
               loop
               %>
            </tbody>
         </table>
      </div>
   </div>
</div>  

<% 
   call footer()
%>