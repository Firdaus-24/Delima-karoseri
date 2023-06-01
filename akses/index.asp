<!--#include file="../Connections/cargo.asp"-->
<!--#include file="../url.asp"-->
<% 
    ' cek hakakses 
    if Ucase(session("username")) <> "DAUSIT" AND Ucase(session("username")) <> Ucase("ADMINISTRATOR") then
        Response.Redirect(url&"login.asp")
    end if

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.CommandText = "SELECT AgenID, AgenName FROM DLK_M_WebLogin LEFT OUTER JOIN GLB_M_Agen ON DLK_M_Weblogin.serverID = GLB_M_Agen.AgenID WHERE UserAktifYN = 'Y' GROUP BY AgenID, AgenName ORDER BY AgenNAme ASC"

    set agen = data_cmd.execute

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.CommandText = "SELECT * FROM DLK_M_webLogin WHERE UserAktifYN = 'Y' ORDER BY Username asc"

    set data = data_cmd.execute   

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
    pagen = request.QueryString("pagen")
    if len(pagen) = 0 then 
        pagen = trim(Request.Form("pagen"))
    end if
    
    if pagen <> "" then 
       filterpagen = " AND DLK_M_webLogin.serverID = '"& pagen &"'"
    else 
       filterpagen = ""
    end if

    if nama <> "" then 
       filternama = " AND DLK_M_webLogin.username LIKE '%"& nama &"%'"
    else 
       filternama = ""
    end if

    ' query seach 
    strquery = "SELECT DLK_M_webLogin.*, GLB_M_Agen.AgenName FROM DLK_M_webLogin LEFT OUTER JOIN GLB_M_Agen ON DLK_M_Weblogin.serverID = GLB_M_Agen.AgenID WHERE UserAktifYN = 'Y' "& filterpagen &" "& filternama &""
    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY Username asc"
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
    server.Execute("../header.asp")
    response.write "<title>Hak Kases</title><body>"
%>
<!--#include file="../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-sm-12 text-center mt-3 mb-3">
         <h3>HAKAKSES USERS</h3>
      </div>
   </div>
   <div class="row">
      <div class="col-sm mb-3">
         <button type="button" class="btn btn-primary" onclick="window.location.href='akses_add.asp'">Tambah</button>
      </div>
   </div>
   <form action="index.asp" method="post">
    <div class="row">
        <div class="col-sm mb-3">
            <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" placeholder="cari nama user">
        </div>
        <div class="col-sm mb-3">
            <select class="form-select" aria-label="Default select example" name="pagen" id="pagen">
                <option value="">Pilih Cabang / Agen</option>
                <% do while not agen.eof %>
                <option value="<%= agen("AgenID") %>"><%= agen("AgenName") %></option>
                <% 
                agen.movenext
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
                    <th scope="col">UserID</th>
                    <th scope="col">UserName</th>
                    <th scope="col">ServerID</th>
                    <th scope="col">Last Login</th>
                    <th scope="col" class="text-center">Aktif</th>
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
                        <th scope="row"><%= recordcounter %></th>
                        <td><%= rs("UserID") %></td>
                        <td><%= rs("username") %></td>
                        <td><%= rs("agenName") %></td>
                        <td><%= rs("lastLogin") %></td>
                        <td class="text-center text-success"><% if rs("useraktifYN") = "Y" then %>ON<% end if %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="pakses_add.asp?id=<%= rs("userid") %>" class="btn badge text-bg-primary">update</a>
                                <a href="aktif.asp?id=<%= rs("userid") %>" class="btn badge bg-danger" onclick="deleteItem(event,'delete user')">delete</a>
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
                        <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&nama=<%= nama %>&pagen=<%= pagen %>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&nama=<%= nama %>&pagen=<%= pagen %>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&nama=<%= nama %>&pagen=<%= pagen %>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&nama=<%= nama %>&pagen=<%= pagen %>">Next &#x25BA;</a>
                        <% else %>
                            <p class="page-link next-p">Next &#x25BA;</p>
                        <% end if %>
                    </li>	
                </ul>
            </nav> 
        </div>
    </div>
</div>
</body>
<% 
   server.execute("../footer.asp")
%>