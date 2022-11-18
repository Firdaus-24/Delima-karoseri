<!--#include file="../../init.asp"-->
<% 

   response.buffer=false
   server.ScriptTimeout=3000000

   rid = trim(Request.querystring("rid")) 'untuk id header return
   pid = trim(Request.querystring("pid")) 'untuk id barang 

   set data_cmd =  Server.CreateObject("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string 
   ' cek header return barang
   data_cmd.commandText = "SELECT * FROM DLK_T_ReturnBarangH WHERE RB_ID = '"& rid &"' AND RB_AktifYN = 'Y'"
   ' response.write data_cmd.commandText & "<br>"
   set returnH = data_cmd.execute

   response.ContentType = "application/json;charset=utf-8"
   if not returnH.eof then
      ' cek data pembelian
      data_cmd.commandText = "SELECT DLK_T_InvPemD.*, DLK_T_InvPemH.IPH_agenID, DLK_T_InvPemH.IPH_VenID, DLK_T_InvPemH.IPH_PPN, DLK_T_InvPemH.IPH_DiskonAll FROM DLK_T_InvPemD LEFT OUTER JOIN DLK_T_InvPemH ON LEFT(DLK_T_InvPemD.IPD_IPHID,13) = DLK_T_InvPemH.IPH_ID WHERE IPD_IPHID = '"& pid &"' AND DLK_T_InvPemH.IPH_venID = '"& returnH("RB_Venid") &"' AND IPH_AktifYN = 'Y'"
      ' response.write data_cmd.commandText & "<br>"
      set fakturID = data_cmd.execute

      if not fakturID.eof then
         ' cek detail return
         data_cmd.commandText = "SELECT * FROM DLK_T_ReturnBarangD WHERE LEFT(RBD_RBID,12) = '"& returnH("RB_ID") &"' AND RBD_IPDIPHID = '"& fakturID("IPD_IPHID") &"'"

         set returnD = data_cmd.execute

         if not returnD.eof then
           call query ("UPDATE DLK_T_ReturnBarangD SET RBD_QtySatuan = RBD_Qtysatuan + 1 WHERE RBD_RBID = '"& returnD("RBD_RBID") &"'")

               response.write "["
                  response.write "{"
                     response.write """DONE""" & ":" & """DATA BERHASIL TERSIMPAN"""
                  response.write "}"
               response.write "]"
         else
            ' get id detail + 1
            data_cmd.commandText = "SELECT (Right('00' + Convert(varchar,Convert(int,(Right(isnull(Max(RBD_RBID),'00'),2)))+1),2)) as ID FROM DLK_T_ReturnBarangD WHERE LEFT(RBD_RBID,12) = '"& returnH("RB_ID") &"'"

            set detailID = data_cmd.execute

            strid = detailID("ID")
            call query ("INSERT INTO DLK_T_ReturnBarangD (RBD_RBID,RBD_IPDIPHID,RBD_Item,RBD_Qtysatuan,RBD_Harga,RBD_JenisSat,RBD_PPN,RBD_Disc1,RBD_Disc2) VALUES ('"& returnH("RB_ID") & strid &"', '"& fakturID("IPD_IPHID") &"', '"& fakturID("IPD_Item") &"', 1, '"& fakturID("IPD_Harga") &"', '"& fakturID("IPD_JenisSat") &"', "& fakturID("IPH_PPN") &", "& fakturID("IPD_Disc1") &", "& fakturID("IPD_Disc2") &")")
            
               response.write "["
                  response.write "{"
                     response.write """DONE""" & ":" & """DATA BERHASIL TERSIMPAN"""
                  response.write "}"
               response.write "]"
         end if
      else
            response.write "["
               response.write "{"
                  response.write """ERORR""" & ":" & """BARANG TIDAK SESUAI VENDOR"""
               response.write "}"
            response.write "]"
      end if
   else 
      response.write "["
         response.write "{"
            response.write """ERORR""" & ":" & """NO TRANSAKSI TIDAK TERDAFTAR"""
         response.write "}"
      response.write "]"

   end if
%>