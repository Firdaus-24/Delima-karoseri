<!--#include file="../../init.asp"-->
<% 
    agen = trim(Request.Form("agen"))
    keb = trim(Request.Form("keb"))
    tgla = trim(Request.Form("tgla"))
    tgle = trim(Request.Form("tgle"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' query cabang  
    set agen_cmd =  Server.CreateObject ("ADODB.Command")
    agen_cmd.ActiveConnection = mm_delima_string
    ' filter agen
    agen_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_Memo_H LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID WHERE GLB_M_Agen.AgenAktifYN = 'Y' and DLK_T_Memo_H.memoAktifYN = 'Y' AND DLK_T_Memo_H.memoApproveYN = 'N' AND NOT EXISTS(select OPH_MemoID FROM dbo.DLK_T_OrPemH where OPH_AktifYN = 'Y' and OPH_memoID = dbo.DLK_T_Memo_H.memoID ) GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
    set agendata = agen_cmd.execute

    ' filter departement
    agen_cmd.commandText = "SELECT dbo.DLK_M_Departement.DepID, dbo.DLK_M_Departement.DepNama FROM dbo.DLK_T_Memo_H LEFT OUTER JOIN dbo.DLK_M_Departement ON dbo.DLK_T_Memo_H.memoDepID = dbo.DLK_M_Departement.DepID WHERE dbo.DLK_T_Memo_H.memoAktifYN = 'Y' AND DLK_T_Memo_H.memoApproveYN = 'N' AND NOT EXISTS(select OPH_MemoID FROM dbo.DLK_T_OrPemH where OPH_AktifYN = 'Y' and OPH_memoID = dbo.DLK_T_Memo_H.memoID ) GROUP BY dbo.DLK_M_Departement.DepID, dbo.DLK_M_Departement.DepNama"
    set kebData = agen_cmd.execute

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
        filterAgen = "AND DLK_T_Memo_H.memoAgenID = '"& agen &"'"
    else
        filterAgen = ""
    end if

    if keb <> "" then
        filterKeb = "AND dbo.DLK_T_Memo_H.memoDepID = '"& keb &"'"
    else
        filterKeb = ""
    end if

    if tgla <> "" AND tgle <> "" then
        filtertgl = "AND dbo.DLK_T_Memo_H.memotgl BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
        filtertgl = "AND dbo.DLK_T_Memo_H.memotgl = '"& tgla &"'"
    else 
        filtertgl = ""
    end if

    ' query seach 
    strquery = "SELECT DLK_T_Memo_H.*, DLK_M_Departement.DepNama, DLK_M_Divisi.DivNama, GLB_M_Agen.AgenName FROM DLK_T_Memo_H LEFT OUTER JOIN DLK_M_departement ON DLK_T_Memo_H.MemoDepID = DLK_M_Departement.DepID LEFT OUTER JOIN DLK_M_Divisi ON DLK_T_Memo_H.memoDivID = DLK_M_Divisi.DivID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = LEFT(GLB_M_Agen.AgenID,3) WHERE NOT EXISTS(select OPH_MemoID FROM dbo.DLK_T_OrPemH where OPH_AktifYN = 'Y' and OPH_memoID = dbo.DLK_T_Memo_H.memoID ) AND (dbo.DLK_T_Memo_H.memoAktifYN = 'Y') AND (dbo.DLK_T_Memo_H.memoApproveYN = 'N') "& filterAgen &" "& filterKeb &" "& filtertgl &""
    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " order by dbo.DLK_T_Memo_H.MemoTgl DESC"
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


    call header("APROVE MEMO PERMINTAAN") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>APPROVE MEMO PERMINTAAN BARANG</h3> 
        </div>
    </div>
    <form action="appmemo.asp" method="post">
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
                <label for="keb">Departement</label>
                <select class="form-select" aria-label="Default select example" name="keb" id="keb">
                    <option value="">Pilih</option>
                    <% do while not kebData.eof %>
                    <option value="<%= kebData("DepID") %>"><%= kebData("DepNama") %></option>
                    <% 
                    kebData.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgla">Tanggal Pertama</label>
                <input type="date" class="form-control" name="tgla" id="tgla" autocomplete="off" >
            </div>
            <div class="col-lg-2 mb-3">
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
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                    <th scope="col">No</th>
                    <th scope="col">No Memo</th>
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

                    ' cek data detail
                    agen_cmd.commandText = "SELECT memoID FROM DLK_T_Memo_D WHERE Left(memoID,17) = '"& rs("memoID") &"' AND memoHarga <> 0 "
                    set ddetail = agen_cmd.execute
                    %>
                    <tr>
                        <th scope="row"><%= recordcounter %></th>
                        <td>
                            <%= left(rs("memoID"),4) %>/<%=mid(rs("memoId"),5,3) %>-<% call getAgen(mid(rs("memoID"),8,3),"") %>/<%= mid(rs("memoID"),11,4) %>/<%= right(rs("memoID"),3) %>
                        </td>
                        <td><%= Cdate(rs("memoTgl")) %></td>
                        <td><%= rs("AgenName") %></td>
                        <td><%= rs("DivNama") %></td>
                        <td><%= rs("DepNama")%></td>
                        <td>
                            <%if rs("memoAktifYN") = "Y" then %>Aktif <% else %>Off <% end if %>
                        </td>
                        <td class="text-center">
                            <% if not ddetail.eof then %>
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="#" class="btn badge text-bg-primary modalSendEmailMemo" data-id="<%= rs("memoID") %>" data-bs-toggle="modal" data-bs-target="#modalSendEmail">Process</a>
                            </div>
                            <% end if %>
                        </td>
                    </tr>
                    <% 
                    showrecords = showrecords - 1
                    rs.movenext
                    if rs.EOF then
                    lastrecord = 1
                    end if
                    loop
                    ' rs.movefirst
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
                        <a class="page-link prev" href="appmemo.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="appmemo.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="appmemo.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="appmemo.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>">Next &#x25BA;</a>
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
<div class="modal fade" id="modalSendEmail" tabindex="-1" aria-labelledby="modalSendEmailLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="modalSendEmailLabel">Approve Memo</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <form action="sendemail.asp" method="post" onsubmit="validasiForm()">
                <input type="hidden" id="idappmemo" name="idappmemo" class="form-control" required>
                <div class="row mb-3">
                    <div class="col-sm-3">
                        <label for="custEmail" class="col-form-label">Email TO</label>
                    </div>
                    <div class="col-sm-9">
                        <input type="email" id="custEmail" name="custEmail" class="form-control" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-3">
                        <label for="subject" class="col-form-label">Subject</label>
                    </div>
                    <div class="col-sm-9">
                        <input type="text" id="subject" name="subject" class="form-control" required>
                    </div>
                </div>
        </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary">Send</button>
            </div>
        </form>
        </div>
    </div>
</div>

<% call footer() %>