<!--#include file="../../init.asp"-->
<% 
    if session("GL2") = false then
        Response.Redirect("../index.asp")
    end if
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
    nama = request.QueryString("nama")
    if len(nama) = 0 then 
        nama = trim(Request.Form("nama"))
    end if
    
    if nama <> "" then
        filterNama = " AND Cat_Name LIKE '%"& nama &"%'"
    else
        filterNama = ""
    end if

    ' query seach 
    strquery = "SELECT GL_M_CategoryItem.*, DLK_M_WebLogin.username FROM GL_M_CategoryItem LEFT OUTER JOIN DLK_M_WebLogin ON GL_M_CategoryItem.Cat_UpdateID = DLK_M_WebLogin.userID WHERE Cat_AktifYN = 'Y' "& filterNama &""

    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY Cat_ID ASC"
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

    call header("Kategori Item")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 mb-3 text-center">
            <h3>KATEGORI ITEM</h3>
        </div>
    </div>
    <% if session("GL2A") = true then %>
    <div class="row">
        <div class="col-sm-12 mb-3">
            <button type="button" class="btn btn-primary tambahCat" data-bs-toggle="modal" data-bs-target="#modalCatItem">Tambah</button>
        </div>
    </div>
    <% end if %>
    <form action="catitem.asp" method="post">
        <div class="row">
            <div class="col-sm-4 mb-3">
                <label for="Nama">Nama</label>
                <input type="text" class="form-control" id="nama" name="nama" autocomplete="off">
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
                        <th scope="col">ID</th>
                        <th scope="col">Nama</th>
                        <th scope="col">Update ID</th>
                        <th scope="col">Update Time</th>
                        <th scope="col" class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 'prints records in the table
                    showrecords = recordsonpage
                    recordcounter = requestrecords
                    do until showrecords = 0 OR  rs.EOF
                    recordcounter = recordcounter + 1 %>
                    <tr>
                        <th scope="row"><%= rs("cat_id") %></th>
                        <td><%= rs("cat_name") %></td>
                        <td><%= rs("username") %></td>
                        <td><%= rs("cat_UpdateTime") %></td>
                        <td class="text-center">
                        <div class="btn-group" role="group" aria-label="Basic example">
                            <% if session("GL2C") = false then %>
                           <a href="Cat_aktif.asp?id=<%= rs("cat_id") %>" class="btn badge bg-danger" onclick="deleteItem(event,'delete kategori item')">delete</a>
                           <% end if %>
                           <% if session("GL2B") = true then %>
                           <a href="#" class="btn badge bg-primary updateCat" data-bs-toggle="modal" data-bs-target="#modalCatItem" data-id="<%= rs("cat_id") %>" data-name="<%= rs("cat_Name") %>">update</a>
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
                        <a class="page-link prev" href="catitem.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&nama=<%=nama%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="catitem.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="catitem.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="catitem.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&nama=<%=nama%>">Next &#x25BA;</a>
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
<div class="modal fade" id="modalCatItem" tabindex="-1" aria-labelledby="modalCatItemLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="modalCatItemLabel">Kategori Item</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="#" method="post" id="formmodalCatItem" onsubmit="validasiForm(this,event,'KATEGORI ITEM','warning')">
                <div class="modal-body">
                    <div class="row">
                        <input type="hidden" id="id" name="id">
                        <div class="col-sm-12 mb-3">
                            <label for="name" class="col-form-label">Name</label>
                            <input type="hidden" id="lname" name="lname"   maxlength="30" autocomplete="off" required>
                            <input type="text" id="name" name="name" class="form-control"  maxlength="30" autocomplete="off" required>
                        </div>
                    </div>
                </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary btnCat">Save</button>
            </div>
            </form>
        </div>
    </div>
</div>

<% 
   call footer()
%>
<script>
     // setting tambah dan update kategori
    $(document).ready(function(){
        $(".tambahCat").click(function (){
            
            $("#formmodalCatItem").attr("action","cat_add.asp")
            $("#id").val('')
            $("#lname").val('')
            $("#name").val('')

            $("#modalCatItemLabel").html("Tambah Kategori Item")
            $(".btnCat").html("Save")
        })
        $(".updateCat").click(function () {
            const id = $(this).data('id');
            const name = $(this).data('name');

            $("#id").val(id)
            $("#lname").val(name)
            $("#name").val(name)

            $("#formmodalCatItem").attr("action","Cat_u.asp")
            
            $("#modalCatItemLabel").html("Update Kategori Item")
            $(".btnCat").html("Update")
        })
    })
</script>