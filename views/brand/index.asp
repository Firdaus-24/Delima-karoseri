<!--#include file="../../init.asp"-->
<% 
   if session("ENG4") = false then 
      Response.Redirect("../index.asp")
   end if

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
      filternama = " AND BrandName LIKE '%"& ucase(nama) &"%'"
   else
      filternama = ""
   end if

   strquery = "SELECT DLK_M_Brand.*, DLK_M_WebLogin.userName FROM DLK_M_Brand LEFT OUTER JOIN DLK_M_WebLogin ON DLK_M_Brand.BrandupdateID = DLK_M_Weblogin.userID WHERE BrandAktifYN = 'Y' "& filternama &""
   ' untuk data paggination
   page = Request.QueryString("page")

   orderBy = " order by BrandID ASC"
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

   call header("Master Class") 

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row mt-3">
      <div class="col-lg-12 text-center">
         <h3>MASTER BRAND</h3>
      </div>
   </div>
   <% if session("ENG4A") = true then  %>
   <div class="row mt-3 mb-3">
      <div class="col-lg-2">
         <button type="button" class="btn btn-primary tambahbrand" data-bs-toggle="modal" data-bs-target="#modalBrand">
            Tambah
         </button>
      </div>
   </div>
   <% end if %>
   <form action="index.asp" method="post">
   <div class="row">
      <div class="col-sm-4 mb-3">
         <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" placeholder="cari nama brand">
      </div>
      <div class="col-sm mb-3">
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
                    <th scope="col">Name</th>
                    <th scope="col">UpdateID</th>
                    <th scope="col">Aktif</th>
                    <th scope="col" class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                   'prints records in the table
                    showrecords = recordsonpage
                    recordcounter = requestrecords
                    do until showrecords = 0 OR  rs.EOF
                    recordcounter = recordcounter + 1
                    %>
                    <tr>
                        <th scope="row"><%= rs("brandID") %> </th>
                        <td><%= rs("brandName") %></td>
                        <td><%= rs("username") %></td>
                        <td><%if rs("brandAktifYN") = "Y" then %>Aktif <% end if %></td>
                        <td class="text-center">
                           <div class="btn-group" role="group" aria-label="Basic example">
                              <% if session("ENG4B") = true then  %>
                              <a href="#" data-id="<%= rs("BrandID") %>" data-nama="<%= rs("BrandName") %>" class="btn badge text-bg-primary updatebrand" data-bs-toggle="modal" data-bs-target="#modalBrand">update</a>
                              <% end if %>
                              <% if session("ENG4C") = true then  %>
                              <a href="aktif.asp?id=<%= rs("BrandID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'Hapus Master Brand')">delete</a>
                              <%end if %>
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
                  <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&nama=<%=nama%>">&#x25C4; Prev </a>
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
                     <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
                  <%else%>
                     <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
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
                     <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&nama=<%=nama%>">Next &#x25BA;</a>
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
<div class="modal fade" id="modalBrand" tabindex="-1" aria-labelledby="modalBrandLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modalBrandLabel">TAMBAH MASTER BRAND</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="brand_add.asp" method="post" id="formmodalBrand" onsubmit="validasiForm(this,event,'Data Master Brand','warning')">
      <div class="modal-body">
         <div class="mb-3 row">
            <label for="nama" class="col-sm-2 col-form-label">Nama</label>
            <div class="col-sm-10">
               <input type="hidden" class="form-control" id="id" name="id" autocomplete="off">
               <input type="hidden" class="form-control" id="lnama" name="lnama" autocomplete="off">
               <input type="text" class="form-control" id="nnama" name="nnama" maxlegth="20" autocomplete="off" required>
            </div>
         </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary btnBrand">Save</button>
      </div>
      </form>
    </div>
  </div>
</div>

<% call footer() %>
<script>
   // setting tambah dan update brand
   $(document).ready(function(){
      $(".tambahbrand").click(function (){
         console.log('bisa');
         
         $("#formmodalBrand").attr("action","brand_add.asp")
         $("#id").val('')
         $("#lnama").val('')
         $("#nnama").val('')

         $("#modalBrandLabel").html("TAMBAH MASTER BRAND")
         $(".btnBrand").html("Save")
      })
      $(".updatebrand").click(function () {
         const id = $(this).data('id');
         const nama = $(this).data('nama');

         $("#id").val(id)
         $("#lnama").val(nama)
         $("#nnama").val(nama)

         $("#formmodalBrand").attr("action","brand_u.asp")
         
         $("#modalBrandLabel").html("UPDATE MASTER BRAND")
         $(".btnBrand").html("Update")
      })
   })
</script>