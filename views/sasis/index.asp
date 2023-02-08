<!--#include file="../../init.asp"-->
<% 
   if session("ENG5") = false then 
      Response.Redirect("../index.asp")
   end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string
   ' filter type sasis
   data_cmd.commandText = "SELECT SasisType FROM DLK_M_Sasis WHERE SasisAktifYN = 'Y' ORDER BY SasisType ASC"
   set getType = data_cmd.execute

   ' filter class
   data_cmd.commandText = "SELECT dbo.DLK_M_Class.ClassName, dbo.DLK_M_Class.ClassID FROM dbo.DLK_M_Sasis LEFT OUTER JOIN dbo.DLK_M_Class ON dbo.DLK_M_Sasis.SasisClassID = dbo.DLK_M_Class.ClassID WHERE (dbo.DLK_M_Sasis.SasisAktifYN = 'Y') GROUP BY dbo.DLK_M_Class.ClassName, dbo.DLK_M_Class.ClassID ORDER BY dbo.DLK_M_Class.ClassName"
   set getclass = data_cmd.execute
   ' filter brand
   data_cmd.commandText = "SELECT dbo.DLK_M_Brand.BrandName, dbo.DLK_M_Brand.BrandID FROM dbo.DLK_M_Sasis LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.DLK_M_Sasis.SasisBrandID = dbo.DLK_M_Brand.BrandID WHERE (dbo.DLK_M_Sasis.SasisAktifYN = 'Y') GROUP BY dbo.DLK_M_Brand.BrandName, dbo.DLK_M_Brand.BrandID ORDER BY dbo.DLK_M_Brand.BrandName ASC"
   set getbrand = data_cmd.execute


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
   
   tclass = request.QueryString("tclass")
   if len(tclass) = 0 then 
      tclass = trim(Request.Form("tclass"))
   end if
   tbrand = request.QueryString("tbrand")
   if len(tbrand) = 0 then 
      tbrand = trim(Request.Form("tbrand"))
   end if
   stype = request.QueryString("stype")
   if len(stype) = 0 then 
      stype = trim(Ucase(Request.Form("stype")))
   end if

   if tclass <> "" then
      filtertclass = " AND sasisClassID = '"& tclass &"'"
   else
      filtertclass = ""
   end if
   if tbrand <> "" then
      filtertbrand = " AND sasisBrandID = '"& tbrand &"'"
   else
      filtertbrand = ""
   end if
   if stype <> "" then
      filterstype = " AND sasisType = '"& stype &"'"
   else
      filterstype = ""
   end if

   strquery = "SELECT dbo.DLK_M_Sasis.*, dbo.DLK_M_Brand.BrandName, dbo.DLK_M_Class.ClassName FROM dbo.DLK_M_Sasis LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.DLK_M_Sasis.SasisBrandID = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.DLK_M_Class ON dbo.DLK_M_Sasis.SasisClassID = dbo.DLK_M_Class.ClassID WHERE SasisAktifYN = 'Y' "& filtertclass &""& filtertbrand &""& filterstype &""
   ' response.write strquery
   ' untuk data paggination
   page = Request.QueryString("page")

   orderBy = " order by SasisID ASC"
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

   call header("Master Sasis") 

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3">
        <div class="col-lg-12 text-center">
            <h3>MASTER SASIS / STANDART PRODUK </h3>
        </div>
    </div>
    <% if session("ENG5A") = true then  %>
    <div class="row mt-3 mb-3">
        <div class="col-lg-2">
            <a href="sasis_add.asp" class="btn btn-primary">Tambah</a>
        </div>
    </div>
    <%  end if %>
   <form action="index.asp" method="post">
   <div class="row">
      <div class="col-sm-3 mb-3">
         <select class="form-select" aria-label="Default select example" id="tclass" name="tclass" >
            <option value="">Pilih Class</option>
            <% do while not getclass.eof %>
            <option value="<%= getclass("classID") %>"><%= getclass("ClassName") %></option>
            <% 
            Response.flush
            getclass.movenext
            loop
            %>
         </select>
      </div>
      <div class="col-sm-3 mb-3">
         <select class="form-select" aria-label="Default select example" id="tbrand" name="tbrand" >
            <option value="">Pilih Brand</option>
            <% do while not getbrand.eof %>
            <option value="<%= getbrand("brandID") %>"><%= getbrand("BrandName") %></option>
            <% 
            Response.flush
            getbrand.movenext
            loop
            %>
         </select>
      </div>
      <div class="col-sm-3 mb-3">
         <select class="form-select" aria-label="Default select example" id="stype" name="stype" >
            <option value="">Pilih Type</option>
            <% do while not getType.eof %>
            <option value="<%= getType("sasisType") %>"><%= getType("sasisType") %></option>getType
            <% 
            Response.flush
            getType.movenext
            loop
            %>
         </select>
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
                    <th scope="col">No</th>
                    <th scope="col">Class</th>
                    <th scope="col">Brand</th>
                    <th scope="col">Type</th>
                    <th scope="col">Long</th>
                    <th scope="col">Width</th>
                    <th scope="col">Height</th>
                    <th scope="col">Drawing</th>
                    <th scope="col">SKRB</th>
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
                    %>
                    <tr>
                        <th scope="row"><%= LEft(rs("SasisID"),5) &"-"& mid(rs("SasisID"),6,4) &"-"& right(rs("SasisID"),3) %> </th>
                        <td><%= rs("className") %></td>
                        <td><%= rs("BrandName") %></td>
                        <td><%= rs("SasisType") %></td>
                        <td><%= rs("SasisL") %></td>
                        <td><%= rs("SasisW") %></td>
                        <td><%= rs("SasisH") %></td>
                        <td>
                           <% 
                           if rs("SasisDrawing") <> "" then
                           %>
                              <a href="uploadDrawing.asp?id=<%= rs("SasisID") %>&t=stack&db=SasisDrawing" class="btn badge text-bg-light"><i class="bi bi-upload"></i></a>
                              <a href="openPdf.asp?id=<%= rs("SasisID") %>&p=draw" class="btn badge text-bg-light" target="_blank"><i class="bi bi-caret-right"></i></a>
                           <%else%>
                              <a href="uploadDrawing.asp?id=<%= rs("SasisID") %>&t=stack&db=SasisDrawing" class="btn badge text-bg-light"><i class="bi bi-upload"></i></a>
                           <%end if
                           set fs = Nothing
                           %>
                        </td>
                        <td>
                           <% 
                           if rs("SasisSKRB") <> "" then
                           %>
                              <a href="uploadDrawing.asp?id=<%= rs("SasisID") %>&t=pdf&db=SasisSKRB" class="btn badge text-bg-light"><i class="bi bi-upload"></i></a>
                              <a href="openPdf.asp?id=<%= rs("SasisID") %>&p=skrb" class="btn badge text-bg-light" target="_blank"><i class="bi bi-caret-right"></i></a>
                           <%else%>
                              <a href="uploadDrawing.asp?id=<%= rs("SasisID") %>&t=pdf&db=SasisSKRB" class="btn badge text-bg-light"><i class="bi bi-upload"></i></a>
                           <%end if
                           set fs = Nothing
                           %>
                        </td>
                        <td><%= rs("SasisKeterangan") %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                              <% if session("ENG5B") = true then  %>
                                <a href="sasis_u.asp?id=<%= rs("SasisID") %>" class="btn badge text-bg-primary">update</a>
                              <% end if %>
                              <% if session("ENG5C") = true then  %>
                                <a href="aktif.asp?id=<%= rs("SasisID") %>" class="btn badge text-bg-danger" onclick="ApproveYN(event,'Master Standart Produk','Delete Master','warning')">delete</a>
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
                  <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&tclass=<%=tclass%>&stype=<%=stype%>&tbrand=<%=tbrand%>">&#x25C4; Prev </a>
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
                     <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&tclass=<%=tclass%>&stype=<%=stype%>&tbrand=<%=tbrand%>"><%= pagelistcounter %></a> 
                  <%else%>
                     <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&tclass=<%=tclass%>&stype=<%=stype%>&tbrand=<%=tbrand%>"><%= pagelistcounter %></a> 
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
                     <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&tclass=<%=tclass%>&stype=<%=stype%>&tbrand=<%=tbrand%>">Next &#x25BA;</a>
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