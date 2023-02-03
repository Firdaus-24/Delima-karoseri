<!--#include file="../../init.asp"-->
<% 
    if session("PR6") = false then
        Response.Redirect("index.asp")
    end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' filter agen
    data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_InvPemH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvPemH.IPH_AgenID = GLB_M_Agen.AgenID WHERE GLB_M_Agen.AgenAktifYN = 'Y' and DLK_T_InvPemH.IPH_AktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
    set agendata = data_cmd.execute
    
    data_cmd.commandText = "SELECT dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_ID FROM dbo.DLK_T_InvPemH LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_InvPemH.IPH_venID = dbo.DLK_M_Vendor.Ven_ID LEFT OUTER JOIN DLK_T_InvpemD ON DLK_T_InvPemH.IPH_ID = LEFT(DLK_T_InvPemD.IPD_IPHID,13) WHERE DLK_T_InvPemH.IPH_AktifYN = 'Y' GROUP BY dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_ID, dbo.DLK_T_InvPemH.IPH_OphId HAVING (SUM(isnull(dbo.DLK_T_InvPemD.IPD_QtySatuan,0)) < (SELECT SUM(ISNULL(dbo.DLK_T_OrPemD.OPD_QtySatuan,0)) AS pesen FROM dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13) WHERE OPH_ID = dbo.DLK_T_InvPemH.IPH_OphId AND OPH_AktifYN = 'Y' GROUP BY dbo.DLK_T_OrPemH.OPH_ID)) ORDER BY Ven_Nama ASC"
    set vendata = data_cmd.execute

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
    vendor = request.QueryString("vendor")
    if len(vendor) = 0 then 
        vendor = trim(Request.Form("vendor"))
    end if
    
    if agen <> "" then
        filterAgen = "AND DLK_T_InvPemH.IPH_AgenID = '"& agen &"'"
    else
        filterAgen = ""
    end if

    if vendor <> "" then
        filtervendor = "AND dbo.DLK_T_InvPemH.IPH_VenID = '"& vendor &"'"
    else
        filtervendor = ""
    end if

    ' query seach 
    strquery = "SELECT dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_AgenId, dbo.DLK_T_InvPemH.IPH_OphId, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_VenId, dbo.DLK_T_InvPemH.IPH_JTDate, dbo.DLK_T_InvPemH.IPH_Keterangan, dbo.DLK_T_InvPemH.IPH_DiskonAll, dbo.DLK_T_InvPemH.IPH_Ppn, GLB_M_Agen.AgenNAme, DLK_M_Vendor.Ven_Nama, SUM(dbo.DLK_T_InvPemD.IPD_QtySatuan) AS beli FROM dbo.DLK_T_InvPemD RIGHT OUTER JOIN dbo.DLK_T_InvPemH ON LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) = dbo.DLK_T_InvPemH.IPH_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvPemH.IPH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Vendor ON DLK_T_InvPemH.IPH_VenID = DLK_M_vendor.Ven_ID WHERE dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y' GROUP BY dbo.DLK_T_InvPemH.IPH_ID, dbo.DLK_T_InvPemH.IPH_AgenId, dbo.DLK_T_InvPemH.IPH_OphId, dbo.DLK_T_InvPemH.IPH_Date, dbo.DLK_T_InvPemH.IPH_VenId, dbo.DLK_T_InvPemH.IPH_JTDate, dbo.DLK_T_InvPemH.IPH_Keterangan, dbo.DLK_T_InvPemH.IPH_DiskonAll, dbo.DLK_T_InvPemH.IPH_Ppn,GLB_M_Agen.AgenNAme, DLK_M_Vendor.Ven_Nama HAVING (SUM(isnull(dbo.DLK_T_InvPemD.IPD_QtySatuan,0)) < (SELECT SUM(ISNULL(dbo.DLK_T_OrPemD.OPD_QtySatuan,0)) AS pesen FROM dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13) WHERE OPH_ID = dbo.DLK_T_InvPemH.IPH_OphId AND OPH_AktifYN = 'Y' "& filterAgen &"  "& filtervendor &" GROUP BY dbo.DLK_T_OrPemH.OPH_ID))"

    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY dbo.DLK_T_InvPemH.IPH_ID ASC"
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

    call header("Daftar Barang Kurang") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 mb-3 text-center">
            <h3>DAFTAR BARANG BELUM DATANG</h3>
        </div>
    </div>
    <form action="invPOmin.asp" method="post">
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
                <label for="vendor">Vendor</label>
                <select class="form-select" aria-label="Default select example" name="vendor" id="vendor">
                    <option value="">Pilih</option>
                    <% do while not vendata.eof %>
                    <option value="<%= vendata("ven_id") %>"><%= vendata("ven_nama") %></option>
                    <% 
                    vendata.movenext
                    loop
                    %>
                </select>
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
                    <th>FakturID</th>
                    <th>Cabang</th>
                    <th>Vendor</th>
                    <th>Tanggal</th>
                    <th>Tanggal JT</th>
                    <th>Diskon All</th>
                    <th>PPN</th>
                    <th>Kurang Barang</th>
                    <th class="text-center">Aksi</th>
                </thead>
                <tbody>
                    <% 
                    'prints records in the table
                    showrecords = recordsonpage
                    recordcounter = requestrecords
                    do until showrecords = 0 OR  rs.EOF
                    recordcounter = recordcounter + 1

                    ' cek data PO 
                    data_cmd.commandText = "SELECT SUM(dbo.DLK_T_OrPemD.OPD_QtySatuan) AS pesen, dbo.DLK_T_OrPemH.OPH_ID FROM dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13) WHERE OPH_ID = '"& rs("IPH_OPHID") &"' AND OPH_AktifYN = 'Y' GROUP BY dbo.DLK_T_OrPemH.OPH_ID"

                    set datapo = data_cmd.execute

                    if not datapo.eof then
                        dpo = datapo("pesen")
                    else 
                        dpo = 0
                    end if

                    tbarang = dpo - rs("beli")
                    %>
                        <tr><TH><%= recordcounter %></TH>
                        <th><%= rs("IPH_ID") %></th>
                        <td><%= rs("AgenName") %></td>
                        <td><%= Cdate(rs("IPH_Date")) %></td>
                        <td>
                            <% if Cdate(rs("IPH_JTDate")) <> Cdate("01/01/1900") then %>
                            <%= Cdate(rs("IPH_JTDate")) %>
                            <% end if %>
                        </td>
                        <td><%= rs("Ven_Nama") %></td>
                        <td><%= rs("IPH_DiskonAll") %></td>
                        <td><%= rs("IPH_PPN") %></td>
                        <td><%= tbarang %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="detailInvPOmin.asp?id=<%= rs("IPH_ID") %>" class="btn badge text-bg-warning" >Detail</a>
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
                        <a class="page-link prev" href="invPOmin.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&vendor=<%=vendor%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="invPOmin.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&vendor=<%=vendor%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="invPOmin.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&vendor=<%=vendor%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="invPOmin.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&vendor=<%=vendor%>">Next &#x25BA;</a>
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