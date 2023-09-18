<% response.buffer = true %>
<!--#include file="../../init.asp"-->
<% 
   if session("INV7A") = false then
      Response.Redirect("./")
   end if
   call header("Proses Mutasi")

   response.write "<div class='loader' style='width:100%;height:100%;line-height:200px;text-align:center;line-height: 3.5;display:inline-block;vertical-align: middle;'><img src='../../public/img/DLL.gif'></div>"


   pbulan = trim(Request.Form("pbulan"))
   pagen = trim(Request.Form("pagen"))

   bulan = month(pbulan)
   tahun = year(pbulan)
   ntahun = tahun + 1

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
   data_cmd.commandText = "SELECT Brg_Id, Brg_Nama, (SELECT ISNULL(SUM(MR_Qtysatuan), 0) AS masuk FROM dbo.DLK_T_MaterialReceiptD2 WHERE MR_Item = Brg_Id AND YEAR(MR_AcpDate) = '"& tahun &"' AND month(MR_AcpDate) = '"& bulan &"') as masuk, (SELECT ISNULL(SUM(MR_Harga * MR_Qtysatuan), 0) AS harga FROM dbo.DLK_T_MaterialReceiptD2 WHERE MR_Item = Brg_Id AND YEAR(MR_AcpDate) = '"& tahun &"' AND month(MR_AcpDate) = '"& bulan &"') as mharga, (SELECT ISNULL(SUM(MO_Qtysatuan),0) as keluar FROM dbo.DLK_T_MaterialOutD where MO_Item = Brg_Id AND YEAR(MO_Date) = '"& tahun &"' AND month(MO_Date) = '"& bulan &"') AS keluar, (SELECT ISNULL(SUM(MO_Harga * MO_Qtysatuan),0) as kharga FROM dbo.DLK_T_MaterialOutD where MO_Item = Brg_Id AND YEAR(MO_Date) = '"& tahun &"' AND month(MO_Date) = '"& bulan &"') AS kharga FROM dbo.DLK_M_Barang WHERE (Brg_AktifYN = 'Y') AND (SELECT ISNULL(SUM(MR_Qtysatuan), 0) AS masuk FROM dbo.DLK_T_MaterialReceiptD2 WHERE MR_Item = Brg_Id AND YEAR(MR_AcpDate) = '"& tahun &"' AND month(MR_AcpDate) = '"& bulan &"') <> 0 OR (SELECT ISNULL(SUM(MO_Qtysatuan),0) as keluar FROM dbo.DLK_T_MaterialOutD where MO_Item = Brg_Id AND YEAR(MO_Date) = '"& tahun &"' AND month(MO_Date) = '"& bulan &"') <> 0"
   ' response.write data_cmd.commandText & "<br>"
   set data = data_cmd.execute

   do while not data.eof
      data_cmd.commandText = "SELECT * FROM DLK_T_MutasiStok WHERE MsTahun = '"& tahun &"' AND MsItem = '"& data("Brg_ID") &"'"

      set ckmutasi = data_cmd.execute 

      if not ckmutasi.eof then
         call query("UPDATE DLK_T_MutasiStok SET "& strbeli &" = "& data("masuk") &", "& strHbeli &" = '"& data("mharga") &"', "& strjual &" = "& data("keluar") &", "& strHjual &" = '"& data("kharga") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MSTahun = '"& tahun &"'")
      else
         call query("INSERT INTO DLK_T_MutasiStok (MsTahun, MSAwal, MsHawal, MsItem, MsBeli01, MsHBeli01, MsJual01, MsHJual01, MsBeli02, MsHBeli02, MsJual02, MsHJual02, MsBeli03, MsHBeli03, MsJual03, MsHJual03, MsBeli04, MsHBeli04, MsJual04, MsHJual04, MsBeli05, MsHBeli05, MsJual05, MsHJual05, MsBeli06, MsHBeli06, MsJual06, MsHJual06, MsBeli07, MsHBeli07, MsJual07, MsHJual07, MsBeli08, MsHBeli08, MsJual08, MsHJual08, MsBeli09, MsHBeli09, MsJual09, MsHJual09, MsBeli10, MsHBeli10, MsJual10, MsHJual10, MsBeli11, MsHBeli11, MsJual11, MsHJual11, MsBeli12, MsHBeli12, MsJual12, MsHJual12) VALUES ('"& tahun &"', 0, '0', '"& data("Brg_ID") &"', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0',  0, '0', 0, '0',  0, '0', 0, '0',  0, '0', 0, '0',  0, '0', 0, '0',  0, '0', 0, '0')")

         ' update harga dan quantyy baru 
         call query("UPDATE DLK_T_MutasiStok SET "& strbeli &" = "& data("masuk") &", "& strHbeli &" = '"& data("mharga") &"', "& strjual &" = "& data("keluar") &", "& strHjual &" = '"& data("kharga") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MSTahun = '"& tahun &"' ")

      end if
   response.flush
   data.movenext
   loop
   if bulan = "12" then
      data_cmd.commandText = "SELECT MsItem, (MsAwal + (MsBeli01 + MsBeli02 + MsBeli03 + MsBeli04 + MsBeli05 + MsBeli06 + MsBeli07 + MsBeli08 + MsBeli09 + MsBeli10 + MsBeli11 + MsBeli12) - (MsJual01 + MsJual02 + MsJual03 + MsJual04 + MsJual05 + MsJual06 + MsJual07 + MsJual08 + MsJual09 + MsJual10 + MsJual11 + MsJual12 )) as saldoQty, (MSHawal + (MsHBeli01 + MsHBeli02 + MsHBeli03 + MsHBeli04 + MsHBeli05 + MsHBeli06 + MsHBeli07 + MsHBeli08 + MsHBeli09 + MsHBeli10 + MsHBeli11 + MsHBeli12) - (MsHJual01 + MsHJual02 + MsHJual03 + MsHJual04 + MsHJual05 + MsHJual06 + MsHJual07 + MsHJual08 + MsHJual09 + MsHJual10 + MsHJual11 + MsHJual12 ) ) as saldoHarga FROM DLK_T_MutasiStok WHERE MSTahun = '"& tahun &"' AND ISNULL(MsItem,'') <> '' AND (MsAwal + (MsBeli01 + MsBeli02 + MsBeli03 + MsBeli04 + MsBeli05 + MsBeli06 + MsBeli07 + MsBeli08 + MsBeli09 + MsBeli10 + MsBeli11 + MsBeli12) - (MsJual01 + MsJual02 + MsJual03 + MsJual04 + MsJual05 + MsJual06 + MsJual07 + MsJual08 + MsJual09 + MsJual10 + MsJual11 + MsJual12 )) <> 0 OR (MSHawal + (MsHBeli01 + MsHBeli02 + MsHBeli03 + MsHBeli04 + MsHBeli05 + MsHBeli06 + MsHBeli07 + MsHBeli08 + MsHBeli09 + MsHBeli10 + MsHBeli11 + MsHBeli12) - (MsHJual01 + MsHJual02 + MsHJual03 + MsHJual04 + MsHJual05 + MsHJual06 + MsHJual07 + MsHJual08 + MsHJual09 + MsHJual10 + MsHJual11 + MsHJual12 ) ) <> 0 "

      set newData = data_cmd.execute 

      Do While not newData.eof
         data_cmd.commandText = "SELECT * FROM DLK_T_MUtasiStok WHERE MSTahun = '"& ntahun &"' AND MSItem = '"& newData("MSItem") &"'"
         ' response.write data_cmd.commandText &  "<br>"
         set ckNewData = data_cmd.execute

         if ckNewData.eof then
            call query("INSERT INTO DLK_T_MutasiStok (MsTahun, MSAwal, MsHawal, MsItem, MsBeli01, MsHBeli01, MsJual01, MsHJual01, MsBeli02, MsHBeli02, MsJual02, MsHJual02, MsBeli03, MsHBeli03, MsJual03, MsHJual03, MsBeli04, MsHBeli04, MsJual04, MsHJual04, MsBeli05, MsHBeli05, MsJual05, MsHJual05, MsBeli06, MsHBeli06, MsJual06, MsHJual06, MsBeli07, MsHBeli07, MsJual07, MsHJual07, MsBeli08, MsHBeli08, MsJual08, MsHJual08, MsBeli09, MsHBeli09, MsJual09, MsHJual09, MsBeli10, MsHBeli10, MsJual10, MsHJual10, MsBeli11, MsHBeli11, MsJual11, MsHJual11, MsBeli12, MsHBeli12, MsJual12, MsHJual12) VALUES ('"& ntahun &"', 0, '0', '"& newData("MSItem") &"', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0', 0, '0',  0, '0', 0, '0',  0, '0', 0, '0',  0, '0', 0, '0',  0, '0', 0, '0',  0, '0', 0, '0',  0, '0', 0, '0')")
         end if
         call query("UPDATE DLK_T_MUtasiStok SET MSAwal = "& newData("saldoQty") &", MSHAwal = '"& newData("saldoHarga") &"' WHERE MSTahun = '"& ntahun &"' AND MSItem = '"& newData("Msitem") &"'")
      response.flush
      newData.movenext
      Loop

   end if

   response.write "<script>"
      response.write "window.location.href = 'mutasiStok.asp'"
   response.write "</script>"

   call footer()
%>