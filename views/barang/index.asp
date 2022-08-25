<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_barang.asp"-->
<% 
    nama = Ucase(trim(Request.Form("nama")))
    kat = trim(Request.Form("kategori"))
    jen = trim(Request.Form("jenis"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = MM_Delima_string

    ' kategori
    data_cmd.CommandText = "SELECT DLK_M_Kategori.KategoriId, DLK_M_Kategori.KategoriNama FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID WHERE DLK_M_Barang.Brg_AktifYN = 'Y' GROUP BY DLK_M_Kategori.KategoriId, DLK_M_Kategori.KategoriNama ORDER BY DLK_M_Kategori.KategoriNama ASC"

    set fkategori = data_cmd.execute
    ' jenis
    data_cmd.CommandText = "SELECT DLK_M_jenisBarang.jenisId, DLK_M_jenisBarang.jenisNama FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_jenisBarang ON DLK_M_Barang.jenisID = DLK_M_jenisBarang.jenisID WHERE DLK_M_Barang.Brg_AktifYN = 'Y' GROUP BY DLK_M_jenisBarang.jenisId, DLK_M_jenisBarang.jenisNama ORDER BY DLK_M_jenisBarang.jenisNama ASC"

    set fjenis = data_cmd.execute

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
    if nama <> "" then
        filterNama = " AND UPPER(Brg_Nama) LIKE '%"& nama &"%' "
    end if
    if kat <> "" then
        filterKat = " AND KategoriId = '"& kat &"'"
    end if
    if jen <> "" then
        filterJen = " AND jenisID = '"& jen &"'"
    end if

    ' real query
    strquery = "SELECT * FROM DLK_M_Barang WHERE Brg_AktifYN = 'Y' "& filterNama &""& filterKat &""& filterJen &""
    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " order by Brg_Nama ASC"
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

    call header("Master Barang") 

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3">
        <div class="col-lg-12 text-center">
            <h3>MASTER BARANG</h3>
        </div>
    </div>
    <div class="row mt-3 mb-3">
        <div class="col-lg-2">
            <!-- Button trigger modal -->
            <a href="bg_Add.asp" class="btn btn-primary tbarang">
                Tambah
            </a>
        </div>
    </div>
    <div class="row">
        <div class="col-lg mb-3">
        <form action="index.asp" method="post">
            <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" placeholder="cari nama barang">
        </div>
        <div class="col-lg mb-3">
            <select class="form-select" aria-label="Default select example" name="kategori" id="kategori">
                <option value="">Pilih kategori</option>
                <% do while not fkategori.eof %>
                <option value="<%= fkategori("KategoriID") %>"><%= fkategori("KategoriNama") %></option>
                <% 
                fkategori.movenext
                loop
                %>
            </select>
        </div>
        <div class="col-lg mb-3">
            <select class="form-select" aria-label="Default select example" name="jenis" id="jenis">
                <option value="">Pilih Jenis</option>
                <% do while not fjenis.eof %>
                <option value="<%= fjenis("jenisID") %>"><%= fjenis("jenisNama") %></option>
                <% 
                fjenis.movenext
                loop
                %>
            </select>
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
                    <th scope="col">Nama</th>
                    <th scope="col">Tanggal</th>
                    <th scope="col">Kategori</th>
                    <th scope="col">Jenis</th>
                    <th scope="col" class="text-center">Stok</th>
                    <th scope="col" class="text-center">Jual</th>
                    <th scope="col" >Aktif</th>
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
                        <td><%= rs("Brg_Nama") %></td>
                        <td><%= rs("Brg_Tanggal") %></td>
                        <td><% call getKategori(rs("KategoriID")) %></td>
                        <td><% call getJenis(rs("JenisID")) %></td>
                        <td class="text-center">
                            <%if rs("Brg_StokYN") = "Y" then %><i class="bi bi-file-earmark-check"></i><% else %><i class="bi bi-file-earmark-excel"></i><% end if %>
                        </td>
                        <td class="text-center">
                            <%if rs("Brg_JualYN") = "Y" then %><i class="bi bi-file-earmark-check"></i><% else %><i class="bi bi-file-earmark-excel"></i><% end if %>
                        </td>
                        <td><%if rs("Brg_AktifYN") = "Y" then%>Aktif <% end if %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="br_u.asp?id=<%= rs("brg_id") %>" class="btn badge text-bg-primary">update</a> 
                                <a href="aktif.asp?id=<%= rs("brg_id") %>" class="btn badge text-bg-danger btn-aktifbrg">delete</a>
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