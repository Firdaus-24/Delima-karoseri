<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    data_cmd.commandText = "SELECT DLK_T_OrJulH.*, GLB_M_Agen.Agenname, GLB_M_Agen.AgenID, dbo.DLK_M_Divisi.divNama, DLK_M_Departement.DepID, DLK_M_Departement.DepNama FROM DLK_T_OrJulH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrJulH.OJH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Divisi ON DLK_T_OrJulH.OJH_divID = DLK_M_Divisi.divID LEFT OUTER JOIN DLK_M_Departement ON DLK_T_OrjulH.OJH_DepID = DLK_M_Departement.DepID WHERE OJH_ID = '"& id &"' AND OJH_AktifYN = 'Y'"

    set data = data_cmd.execute

    ' cek kebutuhan
    if data("OJH_Kebutuhan") = 0 then
        kebutuhan = "Produksi"
    elseif data("OJH_Kebutuhan") = 1 then
        kebutuhan = "Khusus"
    elseif data("OJH_Kebutuhan") = 2 then
        kebutuhan = "Umum"
    else
        kebutuhan = "Sendiri"
    end if

    ' get detail
    data_cmd.commandText = "SELECT DLK_T_OrJulD.*, DLK_M_Barang.Brg_Nama, DLK_M_SatuanBarang.Sat_Nama FROM DLK_T_OrjulD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrjulD.OJD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_SatuanBArang ON DLK_T_OrjulD.OJD_JenisSat = DLK_M_SatuanBarang.Sat_ID WHERE LEFT(OJD_OJHID,13) = '"& data("OJH_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"

    set ddata = data_cmd.execute

    call header("Detail Permintaan")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>DETAIL PERTMINTAAN</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <div class="row">
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="date" id="tgl" name="tgl" class="form-control" value="<%= data("OJH_Date") %>" readonly required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="agenorjul" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="lagen" name="lagen" class="form-control" value="<%= data("AgenName") %>" readonly required>
            </div>
            
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="divisi" class="col-form-label">Divisi</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="divisi" name="divisi" class="form-control" value="<%= data("divNama") %>" readonly required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="departement" class="col-form-label">Departement</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="departement" name="departement" class="form-control" value="<%= data("depNama") %>" readonly  autocomplete="off">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="kebutuhan" class="col-form-label">Kebutuhan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="kebutuhan" name="kebutuhan" class="form-control" value="<%= kebutuhan %>" readonly required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="noproduk" class="col-form-label">No Produksi</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="noproduk" name="noproduk" class="form-control" value="<%= data("OJH_PDID") %>" readonly  autocomplete="off">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-10 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("OJH_Keterangan") %>" readonly autocomplete="off">
            </div>
        </div>    
    </div>  
    <div class="row">
        <div class="col-lg-12">
            <div class="d-flex mb-3">
                <div class="me-auto p-2">
                    <button type="button" class="btn btn-secondary" onClick="window.open('export-Xlspermintaan.asp?id=<%=id%>','_self')">EXPORT</button>
                </div>
                <div class="p-2">
                    <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">No</th>
                        <th scope="col">Item</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Satuan</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    no = 0
                    do while not ddata.eof 
                    no = no + 1

                    %>
                        <tr>
                            <td>
                                <%= no %>
                            </td>
                            <td>
                                <%= ddata("Brg_Nama") %>
                            </td>
                            <td>
                                <%= ddata("OJD_QtySatuan") %>
                            </td>
                            <td>
                                <%= ddata("Sat_Nama") %>
                            </td>
                        </tr>
                    <% 
                    ddata.movenext
                    loop
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>  



<% 
    call footer()
%>