<!--#include file="../../init.asp"-->
<% 
   if session("GL1") = false then
      Response.Redirect("../index.asp")
   end if

   nama = trim(Request.Form("nama"))

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
   
   if nama <> "" then
      filterNama = " AND K_Name LIKE '%"& nama &"%'"
   else
      filterNama = ""
   end if


   ' query seach 
   strquery = "SELECT GL_M_ItemDelima.*, DLK_M_WebLogin.username, GL_M_CategoryItem.CAT_Name FROM GL_M_ItemDelima LEFT OUTER JOIN DLK_M_WebLogin ON GL_M_ItemDelima.Item_UpdateID = DLK_M_WebLogin.userID LEFT OUTER JOIN GL_M_CategoryItem ON GL_M_ItemDelima.Item_Cat_ID = GL_M_CategoryItem.Cat_ID"

   ' untuk data paggination
   page = Request.QueryString("page")

   orderBy = " ORDER BY Item_ID ASC"
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

   call header("Kas Masuk/Keluar")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-lg-12 mt-3 mb-3 text-center">
         <h3>DAFTAR PEMASUKAN DAN PENGELUARAN</h3>
      </div>
   </div>
   <% if session("GL1A") = true then %>
   <div class="row">
      <div class="col-sm-12 mb-3">
         <button type="button" class="btn btn-primary" onclick="window.location.href='item_add.asp'">Tambah</button>
      </div>
   </div>
   <% end if %>
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
                     <th scope="col">ID</th>
                     <th scope="col">KATEGORI</th>
                     <th scope="col">NAMA</th>
                     <th scope="col">TYPE</th>
                     <th scope="col">STATUS</th>
                     <th scope="col">ACC IDD</th>
                     <th scope="col">ACC IDK</th>
                     <th scope="col">UPDATE ID</th>
                     <th scope="col">AKTIF</th>
                     <!-- 
                     <th scope="col" class="text-center">Aksi</th>
                      -->
                  </tr>
               </thead>
               <tbody>
                  <% 'prints records in the table
                  showrecords = recordsonpage
                  recordcounter = requestrecords
                  do until showrecords = 0 OR  rs.EOF
                  recordcounter = recordcounter + 1 %>
                  <tr>
                     <th scope="row"><%= rs("Item_ID") %></th>
                     <td><%= rs("Cat_Name") %></td>
                     <td><%= rs("Item_Name") %></td>
                     <td><%= rs("Item_Type") %></td>
                     <td><%= rs("Item_Status") %></td>
                     <td><%= rs("Item_CAIDD") %></td>
                     <td><%= rs("Item_CAIDk") %></td>
                     <td><%= rs("Item_UpdateID") %></td>
                     <td><%= rs("Item_AktifYN") %></td>
                     <!-- 
                     <td class="text-center">
                        <div class="btn-group" role="group" aria-label="Basic example">
                           <a href="#" class="btn badge bg-danger" onclick="deleteItem(event,'delete kode perkiraan')">delete</a>
                           
                           <a href="#" class="btn badge bg-primary">update</a>
                        </div>
                     </td>
                      -->
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
                     <a class="page-link prev" href="perkiraan.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>">&#x25C4; Prev </a>
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
                           <a class="page-link hal bg-primary text-light" href="perkiraan.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
                     <%else%>
                           <a class="page-link hal" href="perkiraan.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
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
                           <a class="page-link next" href="perkiraan.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>">Next &#x25BA;</a>
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