<!--#include file="../../init.asp"-->
<% 
    if session("PR4") = false then
        Response.Redirect("../index.asp")
    end if
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' filter agen
    data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_InvPemH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvPemH.IPH_AgenID = GLB_M_Agen.AgenID WHERE GLB_M_Agen.AgenAktifYN = 'Y' and DLK_T_InvPemH.IPH_AktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
    set agendata = data_cmd.execute
    ' filter vendor
    data_cmd.commandText = "SELECT dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_ID FROM dbo.DLK_T_InvPemH LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_InvPemH.IPH_venID = dbo.DLK_M_Vendor.Ven_ID WHERE DLK_T_InvPemH.IPH_AktifYN = 'Y' GROUP BY dbo.DLK_M_Vendor.Ven_Nama, dbo.DLK_M_Vendor.Ven_ID ORDER BY Ven_Nama ASC"
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
    tgla = request.QueryString("tgla")
    if len(tgla) = 0 then 
        tgla = trim(Request.Form("tgla"))
    end if
    tgle = request.QueryString("tgle")
    if len(tgle) = 0 then 
        tgle = trim(Request.Form("tgle"))
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

    if tgla <> "" AND tgle <> "" then
        filtertgl = "AND dbo.DLK_T_InvPemH.IPH_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
        filtertgl = "AND dbo.DLK_T_InvPemH.IPH_Date = '"& tgla &"'"
    else 
        filtertgl = ""
    end if

    ' query seach 
    strquery = "SELECT DLK_T_InvPemH.*, GLB_M_Agen.AgenName, DLK_M_Vendor.Ven_Nama FROM DLK_T_InvPemH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvPemH.IPH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Vendor ON DLK_T_InvPemH.IPH_venID = DLK_M_Vendor.Ven_ID WHERE IPH_AktifYN = 'Y' "& filterAgen &"  "& filtervendor &" "& filtermetpem &" "& filtertgl &""
    ' untuk data paggination
    page = Request.QueryString("page")

    orderBy = " ORDER BY IPH_Date DESC"
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

    call header("Faktur Terhutang")
%>
<style>

    /* The Modal (background) */
    .modal {
    display: none; /* Hidden by default */
    position: fixed; /* Stay in place */
    z-index: 1; /* Sit on top */
    padding-top: 100px; /* Location of the box */
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: rgb(0,0,0); /* Fallback color */
    background-color: rgba(0,0,0,0.9); /* Black w/ opacity */
    }

    /* Modal Content (image) */
    .modal-content {
    margin: auto;
    display: block;
    width: 80%;
    max-width: 700px;
    }

    /* Caption of Modal Image */
    #caption {
    margin: auto;
    display: block;
    width: 80%;
    max-width: 700px;
    text-align: center;
    color: #ccc;
    padding: 10px 0;
    height: 150px;
    }

    /* Add Animation */
    .modal-content, #caption {  
    -webkit-animation-name: zoom;
    -webkit-animation-duration: 0.6s;
    animation-name: zoom;
    animation-duration: 0.6s;
    }

    @-webkit-keyframes zoom {
    from {-webkit-transform:scale(0)} 
    to {-webkit-transform:scale(1)}
    }

    @keyframes zoom {
    from {transform:scale(0)} 
    to {transform:scale(1)}
    }

    /* The Close Button */
    .close {
    position: absolute;
    top: 15px;
    right: 35px;
    color: #f1f1f1;
    font-size: 40px;
    font-weight: bold;
    transition: 0.3s;
    }

    .close:hover,
    .close:focus {
    color: #bbb;
    text-decoration: none;
    cursor: pointer;
    }

    /* 100% Image Width on Smaller Screens */
    @media only screen and (max-width: 700px){
    .modal-content {
        width: 100%;
    }
    }
</style>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>TRANSAKSI FAKTUR PEMBELIAN</h3>
        </div>
    </div>
    <% if session("PR4A") = true then %>
    <div class="row">
        <div class="col-lg-12 mb-3">
            <a href="faktur_add.asp" class="btn btn-primary ">Tambah</a>
        </div>
    </div>
    <% end if %>
    <form action="index.asp" method="post">
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
                <% if tgla <> "" OR tgle <> "" OR agen <> "" OR vendor <> "" then %>    
                <button type="button" class="btn btn-secondary" onclick="window.location.href='export_t_buy.asp?la=<%=tgla%>&le=<%=tgle%>&en=<%=agen%>&or=<%=vendor%>'">Export</button>
                <% end if %>
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
                    <th>Tanggal JT</th>
                    <th>Vendor</th>
                    <th>Tukar Faktur</th>
                    <th>Document</th>
                    <th class="text-center">Aksi</th>
                </thead>
                <tbody>
                    <% 
                    'prints records in the table
                    showrecords = recordsonpage
                    recordcounter = requestrecords
                    do until showrecords = 0 OR  rs.EOF
                    recordcounter = recordcounter + 1

                    data_cmd.commandTExt = "SELECT IPD_IphID FROM DLK_T_InvPemD WHERE LEFT(IPD_IphID,13) = '"& rs("IPH_ID") &"'"
                    set p = data_cmd.execute
                    %>
                        <tr><TH><%= recordcounter %></TH>
                        <th><%= LEFT(rs("IPH_ID"),2) &"-"& mid(rs("IPH_ID"),3,3) &"/"& mid(rs("IPH_ID"),6,4) &"/"& right(rs("IPH_ID"),4)%></th>
                        <td><%= rs("AgenNAme")%></td>
                        <td><%= Cdate(rs("IPH_Date")) %></td>
                        <td>
                            <% if rs("IPH_JTDate") <> "1900-01-01" then %>
                            <%= Cdate(rs("IPH_JTDate")) %>
                            <% end if %>
                        </td>
                        <td><%= rs("Ven_Nama") %></td>
                        <td><%if rs("IPH_TukarYN") = "Y"  then%>Yes <% else %>No <%  end if %></td>
                        <td>
                            <% if session("PR4E") = true then %>
                            <% if rs("IPH_image") <> "" then%>
                                <img src="<%= url %>document/image/<%= rs("IPH_image") &".jpg" %>" id="myImg<%= recordcounter %>" width="30px" onclick="openImage('mymodal<%= recordcounter %>', this.src,'img<%= recordcounter %>','caption<%= recordcounter %>','close<%= recordcounter %>','<%= rs("IPH_Id") %>')">
                                <!-- The Modal -->
                                <div class="modal" id="mymodal<%= recordcounter %>">
                                    <span class="close" id="close<%= recordcounter %>">&times;</span>
                                    <div id="caption<%= recordcounter %>"></div>
                                    <img class="modal-content" id="img<%= recordcounter %>">
                                </div>
                            <% else %>
                                <a href="uploadImage.asp?id=<%= rs("IPH_Id") %>" class="btn badge text-bg-light"><i class="bi bi-upload"></i></a>
                            <% end if %>
                            <% end if %>
                        </td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <% if not p.eof then %>
                                    <a href="detailFaktur.asp?id=<%= rs("IPH_ID") %>" class="btn badge text-light bg-warning">Detail</a>
                                <% end if %>
                                <% if session("PR4B") = true then %>    
                                <a href="faktur_u.asp?id=<%= rs("IPH_ID") %>" class="btn badge text-bg-primary" >Update</a>
                                <% end if %>
                                <% if session("PR4C") = true then %>    
                                    <% if p.eof then %>
                                        <a href="aktifh.asp?id=<%= rs("IPH_ID") %>" class="btn badge text-bg-danger btn-fakturh">Delete</a>
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
                        <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&vendor=<%=vendor%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&vendor=<%=vendor%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&vendor=<%=vendor%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&vendor=<%=vendor%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
                        <% else %>
                            <p class="page-link next-p">Next &#x25BA;</p>
                        <% end if %>
                    </li>	
                </ul>
            </nav> 
        </div>
    </div>
</div>  
<script>
function openImage(modal,src,img,caption,close,id){
    let pmodal = $(`#${modal}`)
        
    let modalImg = $(`#${img}`);
    let captionText = $(`#${caption}`);

    pmodal.css("display", "block");
    modalImg.attr('src', `${src}`) ;
    captionText.html(`<a href="uploadImage.asp?id=${id}" class="btn badge text-bg-light">UPLOAD ULANG</a>`).css({"text-align":"center","margin-top":"10px", "margin-bottom": "10px"})
    
    $(`#${close}`).on('click', function(){
    
        pmodal.css("display","none")
    })
}

</script>
<% call footer() %>

