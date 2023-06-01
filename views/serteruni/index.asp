<!--#include file="../../init.asp"-->
<% 
  if session("MQ2") = false then
    Response.Redirect("../index.asp")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")   
  data_cmd.ActiveConnection = mm_delima_string    
  ' filter customer
  data_cmd.commandText = "SELECT custid, custnama FROM DLK_T_UnitcustomerH LEFT OUTER JOIN  DLK_M_Customer ON DLK_T_UnitcustomerH.TFK_custid = DLK_M_Customer.custid WHERE TFK_aktifYN = 'Y' GROUP BY custid, custnama ORDER BY custnama ASC"

  set custData = data_cmd.execute
  ' filter NO SO
  data_cmd.commandText = "SELECT TFK_OJHORHID FROM DLK_T_UnitcustomerH WHERE TFK_aktifYN = 'Y' GROUP BY TFK_OJHORHID ORDER BY TFK_OJHORHID ASC"

  set sodata = data_cmd.execute

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
  customer = request.QueryString("customer")
  if len(customer) = 0 then 
    customer = trim(Request.Form("customer"))
  end if
  noprod = request.QueryString("noprod")
  if len(noprod) = 0 then 
    noprod = trim(Request.Form("noprod"))
  end if
  tgla = request.QueryString("tgla")
  if len(tgla) = 0 then 
    tgla = trim(Request.Form("tgla"))
  end if
  tgle = request.QueryString("tgle")
  if len(tgle) = 0 then 
    tgle = trim(Request.Form("tgle"))
  end if

  ' query seach 
  if customer <> "" then
    filtercustomer = "AND DLK_T_UnitcustomerH.TFK_custid = '"& customer &"'"
  else
    filtercustomer = ""
  end if

  if noprod <> "" then
    filternoprod = "AND dbo.DLK_T_UnitcustomerH.TFK_OJHORHID = '"& noprod &"'"
  else
    filternoprod = ""
  end if

  if tgla <> "" AND tgle <> "" then
    filtertgl = "AND dbo.DLK_T_UnitcustomerH.TFK_Date BETWEEN '"& Cdate(tgla) &"' AND '"& Cdate(tgle) &"'"
  elseIf tgla <> "" AND tgle = "" then
    filtertgl = "AND dbo.DLK_T_UnitcustomerH.TFK_Date = '"& Cdate(tgla) &"'"
  else 
    filtertgl = ""
  end if

  strquery = "SELECT dbo.DLK_T_UnitcustomerH.*, dbo.DLK_M_Customer.custnama, dbo.DLK_M_WebLogin.UserName FROM dbo.DLK_T_UnitcustomerH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_UnitcustomerH.TFK_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.DLK_T_UnitcustomerH.TFK_custid = dbo.DLK_M_Customer.custid WHERE (dbo.DLK_T_UnitcustomerH.TFK_AktifYN = 'Y') "& filtercustomer &" "& filternoprod &" "& filtertgl &""

  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " ORDER BY TFK_ID DESC   "
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

  call header("Serah Terima Unit")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 text-center mt-3 mb-3">
        <h3>SERAH TERIMA UNIT CUSTOMER</h3>
    </div>
  </div>
  <% if session("MQ2A") = true then %>
  <div class="row mt-3 mb-3">
    <div class="col-lg-2">
      <a href="tfk_add.asp" class="btn btn-primary">Tambah</a>
    </div>
  </div>
  <% end if %>
  <form action="index.asp" method="post">
  <div class="row">
    <div class="col-lg-4 mb-3">
        <label>Customer</label>
        <select class="form-select" aria-label="Default select example" name="customer" id="customer">
            <option value="">Pilih</option>
            <% do while not custData.eof %>
            <option value="<%= custData("custid") %>"><%= custData("custnama") %></option>
            <% 
            response.flush
            custData.movenext
            loop
            %>
        </select>
      </div>
    <div class="col-lg-4 mb-3">
        <label>No.Produksi</label>
        <select class="form-select" aria-label="Default select example" name="noprod" id="noprod">
          <option value="">Pilih</option>
          <% do while not sodata.eof %>
          <option value="<%= sodata("TFK_OJHORHID") %>"><%= left(sodata("TFK_OJHORHID") ,2)%>-<%= mid(sodata("TFK_OJHORHID") ,3,3)%>/<%= mid(sodata("TFK_OJHORHID") ,6,4) %>/<%= right(sodata("TFK_OJHORHID"),4) %></option>
          <% 
          response.flush
          sodata.movenext
          loop
          %>
        </select>
    </div>
  </div>
  <div class="row">
      <div class="col-lg-4 mb-3">
          <label>Tanggal awal</label>
          <input type="date" class="form-control" name="tgla" id="tgla" autocomplete="off">
        </div>
      <div class="col-lg-4 mb-3">
          <label>Tanggal akhir</label>
          <input type="date" class="form-control" name="tgle" id="tgle" autocomplete="off">
        </div>
        <div class="col-lg mb-3 d-flex align-items-end">
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
            <th scope="col">No.Sales Order</th>
            <th scope="col">Customer</th>
            <th scope="col">Tanggal</th>
            <th scope="col">Penerima</th>
            <th scope="col">Penyerah</th>
            <th scope="col">Jenis</th>
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

            ' cek data detail
            data_cmd.commandText = "SELECT TOP 1 TFK_ID FROM DLK_T_UnitCustomerD1 WHERE LEFT(TFK_ID,17) = '"& rs("TFK_ID") &"'"
            ' response.write data_cmd.commandText & "<br>"
            set detail = data_cmd.execute
          %>
          <tr>
            <th scope="row"><%= recordcounter %> </th>
            <td><%= left(rs("TFK_OJHORHID") ,2)%>-<%=  mid(rs("TFK_OJHORHID") ,3,3)%>/<%= mid(rs("TFK_OJHORHID") ,6,4) %>/<%= right(rs("TFK_OJHORHID"),4) %></td>
            <td><%= rs("custnama") %></td>
            <td><%= Cdate(rs("TFK_Date")) %></td>
            <td><%= rs("TFK_Penerima") %></td>
            <td><%= rs("TFK_Penyerah") %></td>
            <td>
              <% if rs("TFK_Jenis") = 1 then %>Baru <% elseif rs("TFK_JEnis") = 2 then %>Repair <% else %> - <% end if %>
            </td>
            <td><%= rs("TFK_Keterangan") %></td>
            <td class="text-center">
              <div class="btn-group" role="group" aria-label="Basic example">
                <% if session("MQ2B") = true then %>
                  <a href="tfkd_u.asp?id=<%= rs("TFK_ID") %>" class="btn badge text-bg-primary">update</a>
                <%end if %>
                <% if detail.eof then %>
                    <% if session("MQ2C") = true then %>
                    <a href="aktif.asp?id=<%= rs("TFK_ID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'RETURN BARANG HEADER')">delete</a>
                    <% end if %>
                <% else %>
                  <a href="detail.asp?id=<%= rs("TFK_ID") %>" class="btn badge text-bg-warning">detail</a>
                <% end if %>    
              </div>
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
            <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&customer=<%=customer%>&noprod=<%=noprod%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
            <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&customer=<%=customer%>&noprod=<%=noprod%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
          <%else%>
            <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&customer=<%=customer%>&noprod=<%=noprod%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
              <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&customer=<%=customer%>&noprod=<%=noprod%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
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
