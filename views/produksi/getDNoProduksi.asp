<!--#include file="../../init.asp"-->
<%  
   id = trim(Request.Form("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' cek data sudah di ajukan apa belm 
   data_cmd.commandTExt = "SELECT PDD_ID, PDD_BMID FROM DLK_T_ProduksiD WHERE PDD_ID = '"& id &"' ORDER BY PDD_BMID ASC"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute

   data_cmd.commandTExt = "SELECT DLK_M_BOMD.*, DLK_M_Barang.Brg_Nama, DLK_M_SatuanBarang.Sat_Nama, DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama FROM DLK_M_BOMD LEFT OUTER JOIN DLK_M_Barang ON DLK_M_BomD.BMDItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_satuanBarang ON DLK_M_BOMD.BMDJenisSat = DLK_M_SatuanBarang.Sat_ID INNER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID INNER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.JenisID WHERE LEFT(BMDBMID,12) = '"& data("PDD_BMID") &"' AND NOT EXISTS (SELECT DLK_T_Voucher.VCH_PDDID, DLK_T_Voucher.VCH_BMDBMID FROM DLK_T_Voucher WHERE VCH_PDDID = '"& id &"' AND VCH_BMDBMID = DLK_M_BOMD.BMDBMID)"
   ' response.write data_cmd.commandText & "<br>"
   set ddata = data_cmd.execute  
%>
<table class="table table-hover" style="font-size:12px;" style="height:15rem;">
   <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
      <tr>
         <th scope="col">No</th>
         <th scope="col">Kode</th>
         <th scope="col">Item</th>
         <th scope="col">Quantity</th>
         <th scope="col">Satuan</th>
         <th scope="col">Pilih</th>
      </tr>
   </thead>
   <tbody>
   <% 
   if not ddata.eof then
      no = 0
      do while not ddata.eof
      no = no + 1
   %>
         <tr>
            <th scope="row"><%= no %></th>
            <td><%= ddata("kategoriNama") &"-"& ddata("JenisNama") %></td>
            <td><%= ddata("Brg_Nama") %></td>
            <td><%= ddata("BMDQtty") %></td>
            <td><%= ddata("sat_Nama") %></td>
            <td>
               <div class="form-check">
                  <input class="form-check-input" type="checkbox" name="vchID" id="vchID" value="<%= ddata("BMDBMID") %>">
               </div>
            </td>
         </tr>
   <% 
      response.flush
      ddata.movenext
      loop
   else
   %>
      <tr rowspan="2">
         <th colspan="6" class="text-center">Data sudah di ajukan !!</th>
      </tr>
   <% end if %>
   </tbody>
</table>