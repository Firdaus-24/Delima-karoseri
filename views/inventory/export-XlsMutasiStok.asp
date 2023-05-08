<!--#include file="../../init.asp"-->
<% 
   if session("INV7D") = false then
      Response.Redirect("index.asp")
   end if
   agen = trim(Request.QueryString("agen"))
   tgl = trim(Request.QueryString("tgla"))
   nama = Ucase(trim(Request.QueryString("nama")))

   Response.ContentType = "application/vnd.ms-excel"
   Response.AddHeader "content-disposition", "filename=MutasiStok "& agen &" "& tgl &" "& nama &" .xls"

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

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' cek cabang
   if agen <> "" then
      data_cmd.commandText = "SELECT AgenName FROM GLB_M_Agen WHERE AgenID = '"& agen &"'"
      set dagen = data_cmd.execute
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
   end if

   data_cmd.commandText = strsql

   set data = data_cmd.execute
%>

<table widht="100%" style="font-family: Calibri, Arial, sans-serif;font-size:12px;">
   <tr>
      <td colspan="11" align="center">MUTASI STOK INVENTORY</td> 
   </tr>
   <% if agen <> "" then %>
   <tr>
      <td colspan="11" align="center">Cabang : <%= dagen("agenName") %></td> 
   </tr>
   <% end if %>
   <tr>
      <td colspan="11" align="center">Priode : <%= bulan &"/"& tahun %></td> 
   </tr>
    <tr>
      <td colspan="11" align="center">&nbsp</td> 
   </tr>
   <tr style="font-size:12px;">
      <th style="background-color: #0000a0;color:#fff;">No</th>
      <th style="background-color: #0000a0;color:#fff;">Kode</th>
      <th style="background-color: #0000a0;color:#fff;">Item</th>
      <th style="background-color: #0000a0;color:#fff;">Qty-Awal</th>
      <th style="background-color: #0000a0;color:#fff;">Harga-Awal</th>
      <th style="background-color: #0000a0;color:#fff;">Qty-Beli</th>
      <th style="background-color: #0000a0;color:#fff;">Harga-Beli</th>
      <th style="background-color: #0000a0;color:#fff;">Qty-Jual</th>
      <th style="background-color: #0000a0;color:#fff;">Harga-Jual</th>
      <th style="background-color: #0000a0;color:#fff;">Qty-Akhir</th>
      <th style="background-color: #0000a0;color:#fff;">Harga-Akhir</th>
   </tr>
   <% 
   no = 0
   Do While not data.eof  
   no = no + 1
   %>
   <tr style="font-size:12px"> 
      <th scope="row"><%= no %></th>
      <td><%= data("kategoriNama") &"-"& data("jenisNama") %></td>
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
</table>