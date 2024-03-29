<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_metpem.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' filter agen
    data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_OrJulH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrJulH.OJH_AgenID = GLB_M_Agen.AgenID WHERE GLB_M_Agen.AgenAktifYN = 'Y' and DLK_T_OrJulH.OJH_AktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
    set agendata = data_cmd.execute
    ' filter divisi
    data_cmd.commandText = "SELECT dbo.DLK_M_Divisi.divNama, dbo.DLK_M_Divisi.divID FROM dbo.DLK_T_OrJulH LEFT OUTER JOIN dbo.DLK_M_Divisi ON dbo.DLK_T_OrJulH.OJH_divID = dbo.DLK_M_Divisi.divID WHERE DLK_T_OrJulH.OJH_AktifYN = 'Y' GROUP BY dbo.DLK_M_Divisi.divNama, dbo.DLK_M_Divisi.divID ORDER BY divNama ASC"
    set divisi = data_cmd.execute
    ' filter departement
    data_cmd.commandText = "SELECT dbo.DLK_M_Departement.depNama, dbo.DLK_M_Departement.depID FROM dbo.DLK_T_OrJulH LEFT OUTER JOIN dbo.DLK_M_Departement ON dbo.DLK_T_OrJulH.OJH_depID = dbo.DLK_M_Departement.depID WHERE DLK_T_OrJulH.OJH_AktifYN = 'Y' GROUP BY dbo.DLK_M_Departement.depNama, dbo.DLK_M_Departement.depID ORDER BY depNama ASC"
    set dep = data_cmd.execute

    agen = trim(Request.Form("agen"))
    divout = trim(Request.Form("divout"))
    departement = trim(Request.Form("departement"))
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
        filterAgen = "AND DLK_T_OrJulH.OJH_AgenID = '"& agen &"'"
    else
        filterAgen = ""
    end if

    if divout <> "" then
        filterdiv = "AND dbo.DLK_T_OrJulH.OJH_DivID = '"& divout &"'"
    else
        filterdiv = ""
    end if

    if departement <> "" then
        filterdep = "AND dbo.DLK_T_OrJulH.OJH_depID = '"& departement &"'"
    else
        filterdep = ""
    end if

    if tgla <> "" AND tgle <> "" then
        filtertgl = "AND dbo.DLK_T_OrJulH.OJH_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
        filtertgl = "AND dbo.DLK_T_OrJulH.OJH_Date = '"& tgla &"'"
    else 
        filtertgl = ""
    end if

    ' query seach 
    strquery = "SELECT DLK_T_OrJulH.*, DLK_M_Divisi.divNama, DLK_M_Departement.DepNama FROM DLK_T_OrJulH LEFT OUTER JOIN DLK_M_Divisi ON DLK_T_OrJulH.OJH_divID = DLK_M_Divisi.divId LEFT OUTER JOIN DLK_M_Departement ON DLK_T_OrJulH.OJH_DepID = DLK_M_Departement.DepID WHERE OJH_AktifYN = 'Y' "& filterAgen &"  "& filterdiv &" "& filterdep &" "& filtertgl &""
    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY OJH_Date DESC"
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

    call header("Permintaan Barang") 
%>

<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>DETAIL PERMINTAAN BARANG</h3>
        </div>  
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3">
            <a href="orjul_add.asp" class="btn btn-primary">Tambah</a>
        </div>
    </div>
    <form action="outgoing.asp" method="post">
        <div class="row">
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
            <div class="col-lg-4 mb-3">
                <label for="divout">divisi</label>
                <select class="form-select" aria-label="Default select example" name="divout" id="divout">
                    <option value="">Pilih</option>
                    <% do while not divisi.eof %>
                    <option value="<%= divisi("divID") %>"><%= divisi("divNama") %></option>
                    <% 
                    divisi.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-4 mb-3">
                <label for="departement">Departement</label>
                <select class="form-select" aria-label="Default select example" name="departement" id="departement">
                    <option value="">Pilih</option>
                    <% do while not dep.eof %>
                    <option value="<%= dep("depID") %>"><%= dep("depNama") %></option>
                    <% 
                    dep.movenext
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
                    <th>OrderID</th>
                    <th>Cabang</th>
                    <th>Tanggal</th>
                    <th>Divisi</th>
                    <th>Departement</th>
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

                    data_cmd.commandText = "SELECT OJD_OJHID FROM DLK_T_OrJulD WHERE LEFT(OJD_OJHID,13) = '"& rs("OJH_ID") &"'"

                    set ddata = data_cmd.execute
                    %>
                        <tr><TH><%= recordcounter %></TH>
                        <th><%= rs("OJH_ID") %></th>
                        <td><% call getAgen(rs("OJH_AgenID"),"P") %></td>
                        <td><%= Cdate(rs("OJH_Date")) %></td>
                        <td><%= rs("divNama") %></td>
                        <td><%= rs("depNama") %></td>
                        <td><%= rs("OJH_Keterangan") %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="detailorjul.asp?id=<%= rs("OJH_ID") %>" class="btn badge text-light bg-warning">Detail</a>
                                <a href="orjul_u.asp?id=<%= rs("OJH_ID") %>" class="btn badge text-bg-primary" >Update</a>
                                <% if ddata.eof then %>
                                <a href="aktiforjulh.asp?id=<%= rs("OJH_ID") %>" class="btn badge text-bg-danger btn-orjual">Delete</a>
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
                        <a class="page-link prev" href="outgoing.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="outgoing.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="outgoing.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="outgoing.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>">Next &#x25BA;</a>
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
