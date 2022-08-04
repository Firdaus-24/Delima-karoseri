<!--#include file="../../init.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

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
    
    ' if agen <> "" then
    '     filterAgen = "AND memoAgenID = '"& agen &"'"
    ' else
    '     filterAgen = ""
    ' end if

    ' if keb <> "" then
    '     filterKeb = "AND memoKebID = '"& keb &"'"
    ' else
    '     filterKeb = ""
    ' end if

    ' if tgla <> "" AND tgle <> "" then
    '     filtertgl = "AND memotgl BETWEEN '"& tgla &"' AND '"& tgle &"'"
    ' elseIf tgla <> "" AND tgle = "" then
    '     filtertgl = "AND memotgl = '"& tgla &"'"
    ' else 
    '     filtertgl = ""
    ' end if
    ' query seach 
    strquery = "SELECT TOP (100) PERCENT dbo.DLK_T_AppPermintaan.AppMemoID, dbo.DLK_T_AppPermintaan.AppID, dbo.DLK_T_AppPermintaan.AppTgl, dbo.DLK_T_AppPermintaan.AppDana, dbo.DLK_T_AppPermintaan.AppKeterangan, dbo.DLK_T_AppPermintaan.AppAktifYN, dbo.DLK_T_Memo_H.memoTgl, dbo.DLK_T_Memo_H.memoAgenID, dbo.DLK_T_Memo_H.memoKebID, dbo.DLK_T_Memo_H.memoDivID, dbo.DLK_T_Memo_H.memoApproveYN, dbo.DLK_T_Memo_H.memoID FROM dbo.DLK_T_AppPermintaan INNER JOIN dbo.DLK_T_Memo_H ON dbo.DLK_T_AppPermintaan.AppMemoID = dbo.DLK_T_Memo_H.memoID WHERE (dbo.DLK_T_Memo_H.memoAktifYN = 'Y') AND (dbo.DLK_T_AppPermintaan.AppAktifYN = 'Y')"

    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " order by dbo.DLK_T_AppPermintaan.AppTgl DESC"
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


    call header("Detail Approve Permintaan") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>ANGGARAN DANA PERMINTAAN BARANG</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">Memo</th>
                        <th scope="col">Tanggal Acc</th>
                        <th scope="col">Dana Acc</th>
                        <th scope="col">Tanggal Ajuan</th>
                        <th scope="col">Permintaan</th>
                        <th scope="col">Cabang</th>
                        <th scope="col">Divisi</th>
                        <th scope="col">Keperluan</th>
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

                    data_cmd.commandText = "SELECT SUM(dbo.DLK_T_Memo_D.memoHarga * dbo.DLK_T_Memo_D.memoQtty) As tharga FROM dbo.DLK_T_Memo_H INNER JOIN dbo.DLK_T_Memo_D ON dbo.DLK_T_Memo_H.memoID = LEFT(dbo.DLK_T_Memo_D.memoID, 17) WHERE (dbo.DLK_T_Memo_H.memoID = '"& rs("appMemoID") &"') AND DLK_T_Memo_H.memoAktifYN = 'Y' AND DLK_T_Memo_D.memoAktifYn = 'Y'"
                    ' response.write data_cmd.commandText & "<br>"
                    set ddata = data_cmd.execute
                    %>
                    <tr>
                        <TH>
                            <%= rs("appMemoID") %>
                        </TH>
                        <td>
                            <%= rs("appTgl") %>
                        </td>
                        <td>
                            <%= replace(formatCurrency(rs("appDana")),"$","") %>
                        </td>
                        <td>
                            <%= rs("memoTgl") %>
                        </td>
                        <td>
                            <%= replace(formatCurrency(ddata("tharga")),"$","") %>
                        </td>
                        <td>
                            <% call getAgen(rs("memoAgenID"),"p") %>
                        </td>
                        <td>
                            <% call getDivisi(rs("memoDivid")) %>
                        </td>
                        <td>
                            <% call getKebutuhan(rs("memokebID"),"p") %>
                        </td>
                        <td>
                            <%= rs("appKeterangan") %>
                        </td>
                        <td>
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="dapp_u.asp?id=<%= rs("appID") %>" class="btn badge text-bg-primary">Update</a>
                                <a href="aktifapp.asp?id=<%= rs("appID") %>" class="btn badge text-bg-danger btn-appYN">Delete</a>
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
                        <a class="page-link prev" href="dappPermintaan.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="dappPermintaan.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="dappPermintaan.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="dappPermintaan.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>">Next &#x25BA;</a>
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