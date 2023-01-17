<!--#include file="../../init.asp"-->
<% 
   agen = trim(Request.Form("agen"))
   tgl = trim(Request.Form("tgla"))

   if tgl <> "" then
      bulan = month(tgl)
      tahun = year(tgl)
   else
      bulan = ""
      tahun = ""
   end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.CommandText = "SELECT AgenId, AgenName FROM GLB_M_Agen WHERE AgenaktifYN = 'Y' ORDER BY AgenName ASC"

   set agendata = data_cmd.execute

   if tgl <> "" then
      if bulan = "1" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSBeli01 as beli, DLK_T_MutasiStok.MSJual01 as jual, DLK_T_MutasiStok.MSHBeli01 as hbeli, DLK_T_MutasiStok.MSHJual01 as hjual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 ) - DLK_T_MutasiStok.MSJual01 as tsaldoakhir, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 ) - DLK_T_MutasiStok.MSHJual01 as hargaakhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_MUtasiStok.MSItem,3) = '"& agen &"' AND (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 ) - DLK_T_MutasiStok.MSJual01 <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 ) - DLK_T_MutasiStok.MSHJual01 <> 0 AND MStahun = '"& tahun &"'ORDER BY DLK_M_Barang.Brg_Nama ASC"
      elseIf bulan = "2" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSBeli02 as beli, DLK_T_MutasiStok.MSJual02 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 ) as tsaldoakhir, DLK_T_MutasiStok.MSHBeli02 as hbeli, DLK_T_MutasiStok.MSHJual02 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 ) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_MUtasiStok.MSItem,3) = '"& agen &"' AND (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 ) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 ) <> 0 AND MStahun = '"& tahun &"'ORDER BY DLK_M_Barang.Brg_Nama ASC"
      elseIf bulan = "3" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSBeli03 as beli, DLK_T_MutasiStok.MSJual03 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 ) as tsaldoakhir, DLK_T_MutasiStok.MSHBeli03 as hbeli, DLK_T_MutasiStok.MSHJual03 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 ) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_MUtasiStok.MSItem,3) = '"& agen &"' AND (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 ) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 ) <> 0 AND MStahun = '"& tahun &"'ORDER BY DLK_M_Barang.Brg_Nama ASC"
      elseIf bulan = "4" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal,DLK_T_MutasiStok.MSBeli04 as beli, DLK_T_MutasiStok.MSJual04 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli04 as hbeli, DLK_T_MutasiStok.MSHJual04 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_MUtasiStok.MSItem,3) = '"& agen &"' AND (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04) <> 0 AND MStahun = '"& tahun &"'ORDER BY DLK_M_Barang.Brg_Nama ASC"
      elseIf bulan = "5" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli05 as beli, DLK_T_MutasiStok.MSJual05 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli05 as hbeli, DLK_T_MutasiStok.MSHJual05 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_MUtasiStok.MSItem,3) = '"& agen &"' AND (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05) <> 0 AND MStahun = '"& tahun &"'ORDER BY DLK_M_Barang.Brg_Nama ASC"
      elseIf bulan = "6" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli06 as beli, DLK_T_MutasiStok.MSJual06 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli06 as hbeli, DLK_T_MutasiStok.MSHJual06 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06) as hargaakhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_MUtasiStok.MSItem,3) = '"& agen &"' AND (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06) <> 0 AND MStahun = '"& tahun &"'ORDER BY DLK_M_Barang.Brg_Nama ASC"
      elseIf bulan = "7" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli07 as beli, DLK_T_MutasiStok.MSJual07 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli07 as hbeli, DLK_T_MutasiStok.MSHJual07 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_MUtasiStok.MSItem,3) = '"& agen &"' AND (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07) <> 0 AND MStahun = '"& tahun &"'ORDER BY DLK_M_Barang.Brg_Nama ASC"
      elseIf bulan = "8" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli08 as beli, DLK_T_MutasiStok.MSJual08 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli08 as hbeli, DLK_T_MutasiStok.MSHJual08 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_MUtasiStok.MSItem,3) = '"& agen &"' AND (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08) <> 0 AND MStahun = '"& tahun &"'ORDER BY DLK_M_Barang.Brg_Nama ASC"
      elseIf bulan = "9" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli09 as beli, DLK_T_MutasiStok.MSJual09 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli09 as hbeli, DLK_T_MutasiStok.MSHJual09 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_MUtasiStok.MSItem,3) = '"& agen &"' AND (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09) <> 0 AND MStahun = '"& tahun &"'ORDER BY DLK_M_Barang.Brg_Nama ASC"
      elseIf bulan = "10" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli10 as beli, DLK_T_MutasiStok.MSJual10 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09 + DLK_T_MutasiStok.MSBeli10) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09 + DLK_T_MutasiStok.MSJual10) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli10 as hbeli, DLK_T_MutasiStok.MSHJual10 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09 + DLK_T_MutasiStok.MSHBeli10) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09 + DLK_T_MutasiStok.MSHJual10) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_MUtasiStok.MSItem,3) = '"& agen &"' AND (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09 + DLK_T_MutasiStok.MSBeli10) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09 + DLK_T_MutasiStok.MSJual10) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09 + DLK_T_MutasiStok.MSHBeli10) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09 + DLK_T_MutasiStok.MSHJual10) <> 0 AND MStahun = '"& tahun &"'ORDER BY DLK_M_Barang.Brg_Nama ASC"
      elseIf bulan = "11" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli11 as beli, DLK_T_MutasiStok.MSJual11 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09 + DLK_T_MutasiStok.MSBeli10 + DLK_T_MutasiStok.MSBeli11) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09 + DLK_T_MutasiStok.MSJual10 + DLK_T_MutasiStok.MSJual11) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli11 as hbeli, DLK_T_MutasiStok.MSHJual11 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09 + DLK_T_MutasiStok.MSHBeli10 + DLK_T_MutasiStok.MSHBeli11) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09 + DLK_T_MutasiStok.MSHJual10 + DLK_T_MutasiStok.MSHJual11) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_MUtasiStok.MSItem,3) = '"& agen &"' AND (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09 + DLK_T_MutasiStok.MSBeli10 + DLK_T_MutasiStok.MSBeli11) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09 + DLK_T_MutasiStok.MSJual10 + DLK_T_MutasiStok.MSJual11) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09 + DLK_T_MutasiStok.MSHBeli10 + DLK_T_MutasiStok.MSHBeli11) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09 + DLK_T_MutasiStok.MSHJual10 + DLK_T_MutasiStok.MSHJual11) <> 0 AND MStahun = '"& tahun &"'ORDER BY DLK_M_Barang.Brg_Nama ASC"
      elseIf bulan = "12" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli12 as beli, DLK_T_MutasiStok.MSJual12 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09 + DLK_T_MutasiStok.MSBeli10 + DLK_T_MutasiStok.MSBeli11 + DLK_T_MutasiStok.MSBeli12) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09 + DLK_T_MutasiStok.MSJual10 + DLK_T_MutasiStok.MSJual11 + DLK_T_MutasiStok.MSJual12) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli12 as hbeli, DLK_T_MutasiStok.MSHJual12 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09 + DLK_T_MutasiStok.MSHBeli10 + DLK_T_MutasiStok.MSHBeli11 + DLK_T_MutasiStok.MSHBeli12) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09 + DLK_T_MutasiStok.MSHJual10 + DLK_T_MutasiStok.MSHJual11 + DLK_T_MutasiStok.MSHJual12) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID WHERE LEFT(DLK_T_MUtasiStok.MSItem,3) = '"& agen &"' AND (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09 + DLK_T_MutasiStok.MSBeli10 + DLK_T_MutasiStok.MSBeli11 + DLK_T_MutasiStok.MSBeli12) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09 + DLK_T_MutasiStok.MSJual10 + DLK_T_MutasiStok.MSJual11 + DLK_T_MutasiStok.MSJual12) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09 + DLK_T_MutasiStok.MSHBeli10 + DLK_T_MutasiStok.MSHBeli11 + DLK_T_MutasiStok.MSHBeli12) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09 + DLK_T_MutasiStok.MSHJual10 + DLK_T_MutasiStok.MSHJual11 + DLK_T_MutasiStok.MSHJual12) <> 0 AND MStahun = '"& tahun &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"
      end if
      data_cmd.CommandText = strsql
      ' response.write data_cmd.commandText & "<br>"
      set data = data_cmd.execute
   end if

    call header("Mutasi Stok Barang") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
   <div class="row">
      <div class="col-sm-12 text-center mt-3 mb-3">
         <h3>PROSES MUTASI STOK BARANG</h3>
      </div>
   </div>  
   <div class="row">
      <div class="col-sm mb-3">
         <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalProses">Proses</button>
      </div>
   </div>
   <form action="mutasiStok.asp" method="post">
      <div class="row">
         <div class="col-lg-3 mb-3">
               <label for="Agen">Cabang</label>
               <select class="form-select" aria-label="Default select example" name="agen" id="agen" required>
                  <option value="">Pilih</option>
                  <% do while not agendata.eof %>
                  <option value="<%= agendata("agenID") %>"><%= agendata("agenNAme") %></option>
                  <% 
                  agendata.movenext
                  loop
                  %>
               </select>
         </div>
         <div class="col-lg-3 mb-3">
               <label for="tgla">Bulan & Tahun</label>
               <input type="month" class="form-control" name="tgla" id="tgla" autocomplete="off" required>
         </div>
         <div class="col-lg mt-4 mb-3">
               <button type="submit" class="btn btn-primary">Cari</button>
               <% 
               if agen <> "" OR tgl <> "" then 
                  if not data.eof then
               %>
               <button type="button" class="btn btn-secondary" onclick="window.location.href='export-MutasiStok.asp?agen=<%=agen%>&tgl=<%=tgl%>'">Export</button>
               <% 
                  end if 
               end if %>
         </div>
      </div>
   </form>
   <% if agen <> "" then %>
   <div class="row">
      <div class="col-sm-12">
         <table class="table">
               <thead class="bg-secondary text-light">
                  <tr>
                     <th scope="col">No</th>
                     <th scope="col">Priode</th>
                     <th scope="col">Item</th>
                     <th scope="col">Qty-Awal</th>
                     <th scope="col">Harga-Awal</th>
                     <th scope="col">Qty-Beli</th>
                     <th scope="col">Harga-Beli</th>
                     <th scope="col">Qty-Jual</th>
                     <th scope="col">Harga-Jual</th>
                     <th scope="col">Qty-Akhir</th>
                     <th scope="col">Harga-Akhir</th>
                  </tr>
               </thead>
               <tbody>
                  <% 
                  no = 0
                  do while not data.eof 
                  no = no + 1
                  %>
                  <tr>
                     <th scope="row"><%= no %></th>
                     <td><%= bulan&"/"&data("MSTahun") %></td>
                     <td><%= data("Brg_Nama") %></td>
                     <td><%= data("MSAwal") %></td>
                     <td><%= replace(formatCurrency(data("MSHAwal")),"$","") %></td>
                     <td><%= data("beli") %></td>
                     <td><%= replace(formatCurrency(data("hbeli")),"$","") %></td>
                     <td><%= data("jual") %></td>
                     <td><%= replace(formatCurrency(data("hjual")),"$","") %></td>
                     <td><%= data("tsaldoakhir") %></td>
                     <td><%= replace(formatCurrency(data("hargaakhir")),"$","") %></td>
                  </tr>
                  <% 
                  response.flush
                  data.movenext
                  loop
                  %>
               </tbody>
         </table>
      </div>
   </div>  
   <% end if %>
</div>  
<!-- Modal -->
<div class="modal fade" id="modalProses" tabindex="-1" aria-labelledby="modalProsesLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
               <h1 class="modal-title fs-5" id="modalProsesLabel">Proses Mutasi Stok</h1>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
         <form action="p_mutasi.asp" method="post">
         <div class="modal-body">
            <div class="row">
               <div class="col-sm-6 mb-3">
                  <label for="pagen">Cabang</label>
                  <select class="form-select" aria-label="Default select example" name="pagen" id="pagen">
                        <option value="">Pilih</option>
                        <% 
                        agendata.MoveFirst
                        do while not agendata.eof %>
                        <option value="<%= agendata("agenID") %>"><%= agendata("agenNAme") %></option>
                        <% 
                        agendata.movenext
                        loop
                        %>
                  </select>
               </div>
               <div class="col-sm-6 mb-3">
                  <label for="pbulan">Bulan & tahun</label>
                  <input type="month" class="form-control" id="pbulan" name="pbulan">
               </div>
            </div>
         </div>
         <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-primary">Proses</button>
         </div>
         </form>
      </div>
   </div>
</div>
<% call footer() %>