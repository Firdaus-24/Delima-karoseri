<!--#include file="../init.asp"-->
<% 
    agen = trim(Request.form("agen"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string    

    data_cmd.commandText = "SELECT dbo.DLK_T_ProductH.PDID, dbo.DLK_T_ProductH.PDBrgID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_ProductH.PDAktifYN FROM dbo.DLK_T_ProductH LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_ProductH.PDBrgID = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_T_ProductD ON dbo.DLK_T_ProductH.PDID = LEFT(dbo.DLK_T_ProductD.PDDPDID, 12) WHERE (dbo.DLK_T_ProductD.PDDPDID IS NOT NULL) AND (dbo.DLK_T_ProductH.PDAgenID = '"& agen &"') GROUP BY dbo.DLK_T_ProductH.PDID, dbo.DLK_T_ProductH.PDBrgID, dbo.DLK_M_Barang.Brg_Nama,dbo.DLK_T_ProductH.PDAktifYN HAVING (dbo.DLK_T_ProductH.PDAktifYN = 'Y')"

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
