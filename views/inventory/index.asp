<!--#include file="../../init.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' getcabang 
    data_cmd.commandText = "SELECT AgenID, AgenName FROM DLK_M_Barang LEFT OUTER JOIN GLB_M_Agen ON LEFT(DLK_M_Barang.Brg_ID,3) = GLB_M_agen.AgenID WHERE DLK_M_Barang.Brg_AktifYN = 'Y' GROUP BY AgenID, AgenName ORDER BY AgenName ASC"

    set agendata = data_cmd.execute

    ' get type barang
    data_cmd.commandText = "SELECT T_ID, T_Nama FROM  DLK_M_Barang LEFT OUTER JOIN DLK_M_TYpebarang ON DLK_M_Barang.Brg_Type = DLK_M_Typebarang.T_ID WHERE DLK_M_Barang.Brg_AktifYN = 'Y'  GROUP BY T_ID, T_Nama ORDER BY T_Nama ASC"

    set datatype = data_cmd.execute

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
    ltype = request.QueryString("ltype")
    if len(ltype) = 0 then 
        ltype = trim(Request.Form("type"))
    end if
    nama = request.QueryString("nama")
    if len(nama) = 0 then 
        nama = trim(Request.Form("nama"))
    end if

    if agen <> "" then
        filterAgen = " AND LEFT(Brg_ID,3) = '"& agen &"'"
    else
        filterAgen = " AND LEFT(Brg_ID,3) =" &session("server-id")
    end if
    
    if ltype <> "" then
        filterType = " AND DLK_M_Barang.Brg_Type = '"& ltype &"'"
    else
        filterType = ""
    end if
    
    if nama <> "" then
        filternama = " AND DLK_M_Barang.Brg_nama LIKE '%"& nama &"%'"
    else
        filternama = ""
    end if

    ' query seach 
    strquery = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_MinStok, dbo.DLK_M_Barang.Brg_Type, dbo.DLK_M_JenisBarang.JenisID, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_Barang.Brg_AktifYN, dbo.DLK_M_Barang.Brg_jualYN, dbo.DLK_M_Barang.Brg_StokYN, dbo.DLK_M_TypeBarang.T_ID, dbo.DLK_M_TypeBarang.T_Nama, ISNULL(ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y' AND DB_Acc1 = 'Y' AND DB_Acc2 = 'Y'),0),0) as stok, ISNULL(dbo.DLK_T_MaterialReceiptD2.MR_Harga, 0) as harga, ISNULL((SELECT TOP 1 dbo.DLK_M_SatuanBarang.Sat_Nama FROM dbo.DLK_T_MaterialReceiptD2 LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialReceiptD2.MR_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID WHERE DLK_T_MaterialReceiptD2.MR_Item = DLK_M_Barang.Brg_ID GROUP BY Sat_nama),'') as satuan FROM DLK_M_Barang LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID  LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID LEFT OUTER JOIN dbo.DLK_T_MaterialReceiptD2 ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_MaterialReceiptD2.MR_Item WHERE Brg_AktifYN = 'Y' "& filterAgen &" "& filterType &" "& filternama &" GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_MinStok, dbo.DLK_M_Barang.Brg_Type, dbo.DLK_M_JenisBarang.JenisID, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_Barang.Brg_AktifYN, dbo.DLK_M_Barang.Brg_jualYN, dbo.DLK_M_Barang.Brg_StokYN, dbo.DLK_M_TypeBarang.T_ID, dbo.DLK_M_TypeBarang.T_Nama, DLK_M_Barang.Brg_ID, dbo.DLK_T_MaterialReceiptD2.MR_Harga "

    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY Brg_Nama, T_Nama ASC"
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

    
    call header("Inventory") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 ">
        <div class="col-lg-12 mb-3 text-center">
            <h3>MONITORING STOK INVENTORY</h3>
        </div>
    </div>
    <form action="index.asp" method="post">
        <div class="row">
            <div class="col-sm-3 mb-3">
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
            <div class="col-sm-3 mb-3">
                <label for="type">Type</label>
                <select class="form-select" aria-label="Default select example" name="type" id="type">
                <option value="">Pilih</option>
                <% do while not datatype.eof %>
                <option value="<%= datatype("T_ID") %>"><%= datatype("T_Nama") %></option>
                <% 
                datatype.movenext
                loop
                %>
                </select>
            </div>
            <div class="col-sm-4 mb-3">
                <label for="Nama">Nama</label>
                <input type="text" class="form-control" id="nama" name="nama" autocomplete="off">
            </div>
            <div class="col-lg-2 mt-4 mb-3">
                <button type="submit" class="btn btn-primary">Cari</button>
            </div>
        </div>
    </form>
    <div class="row ">
        <div class="col-lg-12 mb-3">
            <table class="table table-hover">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">Kode</th>
                        <th scope="col">Item</th>
                        <th scope="col">Type</th>
                        <th scope="col">Min Stok</th>
                        <th scope="col">Stok</th>
                        <th scope="col">Satuan</th>
                        <th scope="col">Harga</th>
                        <th scope="col">Total Harga</th>
                        <th scope="col">Keterangan</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    'prints records in the table
                    showrecords = recordsonpage
                    recordcounter = requestrecords
                    do until showrecords = 0 OR  rs.EOF
                    recordcounter = recordcounter + 1
                    
                    ' cek keterangan
                    if rs("stok") = 0  then
                        ket = "stok habis"
                        bgclass = "bg-danger text-light"
                    elseif rs("stok") < 0  then
                        ket = "Data barang tidak singkron"
                        bgclass = "bg-danger text-light"
                    elseif rs("stok") < rs("Brg_Minstok") then
                        ket = "Barang Kurang dari min-stok"
                        bgclass = "bg-warning"
                    elseIf rs("Brg_Minstok") + 2 > rs("stok") then
                        ket = "Barang mendekatin min-stok"
                        bgclass = "bg-success text-light"
                    else
                        ket = "-"
                        bgclass = ""
                    end if

                    tharga = rs("harga") * rs("stok")
                    %>
                    <tr>
                        <td><%= rs("kategoriNama") &"-"& rs("jenisNama") %></td>
                        <td><%= rs("Brg_Nama") %></td>
                        <td><%= rs("T_Nama") %></td>
                        <td><%= rs("Brg_Minstok") %></td>
                        <td><%= rs("stok") %></td>
                        <td><%= rs("satuan") %></td>
                        <td><%= replace(formatCurrency(rs("harga")),"$","") %></td>
                        <td><%= replace(formatCurrency(tharga),"$","") %></td>
                        <td class="<%= bgclass %>">
                            <%= ket %>
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
                    <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&ltype=<%=ltype%>&nama=<%=nama%>">&#x25C4; Prev </a>
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
                        <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&ltype=<%=ltype%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
                    <%else%>
                        <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&ltype=<%=ltype%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
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
                        <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&ltype=<%=ltype%>&nama=<%=nama%>">Next &#x25BA;</a>
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