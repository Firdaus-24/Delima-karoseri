<!--#include file="../../init.asp"-->
<% 
   response.buffer=false
   server.ScriptTimeout=300000

   id = trim(Request.QueryString("id"))

   call header("Barcode Produksi")

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT DLK_T_ProduksiD.*,  dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Barang.Brg_Nama FROM DLK_M_Barang RIGHT OUTER JOIN  DLK_T_ProduksiD ON DLK_T_ProduksiD.PDD_Item = DLK_M_Barang.Brg_ID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE PDD_ID = '"& id &"' ORDER BY PDD_ID ASC"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute

   ' qty = data("IPD_Qtysatuan")
   strid = id & data("PDD_Item")
%> 
<style>
   body{
      width: 100%;
      height: 100%;
      margin: 0;
      padding: 0;
      font: 12pt ;
      page-break-before:auto;
   }
   .container{
      width: 3.5in;
      height: 2.4in;
      background: white;
      box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
   }
   .description{
      margin:0;
      padding-left:5px;
      font-size:12px;
      position:relative;
   }
   .description p{
      margin-top:0;
      margin-bottom:0;
      position:absolute;
   }
   .description span{
      bottom:0;
      position:absolute;
   }
   @media print {
      body {
         margin: 0.5mm 0.1mm 0.1mm 0.1mm; 
      } 
      .container{
         size: 7in 9in;
         clear: both;
         page-break-after: always;
      }
   } 
</style>
<body onload="window.print()">
   <div class="container">
      <div class="row">
         <div class="col-sm">
            <% call getAgen(mid(data("PDD_id"),3,3),"p") %>
         </div>
      </div>   
      <table width="100%">
         <tr>
            <td>
               <b>
               Produksi
               </b>
            </td>
            <td>
               <svg id="barcodeNoPrduksiD" ></svg>
            </td>
         </tr>
         <tr>
            <td>
               <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= strid %>&chs=160x160&chld=L|0" width="100" />
            </td>
            <td class="description">
               <p><%= data("Brg_Nama") %></p>
               </br>
               <p>Kode : <%= data("KategoriNama") &"-"& data("JenisNama") %></p>
               </br>
               <span>www.delimakaroseriindonesia.co.id</span>
            </td>
         </tr>
      </table>
   </div>
</body>
<script>
JsBarcode("#barcodeNoPrduksiD", "<%=strid%>", {width: 1,height: 30, fontSize: 12});
</script>
<% call footer() %>  