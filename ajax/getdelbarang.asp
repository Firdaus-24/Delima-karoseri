<!--#include file="../init.asp"-->
<% 
    cabang = trim(Request.form("cabang"))
    nama = trim(Request.form("nama"))

    if nama <> "" then
        filterNama = " AND (dbo.DLK_M_Barang.Brg_Nama LIKE '%"& nama &"%')"
    else
        filterNama = ""
    end if

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, ISNULL(SUM(dbo.DLK_T_InvPemD.IPD_QtySatuan), 0) AS stok, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama FROM dbo.DLK_M_Kategori RIGHT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID LEFT OUTER JOIN dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID,13) ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_InvPemD.IPD_Item WHERE (LEFT(dbo.DLK_M_Barang.Brg_Id, 3) = '"& cabang &"') "& filterNama &" GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, dbo.DLK_T_InvPemH.IPH_AktifYN, dbo.DLK_T_InvPemH.IPH_AgenId, dbo.DLK_M_Barang.Brg_StokYN, dbo.DLK_M_Barang.Brg_jualYN, dbo.DLK_M_Barang.Brg_AktifYN, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama HAVING (dbo.DLK_M_Barang.Brg_AktifYN = 'Y') ORDER BY Brg_Nama ASC"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute
%>
    <article style="height: 11rem;overflow-y:auto;margin-bottom:20px">
    
    <table class="table">
        <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
        <tr>
            <td>
                Jenis/Kategori
            </td>
            <td>
                Nama
            </td>
            <td>
                Stok
            </td>
            <td>
                Pilih
            </td>
        </tr>
        </thead>
<% 
    do while not data.eof 
    
    ' get penjualan 
    data_cmd.commandTExt = "SELECT ISNULL(SUM(dbo.DLK_T_InvJulD.IJD_QtySatuan), 0) AS jual, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id FROM dbo.DLK_T_InvJulD LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_InvJulD.IJD_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_T_InvJulH ON LEFT(dbo.DLK_T_InvJulD.IJD_IJHID, 13) = dbo.DLK_T_InvJulH.IJH_ID GROUP BY dbo.DLK_T_InvJulH.IJH_agenID, dbo.DLK_T_InvJulH.IJH_AktifYN, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id HAVING (dbo.DLK_M_Barang.Brg_Id = '"& data("brg_ID") &"') AND (dbo.DLK_T_InvJulH.IJH_agenID = '"& cabang &"') AND (dbo.DLK_T_InvJulH.IJH_AktifYN = 'Y') "
    set jual = data_cmd.execute

    ' get klaim barang
    data_cmd.commandText = "SELECT ISNULL(SUM(DB_QtySatuan),0) AS tklaim FROM dbo.DLK_T_DelBarang WHERE (DB_AktifYN = 'Y') AND (DB_Item = '"& data("brg_ID") &"') AND DB_AgenID = '"&cabang&"' GROUP BY DB_Item"
    ' response.write data_cmd.commandText & "<br>"
    set klaim = data_cmd.execute

    ' get aset
    ' data_cmd.commandText = "SELECT AD_item, ISNULL(SUM(AD_QtySatuan),0) AS taset FROM dbo.DLK_T_AsetD LEFT OUTER JOIN DLK_T_AsetH ON LEFT(DLK_T_AsetD.AD_AsetID,10) = DLK_T_ASetH.AsetID WHERE (asetAktifYN = 'Y') AND (AD_Item = '"& data("brg_ID") &"') AND AsetAgenID = '"& cabang &"' GROUP BY AD_item, AsetAgenID, AsetAktifYN"
    ' ' response.write data_cmd.commandText & "<br>"
    ' set aset = data_cmd.execute

    if not jual.eof then
        stokjual = Cint(jual("jual"))
    else
        stokjual = 0 
    end if

    if not klaim.eof then
        tklaim = Cint(klaim("tklaim"))
    else
        tklaim = 0
    end if

    realstok = Cint(data("stok")) - stokjual - tklaim 
    
    if realstok > 0 then
    %>
    <tbody>
    <tr>
        <th scope="row">
            <%= data("KategoriNama") &"-"& data("JenisNama")  %>
        </th>
        <td><%= data("Brg_Nama") %></td>
        <td><%= realstok %></td>
        <td class="text-center">
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="ckdelbarang" id="ckdelbarang" onclick="getBrgDelete('<%= data("Brg_ID") %>','<%= data("Brg_Nama") %>','<%= realstok %>')">
            </div>
        </td>
    </tr>
    </tbody>
    <% 
    end if
    response.flush
    data.movenext
    loop
    %>
    </table>
    </article>
