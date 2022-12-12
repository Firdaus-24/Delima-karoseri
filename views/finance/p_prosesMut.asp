<% response.buffer = true %>
<!--#include file="../../init.asp"-->
<% 
   call header("Proses Mutasi")

   response.write "<div class='loader' style='width:100%;height:100%;line-height:200px;text-align:center;line-height: 3.5;display:inline-block;vertical-align: middle;'><img src='../../public/img/DLL.gif'></div>"


   pbulan = trim(Request.Form("pbulan"))
   pagen = trim(Request.Form("pagen"))

   bulan = month(pbulan)
   tahun = year(pbulan)

   ' cek nilai bulan 
   if bulan = "1" then
      strbeli = "MSBeli01"
      strHbeli = "MSHBeli01"
      strjual = "MSJual01"
      strHjual = "MSHJual01"
   elseif bulan = "2" then
      strbeli = "MSBeli02"
      strHbeli = "MSHBeli02"
      strjual = "MSJual02"
      strHjual = "MSHJual02"
   elseif bulan = "3" then
      strbeli = "MSBeli03"
      strHbeli = "MSHBeli03"
      strjual = "MSJual03"
      strHjual = "MSHJual03"
   elseif bulan = "4" then
      strbeli = "MSBeli04"
      strHbeli = "MSHBeli04"
      strjual = "MSJual04"
      strHjual = "MSHJual04"
   elseif bulan = "5" then
      strbeli = "MSBeli05"
      strHbeli = "MSHBeli05"
      strjual = "MSJual05"
      strHjual = "MSHJual05"
   elseif bulan = "6" then
      strbeli = "MSBeli06"
      strHbeli = "MSHBeli06"
      strjual = "MSJual06"
      strHjual = "MSHJual06"
   elseif bulan = "7" then
      strbeli = "MSBeli07"
      strHbeli = "MSHBeli07"
      strjual = "MSJual07"
      strHjual = "MSHJual07"
   elseif bulan = "8" then
      strbeli = "MSBeli08"
      strHbeli = "MSHBeli08"
      strjual = "MSJual08"
      strHjual = "MSHJual08"
   elseif bulan = "9" then
      strbeli = "MSBeli09"
      strHbeli = "MSHBeli09"
      strjual = "MSJual09"
      strHjual = "MSHJual09"
   elseif bulan = "10" then
      strbeli = "MSBeli10"
      strHbeli = "MSHBeli10"
      strjual = "MSJual10"
      strHjual = "MSHJual10"
   elseif bulan = "11" then
      strbeli = "MSBeli11"
      strHbeli = "MSHBeli11"
      strjual = "MSJual11"
      strHjual = "MSHJual11"
   elseif bulan = "12" then
      strbeli = "MSBeli12"
      strHbeli = "MSHBeli12"
      strjual = "MSJual12"
      strHjual = "MSHJual12"
   else
      strbeli = ""
      strHbeli = ""
      strjual = ""
      strHjual = ""
   end if

   set nthn =  Server.CreateObject ("ADODB.Command")
   nthn.ActiveConnection = mm_delima_string 

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string 
   ' get header table
   data_cmd.commandText = "SELECT IPH_ID as id,IPH_AgenId,IPH_Date,IPH_DiskonAll,IPH_Ppn FROM dbo.DLK_T_InvPemH WHERE (dbo.DLK_T_InvPemH.IPH_AgenId = '"& pagen &"') AND (Month(dbo.DLK_T_InvPemH.IPH_Date) = '"& bulan &"') AND (Year(dbo.DLK_T_InvPemH.IPH_Date) = '"& tahun &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') UNION ALL SELECT  IJH_ID,IJH_agenID,IJH_Date,IJH_DiskonAll,IJH_PPn FROM dbo.DLK_T_InvJulH WHERE (dbo.DLK_T_InvJulH.IJH_agenID = '"& pagen &"') AND (Month(dbo.DLK_T_InvJulH.IJH_Date) = '"& bulan &"') AND (Year(dbo.DLK_T_InvJulH.IJH_Date) = '"& tahun &"') AND (dbo.DLK_T_InvJulH.IJH_AktifYN = 'Y')"

   set data = data_cmd.execute
   harga = 0
   do while not data.eof
      ' cek faktur pembelian
      if LEFT(data("id"),2) = "FR" then
         ' cek data detail
         data_cmd.commandText = "SELECT DLK_T_InvPemD.*, DLK_M_Barang.Brg_ID FROM DLK_T_InvPemD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_InvPemD.IPD_Item = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_InvPemD.IPD_IPHID,13) = '"& data("id") &"' ORDER BY Brg_ID"
         ' response.write data_cmd.commandText & "<br>"
         set detail1 = data_cmd.execute

         qry = 0
         harga = 0
         do while not detail1.eof
            ' cek barang yang di return
            data_cmd.commandText = "SELECT RBD_IPDIPHID,RBD_Item,ISNULL(RBD_QtySatuan,0) as qtyreturn FROM dbo.DLK_T_ReturnBarangD LEFT OUTER JOIN DLK_T_ReturnBarangH ON LEFT(DLK_T_ReturnBarangD.RBD_RBID,12) = DLK_T_ReturnBarangH.RB_ID WHERE RBD_IPDIPHID = '"& detail1("IPD_IPHID") &"' AND Month(RB_Date) = '"& bulan &"' AND Year(RB_Date) = '"& tahun &"'"
            ' response.write data_cmd.commandText & "<br>"
            set returnB = data_cmd.execute

            if not returnb.eof then
               qtyreturn = Cint(returnB("qtyreturn"))
            else
               qtyreturn = 0
            end if

            ' cek data mutasi
            data_cmd.commandText = "SELECT * FROM DLK_T_MutasiStok WHERE MSTahun = '"& tahun &"' AND MSItem = '"& detail1("Brg_ID") &"'"
         response.flush
         detail1.movenext
         loop
      else 'cek faktur penjualan
         data_cmd.commandText = "SELECT * FROM DLK_T_InvJulD WHERE LEFT(DLK_T_InvJulD.IJD_IJHID,13) = '"& data("id") &"'"
         ' response.write data_cmd.commandText & "<br>"
         set datail2 = data_cmd.execute
      end if
   response.flush
   data.movenext
   loop
   response.write qty & "<br>"
%>