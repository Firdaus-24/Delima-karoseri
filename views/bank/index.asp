<!--#include file="../../init.asp"-->
<% 
   if session("FN2") = false then
      Response.Redirect("../index.asp")
   end if
   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT userID, username FROM GL_M_Bank LEFT OUTER JOIN DLK_M_WebLogin ON GL_M_Bank.Bank_updateid = DLK_M_Weblogin.userid where Bank_aktifYN = 'Y' AND DLK_M_WebLogin.UserID IS NOT NULL GROUP BY userID, username ORDER BY username"

   set users = data_cmd.execute

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
   user = request.QueryString("user")
   if len(user) = 0 then 
      user = trim(Request.Form("user"))
   end if

   if nama <> "" then 
      filternama = " AND UPPER(GL_M_Bank.Bank_name) LIKE '%"& ucase(nama) &"%'"
   else 
      filternama = ""
   end if
   if user <> "" then 
      filteruser = " AND GL_M_Bank.Bank_updateid = '"& user &"'"
   else 
      filteruser = ""
   end if

   ' query seach 
   strquery = "SELECT GL_M_Bank.*, DLK_M_WebLogin.UserName FROM GL_M_Bank LEFT OUTER JOIN DLK_M_WebLogin ON GL_M_Bank.Bank_updateID = DLK_M_WebLogin.userid WHERE (dbo.GL_M_Bank.Bank_AktifYN = 'Y') "& filternama &" "& filteruser &""

   ' untuk data paggination
   page = Request.QueryString("page")

   orderBy = " ORDER BY dbo.GL_M_Bank.Bank_Name ASC"
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
   
   call header("Master Bank") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-sm-12 mt-3 text-center">
         <h3>MASTER BANK</h3>
      </div>
   </div>
   <% if session("FN2") = true then %>
   <div class="row">
      <div class="col-sm mt-3">
         <a href="bank_add.asp" class="btn btn-primary">Tambah</a>
      </div>   
   </div>
   <% end if %>
   <form action="index.asp" method="post">
   <div class="row">
      <div class="col-sm-5 mt-3">
         <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" placeholder="cari nama bank">
      </div>
      <div class="col-lg-4 mt-3">
         <select class="form-select" aria-label="Default select example" name="user" id="user">
            <option value="">Pilih user</option>
            <% do while not users.eof %>
               <option value="<%= users("userid") %>"><%= users("username") %></option>
            <% 
            users.movenext
            loop
            %>
         </select>
      </div>
      <div class="col-sm mt-3">
         <button type="submit" class="btn btn-primary">Cari</button>
      </div>
   </div>
   </form>
   <div class="row">
        <div class="col-lg-12 mt-3">
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                    <th scope="col">Nama</th>
                    <th scope="col">Keterangan</th>
                    <th scope="col">Update Time</th>
                    <th scope="col">Update ID</th>
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
                        <td><%= rs("Bank_Name") %></td>
                        <td><%= rs("Bank_Keterangan") %></td>
                        <td><%= rs("Bank_updateTime") %></td>
                        <td><%= rs("username") %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                              <% if session("FN2B") = true then %>
                                <a href="bank_u.asp?id=<%= rs("Bank_ID") %>" class="btn badge text-bg-primary">update</a>
                              <% end if %>
                              <% if session("FN2C") = true then %>
                                <a href="aktif.asp?id=<%= rs("Bank_ID") %>" class="btn badge bg-danger" onclick="deleteItem(event,'delete master bank')">delete</a>
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
