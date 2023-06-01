<!--#include file="../../init.asp"-->
<% 
   if session("PP1") = false then 
      Response.Redirect("../index.asp")
   end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string
   ' filter no produksi
   data_cmd.commandText = "SELECT RC_PDDID FROM DLK_T_RCProdH WHERE RC_AktifYN = 'Y' ORDER BY RC_PDDID ASC"
   set getproduksi = data_cmd.execute

   ' filter class
   data_cmd.commandText = "SELECT dbo.DLK_M_WebLogin.username, dbo.DLK_M_WebLogin.userid FROM dbo.DLK_T_RCProdH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_RCProdH.RC_UpdateID = dbo.DLK_M_WebLogin.userid WHERE (dbo.DLK_T_RCProdH.RC_AktifYN = 'Y') GROUP BY dbo.DLK_M_WebLogin.username, dbo.DLK_M_WebLogin.userid ORDER BY dbo.DLK_M_WebLogin.username"
   set getusers = data_cmd.execute

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
   
   noprod = request.QueryString("noprod")
   if len(noprod) = 0 then 
      noprod = trim(Request.Form("noprod"))
   end if
   user = request.QueryString("user")
   if len(user) = 0 then 
      user = trim(Request.Form("user"))
   end if

   if noprod <> "" then
      filternoprod = " AND RC_PDDID = '"& noprod &"'"
   else
      filternoprod = ""
   end if
   if user <> "" then
      filteruser = " AND RC_UpdateID = '"& user &"'"
   else
      filteruser = ""
   end if

   strquery = "SELECT dbo.DLK_T_RcProdH.*, dbo.DLK_M_WebLogin.username FROM dbo.DLK_T_RcProdH LEFT OUTER JOIN dbo.DLK_M_Weblogin ON dbo.DLK_T_RcProdH.RC_UpdateID = dbo.DLK_M_webLogin.userID WHERE RC_AktifYN = 'Y' "& filternoprod &""& filteruser &""
   ' response.write strquery
   ' untuk data paggination
   page = Request.QueryString("page")

   orderBy = " order by RC_ID DESC"
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

   call header("Penerimaan Barang Produksi") 

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3">
        <div class="col-lg-12 text-center">
            <h3>TRANSAKSI PENERIMAAN BARANG PRODUKSI</h3>
        </div>
    </div>
    <% if session("PP1A") = true then  %>
    <div class="row mt-3 mb-3">
        <div class="col-lg-2">
            <a href="rc_add.asp" class="btn btn-primary">Tambah</a>
        </div>
    </div>
    <%  end if %>
   <form action="index.asp" method="post">
   <div class="row">
      <div class="col-sm-3 mb-3">
         <select class="form-select" aria-label="Default select example" id="noprod" name="noprod" >
            <option value="">Pilih No Produksi</option>
            <% do while not getproduksi.eof %>
            <option value="<%= getproduksi("RC_PDDID") %>">
               <%= left(getproduksi("RC_PDDid"),2)&"-"&mid(getproduksi("RC_PDDid"),3,3) &"/"& mid(getproduksi("RC_PDDid"),6,4) &"/"& mid(getproduksi("RC_PDDid"),10,4) &"/"& right(getproduksi("RC_PDDid"),3)  %>
            </option>
            <% 
            Response.flush
            getproduksi.movenext
            loop
            %>
         </select>
      </div>
      <div class="col-sm-3 mb-3">
         <select class="form-select" aria-label="Default select example" id="user" name="user" >
            <option value="">Pilih Update ID</option>
            <% do while not getusers.eof %>
            <option value="<%= getusers("userid") %>"><%= getusers("username") %></option>
            <% 
            Response.flush
            getusers.movenext
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
                    <th scope="col">No Produksi</th>
                    <th scope="col">Class</th>
                    <th scope="col">Brand</th>
                    <th scope="col">Type</th>
                    <th scope="col">Tanggal</th>
                    <th scope="col">Man Power</th>
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

                  '   cek data detail
                  data_cmd.commandText = "SELECT RCD_ID FROM DLK_T_RCProdD WHERE LEFT(RCD_ID,10) = '"& rs("RC_ID") &"'"
                  set ddata = data_cmd.execute

                  ' get nomor sasis
                  data_cmd.commandText = "SELECT ISNULL(dbo.DLK_M_Brand.BrandName,'') as brand, ISNULL(dbo.DLK_M_Class.ClassName,'') as class, ISNULL(dbo.DLK_M_Sasis.SasisType,'') as type FROM dbo.DLK_M_BOMH INNER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_M_BOMH.BMID = dbo.DLK_T_ProduksiD.PDD_BMID INNER JOIN dbo.DLK_M_Brand INNER JOIN dbo.DLK_M_Sasis INNER JOIN dbo.DLK_M_Class ON dbo.DLK_M_Sasis.SasisClassID = dbo.DLK_M_Class.ClassID ON dbo.DLK_M_Brand.BrandID = dbo.DLK_M_Sasis.SasisBrandID ON dbo.DLK_M_BOMH.BMSasisID = dbo.DLK_M_Sasis.SasisID WHERE (dbo.DLK_T_ProduksiD.PDD_ID = '"& rs("RC_PDDID") &"')"
                  ' response.write data_cmd.commandText & "<br>"
                  set getsasis = data_cmd.execute
                    %>
                    <tr>
                        <th scope="row">
                           <%= LEft(rs("RC_ID"),2) &"-"& mid(rs("RC_ID"),3,4) &"-"& right(rs("RC_ID"),4) %> 
                        </th>
                        <td>
                           <%= left(rs("RC_PDDid"),2)&"-"&mid(rs("RC_PDDid"),3,3) &"/"& mid(rs("RC_PDDid"),6,4) &"/"& mid(rs("RC_PDDid"),10,4) &"/"& right(rs("RC_PDDid"),3)  %>
                        </td>
                        <td>
                           <% if not getsasis.EOF then %>
                              <%= getsasis("class") %>
                           <% else %>
                              -
                           <% end if %>
                        </td>
                        <td>
                           <% if not getsasis.EOF then %>
                              <%= getsasis("brand") %>
                           <% else %>
                              -
                           <% end if %>
                        </td>
                        <td>
                           <% if not getsasis.EOF then %>
                              <%= getsasis("Type") %>
                           <% else %>
                              -
                           <% end if %>
                        </td>
                        <td><%= Cdate(rs("RC_Date")) %></td>
                        <td><%= rs("RC_MP") %></td>
                        <td><%= rs("username") %></td>
                        <td><%= rs("RC_Keterangan") %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                              <% if session("PP1B") = true then  %>
                                <a href="rcd_u.asp?id=<%= rs("RC_ID") %>" class="btn badge text-bg-primary">update</a>
                              <% end if %>
                              <% if ddata.eof then %>
                                 <% if session("PP1C") = true then  %>
                                    <a href="aktifh.asp?id=<%= rs("RC_ID") %>" class="btn badge text-bg-danger" onclick="ApproveYN(event,'Transaksi Penerimaan Barang','Delete transaksi','warning')">delete</a>
                                 <% end if %>
                              <% else %>
                                 <a href="detail.asp?id=<%= rs("RC_ID") %>" class="btn badge text-bg-warning">detail</a>
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
                  <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&noprod=<%=noprod%>&user=<%=user%>">&#x25C4; Prev </a>
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
                     <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&noprod=<%=noprod%>&user=<%=user%>"><%= pagelistcounter %></a> 
                  <%else%>
                     <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&noprod=<%=noprod%>&user=<%=user%>"><%= pagelistcounter %></a> 
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
                     <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&noprod=<%=noprod%>&user=<%=user%>">Next &#x25BA;</a>
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