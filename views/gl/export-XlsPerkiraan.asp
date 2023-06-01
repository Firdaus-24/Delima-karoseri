<!--#include file="../../init.asp"-->
<% 
   Response.ContentType = "application/vnd.ms-excel"
   Response.AddHeader "content-disposition", "filename=kode akun.xls"

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.CommandText = "SELECT GL_M_ChartAccount.*, DLK_M_WebLogin.username FROM GL_M_ChartAccount LEFT OUTER JOIN DLK_M_WebLogin ON GL_M_ChartAccount.CA_UpdateID = DLK_M_WebLogin.userID WHERE CA_AktifYN = 'Y' ORDER BY CA_ID ASC"

   set data = data_cmd.execute
%>
<div class="row">
   <div class="col-lg-12">
      <table class="table">
            <thead class="bg-secondary text-light">
               <tr>
                  <th scope="col">KODE AKUN</th>
                  <th scope="col">KETERANGAN</th>
                  <th scope="col">KODE UP AKUN</th>
                  <th scope="col">JENIS</th>
                  <th scope="col">TIPE</th>
                  <th scope="col">GOLONGAN</th>
                  <th scope="col">KELOMPOK</th>
                  <th scope="col">AKTIF</th>
               </tr>
            </thead>
            <tbody>
               <% 'prints records in the table
               Do While not data.eof %>
               <tr>
                  <th scope="row"><%= data("CA_ID") %></th>
                  <td><%= data("CA_name") %></td>
                  <td><%= data("CA_UPID") %></td>
                  <td><%= data("CA_Jenis") %></td>
                  <td><%= data("CA_Type") %></td>
                  <td>
                     <% if data("CA_GOlongan") = "N" then %>
                        Neraca
                     <% else %>
                        LabaRugi 
                     <% end if %>
                  </td>
                  <td><%= data("CA_Kelompok") %></td>
                  <td>
                     <% if data("CA_AktifYN") = "Y" then %>
                        Aktif
                     <% else %>
                        No 
                     <% end if %>
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