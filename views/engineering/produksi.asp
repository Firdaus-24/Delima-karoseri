<!--#include file="../../init.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' filter agen
    data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_M_ProductH LEFT OUTER JOIN GLB_M_Agen ON DLK_M_ProductH.PDAgenID = GLB_M_Agen.AgenID WHERE GLB_M_Agen.AgenAktifYN = 'Y' and DLK_M_ProductH.PDAktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
    set agendata = data_cmd.execute

    agen = trim(Request.Form("agen"))
    nama = Ucase(trim(Request.Form("nama")))
    tgla = trim(Request.Form("tgla"))
    tgle = trim(Request.Form("tgle"))

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
    
    if agen <> "" then
        filterAgen = "AND DLK_M_ProductH.PDAgenID = '"& agen &"'"
    else
        filterAgen = ""
    end if

    if nama <> "" then
        filternama = "AND dbo.DLK_M_Barang.Brg_nama LIKE '%"& nama &"%'"
    else
        filternama = ""
    end if

    if tgla <> "" AND tgle <> "" then
        filtertgl = "AND dbo.DLK_M_ProductH.PDDate BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
        filtertgl = "AND dbo.DLK_M_ProductH.PDDate = '"& tgla &"'"
    else 
        filtertgl = ""
    end if

    ' query seach 
    strquery = "SELECT DLK_M_ProductH.*, DLK_M_Barang.Brg_Nama, GLB_M_Agen.AgenName FROM DLK_M_ProductH LEFT OUTER JOIN DLK_M_Barang ON DLK_M_ProductH.PDBrgID = DLK_M_Barang.Brg_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_M_ProductH.PDAgenID = GLB_M_Agen.AgenID WHERE PDAktifYN = 'Y' "& filterAgen &" "& filternama &" "& filtertgl &""
    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY DLK_M_ProductH.PDDAte, DLK_M_Barang.Brg_Nama ASC"
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

    call header("Master Produksi") 
%>

<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>MASTER PRODUKSI </h3>
        </div>  
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3">
            <button type="button" class="btn btn-primary" onclick="window.location.href='product_add.asp'">
                Tambah
            </button>
        </div>
    </div>
    <form action="produksi.asp" method="post">
        <div class="row">
            <div class="col-lg-4 mb-3">
                <label for="nama">Nama</label>
                <input type="text" class="form-control" name="nama" id="nama" autocomplete="off">
            </div>
            <div class="col-lg-4 mb-3">
                <label for="Agen">Cabang</label>
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
        </div>
        <div class="row">
            <div class="col-lg-4 mb-3">
                <label for="tgla">Tanggal Pertama</label>
                <input type="date" class="form-control" name="tgla" id="tgla" autocomplete="off" >
            </div>
            <div class="col-lg-4 mb-3">
                <label for="tgle">Tanggal Kedua</label>
                <input type="date" class="form-control" name="tgle" id="tgle" autocomplete="off" >
            </div>
            <div class="col-lg-2 mt-4 mb-3">
                <button type="submit" class="btn btn-primary">Cari</button>
            </div>
        </div>
    </form>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover">
                <thead class="bg-secondary text-light">
                    <th>No</th>
                    <th>ID Product</th>
                    <th>Nama</th>
                    <th>Tanggal</th>
                    <th>Cabang</th>
                    <th class="text-center">Aksi</th>
                </thead>
                <tbody>
                    <% 
                    'prints records in the table
                    showrecords = recordsonpage
                    recordcounter = requestrecords
                    do until showrecords = 0 OR  rs.EOF
                    recordcounter = recordcounter + 1

                    data_cmd.commandText = "SELECT PDDPDID FROM DLK_M_ProductD WHERE LEFT(PDDPDID,12) = '"& rs("PDID") &"'"

                    set ddata = data_cmd.execute
                    %>
                        <tr><TH><%= recordcounter %></TH>
                        <th><%= rs("PDID") %></th>
                        <td><%= rs("Brg_Nama") %></td>
                        <td><%= Cdate(rs("PDDate")) %></td>
                        <td><%= rs("agenName") %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="product_u.asp?id=<%= rs("PDID") %>" class="btn badge text-bg-primary" >Update</a>
                                <% if not ddata.eof then %>
                                <a href="detailProduct.asp?id=<%= rs("PDID") %>" class="btn badge text-light bg-warning">Detail</a>
                                <% else %>
                                <a href="aktifproh.asp?id=<%= rs("PDID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'delete master produksi')">Delete</a>
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
                        <a class="page-link prev" href="produksi.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="produksi.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="produksi.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="produksi.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>">Next &#x25BA;</a>
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
