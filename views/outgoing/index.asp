<!--#include file="../../init.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' filter agen
    data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID FROM dbo.DLK_T_MaterialOutH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialOutH.MO_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_MaterialOutH.MO_AktifYN = 'Y') GROUP BY dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID ORDER BY AgenName ASC"

    set agendata = data_cmd.execute

    ' filter produksi
    data_cmd.commandText = "SELECT dbo.DLK_T_BOMH.BMH_ID FROM dbo.DLK_T_MaterialOutH LEFT OUTER JOIN dbo.DLK_T_BOMH ON dbo.DLK_T_MaterialOutH.MO_BMHID = dbo.DLK_T_BOMH.BMH_ID WHERE (dbo.DLK_T_MaterialOutH.MO_AktifYN = 'Y') GROUP BY dbo.DLK_T_MaterialOutH.MO_AktifYN, dbo.DLK_T_BOMH.BMH_ID ORDER BY BMH_ID ASC"
    ' response.write data_cmd.commandText & "<br>"
    set custdata = data_cmd.execute

    agen = trim(Request.Form("agen"))
    bom = trim(Request.Form("bom"))
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
        filterAgen = "AND dbo.DLK_T_MaterialOutH.MO_AgenID = '"& agen &"'"
    else
        filterAgen = ""
    end if

    if bom <> "" then
        filterbom = "AND dbo.DLK_T_MaterialOutH.MO_BMHID = '"& bom &"'"
    else
        filterbom = ""
    end if

    if tgla <> "" AND tgle <> "" then
        filtertgl = "AND dbo.DLK_T_MaterialOutH.MO_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
        filtertgl = "AND dbo.DLK_T_MaterialOutH.MO_Date = '"& tgla &"'"
    else 
        filtertgl = ""
    end if

    ' query seach 
    strquery = "SELECT dbo.DLK_T_MaterialOutH.MO_ID, dbo.DLK_T_MaterialOutH.MO_BMHID, dbo.DLK_T_MaterialOutH.MO_Date, dbo.DLK_T_MaterialOutH.MO_Keterangan, dbo.DLK_T_MaterialOutH.MO_UpdateID, dbo.DLK_T_MaterialOutH.MO_UpdateTime, dbo.DLK_T_MaterialOutH.MO_AktifYN, dbo.GLB_M_Agen.AgenName FROM dbo.DLK_T_MaterialOutH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialOutH.MO_AgenID = dbo.GLB_M_Agen.AgenID WHERE MO_AktifYN = 'Y' "& filterAgen &"  "& filterbom &" "& filtertgl &""
    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY MO_Date DESC"
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

    call header("Outgoing")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>TRANSAKSI OUTGOING INVENTORY</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3">
            <a href="out_add.asp" class="btn btn-primary ">Tambah</a>
        </div>
    </div>
    <form action="index.asp" method="post">
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
                <label for="bom">No B.O.M</label>
                <select class="form-select" aria-label="Default select example" name="bom" id="bom">
                    <option value="">Pilih</option>
                    <% do while not custdata.eof %>
                    <option value="<%= custdata("BMH_ID") %>"><%= custdata("BMH_ID") %></option>
                    <% 
                    custdata.movenext
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
                    <th>ID</th>
                    <th>Cabang</th>
                    <th>Tanggal</th>
                    <th>No.BOM</th>
                    <th>Update ID</th>
                    <th>Update Time</th>
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

                    data_cmd.commandTExt = "SELECT MO_ID FROM DLK_T_MaterialOutD WHERE LEFT(MO_ID,13) = '"& rs("MO_ID") &"'"
                    set p = data_cmd.execute
                    %>
                        <tr><TH><%= recordcounter %></TH>
                        <th><%= rs("MO_ID") %></th>
                        <td><%= rs("agenName") %></td>
                        <td><%= Cdate(rs("MO_Date")) %></td>
                        <td><%= rs("MO_BMHID") %></td>
                        <td><%= rs("MO_UpdateID") %></td>
                        <td><%= rs("MO_updatetime") %></td>
                        <td><%= rs("MO_Keterangan") %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <% if not p.eof then %>
                                <a href="detailOutGoing.asp?id=<%= rs("MO_ID") %>" class="btn badge text-light bg-warning">Detail</a>
                                <% end if %>
                                <a href="out_u.asp?id=<%= rs("MO_ID") %>" class="btn badge text-bg-primary" >Update</a>

                                <% if p.eof then %>
                                <a href="aktifh.asp?id=<%= rs("MO_ID") %>" class="btn badge text-bg-danger btn-fakturh">Delete</a>
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
<% call footer() %>

