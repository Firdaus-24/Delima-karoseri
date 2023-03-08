<!--#include file="../../init.asp"-->
<% 
  noprod = trim(Request.Form("noprod"))
  thpp = 0

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.CommandText = "SELECT PDH_ID FROM DLK_T_ProduksiH WHERE PDH_Approve1 = 'Y' AND PDH_Approve2 = 'Y' AND PDH_AktifYN = 'Y' ORDER BY PDH_ID ASC"

  set data = data_cmd.execute

  if len(noprod) <> 0 then 
  ' cek detail data
  data_cmd.commandTExt = "SELECT DLK_T_ProduksiD.*,  dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Barang.Brg_Nama FROM DLK_M_Barang RIGHT OUTER JOIN  DLK_T_ProduksiD ON DLK_T_ProduksiD.PDD_Item = DLK_M_Barang.Brg_ID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE LEFT(PDD_ID,13) = '"&noprod &"' ORDER BY PDD_ID ASC"

  set ddata = data_cmd.execute 

  ' cek data manpwer
  data_cmd.commandTExt = "SELECT MP_ID, MP_PDHID FROM dbo.DLK_T_ManPowerH WHERE DLK_T_ManPowerH.MP_PDHID = '"& noprod &"' AND MP_AktifYN = 'Y'"
  ' response.write data_cmd.commandText & "<br>"
  set mph = data_cmd.execute

    if not mph.eof then
    ' detail man power
    data_cmd.commandText = "SELECT dbo.HRD_M_Karyawan.Kry_Nama, dbo.DLK_M_WebLogin.UserName, dbo.DLK_T_ManPowerD.* FROM dbo.DLK_T_ManPowerD LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ManPowerD.MP_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.HRD_M_Karyawan ON dbo.DLK_T_ManPowerD.MP_Nip = dbo.HRD_M_Karyawan.Kry_NIP WHERE LEFT(MP_ID,4) = '"& left(mph("MP_ID"),4) &"' AND RIGHT(MP_ID,7)= '"& RIGHT(mph("MP_ID"),7) &"' ORDER BY Kry_Nama"
    ' response.write data_cmd.commandText & "<br>"
    set detailMP = data_cmd.execute

    end if

  ' cek data return material
  data_cmd.commandTExt = "SELECT RM_ID FROM DLK_T_ReturnMaterialH WHERE RM_PDHID = '"& noprod &"' AND RM_AktifYN = 'Y'"
  set returnmaterial = data_cmd.execute

    if not returnmaterial.eof then
      ' detail returnmaterial
      data_cmd.commandText = "SELECT dbo.DLK_T_ReturnMaterialD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_WebLogin.UserName, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_SatuanBarang.Sat_Nama FROM dbo.DLK_M_WebLogin RIGHT OUTER JOIN dbo.DLK_T_ReturnMaterialD INNER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_ReturnMaterialD.RM_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID ON dbo.DLK_M_WebLogin.UserID = dbo.DLK_T_ReturnMaterialD.RM_UpdateID LEFT OUTER JOIN dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID ON dbo.DLK_T_ReturnMaterialD.RM_Item = dbo.DLK_M_Barang.brg_ID WHERE LEFT(DLK_T_ReturnMaterialD.RM_ID,13) = '"& returnmaterial("RM_ID") &"' ORDER BY dbo.DLK_M_Barang.Brg_Nama"

      set detailreturnM = data_cmd.execute
    end if

  end if

  call header("Report Produksi")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm-12 mt-3 mb-3 text-center">
      <h3>LAPORAN TRANSAKSI HPP PRODUKSI BERJALAN</h3>
    </div>
  </div>
  <form action="report.asp" method="post">
  <div class="row">
    <div class="col-sm-1">
      <label for="noprod" class="col-form-label">No.Produksi</label>
    </div>
    <div class="col-sm-4 mb-3">
      <select class="form-select" aria-label="Default select example" name="noprod" id="noprod" required>
      <option value="">Pilih</option>
      <% do while not data.eof %>
        <option value="<%= data("PDH_ID") %>"><%= left(data("PDH_ID"),2) %>-<%= mid(data("PDH_ID"),3,3) %>/<%= mid(data("PDH_ID"),6,4) %>/<%= right(data("PDH_ID"),4)  %></option>
      <% 
      Response.flush
      data.movenext
      loop
      %>
      </select>
    </div>
    <div class="col-sm-2 mb-3">
      <button type="button" class="btn btn-secondary" onClick="window.open('export-XlsReport.asp?noprod=<%=noprod%>','_self')">Export</button>
      <button type="submit" class="btn btn-primary">Refresh</button>
    </div>
  </div>
  </form>
  <!-- content -->
  <% if len(noprod) <> 0 then %>
  <div class="row">
    <div class="col-lg-12">
      <table class="table table-hover">
        <thead class="bg-secondary text-light">
            <tr>
              <th scope="col">ID</th>
              <th scope="col">B.O.M ID</th>
              <th scope="col">Kode</th>
              <th scope="col">Item</th>
              <th scope="col" colspan="2">PPIC</th>
            </tr>
        </thead>
        <tbody>
          <% 
          hppitem = 0
          do while not ddata.eof 

          ' cek data outgoing
          data_cmd.commandTExt = "SELECT dbo.DLK_T_MaterialOutD.MO_Date, dbo.DLK_T_MaterialOutD.MO_Qtysatuan, dbo.DLK_T_MaterialOutD.MO_Harga, dbo.DLK_T_MaterialOutH.MO_PDDID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama FROM dbo.DLK_M_Kategori INNER JOIN  dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID RIGHT OUTER JOIN dbo.DLK_T_MaterialOutD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialOutD.MO_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_MaterialOutD.MO_Item LEFT OUTER JOIN dbo.DLK_T_MaterialOutH ON dbo.DLK_T_MaterialOutD.MO_ID = dbo.DLK_T_MaterialOutH.MO_ID GROUP BY dbo.DLK_T_MaterialOutD.MO_Date, dbo.DLK_T_MaterialOutD.MO_Qtysatuan, dbo.DLK_T_MaterialOutD.MO_Harga, dbo.DLK_T_MaterialOutH.MO_PDDID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama HAVING (dbo.DLK_T_MaterialOutH.MO_PDDID = '"& ddata("PDD_ID") &"') ORDER BY Brg_nama ASC"

          set outgoing = data_cmd.execute
          %>
            <tr>
                <th>
                  <%= left(ddata("PDD_id"),2) %>-<%= mid(ddata("PDD_id"),3,3) %>/<%= mid(ddata("PDD_id"),6,4) %>/<%= mid(ddata("PDD_id"),10,4) %>/<%= right(ddata("PDD_id"),3)  %>
                </th>
                <td>
                  <%= left(ddata("PDD_BMID"),2) %>-<%= mid(ddata("PDD_BMID"),3,3) %>/<%= mid(ddata("PDD_BMID"),6,4) %>/<%= right(ddata("PDD_BMID"),3)  %>
                </td>
                <td>
                  <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
                </td>
                <td>
                  <%= ddata("brg_nama")%>
                </td>
                <td colspan="2">
                  <%= ddata("PDD_PicName")%>
                </td>
            </tr>
            <!-- data outgoing -->
            <tr style="background-color:#6495ED">
              <th scope="col">Kode</th>
              <th scope="col">Item</th>
              <th scope="col">Quantity</th>
              <th scope="col">Satuan</th>
              <th scope="col">Harga</th>
              <th scope="col">Total Harga </th>
            </tr>
            <% 
            tharga = 0
            grandtotal = 0
            do while not outgoing.eof
            tharga = outgoing("MO_Harga") * Cint(outgoing("MO_Qtysatuan"))
            grandtotal = grandtotal + tharga
            %>
            <tr>
              <td><%= outgoing("KategoriNama") &"-"& outgoing("jenisNama") %></td>
              <td><%= outgoing("Brg_Nama") %></td>
              <td><%= outgoing("MO_Qtysatuan") %></td>
              <td><%= outgoing("Sat_NAma") %></td>
              <td align="right"><%= replace(formatcurrency(outgoing("MO_Harga")),"$","") %></td>
              <td align="right"><%= replace(formatcurrency(tharga),"$","") %></td>
            </tr>
            <% 
            response.flush
            outgoing.movenext
            loop
            %>
            <tr>
              <th colspan="5">Total Item</th>
              <th style="text-align:right"><%= replace(formatcurrency(grandtotal),"$","") %></th>
            </tr>
          <% 
          hppitem = hppitem + grandtotal
          response.flush
          ddata.movenext
          loop
          %>
          <tr>
            <td colspan="6">&nbsp</td>
          </tr>
          <!-- total man power -->
          <tr>
            <th colspan="6">Detail ManPower</th>
          </tr>
          <% if not mph.eof then %>
            <tr>
              <th scope="col">Nip</th>
              <th scope="col">Nama</th>
              <th scope="col">Salary</th>
              <th scope="col">Deskripsi</th>
              <th scope="col">Hari Kerja</th>
              <th scope="col">Total</th>
            </tr>
            <% 
            hktotal = 0
            tmanpower = 0
            do while not detailMP.eof 
            ' cek hari kerja karyawan
            data_cmd.commandText = "SELECT ISNULL(SUM(TW_01 + TW_02 + TW_03 + TW_04 + TW_05 + TW_06 + TW_07 + TW_08 + TW_09 + TW_10 + TW_11 + TW_12 + TW_13 + TW_14 + TW_15 + TW_16 + TW_17 + TW_18 + TW_19 + TW_20	 + TW_21 + TW_22 + TW_23 + TW_24 + TW_25 + TW_26 + TW_27 + TW_28 + TW_29 + TW_30 + TW_31),0) as hari FROM DLK_T_TWMP WHERE TW_MPID = '"& detailMP("MP_ID") &"' "
            ' response.write data_cmd.commandText & "<br>"
            set jhari = data_cmd.execute

            hktotal = detailMP("MP_Salary") * Cint(jhari("hari"))
            %>
            <tr>
              <td><%= detailMP("MP_Nip") %></td>
              <td><%= detailMP("Kry_Nama") %></td>
              <td align="right"><%= replace(formatCurrency(detailMP("MP_Salary")),"$","") %></td>
              <td><%= detailMP("MP_Deskripsi") %></td>
              <td><%= jhari("hari") %></td>
              <td align="right"> <%= replace(formatCurrency(hktotal),"$","") %></td>
            </tr>
            <% 
            tmanpower = tmanpower + hktotal
            response.flush
            detailMP.movenext
            loop

            %>
            <tr>
              <th colspan="5">Grand Total Man Power</th>
              <th style="text-align:right"><%= replace(formatcurrency(tmanpower),"$","") %></th>
            </tr>
          <% end if %>
            <tr>
              <td colspan="6">&nbsp</td>
            </tr>
          <!-- total Return material -->
          <% if not returnmaterial.eof then %>
            <tr>
              <th colspan="6">Return Material Produksi</th>
            </tr>
            <tr style="background-color:#6495ED">
              <th scope="col">Kode</th>
              <th scope="col">Item</th>
              <th scope="col">Quantity</th>
              <th scope="col">Satuan</th>
              <th scope="col">Harga</th>
              <th scope="col">Total Harga </th>
            </tr>
            <% 
            jreturn = 0
            treturn = 0
            do while not detailreturnM.eof 
            jreturn = detailreturnM("RM_Harga") * Cint(detailreturnM("RM_qtysatuan"))
            %>
            <tr>
               <th><%= detailreturnM("KategoriNama") %>-<%= detailreturnM("jenisNama") %></th>
              <td>
                <%= detailreturnM("Brg_Nama") %>
              </td>
              <td><%= detailreturnM("RM_qtysatuan") %></td>
              <td><%= detailreturnM("sat_nama") %></td>
              <td align="right">
                <%= replace(formatCurrency(detailreturnM("RM_Harga")),"$","") %>
              </td>
              <td align="right">
                <%= replace(formatCurrency(jreturn),"$","") %>
              </td>
            </tr>
            <% 
            treturn = treturn + jreturn
            response.flush
            detailreturnM.movenext
            loop

            thpp = thpp + hppitem + tmanpower - treturn
            %>
            <tr style="background-color:#FFFFE0">
              <th colspan="5">Grand Total Return Material</th>
              <th style="text-align:right"><%= replace(formatcurrency(treturn),"$","") %></th>
            </tr>
          <% end if %>
            <tr>
              <td colspan="6">&nbsp</td>
            </tr>
            <tr style="background-color:#FFFFE0">
              <th colspan="5">HPP Produksi</th>
              <th style="text-align:right"><%= replace(formatcurrency(thpp),"$","") %></th>
            </tr>
        </tbody>
      </table>
    </div>
  </div>
  <% end if %>
</div>


<% call footer() %>