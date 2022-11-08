<!--#include file="../../init.asp"-->
<% 
    response.Buffer=true
    server.ScriptTimeout=1000000000

    ' "SELECT HRD_M_Karyawan.Kry_NIP, HRD_M_Karyawan.Kry_Nama,(SELECT ISNULL(SUM(TPK_PP), 0) AS jpinjam FROM HRD_T_PK WHERE "& filterTanggal &" "& filterTahun &" (TPK_AktifYN = 'Y') AND (TPK_NIP = HRD_M_Karyawan.Kry_NIP)) AS jpinjam, (SELECT ISNULL(SUM(TPK_PP), 0) AS jbayar FROM HRD_T_BK WHERE "& filterTanggal &" "& filterTahun &" (TPK_AktifYN = 'Y') AND(TPK_NIP = HRD_M_Karyawan.Kry_NIP)) AS jbayar FROM HRD_M_Karyawan WHERE ((SELECT ISNULL(SUM(TPK_PP), 0) AS jpinjam FROM HRD_T_PK AS HRD_T_PK_1 WHERE "& filterTanggal &" "& filterTahun &" (TPK_NIP = HRD_M_Karyawan.Kry_NIP)) <> 0) OR ((SELECT ISNULL(SUM(TPK_PP), 0) AS jbayar FROM HRD_T_BK AS HRD_T_BK_1 WHERE "& filterTanggal &" "& filterTahun &" (TPK_NIP = HRD_M_Karyawan.Kry_NIP)) <> 0) ORDER BY HRD_M_Karyawan.Kry_NIP"
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
        <div class="col-sm">

        </div>
    </div>
</div>
<% call footer() %>