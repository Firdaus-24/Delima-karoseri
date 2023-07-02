<!--#include file="../../init.asp"-->
<% 
   if session("ENG1") = false then
      Response.Redirect("../index.asp")
   end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' filter agen
   data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_ProduksiH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ProduksiH.PDH_AgenID = GLB_M_Agen.AgenID WHERE GLB_M_Agen.AgenAktifYN = 'Y' and DLK_T_ProduksiH.PDH_AktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
   set agendata = data_cmd.execute

   set conn = Server.CreateObject("ADODB.Connection")
   conn.open MM_Delima_string

   dim recordsonpage, requestrecords, allrecords, hiddenrecords, showrecords, lastrecord, recordconter, pagelist, pagelistcounter, sqlawal
   dim angka
   dim code, nama, aktifId, UpdateId, uTIme, orderBy
   
   ' untuk angka
   angka = request.QueryString("angka")
   if len(angka) = 0 then 
      angka = Request.form("urut") + 1
   end if
   agen = request.QueryString("agen")
   if len(agen) = 0 then 
      agen = trim(Request.Form("agen"))
   end if
   produk = request.QueryString("produk")
   if len(produk) = 0 then 
      produk = trim(Request.Form("produk"))
   end if
   tgla = request.QueryString("tgla")
   if len(tgla) = 0 then 
      tgla = trim(Request.Form("tgla"))
   end if
   tgle = request.QueryString("tgle")
   if len(tgle) = 0 then 
      tgle = trim(Request.Form("tgle"))
   end if
   
   if agen <> "" then
      filterAgen = "AND DLK_T_ProduksiH.PDH_AgenID = '"& agen &"'"
   else
      filterAgen = ""
   end if


   if tgla <> "" AND tgle <> "" then
      filtertgl = "AND dbo.DLK_T_ProduksiH.PDH_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
   elseIf tgla <> "" AND tgle = "" then
      filtertgl = "AND dbo.DLK_T_ProduksiH.PDH_Date = '"& tgla &"'"
   else 
      filtertgl = ""
   end if

   ' query seach 
   strquery = "SELECT dbo.DLK_T_ProduksiH.*, dbo.GLB_M_Agen.AgenName FROM dbo.DLK_T_ProduksiH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ProduksiH.PDH_AgenID = dbo.GLB_M_Agen.AgenID WHERE (DLK_T_ProduksiH.PDH_AktifYN = 'Y') OR (DLK_T_ProduksiH.PDH_AktifYN = 'N') "& filterAgen &" "& filtertgl &""
   ' untuk data paggination
   page = Request.QueryString("page")

   orderBy = " ORDER BY PDH_Date DESC"
   set rs = Server.CreateObject("ADODB.Recordset")
   sqlawal = strquery

   sql= sqlawal + orderBy
   rs.open sql, conn
   ' records per halaman
   recordsonpage = 10
   ' count all records
   allrecords = 0
   do until rs.EOF
      allrecords = allrecords + 1
      rs.movenext
   loop
   ' if offset is zero then the first page will be loaded
   offset = Request.QueryString("offset")
   if offset = 0 OR offset = "" then
      requestrecords = 0
   else
      requestrecords = requestrecords + offset
   end if
   rs.close
   set rs = server.CreateObject("ADODB.RecordSet")
   sqlawal = strquery
   sql=sqlawal + orderBy
   rs.open sql, conn
   ' reads first records (offset) without showing them (can't find another solution!)
   hiddenrecords = requestrecords
   do until hiddenrecords = 0 OR rs.EOF
      hiddenrecords = hiddenrecords - 1
      rs.movenext
      if rs.EOF then
      lastrecord = 1
      end if	
   loop

    call header("Produksi")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-lg-12 mb-3 mt-3 text-center">
         <h3>TRANSAKSI PRODUKSI</h3>
      </div>
   </div>
   <% if session("ENG1A") = true then %>
   <div class="row">
      <div class="col-lg-12 mb-3">
         <a href="prod_add.asp" class="btn btn-primary ">Tambah</a>
      </div>
   </div>
   <% end if %>
   <form action="index.asp" method="post">
      <div class="row">
         <div class="col-lg-4 mb-3">
            <label for="Agen">Cabang</label>
            <select class="form-select" aria-label="Default select example" name="agen" id="agen">
               <option value="">Pilih</option>
               <% do while not agendata.eof %>
               <option value="<%= agendata("agenID") %>"><%= agendata("agenNAme") %></option>
               <% 
               agendata.movenext
               loop
               %>
            </select>
         </div>
      </div>
      <div class="row">
         <div class="col-lg-4 mb-3">
            <label for="tgla">Tanggal Pertama</label>
            <input type="date" class="form-control" name="tgla" id="tgla" autocomplete="off" >
         </div>
         <div class="col-lg-4 mb-3">
            <label for="tgle">Tanggal Kedua</label>
            <input type="date" class="form-control" name="tgle" id="tgle" autocomplete="off" >
         </div>
         <div class="col-lg-2 mt-4 mb-3">
            <button type="submit" class="btn btn-primary">Cari</button>
            <% if tgla <> "" OR tgle <> "" OR agen <> "" OR produk <> "" then %>    
            <button type="button" class="btn btn-secondary" onclick="window.location.href='export-HeaderBom.asp?la=<%=tgla%>&le=<%=tgle%>&en=<%=agen%>&or=<%=produk%>'">Export</button>
            <% end if %>
         </div>
      </div>
   </form>
   <div class="row">
      <div class="col-lg-12">
         <table class="table table-hover">
            <thead class="bg-secondary text-light">
               <th>No</th>
               <th>Produksi ID</th>
               <th>Cabang</th>
               <th>Tgl Mulai</th>
               <th>Tgl Selesai</th>
               <th>Approve1</th>
               <th>Prototype</th>
               <th class="text-center">Aksi</th>
            </thead>
            <tbody>
               <% 
               'prints records in the table
               showrecords = recordsonpage
               recordcounter = requestrecords
               do until showrecords = 0 OR  rs.EOF
               recordcounter = recordcounter + 1

               ' cek data detail
               data_cmd.commandTExt = "SELECT PDD_ID FROM DLK_T_ProduksiD WHERE LEFT(PDD_ID,13) = '"& rs("PDH_ID") &"'"
               set p = data_cmd.execute


               ' ceek exist anggaran
               data_cmd.commandTExt = "SELECT memoid FROM DLK_T_Memo_H WHERE Memopdhid = '"& rs("PDH_ID") &"' AND memoaktifyn = 'Y'"

               set ckanggran = data_cmd.execute
               %>
                  <tr><TH><%= recordcounter %></TH>
                  <td>
                     <% if session("ENG1D") = true then %>
                        <a href="printNoProduksi.asp?id=<%= rs("PDH_ID") %>" class="btn btn-outline-info badge text-dark" style="text-decoration:none;font-size:14px;"><%= left(rs("PDH_ID"),2) %>-<%= mid(rs("PDH_ID"),3,3) %>/<%= mid(rs("PDH_ID"),6,4) %>/<%= right(rs("PDH_ID"),4)  %></a>
                     <% else %>
                        <%= left(rs("PDH_ID"),2) %>-<%= mid(rs("PDH_ID"),3,3) %>/<%= mid(rs("PDH_ID"),6,4) %>/<%= right(rs("PDH_ID"),4)  %>
                     <% end if %>
                  </td>
                  <td><%= rs("AgenNAme")%></td>
                  <td><%= Cdate(rs("PDH_StartDate")) %></td>
                  <td><%= Cdate(rs("PDH_EndDate")) %></td>
                  <td>
                     <% if session("ENG1E") = true then %>
                        <% if rs("PDH_Approve1") = "N" then %>
                           <button type="button" class="btn btn-outline-info btn-sm" data-bs-toggle="modal" data-bs-target="#modalAppProduksi" onclick="getIDProduksi('<%= rs("PDH_ID") %>', '1')">Ajukan</button>
                        <% else %>
                           Yes
                        <% end if %>
                     <% end if %>
                  </td>
                  <td>
                     <%if rs("PDH_PrototypeYN") = "Y" then %>
                        Yes 
                     <% else %>
                        No
                     <% end if %>
                  </td>
                  <td class="text-center">
                     <div class="btn-group" role="group" aria-label="Basic example">

                        <% if session("PP8A") then%>
                           <% if ckanggran.eof then%>
                              <a href="anggaran_bom.asp?id=<%= rs("PDH_ID") %>" class="btn badge text-dark bg-light">Anggarkan</a>
                           <%end if%>
                        <%end if%>
                        <% if not p.eof then %>
                           <a href="detail.asp?id=<%= rs("PDH_ID") %>" class="btn badge text-light bg-warning">Detail</a>
                        <% end if %>
                        <% if session("ENG1B") = true then %>
                           <a href="prod_u.asp?id=<%= rs("PDH_ID") %>" class="btn badge text-bg-primary" >Update</a>
                        <% end if %>   
                        <% if session("ENG1C") = true then %>
                           <% if p.eof then %>
                              <% if rs("PDH_AktifYN") = "Y" then %>
                              <a href="aktifh.asp?id=<%= rs("PDH_ID") %>&p=N" class="btn badge text-bg-danger" onclick="deleteItem(event,'DELETE HEADER PRODUKSI')">Delete</a>
                              <% else %>
                              <a href="aktifh.asp?id=<%= rs("PDH_ID") %>&p=Y" class="btn badge text-bg-light-emphasis text-dark" onclick="deleteItem(event,'AKTIF HEADER PRODUKSI')">Aktif</a>
                              <% end if %>
                           <% end if %>
                        <% end if %>
                     </div>
                  </td>
               </tr>
               <% 
               showrecords = showrecords - 1
               rs.movenext
               if rs.EOF then
               lastrecord = 1
               end if
               loop
               rs.close
               %>
            </tbody>
         </table>
      </div>
   </div>  
   <div class="row">
      <div class="col-sm-12">
      <!-- paggination -->
         <nav aria-label="Page navigation example">
            <ul class="pagination">
               <li class="page-item">
               <% 
                  if page = "" then
                     npage = 1
                  else
                     npage = page - 1
                  end if
                  if requestrecords <> 0 then 
               %>
                  <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&produk=<%=produk%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
               <% else %>
                  <p class="page-link prev-p">&#x25C4; Prev </p>
               <% end if %>
               </li>
               <li class="page-item d-flex" style="overflow-y:auto;height: max-content;">	
                  <%
                  pagelist = 0
                  pagelistcounter = 0
                  do until pagelist > allrecords  
                  pagelistcounter = pagelistcounter + 1
                  if page = "" then
                     page = 1
                  else
                     page = page
                  end if
                  if Cint(page) = pagelistcounter then
                  %>
                     <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&produk=<%=produk%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
                  <%else%>
                     <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&produk=<%=produk%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
                  <%
                  end if
                  pagelist = pagelist + recordsonpage
                  loop
                  %>
               </li>
               <li class="page-item">
                  <% 
                  if page = "" then
                     page = 1
                  else
                     page = page + 1
                  end if
                  %>
                  <% if(recordcounter > 1) and (lastrecord <> 1) then %>
                     <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&produk=<%=produk%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
                  <% else %>
                     <p class="page-link next-p">Next &#x25BA;</p>
                  <% end if %>
               </li>	
            </ul>
         </nav> 
      </div>
   </div>
</div>  
<!-- Modal -->
<div class="modal fade" id="modalAppProduksi" tabindex="-1" aria-labelledby="modalAppProduksiLabel" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
      <div class="modal-header">
         <h5 class="modal-title" id="modalAppProduksiLabel">Approve Produksi</h5>
         <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
         <form action="sendEmail.asp" method="post" onsubmit="validasiForm(this,event,'Kirim Email','info')">
            <input type="hidden" id="idproduksi" name="idproduksi" class="form-control" required>
            <input type="hidden" id="typeapp" name="typeapp" class="form-control" required>
            <div class="row mb-3">
               <div class="col-sm-3">
                  <label for="userEmail" class="col-form-label">Email TO</label>
               </div>
               <div class="col-sm-9">
                  <input type="email" id="userEmail" name="userEmail" class="form-control" required>
               </div>
            </div>
            <div class="row">
               <div class="col-sm-3">
                  <label for="subject" class="col-form-label">Subject</label>
               </div>
               <div class="col-sm-9">
                  <input type="text" id="subject" name="subject" class="form-control" required>
               </div>
            </div>
      </div>
      <div class="modal-footer">
         <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
         <button type="submit" class="btn btn-primary">Send</button>
      </div>
      </form>
      </div>
   </div>
</div>
<script>
   function getIDProduksi(id,no){
      $("#idproduksi").val(id)
      $("#typeapp").val(no)
   }
</script>
<% call footer() %>

