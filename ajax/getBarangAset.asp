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

    data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, ISNULL(SUM(dbo.DLK_T_InvPemD.IPD_QtySatuan), 0) AS stok, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama FROM dbo.DLK_M_Kategori RIGHT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID LEFT OUTER JOIN dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID,13) ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_InvPemD.IPD_Item WHERE (LEFT(dbo.DLK_M_Barang.Brg_Id, 3) = '"& cabang &"') "& filterNama &" GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_Id, dbo.DLK_T_InvPemH.IPH_AktifYN, dbo.DLK_T_InvPemH.IPH_AgenId, dbo.DLK_M_Barang.Brg_StokYN, dbo.DLK_M_Barang.Brg_jualYN, dbo.DLK_M_Barang.Brg_AktifYN, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama HAVING (dbo.DLK_M_Barang.Brg_StokYN = 'Y') AND (dbo.DLK_M_Barang.Brg_jualYN = 'N') AND (dbo.DLK_M_Barang.Brg_AktifYN = 'Y') ORDER BY Brg_Nama ASC"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute
    %>
        <% 
        do while not data.eof 
        
        ' get klaim 
        data_cmd.commandTExt = "SELECT ISNULL(SUM(DB_QtySatuan),0) as klaim, DB_Item FROM DLK_T_DelBarang WHERE DB_Item = '"& data("brg_ID") &"' AND DB_AgenID = '"& cabang &"' AND DB_AktifYN = 'Y' GROUP BY DB_Item"

        set klaim = data_cmd.execute

        if not klaim.eof then
            stokklaim = Cint(klaim("klaim"))
        else
            stokklaim = 0 
        end if

        ' cek aset 
        data_cmd.commandTExt = "SELECT ISNULL(SUM(dbo.DLK_T_AsetD.AD_Qtysatuan), 0) AS aset, dbo.DLK_T_AsetD.AD_Item FROM dbo.DLK_T_AsetH RIGHT OUTER JOIN dbo.DLK_T_AsetD ON dbo.DLK_T_AsetH.AsetId = LEFT(dbo.DLK_T_AsetD.AD_AsetID, 10) GROUP BY dbo.DLK_T_AsetH.AsetAktifYN, dbo.DLK_T_AsetH.AsetAgenID, dbo.DLK_T_AsetD.AD_Item HAVING (dbo.DLK_T_AsetH.AsetAktifYN = 'Y') AND (dbo.DLK_T_AsetH.AsetAgenID = '"& cabang &"') AND (dbo.DLK_T_AsetD.AD_Item = '"& data("brg_ID") &"')"
        ' response.write data_cmd.commandText & "<br>"
        set ckaset = data_cmd.execute

        if not ckaset.eof then 
            aset = Cint(ckaset("aset"))
        else
            aset = 0
        end if

        realstok = Cint(data("stok")) - stokklaim - aset
        %>
        <tr>
            <th scope="row">
                <%= data("KategoriNama") &"-"& data("JenisNama")  %>
            </th>
            <td><%= data("Brg_Nama") %></td>
            <td><%= realstok %></td>
            <td class="text-center">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="ckaset" id="ckaset" value="<%= data("Brg_ID") %>" onclick="setBarangAset('<%= realstok %>')" required>
                </div>
            </td>
        </tr>
        <% 
        response.flush
        data.movenext
        loop
        %>
        