<!--#include file="../../init.asp"-->
<% 
    if session("PR2") = false then
        Response.Redirect("index.asp")
    end if

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' filter agen
    data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_OrPemH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrPemH.OPH_AgenID = GLB_M_Agen.AgenID WHERE GLB_M_Agen.AgenAktifYN = 'Y' and DLK_T_OrPemH.OPH_AktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
    set agendata = data_cmd.execute
    ' filter agen
    data_cmd.commandText = "SELECT dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_ID FROM dbo.DLK_T_OrPemH LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_OrPemH.OPH_venID = dbo.DLK_M_Vendor.Ven_ID WHERE DLK_T_OrPemH.OPH_AktifYN = 'Y' GROUP BY dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_ID ORDER BY Ven_Nama ASC"
    set vendata = data_cmd.execute

    ' get agen by memo
    data_cmd.commandText = "SELECT GLB_M_Agen.AgenID, GLB_M_Agen.AgenName FROM dbo.DLK_T_memo_H LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID WHERE DLK_T_memo_H.memoAktifYN = 'Y' AND memoApproveYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
    set agenmemo = data_cmd.execute

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
    tgla = request.QueryString("tgla")
    if len(tgla) = 0 then 
        tgla = trim(Request.Form("tgla"))
    end if
    tgle = request.QueryString("tgle")
    if len(tgle) = 0 then 
        tgle = trim(Request.Form("tgle"))
    end if
    
    if agen <> "" then
        filterAgen = "AND DLK_T_OrPemH.OPH_AgenID = '"& agen &"'"
    else
        filterAgen = ""
    end if

    if vendor <> "" then
        filtervendor = "AND dbo.DLK_T_OrPemH.OPH_VenID = '"& vendor &"'"
    else
        filtervendor = ""
    end if

    if tgla <> "" AND tgle <> "" then
        filtertgl = "AND dbo.DLK_T_OrPemH.OPH_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
        filtertgl = "AND dbo.DLK_T_OrPemH.OPH_Date = '"& tgla &"'"
    else 
        filtertgl = ""
    end if

    ' query seach 
    strquery = "SELECT * FROM DLK_T_OrPemH WHERE OPH_AktifYN = 'Y' "& filterAgen &"  "& filtervendor &" "& filtertgl &""
    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY OPH_Date DESC"
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

    call header("Purchase Detail") 
%>

<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>DETAIL PURCHASE ORDER</h3>
        </div>  
    </div>
    <% if session("PR2A") = true then %>
    <div class="row">
        <div class="col-lg-12 mb-3">
            <!-- Button trigger modal -->
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalMemoToPO">
                Tambah
            </button>
        </div>
    </div>
    <% end if %>
    <form action="purcesDetail.asp" method="post">
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
                    <th>Vendor</th>
                    <th>Tanggal JT</th>
                    <th>Diskon</th>
                    <th>PPn</th>
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

                    data_cmd.commandText = "SELECT OPD_OPHID FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& rs("OPH_ID") &"'"

                    set ddata = data_cmd.execute
                    %>
                        <tr><TH><%= recordcounter %></TH>
                        <th><%= LEFT(rs("OPH_ID"),2) &"-"& mid(rs("OPH_ID"),3,3) &"/"& mid(rs("OPH_ID"),6,4) &"/"& right(rs("OPH_ID"),4) %></th>
                        <td><% call getAgen(rs("OPH_AgenID"),"P") %></td>
                        <td><%= Cdate(rs("OPH_Date")) %></td>
                        <td><% call getVendor(rs("OPH_VenID")) %></td>
                        <td>
                            <% if rs("OPH_JTDate") <> "1900-01-01" then %>
                            <%= Cdate(rs("OPH_JTDate")) %>
                            <% end if %>
                        </td>
                        <td><%= rs("OPH_DiskonAll") %></td>
                        <td><%= rs("OPH_PPn") %></td>
                        <td><%= rs("OPH_Keterangan") %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <% if not ddata.eof then %>
                                <a href="purce_d.asp?id=<%= rs("OPH_ID") %>" class="btn badge text-light bg-warning">Detail</a>
                                <% end if %>
                                <% if session("PR2B") = true then %>
                                    <a href="purc_u.asp?id=<%= rs("OPH_ID") %>" class="btn badge text-bg-primary" >Update</a>
                                <% end if %>
                                <% if session("PR2C") = true then %>
                                    <% if ddata.eof then %>
                                    <a href="aktifh.asp?id=<%= rs("OPH_ID") %>" class="btn badge text-bg-danger btn-purce1">Delete</a>
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
                        <a class="page-link prev" href="purcesDetail.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&vendor=<%=vendor%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="purcesDetail.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&vendor=<%=vendor%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="purcesDetail.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&vendor=<%=vendor%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="purcesDetail.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&vendor=<%=vendor%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
                        <% else %>
                            <p class="page-link next-p">Next &#x25BA;</p>
                        <% end if %>
                    </li>	
                </ul>
            </nav> 
        </div>
    </div>
</div>
<!-- Modal -->
<div class="modal fade" id="modalMemoToPO" tabindex="-1" aria-labelledby="modalMemoToPOLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="modalMemoToPOLabel">Nomor Memo</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <form action="purces_add.asp" method="post" id="getmemo" onsubmit="validasiForm(this,event,'Proses Purchase Order','warning')">
            <div class="row">
                <div class="col-sm-3 mb-3">
                    <label>Cabang</label>
                </div>
                <div class="col-sm-9 mb-3">
                    <select class="form-select" aria-label="Default select example" name="agenPotoMemo" id="agenPotoMemo" required>
                        <option value="">Pilih</option>
                        <% do while not agenmemo.eof %>
                        <option value="<%= agenmemo("agenID") %>"><%= agenmemo("agenName") %></option>
                        <% 
                        agenmemo.movenext
                        loop
                        %>
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3 mb-3">
                    <label>No Memo</label>
                </div>
                <div class="col-sm-9 mb-3 tampilPoTomemo">
                    <select class="form-select" aria-label="Default select example" disabled="disabled">
                        <option selected>Pilih Cabang Dahulu</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-primary">Save</button>
        </div>
            </form>
        </div>
    </div>
</div>

<% call footer() %>
