<% response.buffer = true %>
<!--#include file="../../init.asp"-->
<% 
   call header("Proses Mutasi")

   response.write "<div class='loader' style='width:100%;height:100%;line-height:200px;text-align:center;line-height: 3.5;display:inline-block;vertical-align: middle;'><img src='../../public/img/DLL.gif'></div>"


   pbulan = trim(Request.Form("pbulan"))
   pagen = trim(Request.Form("pagen"))

   bulan = month(pbulan)
   tahun = year(pbulan)

   set nthn =  Server.CreateObject ("ADODB.Command")
   nthn.ActiveConnection = mm_delima_string 

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string 

   data_cmd.commandText = "SELECT DLK_M_Barang.Brg_ID, ISNULL((SELECT SUM(dbo.DLK_T_InvPemD.IPD_QtySatuan) AS beli FROM  dbo.DLK_T_InvPemD LEFT OUTER JOIN dbo.DLK_T_InvPemH ON LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) = dbo.DLK_T_InvPemH.IPH_ID WHERE (dbo.DLK_T_InvPemH.IPH_AgenId = '"& pagen &"') AND (Month(dbo.DLK_T_InvPemH.IPH_Date) = '"& bulan &"') AND  (Year(dbo.DLK_T_InvPemH.IPH_Date) = '"& tahun &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemD.IPD_Item = DLK_M_Barang.Brg_ID) GROUP BY dbo.DLK_T_InvPemD.IPD_Item), 0) AS beli, ISNULL((SELECT SUM(dbo.DLK_T_InvPemD.IPD_QtySatuan * dbo.DLK_T_InvPemD.IPD_Harga) AS hbeli FROM dbo.DLK_T_InvPemD LEFT OUTER JOIN dbo.DLK_T_InvPemH ON LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) = dbo.DLK_T_InvPemH.IPH_ID WHERE (dbo.DLK_T_InvPemH.IPH_AgenId = '"& pagen &"') AND (Month(dbo.DLK_T_InvPemH.IPH_Date) = '"& bulan &"') AND (Year(dbo.DLK_T_InvPemH.IPH_Date) = '"& tahun &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemD.IPD_Item = DLK_M_Barang.Brg_ID) GROUP BY dbo.DLK_T_InvPemD.IPD_Item),0) AS hbeli, ISNULL((SELECT SUM(dbo.DLK_T_InvJulD.IJD_QtySatuan) AS jual FROM dbo.DLK_T_InvJulH RIGHT OUTER JOIN dbo.DLK_T_InvJulD ON dbo.DLK_T_InvJulH.IJH_ID = LEFT(dbo.DLK_T_InvJulD.IJD_IJHID, 13) WHERE (dbo.DLK_T_InvJulH.IJH_agenID = '"& pagen &"') AND (Month(dbo.DLK_T_InvJulH.IJH_Date) = '"& bulan &"') AND (Year(dbo.DLK_T_InvJulH.IJH_Date) = '"& tahun &"') AND (dbo.DLK_T_InvJulH.IJH_AktifYN = 'Y') AND (dbo.DLK_T_InvJulD.IJD_Item = DLK_M_Barang.Brg_ID) GROUP BY DLK_T_InvJulD.IJD_Item), 0) AS jual, ISNULL((SELECT SUM(dbo.DLK_T_InvJulD.IJD_QtySatuan * dbo.DLK_T_InvJulD.IJD_Harga) AS hjual FROM dbo.DLK_T_InvJulH RIGHT OUTER JOIN dbo.DLK_T_InvJulD ON dbo.DLK_T_InvJulH.IJH_ID = LEFT(dbo.DLK_T_InvJulD.IJD_IJHID, 13) WHERE (dbo.DLK_T_InvJulH.IJH_agenID = '"& pagen &"') AND (Month(dbo.DLK_T_InvJulH.IJH_Date) = '"& bulan &"') AND (Year(dbo.DLK_T_InvJulH.IJH_Date) = '"& tahun &"') AND (dbo.DLK_T_InvJulH.IJH_AktifYN = 'Y') AND (dbo.DLK_T_InvJulD.IJD_Item = DLK_M_Barang.Brg_ID) GROUP BY DLK_T_InvJulD.IJD_Item),0) AS hjual FROM DLK_M_Barang WHERE ((SELECT ISNULL(SUM(dbo.DLK_T_InvPemD.IPD_QtySatuan), 0) AS beli FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) WHERE (dbo.DLK_T_InvPemH.IPH_AgenId = '"& pagen &"') AND (Month(dbo.DLK_T_InvPemH.IPH_Date) = '"& bulan &"') AND (Year(dbo.DLK_T_InvPemH.IPH_Date) = '"& tahun &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemD.IPD_Item = DLK_M_Barang.Brg_ID) GROUP BY dbo.DLK_T_InvPemD.IPD_Item) <> 0) OR ((SELECT ISNULL(SUM(dbo.DLK_T_InvJulD.IJD_QtySatuan), 0) AS jual FROM dbo.DLK_T_InvJulH RIGHT OUTER JOIN dbo.DLK_T_InvJulD ON dbo.DLK_T_InvJulH.IJH_ID = LEFT(dbo.DLK_T_InvJulD.IJD_IJHID, 13) WHERE (dbo.DLK_T_InvJulH.IJH_agenID = '"& pagen &"') AND (Month(dbo.DLK_T_InvJulH.IJH_Date) = '"& bulan &"') AND (Year(dbo.DLK_T_InvJulH.IJH_Date) = '"& tahun &"') AND (dbo.DLK_T_InvJulH.IJH_AktifYN = 'Y') AND (dbo.DLK_T_InvJulD.IJD_Item = DLK_M_Barang.Brg_ID) GROUP BY dbo.DLK_T_InvJulD.IJD_Item) <> 0) ORDER BY DLK_M_Barang.Brg_Nama ASC"
   ' response.write data_cmd.commandText & "<br>" 
   set data = data_cmd.execute

   do while not data.eof 
      data_cmd.commandText = "SELECT * FROM DLK_T_MutasiStok WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'"
      ' response.write data_cmd.commandText & "<br>"
      set mutasi = data_cmd.execute

      if mutasi.eof then
         call query("INSERT INTO DLK_T_MutasiStok (MSTahun,MSAwal,MSHAwal,MSItem,MSBeli01,MSHBeli01,MSJual01,MSHJual01,MSBeli02,MSHBeli02,MSJual02,MSHJual02,MSBeli03,MSHBeli03,MSJual03,MSHJual03,MSBeli04,MSHBeli04,MSJual04,MSHJual04,MSBeli05,MSHBeli05,MSJual05,MSHJual05,MSBeli06,MSHBeli06,MSJual06,MSHJual06,MSBeli07,MSHBeli07,MSJual07,MSHJual07,MSBeli08,MSHBeli08,MSJual08,MSHJual08,MSBeli09,MSHBeli09,MSJual09,MSHJual09,MSBeli10,MSHBeli10,MSJual10,MSHJual10,MSBeli11,MSHBeli11,MSJual11,MSHJual11,MSBeli12,MSHBeli12,MSJual12,MSHJual12) VALUES ('"& tahun &"', '0', '0', '"& data("Brg_ID") &"', '0','0','0','0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0','0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0')")

         if bulan = "1" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli01 = '"& data("beli") &"' , MSHBeli01 = '"& data("hbeli") &"' , MSJual01 = '"& data("jual") &"', MSHJual01 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MSTahun = '"& tahun &"'")
         elseIf bulan = "2" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli02 = '"& data("beli") &"' , MSJual02 = '"& data("jual") &"', MSHBeli02 = '"& data("hbeli") &"' , MSHJual02 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MSTahun = '"& tahun &"'")
         elseIf bulan = "3" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli03 = '"& data("beli") &"' , MSJual03 = '"& data("jual") &"', MSHBeli03 = '"& data("hbeli") &"' , MSHJual03 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "4" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli04 = '"& data("beli") &"' , MSJual04 = '"& data("jual") &"', MSHBeli04 = '"& data("hbeli") &"' , MSHJual04 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "5" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli05 = '"& data("beli") &"' , MSJual05 = '"& data("jual") &"', MSHBeli05 = '"& data("hbeli") &"' , MSHJual05 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "6" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli06 = '"& data("beli") &"' , MSJual06 = '"& data("jual") &"', MSHBeli06 = '"& data("hbeli") &"' , MSHJual06 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "7" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli07 = '"& data("beli") &"' , MSJual07 = '"& data("jual") &"', MSHBeli07 = '"& data("hbeli") &"' , MSHJual07 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "8" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli08 = '"& data("beli") &"' , MSJual08 = '"& data("jual") &"', MSHBeli08 = '"& data("hbeli") &"' , MSHJual08 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "9" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli09 = '"& data("beli") &"' , MSJual09 = '"& data("jual") &"', MSHBeli09 = '"& data("hbeli") &"' , MSHJual09 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "10" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli10 = '"& data("beli") &"' , MSJual10 = '"& data("jual") &"', MSHBeli10 = '"& data("hbeli") &"' , MSHJual10 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "11" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli11 = '"& data("beli") &"' , MSJual11 = '"& data("jual") &"', MSHBeli11 = '"& data("hbeli") &"' , MSHJual11 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "12" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli12 = '"& data("beli") &"' , MSJual12 = '"& data("jual") &"', MSHBeli12 = '"& data("hbeli") &"' , MSHJual12 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         end if
      else
         if bulan = "1" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli01 = '"& data("beli") &"' , MSJual01 = '"& data("jual") &"', MSHBeli01 = '"& data("hbeli") &"' , MSHJual01 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "2" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli02 = '"& data("beli") &"' , MSJual02 = '"& data("jual") &"', MSHBeli02 = '"& data("hbeli") &"' , MSHJual02 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "3" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli03 = '"& data("beli") &"' , MSJual03 = '"& data("jual") &"', MSHBeli03 = '"& data("hbeli") &"' , MSHJual03 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "4" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli04 = '"& data("beli") &"' , MSJual04 = '"& data("jual") &"', MSHBeli04 = '"& data("hbeli") &"' , MSHJual04 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "5" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli05 = '"& data("beli") &"' , MSJual05 = '"& data("jual") &"', MSHBeli05 = '"& data("hbeli") &"' , MSHJual05 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "6" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli06 = '"& data("beli") &"' , MSJual06 = '"& data("jual") &"', MSHBeli06 = '"& data("hbeli") &"' , MSHJual06 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "7" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli07 = '"& data("beli") &"' , MSJual07 = '"& data("jual") &"', MSHBeli07 = '"& data("hbeli") &"' , MSHJual07 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "8" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli08 = '"& data("beli") &"' , MSJual08 = '"& data("jual") &"', MSHBeli08 = '"& data("hbeli") &"' , MSHJual08 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "9" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli09 = '"& data("beli") &"' , MSJual09 = '"& data("jual") &"', MSHBeli09 = '"& data("hbeli") &"' , MSHJual09 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "10" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli10 = '"& data("beli") &"' , MSJual10 = '"& data("jual") &"', MSHBeli10 = '"& data("hbeli") &"' , MSHJual10 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "11" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli11 = '"& data("beli") &"' , MSJual11 = '"& data("jual") &"', MSHBeli11 = '"& data("hbeli") &"' , MSHJual11 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         elseIf bulan = "12" then
            call query("UPDATE DLK_T_MutasiStok SET MSBeli12 = '"& data("beli") &"' , MSJual12 = '"& data("jual") &"', MSHBeli12 = '"& data("hbeli") &"' , MSHJual12 = '"& data("hjual") &"' WHERE MSItem = '"& data("Brg_ID") &"' AND MsTahun = '"& tahun &"'")
         end if
      end if

   response.flush
   data.movenext
   loop

   ntahun = tahun + 1
   if bulan = "12" then

      nthn.commandText = "SELECT MSItem, MSAwal + ((MSBeli01 + MSBeli02 + MSBeli03 + MSBeli04 + MSBeli05 + MSBeli06 + MSBeli07 + MSBeli08 + MSBeli09 + MSBeli10 + MSBeli11 + MSBeli12) - (MSJual01+MSJual02+MSJual03+MSJual04 + MSJual05 + MSJual06 + MSJual07 + MSJual08 + MSJual09 + MSJual10 + MSJual11 + MSJual12)) as saldoakhir , MSHAwal + ((MSHBeli01 + MSHBeli02 + MSHBeli03 + MSHBeli04 + MSHBeli05 + MSHBeli06 + MSHBeli07 + MSHBeli08 + MSHBeli09 + MSHBeli10 + MSHBeli11 + MSHBeli12) - (MSHJual01+MSHJual02+MSHJual03+MSHJual04 + MSHJual05 + MSHJual06 + MSHJual07 + MSHJual08 + MSHJual09 + MSHJual10 + MSHJual11 + MSHJual12)) as hargaakhir FROM DLK_T_MutasiStok WHERE (MSTahun = '"& tahun &"') and isnull(MSItem,'') <> '' and ( MSAwal + ((MSBeli01 + MSBeli02 + MSBeli03 + MSBeli04 + MSBeli05 + MSBeli06 + MSBeli07 + MSBeli08 + MSBeli09 + MSBeli10 + MSBeli11 + MSBeli12) - (MSJual01+MSJual02+MSJual03+MSJual04 + MSJual05 + MSJual06 + MSJual07 + MSJual08 + MSJual09 + MSJual10 + MSJual11 + MSJual12)) <> 0) OR ( MSHAwal + ((MSHBeli01 + MSHBeli02 + MSHBeli03 + MSHBeli04 + MSHBeli05 + MSHBeli06 + MSHBeli07 + MSHBeli08 + MSHBeli09 + MSHBeli10 + MSHBeli11 + MSHBeli12) - (MSHJual01+MSHJual02+MSHJual03+MSHJual04 + MSHJual05 + MSHJual06 + MSHJual07 + MSHJual08 + MSHJual09 + MSHJual10 + MSHJual11 + MSHJual12)) <> 0) order by MSItem"
      ' Response.Write nthn.commandText & "<br>"
      set sapk = nthn.execute

      do while not sapk.eof
         nthn.commandText = "SELECT * FROM DLK_T_MutasiStok WHERE MSItem = '"& sapk("MSItem") &"' AND MSTahun = '"& ntahun &"'"
         
         set tahunBaru = nthn.execute
         
            if tahunBaru.eof then
               call query("INSERT INTO DLK_T_MutasiStok (MSTahun,MSAwal,MSHAwal,MSItem,MSBeli01,MSHBeli01,MSJual01,MSHJual01,MSBeli02,MSHBeli02,MSJual02,MSHJual02,MSBeli03,MSHBeli03,MSJual03,MSHJual03,MSBeli04,MSHBeli04,MSJual04,MSHJual04,MSBeli05,MSHBeli05,MSJual05,MSHJual05,MSBeli06,MSHBeli06,MSJual06,MSHJual06,MSBeli07,MSHBeli07,MSJual07,MSHJual07,MSBeli08,MSHBeli08,MSJual08,MSHJual08,MSBeli09,MSHBeli09,MSJual09,MSHJual09,MSBeli10,MSHBeli10,MSJual10,MSHJual10,MSBeli11,MSHBeli11,MSJual11,MSHJual11,MSBeli12,MSHBeli12,MSJual12,MSHJual12) VALUES ('"& ntahun &"', '0', '0', '"& sapk("MSItem") &"','0','0','0','0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0','0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0')")
            end if 
         call query("UPDATE DLK_T_MutasiStok SET MSAwal = "& sapk("saldoakhir") &", MSHawal = '"& sapk("hargaakhir") &"' WHERE MSTahun = '"& ntahun &"' AND MSItem = '"& sapk("MSItem") &"'")
      response.flush
      sapk.movenext
      loop
   end if
   response.write "<script>"
      response.write "window.location.href = 'mutasiStok.asp'"
   response.write "</script>"

   call footer() 

%>