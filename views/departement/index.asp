<!--#include file="../../init.asp"-->
<% 
    nama = trim(ucase(Request.Form("nama")))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DivID, DivNama FROM DLK_M_Divisi WHERE DivAktifYN = 'Y' ORDER BY DivNama ASC"
    set divisi = data_cmd.execute

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
    
    ' query seach 
    if nama <> "" then
        strnama = "AND DepNama LIKE '%"& nama &"%'"
    else
        strnama = ""
    end if
    strquery = "SELECT DLK_M_Departement.*, DLK_M_Divisi.DivNama FROM DLK_M_Departement LEFT OUTER JOIN DLK_M_Divisi ON DLK_M_Departement.DepDivid = DLK_M_Divisi.DivID WHERE DepAktifYN = 'Y' "& nama &""

    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " order by DepNama ASC"
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

    call header("Departement")
%>    
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3 text-center">
        <div class="col-lg-12">
            <h3>MASTER DEPARTEMENT</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2 mb-3">
            <a href="Dep_add.asp" class="btn btn-primary tambahDep" data-bs-toggle="modal" data-bs-target="#staticBackdrop">Tambah</a>
        </div>
    </div>
    <form action="index.asp" method="post">
        <div class="row">
            <div class="col-lg-4 mb-3">
                <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" placeholder="cari nama">
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
                    <th scope="col">No</th>
                    <th scope="col">Id</th>
                    <th scope="col">Nama</th>
                    <th scope="col">Divisi</th>
                    <th scope="col">Update ID</th>
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
                        <td><%= rs("Depid") %></td>
                        <td><%= rs("Depnama") %></td>
                        <td><%= rs("divNama") %></td>
                        <td><%= rs("DepUpdateID") %></td>
                        <td><%if rs("DepAktifYN") = "Y" then%>Aktif <% end if %></td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="kb_u.asp?id=<%= rs("DepId") %>" class="btn badge text-bg-primary updateDep" data-bs-toggle="modal" data-bs-target="#staticBackdrop" valname="<%= rs("DepNama") %>" data="<%= rs("DepID") %>" divid="<%= rs("DepdivID") %>">update</a>
                                <a href="aktif.asp?id=<%= rs("DepId") %>" class="btn badge text-bg-danger btn-aktifDep">delete</a>
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
<!-- Modal -->
<div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title titleDep" id="staticBackdropLabel">FORM TAMBAH</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
        <form action="keb_add.asp" method="post" id="formDep">
            <div class="modal-body">
                <label for="id" class="form-label">ID Departement</label>
                <input type="text" class="form-control mb-3" name="id" id="id" maxlength="3"  minlength="3" autocomplete="off" required>
                <input type="hidden" class="form-control mb-3" name="oldnama" id="oldnama" autocomplete="off" maxlength="20" required>

                <label for="Nama" class="form-label">Nama</label>
                <input type="text" class="form-control mb-3" name="nama" id="inpnama" autocomplete="off" maxlength="30" required>

                <label for="divisi" class="form-label">Divisi</label>
                <select class="form-select" aria-label="Default select example" name="divid" id="divid" required>
                    <option value="">Pilih</option>
                    <% do while not divisi.eof %>
                    <option value="<%= divisi("DivID") %>"><%= divisi("DivNama") %></option>
                    <% 
                    divisi.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary subDep">Tambah</button>
            </div>
        </form>
    </div>
  </div>
</div>
<% call footer() %>