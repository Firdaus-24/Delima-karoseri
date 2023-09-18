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
<style>
.table{
   font-family: Calibri, Arial, sans-serif;
   font-size:16px;
}
.table th {
   background-color:yellow;
}
</style>

<table widht="100%" class="table">
   <tr>
      <td colspan="11" align="center" style="font-size:18px;">MUTASI STOK INVENTORY</td> 
   </tr>
   <% if agen <> "" then %>
   <tr>
      <td colspan="11" align="center" style="font-size:18px;">Cabang : <%= dagen("agenName") %></td> 
   </tr>
   <% end if %>
   <tr>
      <td colspan="11" align="center" style="font-size:18px;">Priode : <%= MonthName(bulan) &" / "& tahun %></td> 
   </tr>
    <tr>
      <td colspan="11" align="center" style="font-size:18px;">&nbsp</td> 
   </tr>
   <tr>
      <th rowspan="2">No</th>
      <th rowspan="2">Kategori</th>
      <th rowspan="2">Jenis</th>
      <th rowspan="2">Barang</th>
      <th colspan="2">Qty-Awal</th>
      <th colspan="2">Qty-Beli</th>
      <th colspan="2">Qty-Jual</th>
      <th colspan="2">Qty-Akhir</th>
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
   <% 
   no = 0
   qtyawal = 0
   hawal = 0
   qtybeli = 0
   hbeli = 0
   qtyjual = 0
   hjual = 0
   qtyakhir = 0
   hakhir = 0
   Do While not data.eof  
   no = no + 1
   qtyawal = qtyawal +  data("MSAwal")
   hawal = hawal +  data("MSHAwal")
   qtybeli = qtybeli +  data("beli")
   hbeli = hbeli +  data("hbeli")
   qtyjual = qtyjual +  data("jual")
   hjual = hjual +  data("hjual")
   qtyakhir = qtyakhir +  data("tsaldoakhir")
   hakhir = hakhir +  data("hargaakhir")
   %>
   <tr style="font-size:12px"> 
      <td scope="row"><%= no %></td>
      <td><%= data("kategoriNama") %></td>
      <td><%=  data("jenisNama") %></td>
      <td><%= data("Brg_Nama") %></td>
      <td><%= data("MSAwal") %></td>
      <td align="right"><%= replace(formatCurrency(data("MSHAwal")),"$","") %></td>
      <td><%= data("beli") %></td>
      <td align="right"><%= replace(formatCurrency(data("hbeli")),"$","") %></td>
      <td><%= data("jual") %></td>
      <td align="right"><%= replace(formatCurrency(data("hjual")),"$","") %></td>
      <td><%= data("tsaldoakhir") %></td>
      <td align="right"><%= replace(formatCurrency(data("hargaakhir")),"$","") %></td>
   </tr>
   <% 
   response.flush
   data.movenext
   loop
   %>
   <tr>
      <td colspan="4">Total</td>
      <td ><%=qtyawal%></td>
      <td align="right"><%=replace(formatCurrency(hawal),"$","")%></td>
      <td ><%=qtybeli%></td>
      <td align="right"><%=replace(formatCurrency(hbeli),"$","")%></td>
      <td ><%=qtyjual%></td>
      <td align="right"><%=replace(formatCurrency(hjual),"$","")%></td>
      <td ><%=qtyakhir%></td>
      <td align="right"><%=replace(formatCurrency(hakhir),"$","")%></td>
   </tr>
</table>