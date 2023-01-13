<!--#include file="../../init.asp"-->
<% 
    ' query cabang 
    set agen_cmd =  Server.CreateObject ("ADODB.Command")
    agen_cmd.ActiveConnection = mm_delima_string

    agen_cmd.commandText = "SELECT AgenID, AgenName FROM GLB_M_Agen WHERE AgenAktifYN = 'Y'"
    set agendata = agen_cmd.execute

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
    agen = request.QueryString("agen")
    if len(agen) = 0 then 
        agen = trim(Request.Form("agen"))
    end if
    nama = request.QueryString("nama")
    if len(nama) = 0 then 
        nama = trim(Request.Form("nama"))
    end if
    
    ' query seach 
    if agen <> "" and nama <> "" then
        strquery = "SELECT DLK_M_Vendor.*, GLB_M_Agen.Agenname FROM DLK_M_Vendor LEFT OUTER JOIN GLB_M_Agen ON LEFT(DLK_M_Vendor.ven_ID,3) = GLB_M_Agen.AgenID WHERE Ven_AktifYN = 'Y' AND left(Ven_id,3) = '"& agen &"' AND ven_Nama LIKE '%"& nama &"%'"
    elseif agen <> "" then
        strquery = "SELECT DLK_M_Vendor.*, GLB_M_Agen.Agenname FROM DLK_M_Vendor LEFT OUTER JOIN GLB_M_Agen ON LEFT(DLK_M_Vendor.ven_ID,3) = GLB_M_Agen.AgenID WHERE Ven_AktifYN = 'Y' AND left(Ven_id,3) = '"& agen &"'"
    elseif nama <> "" then
        strquery = "SELECT DLK_M_Vendor.*, GLB_M_Agen.Agenname FROM DLK_M_Vendor LEFT OUTER JOIN GLB_M_Agen ON LEFT(DLK_M_Vendor.ven_ID,3) = GLB_M_Agen.AgenID WHERE Ven_AktifYN = 'Y' AND ven_Nama LIKE '%"& nama &"%'"
    else
        strquery = "SELECT DLK_M_Vendor.*, GLB_M_Agen.Agenname FROM DLK_M_Vendor LEFT OUTER JOIN GLB_M_Agen ON LEFT(DLK_M_Vendor.ven_ID,3) = GLB_M_Agen.AgenID WHERE Ven_AktifYN = 'Y'"
    end if

    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " order by Ven_Nama ASC"
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

    call header("Vendor")
%>    
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3 text-center">
        <div class="col-lg-12">
            <h3>MASTER VENDOR</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2 mb-3">
            <a href="ven_add.asp" class="btn btn-primary">Tambah</a>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-4 mb-3">
            <form action="index.asp" method="post">
                <select class="form-select" aria-label="Default select example" name="agen" id="agen">
                    <option value="">Pilih</option>
                    <% do while not agendata.eof %>
                    <option value="<%= agendata("agenID") %>"><%= agendata("agenNAme") %></option>
                    <% 
                    agendata.movenext
                    loop
                    %>
                </select>
        </div>
        <div class="col-lg-4 mb-3">
                <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" placeholder="cari nama vendor">
        </div>
        <div class="col-lg mb-3">
            <button type="submit" class="btn btn-primary">Cari</button>
            </form>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                    <th scope="col">No</th>
                    <th scope="col">Cabang</th>
                    <th scope="col">Nama</th>
                    <th scope="col">Alamat</th>
                    <th scope="col">Contact</th>
                    <th scope="col">Email</th>
                    <th scope="col">TypeTransaksi</th>
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

                    ' cek data detail yang kosong untuk delete header
                    agen_cmd.commandText = "SELECT dven_venid FROM DLK_T_VendorD WHERE LEFT(dven_venid,9) = '"& rs("ven_ID") &"'"
                    set ddata = agen_cmd.execute

                    ' cek type transaksi
                    if rs("Ven_TypeTransaksi") = "1" then
                        strtype = "CBD"
                    elseIF rs("Ven_TypeTransaksi") = "2" then
                        strtype = "COD"
                    elseIF rs("Ven_TypeTransaksi") = "3" then
                        strtype = "TOP"
                    else
                        strtype = ""
                    end if
                    %>
                    <tr>
                        <th scope="row"><%= recordcounter %></th>
                        <td><%= rs("AgenName") %></td>
                        <td><%= rs("ven_Nama") %></td>
                        <td><%= rs("ven_Alamat") %></td>
                        <td><%= rs("ven_phone") %></td>
                        <td><%= rs("ven_Email") %></td>
                        <td><%= strtype %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="detailvendor.asp?id=<%= rs("Ven_Id") %>" class="btn badge text-bg-warning">Detail</a>
                                <a href="vn_u.asp?id=<%= rs("Ven_Id") %>" class="btn badge text-bg-primary">update</a>
                                <% if ddata.eof then %>
                                <a href="aktif.asp?id=<%= rs("Ven_Id") %>" class="btn badge text-bg-danger btn-aktifvendor">delete</a>
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
                        <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&nama=<%=nama%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&nama=<%=nama%>">Next &#x25BA;</a>
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