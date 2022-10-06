<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    data_cmd.commandText = "SELECT DLK_T_OrJulH.*, GLB_M_Agen.Agenname, GLB_M_Agen.AgenID, dbo.DLK_M_Divisi.divNama, DLK_M_Departement.DepID, DLK_M_Departement.DepNama FROM DLK_T_OrJulH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrJulH.OJH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Divisi ON DLK_T_OrJulH.OJH_divID = DLK_M_Divisi.divID LEFT OUTER JOIN DLK_M_Departement ON DLK_T_OrjulH.OJH_DepID = DLK_M_Departement.DepID WHERE OJH_ID = '"& id &"' AND OJH_AktifYN = 'Y'"

    set data = data_cmd.execute

    ' get detail
    data_cmd.commandText = "SELECT DLK_T_OrJulD.*, DLK_M_Barang.Brg_Nama, DLK_M_SatuanBarang.Sat_Nama FROM DLK_T_OrjulD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrjulD.OJD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_SatuanBArang ON DLK_T_OrjulD.OJD_JenisSat = DLK_M_SatuanBarang.Sat_ID WHERE LEFT(OJD_OJHID,13) = '"& data("OJH_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"

    set ddata = data_cmd.execute

    call header("Detail OrderJual")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>DETAIL ORDER PENJUALAN</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <table class="table" style="border:transparent;">
                <tr>
                    <th>No</th>
                    <th>:</th>
                    <td>
                        <%= left(data("OJH_ID"),2) %>-<% call getAgen(mid(data("OJH_ID"),3,3),"") %>/<%= mid(data("OJH_ID"),6,4) %>/<%= right(data("OJH_ID"),4) %>
                    </td>
                </tr>
                <tr>
                    <th>Tanggal</th>
                    <th>:</th>
                    <td>
                        <%= data("OJH_Date") %>
                    </td>
                </tr>
                <tr>
                    <th>Divisi</th>
                    <th>:</th>
                    <td>
                        <%= data("DivNama") %>
                    </td>
                </tr>
                <tr>
                    <th>Departement</th>
                    <th>:</th>
                    <td>
                        <%= data("DepNama") %>
                    </td>
                </tr>
                <tr>
                    <th>Keterangan</th>
                    <th>:</th>
                    <td>
                        <%= data("OJH_Keterangan") %>
                    </td>
                </tr>
            </table>
        </div>
        <div class="col-6 mb-3">
            <div class="btn-group float-end p-0" role="group" aria-label="Basic example">
                <a href="outgoing.asp" type="button" class="btn btn-primary">Kembali</a>
                <button type="button" class="btn btn-secondary" onClick="window.open('export-XlsOrjul.asp?id=<%=id%>','_self')">EXPORT</button>
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
                    grantotal = 0
                    no = 0 + 1
                    do while not ddata.eof 
                    ' cek total harga 
                    ' jml = ddata("OJD_QtySatuan") * ddata("OJD_Harga")
                    ' ' cek diskon peritem
                    ' if ddata("OJD_Disc1") <> 0 and ddata("OJD_Disc2") <> 0  then
                    '     dis1 = (ddata("OJD_Disc1")/100) * ddata("OJD_Harga")
                    '     dis2 = (ddata("OJD_Disc2")/100) * ddata("OJD_Harga")
                    ' elseif ddata("OJD_Disc1") <> 0 then
                    '     dis1 = (ddata("OJD_Disc1")/100) * ddata("OJD_Harga")
                    ' elseIf ddata("OJD_Disc2") <> 0 then
                    '     dis2 = (ddata("OJD_Disc2")/100) * ddata("OJD_Harga")
                    ' else    
                    '     dis1 = 0
                    '     dis2 = 0
                    ' end if
                    ' ' total dikon peritem
                    ' hargadiskon = ddata("OJD_Harga") - dis1 - dis2
                    ' realharga = hargadiskon * ddata("OJD_QtySatuan")  

                    ' grantotal = grantotal + realharga

                    strid = ddata("OJD_OJHID")
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
                    ' ' cek diskonall
                    ' if data("OJH_diskonall") <> 0 OR data("OJH_Diskonall") <> "" then
                    '     diskonall = (data("OJH_Diskonall")/100) * grantotal
                    ' else
                    '     diskonall = 0
                    ' end if

                    ' ' hitung ppn
                    ' if data("OJH_ppn") <> 0 OR data("OJH_ppn") <> "" then
                    '     ppn = (data("OJH_ppn")/100) * grantotal
                    ' else
                    '     ppn = 0
                    ' end if
                    ' realgrantotal = (grantotal - diskonall) + ppn
                    %>
                        <!-- 
                    <tr>
                        <th colspan="6">Total Pembayaran</th>
                        <th><%= replace(formatCurrency(realgrantotal),"$","") %></th>
                    </tr>
                         -->
                </tbody>
            </table>
        </div>
    </div>
</div>  



<% 
    call footer()
%>