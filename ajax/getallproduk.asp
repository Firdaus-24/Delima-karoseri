<!--#include file="../init.asp"-->
<% 
    agen = trim(Request.form("agen"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string    

    data_cmd.commandText = "SELECT dbo.DLK_M_ProductH.PDID, dbo.DLK_M_ProductH.PDBrgID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_ProductH.PDAktifYN FROM dbo.DLK_M_ProductH LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_ProductH.PDBrgID = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_ProductD ON dbo.DLK_M_ProductH.PDID = LEFT(dbo.DLK_M_ProductD.PDDPDID, 12) WHERE (dbo.DLK_M_ProductD.PDDPDID IS NOT NULL) AND (dbo.DLK_M_ProductH.PDAgenID = '"& agen &"') GROUP BY dbo.DLK_M_ProductH.PDID, dbo.DLK_M_ProductH.PDBrgID, dbo.DLK_M_Barang.Brg_Nama,dbo.DLK_M_ProductH.PDAktifYN HAVING (dbo.DLK_M_ProductH.PDAktifYN = 'Y') ORDER BY Brg_Nama"

    set produk = data_cmd.execute

%>
    <select class="form-select" aria-label="Default select example" name="produk" id="produk" required> 
        <option value="">Pilih</option>
        <% do while not produk.eof %>
            <option value="<%= produk("PDID") %>"><%= produk("Brg_Nama") %></option>
        <% 
        produk.movenext
        loop
        %>
    </select>
