<!--#include file="../../init.asp"-->
<% 
   if session("INV2") = false then
      Response.Redirect("../../")
   end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' get cabang
   data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID FROM dbo.DLK_T_MaterialReceiptH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialReceiptH.MR_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y') GROUP BY dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID ORDER BY dbo.GLB_M_Agen.AgenID"

   set datacabang = data_cmd.execute

   ' get po
   data_cmd.commandTExt = "SELECT DLK_T_MaterialReceiptH.MR_OPHID FROM DLK_T_MaterialReceiptH WHERE MR_Aktifyn = 'Y' GROUP BY DLK_T_MaterialReceiptH.MR_OPHID ORDER BY MR_OPHID "

   set datapo = data_cmd.execute

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

   cabang = request.QueryString("cabang")
   if len(cabang) = 0 then 
      cabang = trim(Request.Form("cabang"))
   end if

   tgla = request.QueryString("tgla")
   if len(tgla) = 0 then 
      tgla = trim(Request.Form("tgla"))
   end if

   tgle = request.QueryString("tgle")
   if len(tgle) = 0 then 
      tgle = trim(Request.Form("tgle"))
   end if

   ophidmr = request.QueryString("ophidmr")
   if len(ophidmr) = 0 then 
      ophidmr = trim(Request.Form("ophidmr"))
   end if

   if cabang <> "" then 
      filtercabang = " AND DLK_T_MaterialReceiptH.MR_AgenID = '"& cabang &"'"
   else 
      filtercabang = ""
   end if
  
   if ophidmr <> "" then 
      filterophidmr = " AND DLK_T_MaterialReceiptH.MR_ophid = '"& ophidmr &"'"
   else 
      filterophidmr = ""
   end if

   if tgla <> "" AND tgle <> "" then
      filtertgl = "AND dbo.DLK_T_MaterialReceiptH.MR_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
   elseIf tgla <> "" AND tgle = "" then
      filtertgl = "AND dbo.DLK_T_MaterialReceiptH.MR_Date = '"& tgla &"'"
   else 
      filtertgl = ""
   end if

   ' query seach 
   strquery = "SELECT dbo.DLK_T_MaterialReceiptH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_WebLogin.UserName FROM dbo.DLK_T_MaterialReceiptH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_MaterialReceiptH.MR_updateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialReceiptH.MR_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y') "& filtercabang &" "& filterophidmr &" "& filtertgl &""

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
   <% if session("INV2A") = true then %>
   <div class="row">
      <div class="col-sm mt-3">
         <a href="income_add.asp" class="btn btn-primary">Tambah</a>
      </div>   
   </div>
   <% end if %>
   <form action="./" method="post">
   <div class="row">
      <div class="col-sm-4 mt-3">
         <label for="tgla">Tanggal Pertama</label>
         <input type="date" class="form-control" name="tgla" id="tgla" autocomplete="off">
      </div>
      <div class="col-sm-4 mt-3">
         <label for="tgle">Tanggal kedua</label>
         <input type="date" class="form-control" name="tgle" id="tgle" autocomplete="off">
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
         <label for="ophidmr">No. Purchase</label>
         <select class="form-select" aria-label="Default select example" name="ophidmr" id="ophidmr">
            <option value="">Pilih</option>
            <% do while not datapo.eof %>
               <option value="<%= datapo("MR_OPHID") %>"><%= left(datapo("MR_OPHID"),2) %>-<%= mid(datapo("MR_OPHID"),3,3)%>/<%= mid(datapo("MR_OPHID"),6,4) %>/<%= right(datapo("MR_OPHID"),4) %></option>
            <% 
            Response.flush
            datapo.movenext
            loop
            %>
         </select>
      </div>
      <div class="col-sm-2 mt-3">
         </br>
         <button type="submit" class="btn btn-primary">Cari</button>
      </div>
   </div>
   </form>
   <div class="row">
      <div class="col-sm-12 mt-3">
         <table class="table table-hover table-bordered">
            <thead class="bg-secondary text-light">
               <tr>
               <th scope="col">No</th>
               <th scope="col">Tanggal</th>
               <th scope="col">No.M.R</th>
               <th scope="col">No.Purchase</th>
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
               data_cmd.commandTExt = "SELECT * FROM DLK_T_MaterialReceiptD2 WHERE MR_ID = '"& rs("MR_ID") &"'"

               set detail = data_cmd.execute
               %>
               <tr>
                  <th><%= recordcounter%></th>
                  <td><%= Cdate(rs("MR_Date")) %></td>
                  <td> <%= LEFT(rs("MR_ID"),2) &"-"& mid(rs("MR_ID"),3,3) &"/"& mid(rs("MR_ID"),6,4) &"/"& right(rs("MR_ID"),4)%></td>
                  <td><%= left(rs("MR_OPHID"),2) %>-<%= mid(rs("MR_OPHID"),3,3)%>/<%= mid(rs("MR_OPHID"),6,4) %>/<%= right(rs("MR_OPHID"),4) %></td>
                  <td><%= rs("MR_Keterangan") %></td>
                  <td class="text-center">
                     <div class="btn-group" role="group" aria-label="Basic example">
                        <a href="detail.asp?id=<%= rs("MR_ID") %>" class="btn badge text-bg-warning">Detail</a>
                        <% if session("INV2B") = true then %> 
                        <a href="incomed_add.asp?id=<%= rs("MR_ID") %>" class="btn badge text-bg-primary">update</a>
                        <% end if %>
                        <% if session("INV2C") = true then %> 
                           <% if detail.eof then %>
                           <a href="aktif.asp?id=<%= rs("MR_ID") %>" class="btn badge bg-danger" onclick="deleteItem(event,'delete header material receipt')">delete</a>
                           <% end if %>
                        <% end if %>
                     </div>
                  </td>
               </tr>
               <% 
               Response.flush
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
                  <a class="page-link prev" href="./?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&cabang=<%=cabang%>&tgla=<%=tgla%>&tgle=<%=tgle%>&ophidmr=<%=ophidmr%>">&#x25C4; Prev </a>
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
                     <a class="page-link hal bg-primary text-light" href="./?offset=<% = pagelist %>&page=<%=pagelistcounter%>&cabang=<%=cabang%>&tgla=<%=tgla%>&tgle=<%=tgle%>&ophidmr=<%=ophidmr%>"><%= pagelistcounter %></a> 
                  <%else%>
                     <a class="page-link hal" href="./?offset=<% = pagelist %>&page=<%=pagelistcounter%>&cabang=<%=cabang%>&tgla=<%=tgla%>&tgle=<%=tgle%>&ophidmr=<%=ophidmr%>"><%= pagelistcounter %></a> 
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
                     <a class="page-link next" href="./?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&cabang=<%=cabang%>&tgla=<%=tgla%>&tgle=<%=tgle%>&ophidmr=<%=ophidmr%>">Next &#x25BA;</a>
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