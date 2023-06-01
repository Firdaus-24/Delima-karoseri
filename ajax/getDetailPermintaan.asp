<!--#include file="../init.asp"-->
<% 
    id = trim(Request.form("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandTExt = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, DLK_M_satuanBarang.Sat_Nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.memoItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_Memo_D.memoSatuan = DLK_M_SatuanBarang.Sat_ID WHERE memoID = '"& id &"'"
    set data = data_cmd.execute
    
  
    response.ContentType = "application/json;charset=utf-8"

    response.write "["
            response.write "{"
                response.write """MEMOID""" & ":" &  """" & data("memoID") &  """"  & ","
                    response.write """BARANGID""" & ":" &  """" & data("memoItem") &  """"  & ","
                    response.write """BARANGNAMA""" & ":" &  """" & data("Brg_Nama") &  """"  & ","
                    response.write """SPECT""" & ":" &  """" & data("memoSpect") &  """"  & ","
                    response.write """QTTY""" & ":" &  """" & data("memoQtty") &  """"  & ","
                    response.write """SATUANID""" & ":" &  """" & data("memoSatuan") &  """"  & ","
                    response.write """SATUANNAMA""" & ":" &  """" & data("Sat_Nama") &  """"  & ","
                    response.write """KETERANGAN""" & ":" &  """" & data("memoKeterangan") &  """"  & ","
                    response.write """HARGA""" & ":" &  """" & data("memoHarga") &  """"
                response.write "}"
    response.write "]"

%>