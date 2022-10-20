<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_InvJulH.*, GLB_M_Agen.AgenName FROM dbo.DLK_T_InvJulH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvJulH.IJH_AgenID = GLB_M_Agen.AgenID WHERE dbo.DLK_T_InvJulH.IJH_ID = '"& id &"' AND dbo.DLK_T_InvJulH.IJH_AktifYN = 'Y'"

    set data = data_cmd.execute

    ' cek kebutuhan
    if data("IJH_Kebutuhan") = 0 then
        kebutuhan = "Produksi"
    elseif data("IJH_Kebutuhan") = 1 then
        kebutuhan = "Khusus"
    elseif data("IJH_Kebutuhan") = 2 then
        kebutuhan = "Umum"
    else
        kebutuhan = "Sendiri"
    end if

    ' cek detai permintaan 
    data_cmd.commandTExt = "SELECT dbo.DLK_M_Rak.Rak_nama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Rak.Rak_ID, dbo.DLK_T_InvJulD.* FROM DLK_T_InvJulD LEFT OUTER JOIN dbo.DLK_M_Rak ON dbo.DLK_T_InvJulD.IJD_RakID = dbo.DLK_M_Rak.Rak_ID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_InvJulD.IJD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_InvJulD.IJD_Item = dbo.DLK_M_Barang.Brg_Id WHERE LEFT(dbo.DLK_T_InvJulD.IJD_IJHID,13) = '"& data("IJH_ID") &"' ORDER BY dbo.DLK_M_Barang.Brg_Nama ASC"

    set ddata = data_cmd.execute
    
    call header("Detail Prosess Outgoing")
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
#tbl1{
    width:100%;
    text-align:center;
    font-size:16px;
    margin-bottom:20px;
    font-weight: bold;
}
#tbl1 .labelId{
    color:green;
} 
#tbl2{
    width:100%;
    text-align:left;
    margin-bottom:20px;
    font-size:12px;
}
#tbl3{
    width:100%;
    text-align:left;
    margin-bottom:10px;
    border-collapse:collapse;
    font-size:12px;
}
#tbl3 > * > tr > *{
  border: 1px solid black;
  padding:5px;
}
</style>
    <div class="row gambar">
        <div class="col ">
            <img src="<%= url %>/public/img/delimalogo.png" alt="delimalogo">
        </div>
    </div>
    <table id="tbl1">
        <tr>
            <td colspan="4">
                DETAIL PROSESS OUTGOING
            </td>
        </tr>
        <tr>
            <td colspan="4" class="labelId">
                <%= data("IJH_ID") %>
            </td>
        </tr>
    </table>
    <table id="tbl2">
            <tr>
            <th>No Permintaan / B.O.M</th>
            <th>:</th>
            <td>
                <%= left(data("IJH_OJHID"),2) %>-<% call getAgen(mid(data("IJH_OJHID"),3,3),"") %>/<%= mid(data("IJH_OJHID"),6,4) %>/<%= right(data("IJH_OJHID"),4) %>
            </td>
            <th>Cabang / Agen</th>
            <th>:</th>
            <td>
                <%= data("AgenName") %>
            </td>
        </tr>
        <tr>
            <th>Tanggal</th>
            <th>:</th>
            <td>
                <%= Cdate(data("IJH_Date")) %>
            </td>
            <th>Tanggal JT</th>
            <th>:</th>
            <td>
                <%
                if Cdate(data("IJH_JTDate")) <> Cdate("1/1/1900") then 
                    response.write Cdate(data("IJH_JTDate"))
                end if
                %>

            </td>
        </tr>
        <tr>
            <th>No Produksi</th>
            <th>:</th>
            <td>
                <%= data("IJH_PDID") %>
            </td>
            <th>Kebutuhan</th>
            <th>:</th>
            <td>
                <%= kebutuhan %>
            </td>
        </tr>
    </table>
    <table id="tbl3">
        <thead>
            <tr>
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
                    <td>
                        <%= ddata("Brg_Nama") %>
                    </td>
                    <td>
                        <%= ddata("IJD_QtySatuan") %>
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
<% 
    call footer()
%>