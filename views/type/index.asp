<!--#include file="../../init.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT userID, username FROM DLK_M_TypeBarang LEFT OUTER JOIN DLK_M_WebLogin ON DLK_M_TypeBarang.T_UpdateID = DLK_M_Weblogin.username WHERE T_AktifYN = 'Y' AND T_UpdateID != '' GROUP BY userID, username ORDER BY Username ASC"

    set puser = data_cmd.execute

    nama = trim(Request.Form("nama"))
    user = trim(Request.Form("user"))

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

    ' query seach 
    if nama <> "" and user <> "" then
        strquery = "SELECT * FROM DLK_M_TypeBarang WHERE T_AktifYN = 'Y' AND T_Nama LIKE '%"& nama &"%' AND T_UPdateID = '"& user &"'"
    elseif nama <> "" then
        strquery = "SELECT * FROM DLK_M_TypeBarang WHERE T_AktifYN = 'Y' AND T_Nama LIKE '%"& nama &"%'"
    elseif user <> "" then
        strquery = "SELECT * FROM DLK_M_TypeBarang WHERE T_AktifYN = 'Y' AND T_updateID LIKE '%"& user &"%'"
    else
        strquery = "SELECT * FROM DLK_M_TypeBarang WHERE T_AktifYN = 'Y'"
    end if

    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " order by T_ID ASC"
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

    call header("Type Barang") 

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3">
        <div class="col-lg-12 text-center">
            <h3>MASTER TYPE BARANG</h3>
        </div>
    </div>
    <div class="row mt-3 mb-3">
        <div class="col-lg-2">
            <!-- Button trigger modal -->
            <button type="button" class="btn btn-primary" onclick="window.location.href='type_ad.asp'">
                Tambah
            </button>
        </div>
    </div>
    <form action="index.asp" method="post">
        <div class="row">
            <div class="col-lg-4 mb-3">
                <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" placeholder="cari nama">
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example">
                    <option value="">Pilih</option>
                    <% do while not puser.eof %>
                    <option value="<%= puser("username") %>"><%= puser("username") %></option>
                    <% 
                    puser.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg mb-3">
                <button type="submit" class="btn btn-primary">Cari</button>
            </div>
        </div>
    </form>
    <div class="row">
        <div class="col-lg-12">
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                    <th scope="col">Id</th>
                    <th scope="col">Nama</th>
                    <th scope="col">UpdateId</th>
                    <th scope="col">Keterangan</th>
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
                        <th scope="row"><%= rs("T_Id") %> </th>
                        <td><%= rs( "T_Nama") %></td>
                        <td><%= rs("T_UpdateId") %></td>
                        <td><%= rs("T_Keterangan") %></td>
                        <td><%if rs("T_AktifYN") = "Y" then%>Aktif <% end if %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="type_u.asp?id=<%= rs("T_Id") %>" class="btn badge text-bg-primary">update</a> 
                                <a href="aktif.asp?id=<%= rs("T_Id") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'MASTER TYPE BARANG')">delete</a>
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