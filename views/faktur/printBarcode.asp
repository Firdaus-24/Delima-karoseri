<!--#include file="../../init.asp"-->
<% 
   response.buffer=false
   server.ScriptTimeout=300000

   id = trim(Request.QueryString("id"))

   call header("Barcode Barang")

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, dbo.GLB_M_Agen.AgenName, dbo.DLK_T_InvPemH.IPH_AktifYN, dbo.DLK_T_InvPemD.IPD_Item FROM dbo.DLK_T_InvPemD LEFT OUTER JOIN dbo.DLK_T_InvPemH INNER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_InvPemH.IPH_AgenId = dbo.GLB_M_Agen.AgenID ON LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) = dbo.DLK_T_InvPemH.IPH_ID LEFT OUTER JOIN dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID ON dbo.DLK_T_InvPemD.IPD_Item = dbo.DLK_M_Barang.Brg_Id WHERE (dbo.DLK_T_InvPemD.IPD_IphID = '"& id &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y')"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute

   qty = data("IPD_Qtysatuan")
   strid = id & data("IPD_Item")
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
<% For no = 1 To qty %>
   <div class="container">
      <div class="row">
         <div class="col-sm">
            <%= data("agenName") %>
         </div>
      </div>   
      <table width="100%">
         <tr>
            <td>
               <b>
               <%= qty %> / <%= no %>
               </b>
            </td>
            <td>
               <svg id="barcodeFaktur" ></svg>
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
<%next%>
</body>
<script>
JsBarcode("#barcodeFaktur", "<%=strid%>", {width: 1,height: 30, fontSize: 12});
</script>
<% call footer() %>  