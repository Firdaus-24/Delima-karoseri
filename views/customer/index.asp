<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_barang.asp"-->
<% 
    if session("M2") = false then 
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
        nama = Ucase(trim(Request.Form("nama")))
    end if
    typet = request.QueryString("typet")
    if len(typet) = 0 then 
        typet = trim(Request.Form("typet"))
    end if

    ' query seach 
    if nama <> "" then
        filterNama = " AND UPPER(custNama) LIKE '%"& nama &"%' "
    end if
    if typet <> "" then
        filtertypet = " AND custTypeTransaksi = "& typet &""
    end if

    ' real query
    strquery = "SELECT dbo.DLK_M_Customer.custId, dbo.DLK_M_Customer.custNama, dbo.DLK_M_Customer.custEmail, dbo.DLK_M_Customer.custAlamat, dbo.DLK_M_Customer.custPhone1,(CASE WHEN dbo.DLK_M_Customer.custTypeTransaksi = 1 THEN 'CBD' WHEN dbo.DLK_M_Customer.custTypeTransaksi = 2 THEN 'COD' WHEN dbo.DLK_M_Customer.custTypeTransaksi = 3 THEN 'TOP' ELSE '' END) AS ttrans, dbo.DLK_M_Customer.custNorek, dbo.DLK_M_Customer.custBankID, dbo.DLK_M_Customer.custRekName, dbo.GL_M_Bank.Bank_Name FROM dbo.DLK_M_Customer LEFT OUTER JOIN dbo.GL_M_Bank ON dbo.DLK_M_Customer.custBankID = dbo.GL_M_Bank.Bank_ID WHERE custAktifYN = 'Y' "& filterNama &" "& filtertypet &""
    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " order by custNama ASC"
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

    call header("Master Customer") 

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3">
        <div class="col-lg-12 text-center">
            <h3>MASTER CUSTOMER</h3>
        </div>
    </div>
    <% if session("M2A") = true then  %>
    <div class="row mt-3 mb-3">
        <div class="col-lg-2">
            <!-- Button trigger modal -->
            <a href="cust_Add.asp" class="btn btn-primary tcust">
                Tambah
            </a>
        </div>
    </div>
    <% end if %>
    <form action="index.asp" method="post">
        <div class="row">
            <div class="col-lg-4 mb-3">
                <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" placeholder="cari nama customer">
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" name="typet" id="typet">
                    <option value="">Pilih Type Pembayaran</option>
                    <option value="1">CBD</option>
                    <option value="2">COD</option>
                    <option value="3">TOP</option>
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
                        <th scope="col">ID</th>
                        <th scope="col">Nama</th>
                        <th scope="col">Phone1</th>
                        <th scope="col">Email</th>
                        <th scope="col">Bank ID</th>
                        <th scope="col" >Type Pembayaran</th>
                        <th scope="col">Alamat</th>
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
                        <th><%= rs("custID") %></th>
                        <td><%= rs("custNama") %></td>
                        <td><%= rs("custPhone1") %></td>
                        <td><%= rs("custEmail") %></td>
                        <td><%= rs("bank_name") %></td>
                        <td><%= rs("ttrans") %></td>
                        <td><%= rs("custAlamat") %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <% if session("M2B") = true then  %>
                                <a href="cust_u.asp?id=<%= rs("custId") %>" class="btn badge text-bg-primary">update</a> 
                                <% end if %>
                                <% if session("M2C") = true then  %>
                                <a href="aktif.asp?id=<%= rs("custId") %>" class="btn badge text-bg-danger btn-aktifcust">delete</a>
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
<% call footer()%>