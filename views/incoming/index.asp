<!--#include file="../../init.asp"-->
<% 
   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' get cabang
   data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID FROM dbo.DLK_T_MaterialReceiptH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialReceiptH.MR_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y') GROUP BY dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID ORDER BY dbo.GLB_M_Agen.AgenID"

   set datacabang = data_cmd.execute

   ' get users
   data_cmd.commandTExt = "SELECT dbo.DLK_M_WebLogin.UserName, dbo.DLK_M_WebLogin.UserID FROM dbo.DLK_T_MaterialReceiptH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_MaterialReceiptH.MR_updateID = dbo.DLK_M_WebLogin.UserID WHERE (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y')GROUP BY dbo.DLK_M_WebLogin.UserName, dbo.DLK_M_WebLogin.UserID ORDER BY Username ASC"

   set users = data_cmd.execute
   ' get type barang
   data_cmd.commandTExt = "SELECT dbo.DLK_M_TypeBarang.T_Nama, dbo.DLK_M_TypeBarang.T_ID FROM dbo.DLK_T_MaterialReceiptH LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_T_MaterialReceiptH.MR_Jenis = dbo.DLK_M_TypeBarang.T_ID WHERE        (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y') GROUP BY dbo.DLK_M_TypeBarang.T_Nama, dbo.DLK_M_TypeBarang.T_ID ORDER BY dbo.DLK_M_TypeBarang.T_Nama"

   set datajenis = data_cmd.execute

   cabang = trim(Request.Form("cabang"))
   user = trim(Request.Form("user"))
   tgla = trim(Request.Form("tgla"))
   tgle = trim(Request.Form("tgle"))
   jenis = trim(Request.Form("jenis"))

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

   if cabang <> "" then 
      filtercabang = " AND DLK_T_MaterialReceiptH.MR_AgenID = '"& cabang &"'"
   else 
      filtercabang = ""
   end if
   if user <> "" then 
      filteruser = " AND DLK_T_MaterialReceiptH.MR_UpdateID = '"& user &"'"
   else 
      filteruser = ""
   end if
   if jenis <> "" then 
      filterjenis = " AND DLK_T_MaterialReceiptH.MR_Jenis = '"& jenis &"'"
   else 
      filterjenis = ""
   end if

   if tgla <> "" AND tgle <> "" then
      filtertgl = "AND dbo.DLK_T_MaterialReceiptH.MR_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
      filtertgl = "AND dbo.DLK_T_MaterialReceiptH.MR_Date = '"& tgla &"'"
   else 
      filtertgl = ""
   end if

   ' query seach 
   strquery = "SELECT dbo.DLK_T_MaterialReceiptH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_WebLogin.UserName, dbo.DLK_M_TypeBarang.T_Nama FROM dbo.DLK_T_MaterialReceiptH LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_T_MaterialReceiptH.MR_Jenis = dbo.DLK_M_TypeBarang.T_ID LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_MaterialReceiptH.MR_updateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialReceiptH.MR_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y') "& filtercabang &" "& filteruser &" "& filtertgl &" "& filterjenis &""

   ' untuk data paggination
   page = Request.QueryString("page")

   orderBy = " ORDER BY dbo.DLK_T_MaterialREceiptH.MR_Date DESC"
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

   call header("Incomming")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-sm-12 text-center mt-3">
         <h3>PROSES INCOMMING</h3>
      </div>
   </div>
   <div class="row">
      <div class="col-sm mt-3">
         <a href="income_add.asp" class="btn btn-primary">Tambah</a>
      </div>   
   </div>
   <form action="index.asp" method="post">
   <div class="row">
      <div class="col-sm-4 mt-3">
         <label for="tgla">Tanggal Pertama</label>
         <input type="date" class="form-control" name="tgla" id="tgla" autocomplete="off">
      </div>
      <div class="col-sm-4 mt-3">
         <label for="tgle">Tanggal kedua</label>
         <input type="date" class="form-control" name="tgle" id="tgle" autocomplete="off">
      </div>
      <div class="col-sm-2 mt-3">
         </br>
         <button type="submit" class="btn btn-primary">Cari</button>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-4 mt-3">
         <label for="cabang">Cabang</label>
         <select class="form-select" aria-label="Default select example" name="cabang" id="cabang">
            <option value="">Pilih</option>
            <% do while not datacabang.eof %>
               <option value="<%= datacabang("agenID") %>"><%= datacabang("agenName") %></option>
            <% 
            datacabang.movenext
            loop
            %>
         </select>
      </div>
      <div class="col-lg-4 mt-3">
         <label for="user">User ID</label>
         <select class="form-select" aria-label="Default select example" name="user" id="user">
            <option value="">Pilih</option>
            <% do while not users.eof %>
               <option value="<%= users("userid") %>"><%= users("username") %></option>
            <% 
            users.movenext
            loop
            %>
         </select>
      </div>
      <div class="col-lg-4 mt-3">
         <label for="jenis">Type Barang</label>
         <select class="form-select" aria-label="Default select example" name="jenis" id="jenis">
            <option value="">Pilih</option>
            <% do while not datajenis.eof %>
               <option value="<%= datajenis("T_ID") %>"><%= datajenis("T_Nama") %></option>
            <% 
            datajenis.movenext
            loop
            %>
         </select>
      </div>
   </div>
   </form>
   <div class="row">
      <div class="col-sm-12 mt-3">
         <table class="table">
            <thead class="bg-secondary text-light">
               <tr>
               <th scope="col">No</th>
               <th scope="col">Cabang</th>
               <th scope="col">Tanggal</th>
               <th scope="col">Type</th>
               <th scope="col">Update ID</th>
               <th scope="col">Keterangan</th>
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

               ' cek detail material d1
               data_cmd.commandTExt = "SELECT * FROM DLK_T_MaterialReceiptD1 WHERE MR_ID = '"& rs("MR_ID") &"'"

               set detail = data_cmd.execute
               %>
               <tr>
                  <th><%= rs("MR_ID") %></th>
                  <td><%= rs("AgenName") %></td>
                  <td><%= Cdate(rs("MR_Date")) %></td>
                  <td><%= rs("T_Nama") %></td>
                  <td><%= rs("username") %></td>
                  <td><%= rs("MR_Keterangan") %></td>
                  <td class="text-center">
                     <div class="btn-group" role="group" aria-label="Basic example">
                        <a href="detail.asp?id=<%= rs("MR_ID") %>" class="btn badge text-bg-warning">Detail</a>
                        <a href="income_u.asp?id=<%= rs("MR_ID") %>" class="btn badge text-bg-primary">update</a>
                        <% if detail.eof then %>
                        <a href="aktif.asp?id=<%= rs("MR_ID") %>" class="btn badge bg-danger" onclick="deleteItem(event,'delete header material receipt')">delete</a>
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
                  <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>">&#x25C4; Prev </a>
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
                     <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
                  <%else%>
                     <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
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
                     <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>">Next &#x25BA;</a>
                  <% else %>
                     <p class="page-link next-p">Next &#x25BA;</p>
                  <% end if %>
               </li>	
            </ul>
         </nav> 
      </div>
   </div>
</div>
<% call footer() %>