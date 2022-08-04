<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_metpem.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

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
    
    ' if agen <> "" then
    '     filterAgen = "AND DLK_T_Memo_H.memoAgenID = '"& agen &"'"
    ' else
    '     filterAgen = ""
    ' end if

    ' if keb <> "" then
    '     filterKeb = "AND dbo.DLK_T_Memo_H.memoKebID = '"& keb &"'"
    ' else
    '     filterKeb = ""
    ' end if

    ' if tgla <> "" AND tgle <> "" then
    '     filtertgl = "AND dbo.DLK_T_Memo_H.memotgl BETWEEN '"& tgla &"' AND '"& tgle &"'"
    ' elseIf tgla <> "" AND tgle = "" then
    '     filtertgl = "AND dbo.DLK_T_Memo_H.memotgl = '"& tgla &"'"
    ' else 
    '     filtertgl = ""
    ' end if

    ' query seach 
    strquery = "SELECT * FROM DLK_T_OrPemH WHERE OPH_AktifYN = 'Y' "
    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY OPH_Date DESC"
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

    call header("Purchase Detail") 
%>

<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>DETAIL PURCHASE ORDER</h3>
        </div>  
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3">
            <a href="purc_ad.asp" class="btn btn-primary">Tambah</a>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover">
                <thead class="bg-secondary text-light">
                    <th>No</th>
                    <th>Cabang</th>
                    <th>Tanggal</th>
                    <th>Vendor</th>
                    <th>Tanggal JT</th>
                    <th>Diskon</th>
                    <th>PPn</th>
                    <th>Pembayaran</th>
                    <th>Keterangan</th>
                    <th class="text-center">Aksi</th>
                </thead>
                <tbody>
                    <% 
                    'prints records in the table
                    showrecords = recordsonpage
                    recordcounter = requestrecords
                    do until showrecords = 0 OR  rs.EOF
                    recordcounter = recordcounter + 1
                    %>
                        <tr><TH><%= recordcounter %></TH>
                        <td><% call getAgen(rs("OPH_AgenID"),"P") %></td>
                        <td><%= rs("OPH_Date") %></td>
                        <td><% call getVendor(rs("OPH_VenID")) %></td>
                        <td>
                            <% if rs("OPH_JTDate") <> "1900-01-01" then %>
                            <%= rs("OPH_JTDate") %>
                            <% end if %>
                        </td>
                        <td><%= rs("OPH_DiskonAll") %></td>
                        <td><%= rs("OPH_PPn") %></td>
                        <td><% call getmetpem(rs("OPH_MetPem")) %></td>
                        <td><%= rs("OPH_Keterangan") %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="purce_d.asp?id=<%= rs("OPH_ID") %>" class="btn badge text-light bg-warning">Detail</a>
                                <a href="purc_u.asp?id=<%= rs("OPH_ID") %>" class="btn badge text-bg-primary" >Update</a>
                                <a href="aktifh.asp?id=<%= rs("OPH_ID") %>" class="btn badge text-bg-danger btn-purce1">Delete</a>
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
                        <a class="page-link prev" href="purcesDetail.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="purcesDetail.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="purcesDetail.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="purcesDetail.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>">Next &#x25BA;</a>
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
