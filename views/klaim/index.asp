<!--#include file="../../init.asp"-->
<% 
    if session("INV3") = false then
        Response.Redirect("../index.asp")
    end if

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' filter agen
    data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenID, dbo.GLB_M_Agen.AgenName FROM dbo.GLB_M_Agen RIGHT OUTER JOIN dbo.DLK_T_DelBarang ON dbo.GLB_M_Agen.AgenID = dbo.DLK_T_DelBarang.DB_AgenID GROUP BY dbo.DLK_T_DelBarang.DB_AktifYN, dbo.GLB_M_Agen.AgenID, dbo.GLB_M_Agen.AgenName HAVING (dbo.DLK_T_DelBarang.DB_AktifYN = 'Y') ORDER BY dbo.GLB_M_Agen.AgenName"

    set agendata = data_cmd.execute

    ' filter barang
    data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_DelBarang LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_DelBarang.DB_Item = dbo.DLK_M_Barang.Brg_Id WHERE        (dbo.DLK_T_DelBarang.DB_AktifYN = 'Y') GROUP BY dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama ORDER BY dbo.DLK_M_Barang.Brg_Nama"

    set barangdata = data_cmd.execute

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
    cabang = request.QueryString("cabang")
    if len(cabang) = 0 then 
        cabang = trim(Request.Form("cabang"))
    end if
    brg = request.QueryString("brg")
    if len(brg) = 0 then 
        brg = trim(Request.Form("brg"))
    end if
    tgla = request.QueryString("tgla")
    if len(tgla) = 0 then 
        tgla = trim(Request.Form("tgla"))
    end if
    tgle = request.QueryString("tgle")
    if len(tgle) = 0 then 
        tgle = trim(Request.Form("tgle"))
    end if

    if cabang <> "" then 
        filterCabang = " AND DLK_T_Delbarang.DB_AgenID = '"& cabang &"'"
    else 
        filterCabang = ""
    end if

    if brg <> "" then 
        filterbrg = " AND DLK_T_DelBarang.DB_Item = '"& brg &"'"
    else 
        filterbrg = ""
    end if

    if tgla <> "" AND tgle <> "" then
        filtertgl = "AND DLK_T_DelBarang.DB_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
        filtertgl = "AND DLK_T_DelBarang.DB_Date = '"& tgla &"'"
    else 
        filtertgl = ""
    end if

    ' query seach 
    strquery = "SELECT dbo.DLK_T_DelBarang.*, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, dbo.GLB_M_Agen.AgenID FROM dbo.DLK_T_DelBarang LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_DelBarang.DB_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_DelBarang.DB_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_DelBarang.DB_Item = dbo.DLK_M_Barang.Brg_Id WHERE (dbo.DLK_T_DelBarang.DB_AktifYN = 'Y') "& filterCabang &" "& filterbrg &" "& filtertgl &""

    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY DB_Date ASC"
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

    

    call header("Klaim Barang Rusak") 
%>
<style>
    .column{
        height:12rem;
        width:10rem;
        position:relative;
    }
    .column img{
        display:block;
    }
    .textImg {
        position: absolute;
        bottom: 0;
        font-size: 15px;
        padding: 10px;
        text-align: center;
        background: rgb(0, 0, 0);
        background: rgba(0, 0, 0, 0.5);
        width: 100%;
        transition: .5s ease;
        opacity:0;
        color: white;
    }
    .textImg a {
        color: #fff;
        text-decoration:none;
    }
    .column:hover .textImg {
        opacity: 1;
    }
</style>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>DATA BARANG RUSAK</h3>
        </div>
    </div>
    <% if session("INV3A") = true then %>
    <div class="row mt-3 mb-3">
        <div class="col-lg-2">
            <a href="klaim_add.asp" class="btn btn-primary">Tambah</a>
        </div>
    </div>
    <% end if %>
    <form action="index.asp" method="post">
        <div class="row">
            <div class="col-lg-3 mb-3">
                <label for="cabang">Cabang</label>
                <select class="form-select" aria-label="Default select example" name="cabang" id="cabang">
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
                <label for="brg">Barang</label>
                <select class="form-select" aria-label="Default select example" name="brg" id="brg">
                    <option value="">Pilih</option>
                    <% do while not barangdata.eof %>
                    <option value="<%= barangdata("brg_id") %>"><%= barangdata("brg_nama") %></option>
                    <% 
                    barangdata.movenext
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
            <table class="table" style="display:block;overflow:auto;border-color:#fff;">
                <thead class="bg-secondary text-light">
                    <tr>
                    <th scope="col">Tanggal</th>
                    <th scope="col">Cabang</th>
                    <th scope="col">Barang</th>
                    <th scope="col">Quantity</th>
                    <th scope="col">Satuan</th>
                    <th scope="col">Keterangan</th>
                    <th scope="col">Document</th>
                    <th scope="col">Doc Image</th>
                    <th scope="col">Acc 1</th>
                    <th scope="col">Acc 2</th>
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
                        <td><%= Cdate(rs("DB_Date")) %></td>
                        <td><%= rs("AgenNAme") %></td>
                        <td><%= rs("Brg_Nama") %></td>
                        <td><%= rs("DB_QtySatuan") %></td>
                        <td><%= rs("Sat_Nama") %></td>
                        <td><%= rs("DB_Keterangan") %></td>
                        <td class="text-center p-3">
                            <% if session("INV3F") = true then%>
                                <% 
                                set fs = server.createObject("Scripting.FileSystemObject")
                                path =  "D:Delima\document\pdf\"& rs("DB_ID") &".pdf"
                                if fs.FileExists(path) then
                                %>
                                    <a href="openPdf.asp?id=<%= rs("DB_ID") %>" class="btn badge text-bg-light" target="_blank"><i class="bi bi-caret-right"></i></a>
                                <% 
                                else
                                %>
                                    <a href="uploadtest.asp?id=<%= rs("DB_ID") %>&p=pdf&T=pdf" class="btn badge text-bg-light"><i class="bi bi-upload"></i></a>
                                <%end if
                                set fs = Nothing
                                %>
                            <% end if %>
                        </td>
                        <td class="text-center">
                            <% if session("INV3F") = true then%>
                            <button type="button" class="btn btn-sm btn-light" data-bs-toggle="modal" data-bs-target="#modalImgDeleteBrg" onclick="getIDdestroy('<%=rs("DB_ID")%>', '<%=url%>', '<%=rs("DB_Image1")%>', '<%=rs("DB_Image2")%>', '<%=rs("DB_Image3")%>')">
                                See
                            </button>
                            <% end if %>
                        </td>
                        <td>
                            <% if session("INV3E") = true then  %>
                                <% if rs("DB_Acc1") = "N" then%>
                                    <button type="button" class="btn badge btn-info" data-bs-toggle="modal" data-bs-target="#modalAccDelbarang" onclick="getIDDelBarang('<%= rs("DB_ID") %>', '1')">Ajukan</button>
                                <% else %>
                                    yes
                                <% end if %>
                            <% end if %>
                        </td>
                        <td>
                            <% if session("INV3E") = true then  %>
                                <% if rs("DB_Acc2") = "N" then%>
                                    <button type="button" class="btn badge btn-info btn-sm" data-bs-toggle="modal" data-bs-target="#modalAccDelbarang" onclick="getIDDelBarang('<%= rs("DB_ID") %>', '2')">Ajukan</button>
                                <% else %>
                                    yes
                                <% end if %>
                            <% end if %>
                        </td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <% if session("INV3D") = true then %>
                                <button class="btn badge bg-warning" onclick="printIt('print.asp?id=<%= rs("DB_ID") %>')">print</button>
                                <% end if %>
                                <!-- 
                                <a href="klaim_u.asp?id=<%'= rs("DB_ID") %>" class="btn badge text-bg-primary">update</a>
                                 -->
                                <% if session("INV3C") = true then %>
                                    <a href="aktif.asp?id=<%= rs("DB_ID") %>" class="btn badge bg-danger" onclick="deleteItem(event,'delete barang')">delete</a>
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
                        <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&cabang=<%=cabang%>&brg=<%=brg%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&cabang=<%=cabang%>&brg=<%=brg%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&cabang=<%=cabang%>&brg=<%=brg%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&cabang=<%=cabang%>&brg=<%=brg%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
                        <% else %>
                            <p class="page-link next-p">Next &#x25BA;</p>
                        <% end if %>
                    </li>	
                </ul>
            </nav> 
        </div>
    </div>
</div>
<!-- Modal upload image -->
<div class="modal fade" id="modalImgDeleteBrg" tabindex="-1" aria-labelledby="modalImgDeleteBrgLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header text-center">
        <h1 class="modal-title fs-5" id="modalImgDeleteBrgLabel">Document Pendukung</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="row">
            <div class="col-sm-4 column">
                <img id="destroy1" src="" width="100%">
                <a href="" id="DB_Img1">
                    <div class="textImg">
                        Image 1
                    </div>
                </a>
            </div>
            <div class="col-sm-4 column">
                <img id="destroy2" src="" width="100%">
                <a href="" id="DB_Img2">
                    <div class="textImg">
                        Image 2
                    </div>
                </a>
            </div>
            <div class="col-sm-4 column">
                <img id="destroy3" src="" width="100%">
                <a href="" id="DB_Img3">
                    <div class="textImg">
                        Image 3
                    </div>
                </a>
            </div>
        </div>
      </div>
      <div class="modal-footer">
        <p>PT DELIMA KAROSERIN INDONESIA</p>
      </div>
    </div>
  </div>
</div>

<!-- Modal -->
<div class="modal fade" id="modalAccDelbarang" tabindex="-1" aria-labelledby="modalAccDelbarangLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="modalAccDelbarangLabel">Approve Destroy Barang</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <form action="sendEmail.asp" method="post" onsubmit="validasiForm(this,event,'Kirim Email','info')">
                <input type="hidden" id="ndestroy" name="ndestroy" class="form-control" required>
                <input type="hidden" id="iddestroy" name="iddestroy" class="form-control" required>
                <div class="row mb-3">
                    <div class="col-sm-3">
                        <label for="emailTo" class="col-form-label">Email TO</label>
                    </div>
                    <div class="col-sm-9">
                        <input type="email" id="emailTo" name="emailTo" class="form-control" required>
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

<script>
    const getIDdestroy = (id,url, img1,img2,img3) => {
        if(!img1){
            $("#destroy1").attr(`src`,`${url}document/image/nophoto.jpg`)
        }else{
            $("#destroy1").attr(`src`,`${url}document/image/${img1}.jpg`)

        }        
        if(!img2){
            $("#destroy2").attr(`src`,`${url}document/image/nophoto.jpg`)
        }else{
            $("#destroy2").attr(`src`,`${url}document/image/${img2}.jpg`)

        }        
        if(!img3){
            $("#destroy3").attr(`src`,`${url}document/image/nophoto.jpg`)
        }else{
            $("#destroy3").attr(`src`,`${url}document/image/${img3}.jpg`)
        }        

        // setting attr href
        $("#DB_Img1").attr(`href`, `uploadtest.asp?id=${id}1&p=jpg&T=image&db=DB_Image1`)
        $("#DB_Img2").attr(`href`, `uploadtest.asp?id=${id}2&p=jpg&T=image&db=DB_Image2`)
        $("#DB_Img3").attr(`href`, `uploadtest.asp?id=${id}3&p=jpg&T=image&db=DB_Image3`)

    }
    function getIDDelBarang(id,no){
      $("#iddestroy").val(id)
      $("#ndestroy").val(no)
   }
</script>
<% call footer() %>