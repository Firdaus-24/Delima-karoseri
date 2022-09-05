<!--#include file="../../init.asp"-->
<% 
    agen = trim(Request.Form("agen"))
    keb = trim(Request.Form("keb"))
    tgla = trim(Request.Form("tgla"))
    tgle = trim(Request.Form("tgle"))

    ' query data  
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' query cabang  
    set agen_cmd =  Server.CreateObject ("ADODB.Command")
    agen_cmd.ActiveConnection = mm_delima_string
    ' filter agen
    agen_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_OrPemH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrPemH.OPH_AgenID = GLB_M_Agen.AgenID WHERE GLB_M_Agen.AgenAktifYN = 'Y' and DLK_T_OrPemH.OPH_AktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
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
    
    if agen <> "" then
        filterAgen = "AND OPH_AgenID = '"& agen &"'"
    else
        filterAgen = ""
    end if

    if tgla <> "" AND tgle <> "" then
        filtertgl = "AND OPH_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
        filtertgl = "AND OPH_Date = '"& tgla &"'"
    else 
        filtertgl = ""
    end if
    ' query seach 
    strquery = "SELECT DLK_T_OrPemH.*, GLB_M_Agen.agenName, DLK_M_Vendor.Ven_Nama FROM DLK_T_OrPemH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrPemH.OPH_AgenID = LEFT(GLB_M_Agen.AgenID,3) LEFT OUTER JOIN DLK_M_Vendor ON DLK_T_OrPemH.OPH_VenID = DLK_M_Vendor.Ven_ID WHERE OPH_AktifYN = 'Y'  "& filterAgen &" "& filterDep &" "& filtertgl &""

    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " order by OPH_Date DESC"
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


    call header("Finance") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 mb-3 text-center">
            <h3>FINANCE REQUEST</h3>
        </div>
    </div>
    <form action="index.asp" method="post">
        <div class="row">
            <div class="col-lg-3 mb-3">
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
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                    <th scope="col">No Purchase</th>
                    <th scope="col">Tanggal</th>
                    <th scope="col">Tanggal JT</th>
                    <th scope="col">Cabang</th>
                    <th scope="col">Vendor</th>
                    <th scope="col">Diskon</th>
                    <th scope="col">Ppn</th>
                    <th scope="col">Permintaan</th>
                    <th scope="col">Status</th>
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

                    data_cmd.commandText = "SELECT SUM(dbo.DLK_T_OrPemD.OPD_Harga * dbo.DLK_T_OrPemD.OPD_QtySatuan) As tharga FROM dbo.DLK_T_OrPemD LEFT OUTER JOIN dbo.DLK_T_OrPemH ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13) WHERE (dbo.DLK_T_OrPemH.OPH_ID = '"& rs("OPH_ID") &"') AND DLK_T_OrPemH.OPH_AktifYN = 'Y'"
                    set ddata = data_cmd.execute

                    ' cek approve finance
                    data_cmd.commandText = "SELECT DLK_T_AppPermintaan.appID, DLK_T_AppPermintaan.appDana, DLK_T_OrPemH.OPH_ID, SUM(dbo.DLK_T_OrPemD.OPD_Harga * dbo.DLK_T_OrPemD.OPD_QtySatuan) As tharga FROM dbo.DLK_T_OrPemD LEFT OUTER JOIN dbo.DLK_T_OrPemH ON left(dbo.DLK_T_OrPemD.OPD_OPHID,13) = DLK_T_OrPemH.OPH_ID LEFT OUTER JOIN DLK_T_appPermintaan ON LEFT(DLK_T_OrPemD.OPD_OPHID,13) = DLK_T_AppPermintaan.AppOPHID WHERE (dbo.DLK_T_AppPermintaan.AppOPHID = '"& rs("OPH_ID") &"') AND DLK_T_OrPemH.OPH_AktifYN = 'Y' AND DLK_T_AppPermintaan.AppAktifYN = 'Y' group by DLK_T_AppPermintaan.appID, DLK_T_AppPermintaan.appDana, DLK_T_OrPemH.OPH_ID"
                    ' response.write data_cmd.commandText & "<br>"
                    set app = data_cmd.execute
                    %>
                    <tr>
                        <th>
                            <%= rs("OPH_ID") %>
                        </th>
                        <td><%= Cdate(rs("OPH_Date")) %></td>
                        <td><%= Cdate(rs("OPH_JTDate")) %></td>
                        <td><%= rs("AgenName") %></td>
                        <td><%= rs("Ven_Nama") %></td>
                        <td><%= rs("OPH_DiskonAll") %></td>
                        <td><%= rs("OPH_PPN") %></td>
                        <td><%= replace(formatCurrency(ddata("tharga")),"$","") %></td>
                        
                        <td>
                            <% if not app.eof then %>
                                <% if app("appDana") >= app("tharga") then %>
                                <b style="color:green">Done </b>
                                <% else %> 
                                <b style="color:red"> Minus </b> 
                                <% end if %>
                            <% else %>
                                <b> Waiting </b>
                            <% end if %>
                        </td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <% if app.eof then %>
                                <a href="approvepbarang.asp?id=<%= rs("OPH_ID") %>" class="btn badge text-bg-primary btnAppPer">Approve</a>
                                <a href="dpbarang.asp?id=<%= rs("OPH_ID") %>" class="btn badge text-bg-danger">Detail</a>
                                <% else %>
                                <a href="dapp_u.asp?id=<%= app("AppID") %>" class="btn badge text-bg-light">Update</a>
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