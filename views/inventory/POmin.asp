<!--#include file="../../init.asp"-->
<% 
    ' query cabang  
    set agen_cmd =  Server.CreateObject ("ADODB.Command")
    agen_cmd.ActiveConnection = mm_delima_string
    ' filter agen
    agen_cmd.commandText = "SELECT SUM(dbo.DLK_T_Memo_D.memoQtty) AS minta, dbo.DLK_T_Memo_H.memoID, dbo.DLK_T_Memo_H.memoApproveYN, dbo.DLK_T_Memo_H.memoAktifYN, GLB_M_Agen.AgenName, GLB_M_Agen.Agenid FROM dbo.DLK_T_Memo_D RIGHT OUTER JOIN dbo.DLK_T_Memo_H ON LEFT(dbo.DLK_T_Memo_D.memoID, 17) = dbo.DLK_T_Memo_H.memoID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.Agenid GROUP BY dbo.DLK_T_Memo_H.memoID, dbo.DLK_T_Memo_H.memoApproveYN, dbo.DLK_T_Memo_H.memoAktifYN, GLB_M_Agen.AgenName, GLB_M_Agen.Agenid HAVING (dbo.DLK_T_Memo_H.memoAktifYN = 'Y') AND (dbo.DLK_T_Memo_H.memoApproveYN = 'Y') AND (SUM(dbo.DLK_T_Memo_D.memoQtty) > (SELECT SUM(dbo.DLK_T_OrPemD.OPD_QtySatuan) AS po FROM dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13) WHERE OPH_AktifYN = 'Y' AND OPH_MemoID = DLK_T_Memo_H.memoID GROUP BY dbo.DLK_T_OrPemH.OPH_MemoID)) "
    set agendata = agen_cmd.execute

    ' filter departemen
    agen_cmd.commandText = "SELECT SUM(dbo.DLK_T_Memo_D.memoQtty) AS minta, dbo.DLK_T_Memo_H.memoID, dbo.DLK_T_Memo_H.memoApproveYN, dbo.DLK_T_Memo_H.memoAktifYN, DLK_M_Departement.DepID, DLK_M_Departement.DepNama FROM dbo.DLK_T_Memo_D RIGHT OUTER JOIN dbo.DLK_T_Memo_H ON LEFT(dbo.DLK_T_Memo_D.memoID, 17) = dbo.DLK_T_Memo_H.memoID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.Agenid LEFT OUTER JOIN DLK_M_Divisi ON DLK_T_Memo_H.memoDivid = DLK_M_Divisi.DivID LEFT OUTER JOIN DLK_M_Departement ON DLK_T_Memo_H.memoDepid = DLK_M_Departement.DepID GROUP BY dbo.DLK_T_Memo_H.memoID, dbo.DLK_T_Memo_H.memoApproveYN, dbo.DLK_T_Memo_H.memoAktifYN, DLK_M_Departement.DepID, DLK_M_Departement.DepNama HAVING (dbo.DLK_T_Memo_H.memoAktifYN = 'Y') AND (dbo.DLK_T_Memo_H.memoApproveYN = 'Y') AND (SUM(dbo.DLK_T_Memo_D.memoQtty) > (SELECT SUM(dbo.DLK_T_OrPemD.OPD_QtySatuan) AS po FROM dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13) WHERE OPH_AktifYN = 'Y' AND OPH_MemoID = DLK_T_Memo_H.memoID GROUP BY dbo.DLK_T_OrPemH.OPH_MemoID))"
    set DepData = agen_cmd.execute

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
    dep = request.QueryString("dep")
    if len(dep) = 0 then 
        dep = trim(Request.Form("dep"))
    end if
    tgla = request.QueryString("tgla")
    if len(tgla) = 0 then 
        tgla = trim(Request.Form("tgla"))
    end if
    tgle = request.QueryString("tgle")
    if len(tgle) = 0 then 
        tgle = trim(Request.Form("tgle"))
    end if
    
    if agen <> "" then
        filterAgen = "AND memoAgenID = '"& agen &"'"
    else
        filterAgen = ""
    end if

    if dep <> "" then
        filterdep = "AND memoDepID = '"& dep &"'"
    else
        filterdep = ""
    end if

    if tgla <> "" AND tgle <> "" then
        filtertgl = "AND memotgl BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
        filtertgl = "AND memotgl = '"& tgla &"'"
    else 
        filtertgl = ""
    end if
    ' query seach 
    strquery = "SELECT SUM(dbo.DLK_T_Memo_D.memoQtty) AS minta, dbo.DLK_T_Memo_H.memoID, dbo.DLK_T_Memo_H.memoTgl, dbo.DLK_T_Memo_H.memoAgenID, dbo.DLK_T_Memo_H.memoDepID, dbo.DLK_T_Memo_H.memoDivID, dbo.DLK_T_Memo_H.memoKeterangan, dbo.DLK_T_Memo_H.memoKebutuhan, dbo.DLK_T_Memo_H.memoApproveYN, dbo.DLK_T_Memo_H.memoAktifYN, dbo.DLK_T_Memo_H.memoUpdateID, GLB_M_Agen.AgenName, DLK_M_Divisi.DivNama, DLK_M_Departement.DepNama FROM dbo.DLK_T_Memo_D RIGHT OUTER JOIN dbo.DLK_T_Memo_H ON LEFT(dbo.DLK_T_Memo_D.memoID, 17) = dbo.DLK_T_Memo_H.memoID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.Agenid LEFT OUTER JOIN DLK_M_Divisi ON DLK_T_Memo_H.memoDivid = DLK_M_Divisi.DivID LEFT OUTER JOIN DLK_M_Departement ON DLK_T_Memo_H.memoDepid = DLK_M_Departement.DepID GROUP BY dbo.DLK_T_Memo_H.memoID, dbo.DLK_T_Memo_H.memoTgl, dbo.DLK_T_Memo_H.memoAgenID, dbo.DLK_T_Memo_H.memoDepID, dbo.DLK_T_Memo_H.memoDivID, dbo.DLK_T_Memo_H.memoKeterangan, dbo.DLK_T_Memo_H.memoKebutuhan, dbo.DLK_T_Memo_H.memoApproveYN, dbo.DLK_T_Memo_H.memoAktifYN, dbo.DLK_T_Memo_H.memoUpdateID, GLB_M_Agen.AgenName, DLK_M_Divisi.DivNama, DLK_M_Departement.DepNama HAVING (dbo.DLK_T_Memo_H.memoAktifYN = 'Y') AND (dbo.DLK_T_Memo_H.memoApproveYN = 'Y') "& filterAgen &" "& filterdep &" "& filtertgl &" AND (SUM(dbo.DLK_T_Memo_D.memoQtty) > (SELECT SUM(dbo.DLK_T_OrPemD.OPD_QtySatuan) AS po FROM dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13) WHERE OPH_AktifYN = 'Y' AND OPH_MemoID = DLK_T_Memo_H.memoID GROUP BY dbo.DLK_T_OrPemH.OPH_MemoID)) "

    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY DLK_T_Memo_H.memoTgl ASC"
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

    call header("Daftar Permintaan Kurang")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
<div class="row mt-3 mb-3 text-center">
        <div class="col-lg-12">
            <h3>DAFTAR PERMINTAAN KURANG</h3>
        </div>
    </div>
    <form action="POMin.asp" method="post">
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
            <div class="col-lg-3 mb-3">
                <label for="dep">Departement</label>
                <select class="form-select" aria-label="Default select example" name="dep" id="dep">
                    <option value="">Pilih</option>
                    <% do while not DepData.eof %>
                    <option value="<%= DepData("DepID") %>"><%= DepData("DepNama") %></option>
                    <% 
                    DepData.movenext
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
                    <th scope="col">No</th>
                    <th scope="col">No memo</th>
                    <th scope="col">Tanggal</th>
                    <th scope="col">Cabang</th>
                    <th scope="col">Divisi</th>
                    <th scope="col">Departement</th>
                    <th scope="col">Aktif</th>
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
                        <th scope="row"><%= recordcounter %></th>
                        <th>
                            <%= rs("memoID") %>
                        </th>
                        <td><%= Cdate(rs("memoTgl")) %></td>
                        <td><%= rs("AgenName") %></td>
                        <td><%= rs("DivNama") %></td>
                        <td><%= rs("DepNama")%></td>
                        <td>
                            <%if rs("memoAktifYN") = "Y" then %>Aktif <% else %>Off <% end if %>
                        </td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="detailPOMin.asp?id=<%= rs("memoID") %>" class="btn badge text-bg-warning">Detail</a>
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
                        <a class="page-link prev" href="POMin.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&dep=<%=dep%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="POMin.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&dep=<%=dep%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="POMin.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&dep=<%=dep%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="POMin.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&dep=<%=dep%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
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