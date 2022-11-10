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

    ' query seach 
    ' if agen <> "" and nama <> "" then
    '     strquery = "SELECT * FROM DLK_M_Rak WHERE Rak_AktifYN = 'Y' AND left(Rak_id,3) = '"& agen &"' AND Rak_Nama LIKE '%"& nama &"%'"
    ' elseif agen <> "" then
    '     strquery = "SELECT * FROM DLK_M_Rak WHERE Rak_AktifYN = 'Y' AND left(Rak_id,3) = '"& agen &"'"
    ' elseif nama <> "" then
    '     strquery = "SELECT * FROM DLK_M_Rak WHERE Rak_AktifYN = 'Y' AND Rak_Nama LIKE '%"& nama &"%'"
    ' else
    '     strquery = "SELECT * FROM DLK_M_Rak WHERE Rak_AktifYN = 'Y'"
    ' end if
        strquery = "SELECT DLK_T_ReturnBarangH.*, GLB_M_Agen.AgenNAme, DLK_M_Vendor.Ven_Nama FROM DLK_T_ReturnBarangH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ReturnBarangH.RB_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Vendor ON DLK_T_ReturnBarangH.RB_VenID = DLK_M_Vendor.Ven_ID WHERE RB_AktifYN = 'Y' "

    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY RB_Date DESC   "
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

    call header("Return Barang")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 text-center mt-3 mb-3">
            <h3>DAFTAR RETURN BARANG PEMBELIAN</h3>
        </div>
    </div>
    <div class="row mt-3 mb-3">
        <div class="col-lg-2">
            <a href="rb_add.asp" class="btn btn-primary">Tambah</a>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                    <th scope="col">No</th>
                    <th scope="col">Tanggal</th>
                    <th scope="col">Cabang</th>
                    <th scope="col">Vendor</th>
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
                        <th scope="row"><%= recordcounter %> </th>
                        <td><%= Cdate(rs("RB_Date")) %></td>
                        <td><%= rs("AgenNAme") %></td>
                        <td><%= rs("Ven_Nama") %></td>
                        <td><%= rs("RB_Keterangan") %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="ra_u.asp?id=<%= rs("RB_ID") %>" class="btn badge text-bg-primary">update</a>
                                <a href="aktif.asp?id=<%= rs("RB_ID") %>" class="btn badge text-bg-danger btn-aktifrak">delete</a>
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
