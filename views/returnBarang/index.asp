<!--#include file="../../init.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")   
    data_cmd.ActiveConnection = mm_delima_string    
    ' filter agen
    data_cmd.commandText = "SELECT AgenID, AgenName FROM DLK_T_ReturnBarangH LEFT OUTER JOIN  GLB_M_Agen ON DLK_T_ReturnBarangH.RB_agenID = GLB_M_Agen.AgenID WHERE RB_aktifYN = 'Y' GROUP BY AgenID, AgenName ORDER BY AgenName ASC"

    set agendata = data_cmd.execute
    ' filter vendor
    data_cmd.commandText = "SELECT Ven_ID, Ven_Nama FROM DLK_T_ReturnBarangH LEFT OUTER JOIN  DLK_M_Vendor ON DLK_T_ReturnBarangH.RB_Venid = DLK_M_Vendor.Ven_ID WHERE RB_aktifYN = 'Y' GROUP BY Ven_ID, Ven_Nama ORDER BY Ven_Nama ASC"

    set vendordata = data_cmd.execute
   
    agen = trim(Request.Form("agen"))
    vendor = trim(Request.Form("vendor"))
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

    ' query seach 
    if agen <> "" then
        filterAgen = "AND DLK_T_ReturnBarangH.RB_AgenID = '"& agen &"'"
    else
        filterAgen = ""
    end if

    if vendor <> "" then
        filtervendor = "AND dbo.DLK_T_ReturnBarangH.RB_VenID = '"& vendor &"'"
    else
        filtervendor = ""
    end if

    if tgla <> "" AND tgle <> "" then
        filtertgl = "AND dbo.DLK_T_ReturnBarangH.RB_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
        filtertgl = "AND dbo.DLK_T_ReturnBarangH.RB_Date = '"& tgla &"'"
    else 
        filtertgl = ""
    end if

    strquery = "SELECT DLK_T_ReturnBarangH.*, GLB_M_Agen.AgenNAme, DLK_M_Vendor.Ven_Nama FROM DLK_T_ReturnBarangH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ReturnBarangH.RB_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Vendor ON DLK_T_ReturnBarangH.RB_VenID = DLK_M_Vendor.Ven_ID WHERE RB_AktifYN = 'Y' "& filterAgen &" "& filtervendor &" "& filtertgl &""

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
        response.flush
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
        response.flush
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
    <form action="index.asp" method="post">
    <div class="row">
        <div class="col-lg-4 mb-3">
            <label>Agen / Cabang</label>
            <select class="form-select" aria-label="Default select example" name="agen" id="agen">
                <option value="">Pilih</option>
                <% do while not agendata.eof %>
                <option value="<%= agendata("agenID") %>"><%= agendata("agenNAme") %></option>
                <% 
                response.flush
                agendata.movenext
                loop
                %>
            </select>
         </div>
        <div class="col-lg-4 mb-3">
            <label>Vendor</label>
            <select class="form-select" aria-label="Default select example" name="vendor" id="vendor">
                <option value="">Pilih</option>
                <% do while not vendordata.eof %>
                <option value="<%= vendordata("Ven_ID") %>"><%= vendordata("Ven_Nama") %></option>
                <% 
                response.flush
                vendordata.movenext
                loop
                %>
            </select>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-4 mb-3">
            <label>Tanggal awal</label>
            <input type="date" class="form-control" name="tgla" id="tgla" autocomplete="off">
         </div>
        <div class="col-lg-4 mb-3">
            <label>Tanggal akhir</label>
            <input type="date" class="form-control" name="tgle" id="tgle" autocomplete="off">
         </div>
         <div class="col-lg mb-3 d-flex align-items-end">
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

                    ' cek data detail
                    data_cmd.commandText = "SELECT TOP 1 RBD_RBID FROM DLK_T_ReturnBarangD WHERE LEFT(RBD_RBID,12) = '"& rs("RB_ID") &"'"

                    set detail = data_cmd.execute
                    %>
                    <tr>
                        <th scope="row"><%= recordcounter %> </th>
                        <td><%= Cdate(rs("RB_Date")) %></td>
                        <td><%= rs("AgenNAme") %></td>
                        <td><%= rs("Ven_Nama") %></td>
                        <td><%= rs("RB_Keterangan") %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="rb_u.asp?id=<%= rs("RB_ID") %>" class="btn badge text-bg-primary">update</a>
                                <% if detail.eof then %>
                                <a href="aktif.asp?id=<%= rs("RB_ID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'RETURN BARANG HEADER')">delete</a>
                                <% else %>
                                <a href="detail.asp?id=<%= rs("RB_ID") %>" class="btn badge text-bg-warning">detail</a>
                                <% end if %>    
                            </div>
                        </td>
                    </tr>
                    <% 
                    response.flush
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
