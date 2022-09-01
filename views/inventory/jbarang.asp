<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_metpem.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' get data puchaseOrder
    data_cmd.commandText = "SELECT dbo.DLK_T_OrJulH.OJH_ID FROM dbo.DLK_T_InvJulH RIGHT OUTER JOIN dbo.DLK_T_OrJulH ON dbo.DLK_T_InvJulH.IJH_OJHId = dbo.DLK_T_OrJulH.OJH_ID WHERE (dbo.DLK_T_InvJulH.IJH_OJHId IS NULL) AND dbo.DLK_T_OrJulH.OJH_aktifYN = 'Y' ORDER BY dbo.DLK_T_OrJulH.OJH_ID DESC"
    set getpo = data_cmd.execute

    ' filter agen
    data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_InvJulH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvJulH.IJH_AgenID = GLB_M_Agen.AgenID WHERE GLB_M_Agen.AgenAktifYN = 'Y' and DLK_T_InvJulH.IJH_AktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
    set agendata = data_cmd.execute

    ' filter customer
    data_cmd.commandText = "SELECT dbo.DLK_M_Customer.custNama, dbo.DLK_M_Customer.custID FROM dbo.DLK_T_InvJulH LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.DLK_T_InvJulH.IJH_custID = dbo.DLK_M_Customer.custID WHERE DLK_T_InvJulH.IJH_AktifYN = 'Y' GROUP BY dbo.DLK_M_Customer.custNama, dbo.DLK_M_Customer.custID ORDER BY custNama ASC"
    set custdata = data_cmd.execute

    agen = trim(Request.Form("agen"))
    customer = trim(Request.Form("customer"))
    metpem = trim(Request.Form("metpem"))
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
        filterAgen = "AND DLK_T_InvJulH.IJH_AgenID = '"& agen &"'"
    else
        filterAgen = ""
    end if

    if vendor <> "" then
        filtervendor = "AND dbo.DLK_T_InvJulH.IJH_VenID = '"& vendor &"'"
    else
        filtervendor = ""
    end if

    if metpem <> "" then
        filtermetpem = "AND dbo.DLK_T_InvJulH.IJH_metpem = '"& metpem &"'"
    else
        filtermetpem = ""
    end if

    if tgla <> "" AND tgle <> "" then
        filtertgl = "AND dbo.DLK_T_InvJulH.IJH_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
        filtertgl = "AND dbo.DLK_T_InvJulH.IJH_Date = '"& tgla &"'"
    else 
        filtertgl = ""
    end if

    ' query seach 
    strquery = "SELECT * FROM DLK_T_InvJulH WHERE IJH_AktifYN = 'Y' "& filterAgen &"  "& filtervendor &" "& filtermetpem &" "& filtertgl &""
    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY IJH_Date DESC"
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

    call header("Penjualan Barang")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>TRANSAKSI FAKTUR PENJUALAN</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3">
            <a href="faktur_add.asp" class="btn btn-primary " data-bs-toggle="modal" data-bs-target="#carimemo">Tambah</a>
        </div>
    </div>
    <form action="jbarang.asp" method="post">
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
                <label for="customer">Customer</label>
                <select class="form-select" aria-label="Default select example" name="customer" id="customer">
                    <option value="">Pilih</option>
                    <% do while not custdata.eof %>
                    <option value="<%= custdata("custid") %>"><%= custdata("custnama") %></option>
                    <% 
                    custdata.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-4 mb-3">
                <label for="metpem">Pembayaran</label>
                <select class="form-select" aria-label="Default select example" name="metpem" id="metpem">
                    <option value="">Pilih</option>
                    <option value="1">Transfer</option>
                    <option value="2">Cash</option>
                    <option value="3">PayLater</option>
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
                    <th>FakturID</th>
                    <th>Cabang</th>
                    <th>Tanggal</th>
                    <th>Customer</th>
                    <th>Tanggal JT</th>
                    <th>Diskon</th>
                    <th>PPn</th>
                    <th>Pembayaran</th>
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

                    data_cmd.commandTExt = "SELECT IJD_IJHID FROM DLK_T_InvJulD WHERE LEFT(IJD_IJHID,13) = '"& rs("IJH_ID") &"'"
                    set p = data_cmd.execute
                    %>
                        <tr><TH><%= recordcounter %></TH>
                        <th><%= rs("IJH_ID") %></th>
                        <td><% call getAgen(rs("IJH_AgenID"),"P") %></td>
                        <td><%= Cdate(rs("IJH_Date")) %></td>
                        <td><%= rs("IJH_custID") %></td>
                        <td>
                            <% if rs("IJH_JTDate") <> "1900-01-01" then %>
                            <%= Cdate(rs("IJH_JTDate")) %>
                            <% end if %>
                        </td>
                        <td><%= rs("IJH_DiskonAll") %></td>
                        <td><%= rs("IJH_PPn") %></td>
                        <td><% call getmetpem(rs("IJH_MetPem")) %></td>
                        <td><%= rs("IJH_Keterangan") %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="detailFaktur.asp?id=<%= rs("IJH_ID") %>" class="btn badge text-light bg-warning">Detail</a>
                                <a href="faktur_u.asp?id=<%= rs("IJH_ID") %>" class="btn badge text-bg-primary" >Update</a>

                                <% if p.eof then %>
                                <a href="aktifh.asp?id=<%= rs("IJH_ID") %>" class="btn badge text-bg-danger btn-fakturh">Delete</a>
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
                        <a class="page-link prev" href="jbarang.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="jbarang.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="jbarang.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="jbarang.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>">Next &#x25BA;</a>
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
<div class="modal fade" id="carimemo" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="carimemoLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="carimemoLabel">Cari Puchase Order</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form action="jbarang_add.asp" method="get">
            <select class="form-select" aria-label="Default select example" id="id" name="id" required>
                <option value="">Pilih</option>
                <% do while not getpo.eof %>
                <option value="<%= getpo("OJH_ID") %>"><%= getpo("OJH_ID") %></option>
                <% 
                getpo.movenext
                loop 
                %>
            </select>
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

