<!--#include file="../../init.asp"-->
<% 
  if session("ENG7") = false then
    Response.Redirect("../index.asp")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' filter agen
  data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_M_BOMH LEFT OUTER JOIN GLB_M_Agen ON DLK_M_BOMH.BMAgenID = GLB_M_Agen.AgenID WHERE GLB_M_Agen.AgenAktifYN = 'Y' and DLK_M_BOMH.BMAktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
  set agendata = data_cmd.execute

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
  nama = request.QueryString("nama")
  if len(nama) = 0 then 
    nama = trim(Request.Form("nama"))
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
    filterAgen = "AND DLK_M_BOMH.BMAgenID = '"& agen &"'"
  else
    filterAgen = ""
  end if

  if nama <> "" then
    filternama = "AND dbo.DLK_M_Barang.Brg_nama LIKE '%"& nama &"%'"
  else
    filternama = ""
  end if

  if tgla <> "" AND tgle <> "" then
    filtertgl = "AND dbo.DLK_M_BOMH.BMDate BETWEEN '"& tgla &"' AND '"& tgle &"'"
  elseIf tgla <> "" AND tgle = "" then
    filtertgl = "AND dbo.DLK_M_BOMH.BMDate = '"& tgla &"'"
  else 
    filtertgl = ""
  end if

  ' query seach 
  strquery = "SELECT DLK_M_BOMH.*, DLK_M_Barang.Brg_Nama, GLB_M_Agen.AgenName FROM DLK_M_BOMH LEFT OUTER JOIN DLK_M_Barang ON DLK_M_BOMH.BMBrgID = DLK_M_Barang.Brg_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_M_BOMH.BMAgenID = GLB_M_Agen.AgenID WHERE (BMAktifYN = 'Y') AND BMApproveYN = 'Y' "& filterAgen &" "& filternama &" "& filtertgl &""
  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " ORDER BY DLK_M_Barang.Brg_Nama, DLK_M_BOMH.BMID ASC"
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

  call header("Report Harga B.O.M") 
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
      <h3>PREDIKSI HARGA B.O.M </h3>
    </div>  
  </div>
  <form action="predBom.asp" method="post">
    <div class="row">
      <div class="col-lg-4 mb-3">
        <label for="nama">Nama</label>
        <input type="text" class="form-control" name="nama" id="nama" autocomplete="off">
      </div>
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
          <th>ID Product</th>
          <th>Nama</th>
          <th>Tanggal</th>
          <th>Cabang</th>
          <th>No Drawing</th>
          <th class="text-center">Aksi</th>
        </thead>
        <tbody>
          <% 
          'prints records in the table
          showrecords = recordsonpage
          recordcounter = requestrecords
          do until showrecords = 0 OR  rs.EOF
          recordcounter = recordcounter + 1

          data_cmd.commandText = "SELECT BMDBMID FROM DLK_M_BOMD WHERE LEFT(BMDBMID,12) = '"& rs("BMID") &"'"

          set ddata = data_cmd.execute

          if not ddata.eof then
          %>
          <tr>
            <TH><%= recordcounter %></TH>
            <th><%= left(rs("BMID"),2) %>-<%=mid(rs("BMID"),3,3) %>/<%= mid(rs("BMID"),6,4) %>/<%= right(rs("BMID"),3) %></th>
            <td><%= rs("Brg_Nama") %></td>
            <td><%= Cdate(rs("BMDate")) %></td>
            <td><%= rs("agenName") %></td>
            <td>
              <a href="<%= url %>/views/sasis/openPdf.asp?id=<%= rs("BMSasisID") %>&p=draw" target="blank" style="text-decoration:none;color:black;">
              <%= LEft(rs("BMSasisID"),5) &"-"& mid(rs("BMSasisID"),6,4) &"-"& right(rs("BMSasisID"),3) %>
              </a>
            </td>
            <td class="text-center">
              <div class="btn-group" role="group" aria-label="Basic example">
                <a href="detailPredbom.asp?id=<%= rs("BMID") %>">
                  <span class="badge text-bg-warning">Detail</span>
                </a>
              </div>
            </td>
          </tr>
          <%  
          end if
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
                <a class="page-link prev" href="predBom.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&nama=<%=nama%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
                      <a class="page-link hal bg-primary text-light" href="predBom.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&nama=<%=nama%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
                <%else%>
                      <a class="page-link hal" href="predBom.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&nama=<%=nama%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
                      <a class="page-link next" href="predBom.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&nama=<%=nama%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
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
function openDrawing(modal,src,img,caption,close,id,urut){
    let pmodal = $(`#${modal}`)
        
    let modalImg = $(`#${img}`);
    let captionText = $(`#${caption}`);

    pmodal.css("display", "block");
    modalImg.attr('src', `${src}`) ;
    captionText.html(`<a href="uploadDrawing.asp?id=${id}&img=${urut}" class="btn badge text-bg-light">UPLOAD ULANG</a>`).css({"text-align":"center","margin-top":"10px", "margin-bottom": "10px"})
    
    $(`#${close}`).on('click', function(){
    
        pmodal.css("display","none")
    })
}

</script>
<% call footer() %>
