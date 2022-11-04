<!--#include file="../../init.asp"-->
<% 
    cabang = trim(Request.Form("cabang"))
    brg = trim(Request.Form("brg"))
    tgla = trim(Request.Form("tgla"))
    tgle = trim(Request.Form("tgle"))
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' filter agen
    data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenID, dbo.GLB_M_Agen.AgenName FROM dbo.GLB_M_Agen RIGHT OUTER JOIN dbo.DLK_T_DelBarang ON dbo.GLB_M_Agen.AgenID = dbo.DLK_T_DelBarang.DB_AgenID GROUP BY dbo.DLK_T_DelBarang.DB_AktifYN, dbo.GLB_M_Agen.AgenID, dbo.GLB_M_Agen.AgenName HAVING (dbo.DLK_T_DelBarang.DB_AktifYN = 'Y') ORDER BY dbo.GLB_M_Agen.AgenName"

    set agendata = data_cmd.execute

    ' filter barang
    data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_DelBarang LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_DelBarang.DB_Item = dbo.DLK_M_Barang.Brg_Id WHERE        (dbo.DLK_T_DelBarang.DB_AktifYN = 'Y') GROUP BY dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama ORDER BY dbo.DLK_M_Barang.Brg_Nama"

    set barangdata = data_cmd.execute

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

    if cabang <> "" then 
        filterCabang = " AND DLK_T_Delbarang.DB_AgenID = '"& cabang &"'"
    else 
        filterCabang = ""
    end if

    if brg <> "" then 
        filterbrg = " AND DLK_T_DelBarang.DB_Item = '"& brg &"'"
    else 
        filterbrg = ""
    end if

    if tgla <> "" AND tgle <> "" then
        filtertgl = "AND DLK_T_DelBarang.DB_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
        filtertgl = "AND DLK_T_DelBarang.DB_Date = '"& tgla &"'"
    else 
        filtertgl = ""
    end if

    ' query seach 
    strquery = "SELECT dbo.DLK_T_DelBarang.*, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, dbo.GLB_M_Agen.AgenID FROM dbo.DLK_T_DelBarang LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_DelBarang.DB_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_DelBarang.DB_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_DelBarang.DB_Item = dbo.DLK_M_Barang.Brg_Id WHERE (dbo.DLK_T_DelBarang.DB_AktifYN = 'Y') "& filterCabang &" "& filterbrg &" "& filtertgl &""

    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY DB_Date ASC"
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

    

    call header("Klaim Barang Rusak") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>DATA BARANG RUSAK</h3>
        </div>
    </div>
    <div class="row mt-3 mb-3">
        <div class="col-lg-2">
            <a href="klaim_add.asp" class="btn btn-primary">Tambah</a>
        </div>
    </div>
    <form action="index.asp" method="post">
        <div class="row">
            <div class="col-lg-3 mb-3">
                <label for="cabang">Cabang</label>
                <select class="form-select" aria-label="Default select example" name="cabang" id="cabang">
                    <option value="">Pilih</option>
                    <% do while not agendata.eof %>
                    <option value="<%= agendata("agenID") %>"><%= agendata("agenNAme") %></option>
                    <% 
                    agendata.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-3 mb-3">
                <label for="brg">Barang</label>
                <select class="form-select" aria-label="Default select example" name="brg" id="brg">
                    <option value="">Pilih</option>
                    <% do while not barangdata.eof %>
                    <option value="<%= barangdata("brg_id") %>"><%= barangdata("brg_nama") %></option>
                    <% 
                    barangdata.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgl">Tanggal Pertama</label>
                <input type="date" class="form-control" name="tgla" id="tgla" autocomplete="off" >
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgl">Tanggal Kedua</label>
                <input type="date" class="form-control" name="tgle" id="tgle" autocomplete="off" >
            </div>
            <div class="col-lg-2 mt-4 mb-3">
                <button type="submit" class="btn btn-primary">Cari</button>
            </div>
        </div>
    </form>
    <div class="row">
        <div class="col-lg-12">
            <table class="table" style="font-size:14px;display:block;overflow:auto;border-color:#fff;">
                <thead class="bg-secondary text-light">
                    <tr>
                    <th scope="col">ID</th>
                    <th scope="col">Tanggal</th>
                    <th scope="col">Cabang</th>
                    <th scope="col">Barang</th>
                    <th scope="col">Quantity</th>
                    <th scope="col">Satuan</th>
                    <th scope="col">Keterangan</th>
                    <th scope="col">Document</th>
                    <th scope="col">Image 1</th>
                    <th scope="col">Image 2</th>
                    <th scope="col">Image 3</th>
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
                        <th scope="row"><%= rs("DB_ID") %> </th>
                        <td><%= Cdate(rs("DB_Date")) %></td>
                        <td><%= rs("AgenNAme") %></td>
                        <td><%= rs("Brg_Nama") %></td>
                        <td><%= rs("DB_QtySatuan") %></td>
                        <td><%= rs("Sat_Nama") %></td>
                        <td><%= rs("DB_Keterangan") %></td>
                        <td class="text-center p-3">
                            <% 
                            set fs = server.createObject("Scripting.FileSystemObject")
                            path =  "D:Delima\document\pdf\"& rs("DB_ID") &".pdf"
                            if fs.FileExists(path) then
                            %>
                                <a href="openPdf.asp?id=<%= rs("DB_ID") %>" class="btn badge text-bg-light" target="_blank"><i class="bi bi-caret-right"></i></a>
                            <% 
                            else
                            %>
                                <a href="uploadtest.asp?id=<%= rs("DB_ID") %>&p=pdf&T=pdf" class="btn badge text-bg-light"><i class="bi bi-upload"></i></a>
                            <%end if
                            set fs = Nothing
                            %>
                        </td>
                        <td class="p-3 text-center">
                            <% if rs("DB_image1") <> "" then%>
                                <a href="uploadtest.asp?id=<%= rs("DB_ID") & 1 %>&p=jpg&T=image&db=DB_Image1">
                                <img src="<%= url %>document/image/<%= rs("DB_image1") &".jpg" %>" width="40px">
                                </a>
                            <% else %>  
                                <a href="uploadtest.asp?id=<%= rs("DB_ID") & 1 %>&p=jpg&T=image&db=DB_Image1" class="btn badge text-bg-light"><i class="bi bi-upload"></i></a>
                            <% end if %>
                        </td>
                        <td class="p-3 text-center">
                            <% if rs("DB_image2") <> "" then%>
                                <a href="uploadtest.asp?id=<%= rs("DB_ID") & 2 %>&p=jpg&T=image&db=DB_Image2">
                                <img src="<%= url %>document/image/<%= rs("DB_image2") &".jpg" %>" width="40px">
                                </a>
                            <% else %>  
                                <a href="uploadtest.asp?id=<%= rs("DB_ID") & 2 %>&p=jpg&T=image&db=DB_Image2" class="btn badge text-bg-light"><i class="bi bi-upload"></i></a>
                            <% end if %>
                        </td>
                        <td class="p-3 text-center">
                            <% if rs("DB_image3") <> "" then%>
                                <a href="uploadtest.asp?id=<%= rs("DB_ID") & 3 %>&p=jpg&T=image&db=DB_Image3">
                                <img src="<%= url %>document/image/<%= rs("DB_image3") &".jpg" %>" width="40px">
                                </a>
                            <% else %>  
                                <a href="uploadtest.asp?id=<%= rs("DB_ID") & 3 %>&p=jpg&T=image&db=DB_Image3" class="btn badge text-bg-light"><i class="bi bi-upload"></i></a>
                            <% end if %>
                        </td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <button class="btn badge bg-warning" onclick="printIt('print.asp?id=<%= rs("DB_ID") %>')">print</button>
                                <a href="klaim_u.asp?id=<%= rs("DB_ID") %>" class="btn badge text-bg-primary">update</a>
                                <a href="aktif.asp?id=<%= rs("DB_ID") %>" class="btn badge bg-danger" onclick="deleteItem(event,'delete barang')">delete</a>
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