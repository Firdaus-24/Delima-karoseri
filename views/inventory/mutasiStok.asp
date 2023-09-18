<!--#include file="../../init.asp"-->
<% 
   if session("INV7") = false then
      Response.Redirect("./")
   end if

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.CommandText = "SELECT AgenId, AgenName FROM GLB_M_Agen WHERE AgenaktifYN = 'Y' ORDER BY AgenName ASC"

   set agendata = data_cmd.execute

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
   
   agen = request.QueryString("agen")
   if len(agen) = 0 then 
      agen = trim(Request.Form("agen"))
   end if

   tgl = request.QueryString("tgla")
   if len(tgl) = 0 then 
      tgl = trim(Request.Form("tgla"))
   end if

   nama = request.QueryString("nama")
   if len(nama) = 0 then 
      nama = trim(Request.Form("nama"))
   end if

   if tgl <> "" then
      bulan = month(tgl)
      tahun = year(tgl)
   else
      bulan = ""
      tahun = ""
   end if

   if agen <> "" then
      filterAgen = "AND LEFT(DLK_T_MUtasiStok.MSItem,3) = '"& agen &"' "
   else
      filterAgen = " AND LEFT(Brg_ID,3) = '"&session("server-id")&"' "
   end if
   
   if nama <> "" then
      filternama = " AND UPPER(DLK_M_Barang.Brg_nama) LIKE '%"& ucase(nama) &"%'"
   else
      filternama = ""
   end if

   if tgl <> "" then
      if bulan = "1" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSBeli01 as beli, DLK_T_MutasiStok.MSJual01 as jual, DLK_T_MutasiStok.MSHBeli01 as hbeli, DLK_T_MutasiStok.MSHJual01 as hjual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 ) - DLK_T_MutasiStok.MSJual01 as tsaldoakhir, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 ) - DLK_T_MutasiStok.MSHJual01 as hargaakhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 ) - DLK_T_MutasiStok.MSJual01 <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 ) - DLK_T_MutasiStok.MSHJual01 <> 0 AND MStahun = '"& tahun &"' "& filterAgen &" "& filterNama &" "
      elseIf bulan = "2" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSBeli02 as beli, DLK_T_MutasiStok.MSJual02 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 ) as tsaldoakhir, DLK_T_MutasiStok.MSHBeli02 as hbeli, DLK_T_MutasiStok.MSHJual02 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 ) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 ) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 ) <> 0 AND MStahun = '"& tahun &"' "& filterAgen &" "& filterNama &" "
      elseIf bulan = "3" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSBeli03 as beli, DLK_T_MutasiStok.MSJual03 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 ) as tsaldoakhir, DLK_T_MutasiStok.MSHBeli03 as hbeli, DLK_T_MutasiStok.MSHJual03 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 ) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 ) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 ) <> 0 AND MStahun = '"& tahun &"' "& filterAgen &" "& filterNama &" "
      elseIf bulan = "4" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal,DLK_T_MutasiStok.MSBeli04 as beli, DLK_T_MutasiStok.MSJual04 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli04 as hbeli, DLK_T_MutasiStok.MSHJual04 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04) <> 0 AND MStahun = '"& tahun &"' "& filterAgen &" "& filterNama &" "
      elseIf bulan = "5" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli05 as beli, DLK_T_MutasiStok.MSJual05 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli05 as hbeli, DLK_T_MutasiStok.MSHJual05 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05) <> 0 AND MStahun = '"& tahun &"' "& filterAgen &" "& filterNama &" "
      elseIf bulan = "6" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli06 as beli, DLK_T_MutasiStok.MSJual06 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli06 as hbeli, DLK_T_MutasiStok.MSHJual06 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06) as hargaakhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06) <> 0 AND MStahun = '"& tahun &"' "& filterAgen &" "& filterNama &" "
      elseIf bulan = "7" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli07 as beli, DLK_T_MutasiStok.MSJual07 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli07 as hbeli, DLK_T_MutasiStok.MSHJual07 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07) <> 0 AND MStahun = '"& tahun &"' "& filterAgen &" "& filterNama &" "
      elseIf bulan = "8" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli08 as beli, DLK_T_MutasiStok.MSJual08 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli08 as hbeli, DLK_T_MutasiStok.MSHJual08 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08) <> 0 AND MStahun = '"& tahun &"' "& filterAgen &" "& filterNama &" "
      elseIf bulan = "9" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli09 as beli, DLK_T_MutasiStok.MSJual09 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli09 as hbeli, DLK_T_MutasiStok.MSHJual09 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09) <> 0 AND MStahun = '"& tahun &"' "& filterAgen &" "& filterNama &" "
      elseIf bulan = "10" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli10 as beli, DLK_T_MutasiStok.MSJual10 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09 + DLK_T_MutasiStok.MSBeli10) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09 + DLK_T_MutasiStok.MSJual10) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli10 as hbeli, DLK_T_MutasiStok.MSHJual10 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09 + DLK_T_MutasiStok.MSHBeli10) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09 + DLK_T_MutasiStok.MSHJual10) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09 + DLK_T_MutasiStok.MSBeli10) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09 + DLK_T_MutasiStok.MSJual10) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09 + DLK_T_MutasiStok.MSHBeli10) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09 + DLK_T_MutasiStok.MSHJual10) <> 0 AND MStahun = '"& tahun &"' "& filterAgen &" "& filterNama &" "
      elseIf bulan = "11" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli11 as beli, DLK_T_MutasiStok.MSJual11 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09 + DLK_T_MutasiStok.MSBeli10 + DLK_T_MutasiStok.MSBeli11) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09 + DLK_T_MutasiStok.MSJual10 + DLK_T_MutasiStok.MSJual11) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli11 as hbeli, DLK_T_MutasiStok.MSHJual11 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09 + DLK_T_MutasiStok.MSHBeli10 + DLK_T_MutasiStok.MSHBeli11) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09 + DLK_T_MutasiStok.MSHJual10 + DLK_T_MutasiStok.MSHJual11) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09 + DLK_T_MutasiStok.MSBeli10 + DLK_T_MutasiStok.MSBeli11) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09 + DLK_T_MutasiStok.MSJual10 + DLK_T_MutasiStok.MSJual11) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09 + DLK_T_MutasiStok.MSHBeli10 + DLK_T_MutasiStok.MSHBeli11) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09 + DLK_T_MutasiStok.MSHJual10 + DLK_T_MutasiStok.MSHJual11) <> 0 AND MStahun = '"& tahun &"' "& filterAgen &" "& filterNama &" "
      elseIf bulan = "12" then
         strsql = "SELECT DLK_T_MutasiStok.MSTahun, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, DLK_M_Barang.Brg_Nama, DLK_T_MutasiStok.MSAwal, DLK_T_MutasiStok.MSBeli12 as beli, DLK_T_MutasiStok.MSJual12 as jual, (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09 + DLK_T_MutasiStok.MSBeli10 + DLK_T_MutasiStok.MSBeli11 + DLK_T_MutasiStok.MSBeli12) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09 + DLK_T_MutasiStok.MSJual10 + DLK_T_MutasiStok.MSJual11 + DLK_T_MutasiStok.MSJual12) as tsaldoakhir, DLK_T_MutasiStok.MSHAwal, DLK_T_MutasiStok.MSHBeli12 as hbeli, DLK_T_MutasiStok.MSHJual12 as hjual, (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09 + DLK_T_MutasiStok.MSHBeli10 + DLK_T_MutasiStok.MSHBeli11 + DLK_T_MutasiStok.MSHBeli12) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09 + DLK_T_MutasiStok.MSHJual10 + DLK_T_MutasiStok.MSHJual11 + DLK_T_MutasiStok.MSHJual12) as hargaAkhir FROM DLK_T_MutasiStok LEFT OUTER JOIN DLK_M_Barang ON DLK_T_MutasiStok.MSItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE (DLK_T_MutasiStok.MSAwal + DLK_T_MutasiStok.MSBeli01 + DLK_T_MutasiStok.MSBeli02 + DLK_T_MutasiStok.MSBeli03 + DLK_T_MutasiStok.MSBeli04 + DLK_T_MutasiStok.MSBeli05 + DLK_T_MutasiStok.MSBeli06 + DLK_T_MutasiStok.MSBeli07 + DLK_T_MutasiStok.MSBeli08 + DLK_T_MutasiStok.MSBeli09 + DLK_T_MutasiStok.MSBeli10 + DLK_T_MutasiStok.MSBeli11 + DLK_T_MutasiStok.MSBeli12) - (DLK_T_MutasiStok.MSJual01 + DLK_T_MutasiStok.MSJual02 + DLK_T_MutasiStok.MSJual03 + DLK_T_MutasiStok.MSJual04 + DLK_T_MutasiStok.MSJual05 + DLK_T_MutasiStok.MSJual06 + DLK_T_MutasiStok.MSJual07 + DLK_T_MutasiStok.MSJual08 + DLK_T_MutasiStok.MSJual09 + DLK_T_MutasiStok.MSJual10 + DLK_T_MutasiStok.MSJual11 + DLK_T_MutasiStok.MSJual12) <> 0 AND (DLK_T_MutasiStok.MSHAwal + DLK_T_MutasiStok.MSHBeli01 + DLK_T_MutasiStok.MSHBeli02 + DLK_T_MutasiStok.MSHBeli03 + DLK_T_MutasiStok.MSHBeli04 + DLK_T_MutasiStok.MSHBeli05 + DLK_T_MutasiStok.MSHBeli06 + DLK_T_MutasiStok.MSHBeli07 + DLK_T_MutasiStok.MSHBeli08 + DLK_T_MutasiStok.MSHBeli09 + DLK_T_MutasiStok.MSHBeli10 + DLK_T_MutasiStok.MSHBeli11 + DLK_T_MutasiStok.MSHBeli12) - (DLK_T_MutasiStok.MSHJual01 + DLK_T_MutasiStok.MSHJual02 + DLK_T_MutasiStok.MSHJual03 + DLK_T_MutasiStok.MSHJual04 + DLK_T_MutasiStok.MSHJual05 + DLK_T_MutasiStok.MSHJual06 + DLK_T_MutasiStok.MSHJual07 + DLK_T_MutasiStok.MSHJual08 + DLK_T_MutasiStok.MSHJual09 + DLK_T_MutasiStok.MSHJual10 + DLK_T_MutasiStok.MSHJual11 + DLK_T_MutasiStok.MSHJual12) <> 0 AND MStahun = '"& tahun &"' "& filterAgen &" "& filterNama &"  "
      end if


      ' query seach 
      strquery = strsql

      ' untuk data paggination
      page = Request.QueryString("page")

      orderBy = " ORDER BY DLK_M_Barang.Brg_Nama ASC"
      set rs = Server.CreateObject("ADODB.Recordset")
      sqlawal = strquery

      sql= sqlawal + orderBy
      ' response.write sql & "<br>"
      rs.open sql, conn
      ' records per halaman
      recordsonpage = 10
      ' count all records
      allrecords = 0
      do until rs.EOF
         allrecords = allrecords + 1
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
         rs.movenext
         if rs.EOF then
         lastrecord = 1
         end if	
      loop

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
   <% if session("INV7A") = true then %>
   <div class="row">
      <div class="col-sm mb-3">
         <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalProses">Proses</button>
      </div>
   </div>
   <% end if %>
   <form action="mutasiStok.asp" method="post">
      <div class="row">
         <div class="col-lg-3 mb-3">
            <label for="Agen">Cabang</label>
            <select class="form-select" aria-label="Default select example" name="agen" id="agen">
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
         <div class="col-lg-4">
            <label for="nama">Item</label>
            <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" placeholder="cari nama">
         </div>
         <div class="col-lg-2 mt-4 mb-3">
            <button type="submit" class="btn btn-primary">Cari</button>
            <% 
            if agen <> "" OR tgl <> "" then 
               if not rs.eof then
            %>
                  <% if session("INV7D") = true then %>
                     <button type="button" class="btn btn-secondary" onclick="window.location.href='export-XlsMutasiStok.asp?agen=<%=agen%>&tgla=<%=tgl%>&nama=<%=nama%>'">Export</button>
            <% 
                  end if 
               end if 
            end if %>
         </div>
      </div>
   </form>
   <% if agen <> "" OR tgl <>  "" then %>
   <div class="row">
      <div class="col-sm-12">
         <table class="table table-hover table-bordered" style="font-size:14px;" >
            <thead class="bg-secondary text-light text-center">
               <tr>
                  <th scope="col" rowspan="2">No</th>
                  <th scope="col" rowspan="2">Kategori</th>
                  <th scope="col" rowspan="2">Jenis</th>
                  <th scope="col" rowspan="2">Barang</th>
                  <th scope="col" colspan="2">Saldo-Awal</th>
                  <th scope="col" colspan="2">Saldo-Beli</th>
                  <th scope="col" colspan="2">Saldo-Jual</th>
                  <th scope="col" colspan="2">Saldo-Akhir</th>
               </tr>
               <tr>
                  <th>Qty</th>
                  <th>Harga</th>
                  <th>Qty</th>
                  <th>Harga</th>
                  <th>Qty</th>
                  <th>Harga</th>
                  <th>Qty</th>
                  <th>Harga</th>
               </tr>
            </thead>
            <tbody>
               <% 
               no = 0
               'prints records in the table
               showrecords = recordsonpage
               recordcounter = requestrecords
               do until showrecords = 0 OR  rs.EOF
               recordcounter = recordcounter + 1
               no = no + 1
               %>
               <tr>
                  <th scope="row"><%= recordcounter %></th>
                  <td><%= rs("kategoriNama") %></td>
                  <td><%= rs("jenisNama") %></td>
                  <td><%= rs("Brg_Nama") %></td>
                  <td><%= rs("MSAwal") %></td>
                  <td><%= replace(formatCurrency(rs("MSHAwal")),"$","") %></td>
                  <td><%= rs("beli") %></td>
                  <td><%= replace(formatCurrency(rs("hbeli")),"$","") %></td>
                  <td><%= rs("jual") %></td>
                  <td><%= replace(formatCurrency(rs("hjual")),"$","") %></td>
                  <td><%= rs("tsaldoakhir") %></td>
                  <td><%= replace(formatCurrency(rs("hargaakhir")),"$","") %></td>
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
                  <a class="page-link prev" href="mutasistok.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&tgla=<%=tgl%>&nama=<%=nama%>">&#x25C4; Prev </a>
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
                     <a class="page-link hal bg-primary text-light" href="mutasistok.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&tgla=<%=tgl%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
                  <%else%>
                     <a class="page-link hal" href="mutasistok.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&tgla=<%=tgl%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
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
                     <a class="page-link next" href="mutasistok.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&tgla=<%=tgl%>&nama=<%=nama%>">Next &#x25BA;</a>
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
<!-- Modal -->
<div class="modal fade" id="modalProses" tabmutasistok="-1" aria-labelledby="modalProsesLabel" aria-hidden="true">
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