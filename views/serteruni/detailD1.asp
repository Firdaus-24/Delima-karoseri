<!--#include file="../../init.asp"-->
<% 
  if session("MQ2A") = false OR session("MQ2B") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))
  p = trim(Request.QueryString("p"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.DLK_T_UnitCustomerD1.*, dbo.DLK_M_WebLogin.UserName, dbo.DLK_M_Brand.BrandName FROM dbo.DLK_T_UnitCustomerD1 LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.DLK_T_UnitCustomerD1.TFK_BrandID = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_UnitCustomerD1.TFK_UpdateID = dbo.DLK_M_WebLogin.UserID WHERE TFK_ID = '"& id &"'"
  set data = data_cmd.execute


  ' get data item unit
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

  ' untuk data paggination
  page = Request.QueryString("page")

  strquery = "SELECT * FROM DLK_M_ItemKendaraan WHERE FK_AktifYN = 'Y'"

  orderBy = " ORDER BY FK_ID ASC"
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
    response.flush
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
    response.flush
    rs.movenext
    if rs.EOF then
    lastrecord = 1
    end if	
  loop



  call header("Detail Unit Customer")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm-12 text-center mt-3">
      <h3> DETAIL UNIT CUSTOMER</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12 text-center mb-3 labelId">
      <h3><%= LEFT(id,11) &"/"& MID(id,12,4) &"/"& Right(id,2) &"/"& right(id,3)%></h3>
    </div>
  </div>
<% if not data.eof then %>
  <div class="row">
    <div class="col-sm-2">
      <label>Tanggal</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input class="form-control" type="text" value="<%= Cdate(data("TFK_Date")) %>" name="tgl" id="tgl" readonly>
    </div>
    <div class="col-sm-2">
      <label>Merk / Brand</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input class="form-control" type="text" value="<%= data("BrandName") %>" name="merk" id="merk" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label>Type</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input class="form-control" type="text" value="<%= data("TFK_Type") %>" name="tgl" id="tgl" readonly>
    </div>
    <div class="col-sm-2">
      <label>No.Polisi</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input class="form-control" type="text" value="<%= data("TFK_nopol") %>" name="merk" id="merk" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label>No.Ranka</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input class="form-control" type="text" value="<%= data("TFK_norangka") %>" name="tgl" id="tgl" readonly>
    </div>
    <div class="col-sm-2">
      <label>No.Mesin</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input class="form-control" type="text" value="<%= data("TFK_Nomesin") %>" name="merk" id="merk" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-2">
      <label>Warna</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input class="form-control" type="text" value="<%= data("TFK_Color") %>" name="tgl" id="tgl" readonly>
    </div>
    <div class="col-sm-2">
      <label>Update Id</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input class="form-control" type="text" value="<%= data("username") %>" name="merk" id="merk" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12">
      <button type="button" class="btn btn-secondary" onclick="window.location.href='<%=p%>.asp?id=<%= left(id,17)%>'">Kembali</button>
      <% if session("MQ2C") = true then %>
        <button type="button" class="btn btn-danger" onclick="deleteAllUnit('<%=data("TFK_ID")%>','<%= p %>')">Delete</button>
      <%  end if %>
      <marquee class="justify-content-end text-danger">PERHATIAN...PASTIKAN MENGISI KETERANGAN SEBELUM MENNCEKLIS PILIHAN ITEM DIBAWAH INI!!</marquee>
    </div>
  </div>  
  <div class="row">
    <div class="col-sm-12 mb-3">
      <table class="table">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">No</th>
            <th scope="col">Nama</th>
            <th scope="col">Keterangan</th>
            <th scope="col">Pilih</th>
          </tr>
        </thead>
        <tbody>
          <%
          showrecords = recordsonpage
          recordcounter = requestrecords
          do until showrecords = 0 OR  rs.EOF
          recordcounter = recordcounter + 1

          ' get detail D2
          data_cmd.commandText = "SELECT * FROM DLK_T_UnitCustomerD2 WHERE TFK_ID = '"& id &"' AND TFK_FKID = '"& rs("FK_ID") &"'"
          set ddata2 = data_cmd.execute
            %>
          <tr>
            <th scope="row"><%= recordcounter %></th>
            <td><%= rs("FK_Nama") %></td>
            <td>
              <input class="form-control" type="text" maxlength="30" id="cktoolKeterangan<%=recordcounter%>" <% if not ddata2.eof then %> value="<%= ddata2("TFK_Keterangan") %>" <% end if %> style="border:none;border-bottom:1px solid black;">
            </td>
            <td>
              <input class="form-check-input" type="checkbox" id="cktoolsUnit<%=recordcounter%>" onchange="getCkUnit('<%=id%>','<%= rs("FK_Id") %>','<%=recordcounter%>')" <% if not ddata2.eof then %>checked <% end if %>>
            </td>
          </tr>
          <% 
          response.flush
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
            <a class="page-link prev" href="detailD1.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&id=<%=id%>&p=<%=p%>">&#x25C4; Prev </a>
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
            <a class="page-link hal bg-primary text-light" href="detailD1.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&id=<%=id%>&p=<%=p%>"><%= pagelistcounter %></a> 
          <%else%>
            <a class="page-link hal" href="detailD1.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&id=<%=id%>&p=<%=p%>"><%= pagelistcounter %></a> 
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
              <a class="page-link next" href="detailD1.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&id=<%=id%>&p=<%=p%>">Next &#x25BA;</a>
            <% else %>
              <p class="page-link next-p">Next &#x25BA;</p>
            <% end if %>
          </li>	
        </ul>
      </nav> 
    </div>
  </div>
<% end if %>
</div>
<% call footer() %>
<script>
  const getCkUnit = (id1,id2,no) =>{
    let keterangan = $(`#cktoolKeterangan${no}`).val()
    $.post("getTools.asp",{id1,id2,keterangan}, function(data){
    })

  }

  const deleteAllUnit = (id,p) => {
    swal({
      title: "YAKIN UNTUK DI HAPUS??",
      text: "Perhatian!! aksi ini akan menghapus semua data detail transaksi",
      icon: "warning",
      buttons: [
          'No',
          'Yes'
      ],
      dangerMode: true,
    }).then(function (isConfirm) {
      if (isConfirm) {
          window.location.href = (`deleteAllUnit.asp?id=${id}&p=${p}`) // <--- submit form programmatically
      } else {
          swal("Request gagal di kirim");
      }
    })
  }
</script>