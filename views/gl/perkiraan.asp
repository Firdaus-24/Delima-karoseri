<!--#include file="../../init.asp"-->
<% 
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
   nama = request.QueryString("nama")
   if len(nama) = 0 then 
      nama = trim(Request.Form("nama"))
   end if
   
   if nama <> "" then
      filterNama = " AND CA_Name LIKE '%"& nama &"%'"
   else
      filterNama = ""
   end if

   ' query seach 
   strquery = "SELECT GL_M_ChartAccount.*, DLK_M_WebLogin.username FROM GL_M_ChartAccount LEFT OUTER JOIN DLK_M_WebLogin ON GL_M_ChartAccount.CA_UpdateID = DLK_M_WebLogin.userID WHERE CA_AktifYN = 'Y'"& filterNama &""

   ' untuk data paggination
   page = Request.QueryString("page")

   orderBy = " ORDER BY CA_ID ASC"
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

   call header("Kode Perkiraan")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-lg-12 mt-3 mb-3 text-center">
         <h3>DAFTAR KODE PERKIRAAN</h3>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-12 mb-3">
         <button type="button" class="btn btn-primary" onclick="window.location.href='perkiraan_add.asp'">Tambah</button>
      </div>
   </div>
   <form action="perkiraan.asp" method="post">
      <div class="row">
         <div class="col-sm-4 mb-3">
            <label for="Nama">Nama</label>
            <input type="text" class="form-control" id="nama" name="nama" autocomplete="off">
         </div>
         <div class="col-lg-2 mt-4 mb-3">
            <button type="submit" class="btn btn-primary">Cari</button>
         </div>
      </div>
   </form>
   <div class="row">
      <div class="col-lg-12">
         <table class="table">
               <thead class="bg-secondary text-light">
                  <tr>
                     <th scope="col">KODE AKUN</th>
                     <th scope="col">KETERANGAN</th>
                     <th scope="col">KODE UP AKUN</th>
                     <th scope="col">JENIS</th>
                     <th scope="col">TIPE</th>
                     <th scope="col">GOLONGAN</th>
                     <th scope="col">KELOMPOK</th>
                     <th scope="col">AKTIF</th>
                     <th scope="col" class="text-center">Aksi</th>
                  </tr>
               </thead>
               <tbody>
                  <% 'prints records in the table
                  showrecords = recordsonpage
                  recordcounter = requestrecords
                  do until showrecords = 0 OR  rs.EOF
                  recordcounter = recordcounter + 1 %>
                  <tr>
                     <th scope="row"><%= rs("CA_ID") %></th>
                     <td><%= rs("CA_name") %></td>
                     <td><%= rs("CA_UPID") %></td>
                     <td><%= rs("CA_Jenis") %></td>
                     <td><%= rs("CA_Type") %></td>
                     <td>
                        <% if rs("CA_GOlongan") = "N" then %>
                           Neraca
                        <% else %>
                           LabaRugi 
                        <% end if %>
                     </td>
                     <td><%= rs("CA_Kelompok") %></td>
                     <td>
                        <% if rs("CA_AktifYN") = "Y" then %>
                           Aktif
                        <% else %>
                           No 
                        <% end if %>
                     </td>
                     <td class="text-center">
                        <div class="btn-group" role="group" aria-label="Basic example">
                              <a href="aktifPerkiraan.asp?id=<%= rs("CA_ID") %>&p=N" class="btn badge bg-danger" onclick="deleteItem(event,'delete kode perkiraan')">delete</a>
                           <a href="perkiraan_u.asp?id=<%= rs("CA_ID") %>" class="btn badge bg-primary">update</a>
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
                  <a class="page-link prev" href="perkiraan.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&nama=<%=nama%>">&#x25C4; Prev </a>
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
                        <a class="page-link hal bg-primary text-light" href="perkiraan.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
                  <%else%>
                        <a class="page-link hal" href="perkiraan.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
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
                        <a class="page-link next" href="perkiraan.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&nama=<%=nama%>">Next &#x25BA;</a>
                  <% else %>
                        <p class="page-link next-p">Next &#x25BA;</p>
                  <% end if %>
               </li>	
            </ul>
         </nav> 
      </div>
   </div>
</div>
<% 
   call footer()
%>