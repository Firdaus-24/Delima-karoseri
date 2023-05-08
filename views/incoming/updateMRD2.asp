<!--#include file="../../init.asp"-->
<% 
   if session("INV2B") = false then
      Response.Redirect("index.asp")
   end if

   id = trim(Request.form("id"))
   trans = trim(Request.form("trans"))
   rak = trim(Request.form("rak"))
   qty = trim(Request.form("qty"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_T_MaterialReceiptD2 WHERE MR_ID = '"& id &"' AND MR_Transaksi = '"& trans &"'"

   set data = data_cmd.execute

   if not data.eof then
      data_cmd.commandTExt = "SELECT OPD_Item, OPD_OPHID, OPD_Qtysatuan FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& left(data("MR_Transaksi"),13) &"' AND OPD_Item = '"& data("MR_item") &"'"

      set ckinvdata = data_cmd.execute

      if not ckinvdata.eof then
         if Cint(ckinvdata("OPD_Qtysatuan")) >= Cint(qty) then
            call query ("UPDATE DLK_T_MaterialReceiptD2 SET MR_Qtysatuan = "& qty &", MR_RakID = '"& rak &"', MR_transaksi = '"& ckinvdata("OPD_OPHID") &"' WHERE MR_ID = '"& id &"' AND MR_Transaksi = '"& trans &"'")
            response.write "DONE"
         else
            response.write "QTY MELEBIHI BATAS PEMBELIAN"
         end if
      else 
         response.write "DATA TIDAK TERDAFTAR DI PURCHASING"
      end if
   else
      response.write "DATA TIDAK TERDAFTAR"
   end if
%>