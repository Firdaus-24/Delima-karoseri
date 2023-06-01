<!--#include file="../../init.asp"-->
<%  
    if session("HR1D") = false then
        Response.Redirect("index.asp")
    end if
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' get cabang
    data_cmd.commandText = "SELECT dbo.DLK_T_AsetH.AsetId, dbo.DLK_T_AsetH.AsetAgenID, dbo.DLK_T_AsetH.AsetPJawab, dbo.DLK_T_AsetH.AsetKeterangan, dbo.DLK_T_AsetH.AsetUpdateID, dbo.DLK_T_AsetH.AsetUpdateTime, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Departement.DepNama, dbo.DLK_M_Divisi.DivNama, dbo.DLK_M_Divisi.DivId, dbo.DLK_M_WebLogin.UserName FROM dbo.DLK_T_AsetH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_AsetH.AsetPJawab = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.DLK_M_Divisi ON dbo.DLK_T_AsetH.AsetDivID = dbo.DLK_M_Divisi.DivId LEFT OUTER JOIN dbo.DLK_M_Departement ON dbo.DLK_T_AsetH.AsetDepID = dbo.DLK_M_Departement.DepID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_AsetH.AsetAgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_AsetH.AsetAktifYN = 'Y') AND (dbo.DLK_T_AsetH.Asetid = '"& id &"')"
    set data = data_cmd.execute

    ' get detail aset 
    data_cmd.commandTExt = "SELECT DLK_T_AsetD.*, DLK_M_BArang.Brg_Nama, DLK_M_SatuanBarang.sat_Nama, DLK_M_Rak.Rak_Nama FROM DLK_T_AsetD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_AsetD.AD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_AsetD.AD_JenisSat = DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_Rak ON DLK_T_AsetD.AD_RakID = DLK_M_Rak.Rak_ID WHERE LEFT(AD_AsetID,10) = '"& data("AsetID") &"'"
    set ddata = data_cmd.execute

    ' get satuan
    data_cmd.commandTExt = "SELECT sat_Nama, sat_id FROM DLK_M_SatuanBarang WHERE sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"
    set psatuan = data_cmd.execute

call header("Form Detail Aset") 
%>
<style>
   body{
        padding:10px;
    }
    .gambar{
        width:80px;
        height:80px;
        position:absolute;
        right:70px;
    }
    .gambar img{
        position:absolute;
        width:100px;
        height:50px;
    }
    table{
        font-size:14px;
        margin-bottom:10px;
    }
    #cdetail > * > tr > *  {
        border: 1px solid black;
        padding:5px;
    }

    #cdetail{
        width:100%;
        font-size:12px;
        border-collapse: collapse;
    }
</style>
<div class="row gambar">
         <div class="col ">
            <img src="<%= url %>/public/img/delimalogo.png" alt="delimalogo">
        </div>
    </div>
<div class="container">
    <div class="row">
        <div class="col-lg text-center">
            <h3>FORM DETAIL ASET BARANG</h3>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-lg text-center labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <table width="100%">
        <tr>
            <td>
                Cabang
            </td>
            <td>
                <%= data("AgenName") %>
            </td>
            <td>
                Tanggal
            </td>
            <td>
                <%= data("AsetUpdateTime") %>
            </td>
        </tr>
        <tr>
            <td>
                Divisi
            </td>
            <td>
                <%= data("DivNama") %>
            </td>
            <td>
                Departement
            </td>
            <td>
                <%= data("DepNama") %>
            </td>
        </tr>
        <tr>
            <td>
                Keterangan
            </td>
            <td>
                <%= data("asetKeterangan") %>
            </td>
            <td>
                Penanggung Jawab
            </td>
            <td>
                <%= data("username") %>
            </td>
        </tr>
    </table>
    <table width="100%" id="cdetail">
        <thead>
            <tr>
                <th scope="col">ID</th>
                <th scope="col">Item</th>
                <th scope="col">Quantity</th>
                <th scope="col">Satuan</th>
                <th scope="col">Rak</th>
            </tr>
        </thead>
        <tbody>
            <% 
            do while not ddata.eof 
            %>
            <tr>
                <th>
                    <%= ddata("AD_AsetID") %>
                </th>
                <td>
                    <%= ddata("Brg_Nama") %>
                </td>
                <td>
                    <%= ddata("AD_QtySatuan") %>
                </td>
                <td>
                    <%= ddata("Sat_Nama") %>
                </td>
                <td>
                    <%= ddata("Rak_Nama") %>
                </td>
            </tr>
            <% 
            ddata.movenext
            loop
            %>
        </tbody>
    </table>
</div>
<% 
call footer() 
%>