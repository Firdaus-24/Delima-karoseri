<!--#include file="../../init.asp"-->
<% 
    if session("HR1") = false then
        Response.Redirect("../index.asp")
    end if

    cabang = trim(Request.Form("cabang"))
    user = trim(Request.Form("user"))
    divisi = trim(Request.Form("divisi"))
    dep = trim(Request.Form("dep"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID FROM dbo.DLK_T_AsetH RIGHT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_AsetH.AsetAgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_AsetH.AsetAktifYN = 'Y') GROUP BY dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID ORDER BY dbo.GLB_M_Agen.AgenName asc"

    set getcabang = data_cmd.execute

    ' get penanggung jawab
    data_cmd.commandTExt = "SELECT UserID, Username FROM DLK_T_AsetH LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_AsetH.ASetPjawab = DLK_M_WebLogin.USerID WHERE DLK_T_AsetH.AsetAktifYN = 'Y' GROUP BY UserID, Username ORDER BY USername"
    
    set getuser = data_cmd.execute

    ' get divisi
    data_cmd.commandTExt = "SELECT divID, divnama FROM DLK_T_AsetH LEFT OUTER JOIN HRD_M_divisi ON DLK_T_AsetH.ASetdivID = HRD_M_divisi.divID WHERE DLK_T_AsetH.AsetAktifYN = 'Y' GROUP BY divID, divnama ORDER BY divnama"
    
    set divaset = data_cmd.execute
    
    ' get departement
    data_cmd.commandTExt = "SELECT depID, depnama FROM DLK_T_AsetH LEFT OUTER JOIN HRD_M_Departement ON DLK_T_AsetH.ASetdepID = HRD_M_Departement.depID WHERE DLK_T_AsetH.AsetAktifYN = 'Y' GROUP BY depID, depnama ORDER BY depnama"
    
    set depaset = data_cmd.execute

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
        filterCabang = " AND DLK_T_AsetH.AsetAgenID = '"& cabang &"'"
    else 
        filterCabang = ""
    end if

    if user <> "" then 
        filteruser = " AND DLK_T_AsetH.AsetPjawab = '"& user &"'"
    else 
        filteruser = ""
    end if

    if divisi <> "" then 
        filterdivisi = " AND DLK_T_AsetH.AsetdivID = '"& divisi &"'"
    else 
        filterdivisi = ""
    end if

    if dep <> "" then 
        filterdep = " AND DLK_T_AsetH.AsetdepID = '"& dep &"'"
    else 
        filterdep = ""
    end if
    ' query seach 
    strquery = "SELECT dbo.HRD_M_Departement.DepNama, dbo.HRD_M_Divisi.DivNama, dbo.DLK_T_AsetH.AsetId, dbo.DLK_T_AsetH.AsetAgenID, dbo.DLK_T_AsetH.AsetPJawab, dbo.DLK_T_AsetH.AsetKeterangan, dbo.DLK_T_AsetH.AsetUpdateID, dbo.DLK_T_AsetH.AsetUpdateTime, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_WebLogin.UserName, dbo.HRD_M_Divisi.DivId, dbo.DLK_M_WebLogin.UserID FROM dbo.DLK_T_AsetH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_AsetH.AsetAgenID = dbo.GLB_M_Agen.AgenID RIGHT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_AsetH.AsetPJawab = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.HRD_M_Departement ON dbo.DLK_T_AsetH.AsetDepID = dbo.HRD_M_Departement.DepID LEFT OUTER JOIN dbo.HRD_M_Divisi ON dbo.DLK_T_AsetH.AsetDivID = dbo.HRD_M_Divisi.DivId WHERE (dbo.DLK_T_AsetH.AsetAktifYN = 'Y') "& filterCabang &" "& filteruser &" "& filterdivisi &""

    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY dbo.DLK_T_AsetH.AsetUpdateTime ASC"
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

    call header("Master Aset") 

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3">
        <div class="col-lg-12 text-center">
            <h3>MASTER ASET BARANG</h3>
        </div>
    </div>
    <% if session("HR1A") = true then %>
    <div class="row mt-3 mb-3">
        <div class="col-lg-2">
            <a href="aset_add.asp" class="btn btn-primary">Tambah</a>
        </div>
    </div>
    <% end if %>
    <form action="index.asp" method="post">
        <div class="row">
            <div class="col-lg-1">
                <label for="cabang" class="form-label">Cabang</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" name="cabang" id="cabang">
                    <option value="">Pilih</option>
                    <% do while not getcabang.eof %>
                        <option value="<%= getcabang("agenID") %>"><%= getcabang("AgenName") %></option>
                    <% 
                    getcabang.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-1">
                <label for="user" class="form-label">Pjawab</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" name="user" id="user">
                    <option value="">Pilih</option>
                    <% do while not getuser.eof %>
                        <option value="<%= getuser("userid") %>"><%= getuser("username") %></option>
                    <% 
                    getuser.movenext
                    loop
                    %>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-1">
                <label for="divisi" class="form-label">Divisi</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" name="divisi" id="divisi">
                    <option value="">Pilih</option>
                    <% do while not divaset.eof %>
                        <option value="<%= divaset("divID") %>"><%= divaset("divNama") %></option>
                    <% 
                    divaset.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-1">
                <label for="dep" class="form-label">Departement</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" name="dep" id="dep">
                    <option value="">Pilih</option>
                    <% do while not depaset.eof %>
                        <option value="<%= depaset("depID") %>"><%= depaset("depNama") %></option>
                    <% 
                    depaset.movenext
                    loop
                    %>
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
                    <th scope="col">Cabang</th>
                    <th scope="col">Divisi</th>
                    <th scope="col">Departement</th>
                    <th scope="col">PJawab</th>
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

                    ' cek data detail aset
                    data_cmd.commandTExt = "SELECT AD_ASetID FROM DLK_T_ASetD WHERE LEFT(AD_AsetiD,10) = '"& rs("AsetId") &"'"
                    set detailaset = data_cmd.execute
                    %>
                    <tr>
                        <th scope="row"><%= rs("AsetId") %> </th>
                        <td><%= rs("AgenNAme") %></td>
                        <td><%= rs("divNama") %></td>
                        <td><%= rs("DepNama") %></td>
                        <td><%= rs("username") %></td>
                        <td><%= rs("AsetKeterangan") %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <% if session("HR1D") = true then %>
                                    <% if not detailaset.eof then %>
                                    <button class="btn badge bg-warning" onclick="printIt('print.asp?id=<%= rs("AsetId") %>')">print</button>
                                    <% end if %>
                                <% end if %>
                                <% if session("HR1B") = true then %>
                                    <a href="aset_u.asp?id=<%= rs("AsetId") %>" class="btn badge text-bg-primary">update</a>
                                <% end if %>
                                <% if session("HR1C") = true then %>
                                    <% if detailaset.eof then %>
                                    <a href="aktif.asp?id=<%= rs("AsetId") %>" class="btn badge bg-danger" onclick="deleteItem(event,'delete master aset')">delete</a>
                                    <% end if %>
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