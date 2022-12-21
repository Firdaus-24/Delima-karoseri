<!--#include file="../../init.asp"-->
<% 
    agen = trim(Request.Form("agen"))
    ltype = trim(Request.Form("type"))

    if agen <> "" then
        filterAgen = " AND LEFT(Brg_ID,3) = '"& agen &"'"
    else
        filterAgen = " AND LEFT(Brg_ID,3) =" &session("server-id")
    end if
    
    if ltype <> "" then
        filterType = " AND DLK_M_Barang.Brg_Type = '"& ltype &"'"
    else
        filterType = ""
    end if

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' getcabang 
    data_cmd.commandText = "SELECT AgenID, AgenName FROM DLK_M_Barang LEFT OUTER JOIN GLB_M_Agen ON LEFT(DLK_M_Barang.Brg_ID,3) = GLB_M_agen.AgenID WHERE DLK_M_Barang.Brg_AktifYN = 'Y' GROUP BY AgenID, AgenName ORDER BY AgenName ASC"

    set agendata = data_cmd.execute

    ' get type barang
    data_cmd.commandText = "SELECT T_ID, T_Nama FROM  DLK_M_Barang LEFT OUTER JOIN DLK_M_TYpebarang ON DLK_M_Barang.Brg_Type = DLK_M_Typebarang.T_ID WHERE DLK_M_Barang.Brg_AktifYN = 'Y'  GROUP BY T_ID, T_Nama ORDER BY T_Nama ASC"

    set datatype = data_cmd.execute

    data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_MinStok, dbo.DLK_M_Barang.Brg_Type, dbo.DLK_M_JenisBarang.JenisID, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_Barang.Brg_AktifYN, dbo.DLK_M_Barang.Brg_jualYN, dbo.DLK_M_Barang.Brg_StokYN, dbo.DLK_M_TypeBarang.T_ID, dbo.DLK_M_TypeBarang.T_Nama, ISNULL(ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y'),0),0) as stok, ISNULL(dbo.DLK_T_MaterialReceiptD2.MR_Harga, 0) as harga FROM DLK_M_Barang LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID  LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID LEFT OUTER JOIN dbo.DLK_T_MaterialReceiptD2 ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_MaterialReceiptD2.MR_Item WHERE Brg_AktifYN = 'Y' "& filterAgen &" "& filterType &" GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_MinStok, dbo.DLK_M_Barang.Brg_Type, dbo.DLK_M_JenisBarang.JenisID, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_Barang.Brg_AktifYN, dbo.DLK_M_Barang.Brg_jualYN, dbo.DLK_M_Barang.Brg_StokYN, dbo.DLK_M_TypeBarang.T_ID, dbo.DLK_M_TypeBarang.T_Nama, DLK_M_Barang.Brg_ID, dbo.DLK_T_MaterialReceiptD2.MR_Harga ORDER BY Brg_Nama, T_Nama ASC"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute
    
    call header("Inventory") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 ">
        <div class="col-lg-12 mb-3 text-center">
            <h3>MONITORING STOK INVENTORY</h3>
        </div>
    </div>
    <form action="index.asp" method="post">
        <div class="row">
            <div class="col-lg-4 mb-3">
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
            <div class="col-lg-4 mb-3">
                <label for="type">Type</label>
                <select class="form-select" aria-label="Default select example" name="type" id="type">
                <option value="">Pilih</option>
                <% do while not datatype.eof %>
                <option value="<%= datatype("T_ID") %>"><%= datatype("T_Nama") %></option>
                <% 
                datatype.movenext
                loop
                %>
                </select>
            </div>
            <div class="col-lg-2 mt-4 mb-3">
                <button type="submit" class="btn btn-primary">Cari</button>
            </div>
        </div>
    </form>
    <div class="row ">
        <div class="col-lg-12 mb-3">
            <table class="table table-hover">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">Kode</th>
                        <th scope="col">Item</th>
                        <th scope="col">Type</th>
                        <th scope="col">Min Stok</th>
                        <th scope="col">Stok</th>
                        <th scope="col">Harga</th>
                        <th scope="col">Total Harga</th>
                        <th scope="col">Keterangan</th>
                    </tr>
                </thead>
                <tbody>
                    <% do while not data.eof 
                    
                    ' cek keterangan
                    if data("stok") = 0  then
                        ket = "stok habis"
                        bgclass = "bg-danger text-light"
                    elseif data("stok") < 0  then
                        ket = "Data barang tidak singkron"
                        bgclass = "bg-danger text-light"
                    elseif data("stok") < data("Brg_Minstok") then
                        ket = "Barang Kurang dari min-stok"
                        bgclass = "bg-warning"
                    elseIf data("Brg_Minstok") + 2 > data("stok") then
                        ket = "Barang mendekatin min-stok"
                        bgclass = "bg-success text-light"
                    else
                        ket = "-"
                        bgclass = ""
                    end if

                    tharga = data("harga") * data("stok")
                    %>
                    <tr>
                        <td><%= data("kategoriNama") &"-"& data("jenisNama") %></td>
                        <td><%= data("Brg_Nama") %></td>
                        <td><%= data("T_Nama") %></td>
                        <td><%= data("Brg_Minstok") %></td>
                        <td><%= data("stok") %></td>
                        <td><%= replace(formatCurrency(data("harga")),"$","") %></td>
                        <td><%= replace(formatCurrency(tharga),"$","") %></td>
                        <td class="<%= bgclass %>">
                            <%= ket %>
                        </td>
                    </tr>
                    <% 
                    data.movenext
                    loop
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>
<% call footer() %>