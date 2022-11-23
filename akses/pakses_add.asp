<!--#include file="../Connections/cargo.asp"-->
<!--#include file="../url.asp"-->
<!--#include file="../functions/md5.asp"-->
<!--#include file="../functions/func_alert.asp"-->
<% 
   id = trim(Request.QueryString("id"))

   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   data_cmd.commandText = "SELECT * FROM DLK_M_WebLogin WHERE UserID = '"& id &"' AND userAktifYN = 'Y'"

   set data = data_cmd.execute

   server.Execute("../header.asp")
   response.write "<title>Form Hak Kases</title><body>"
%>
<!--#include file="../navbar.asp"-->
<style>
   ul li{
      list-style:none;
      padding:5px;
   }
   ul li input[type='checkbox']{
      margin-right:10px;
   }
   ul li:hover{
      background-color:#e9e9e9;
   }
   #ckHeaderAkses{
      background-color:#ffffe0;
   }
</style>
<div class='container'>
   <div class='row'>
      <div class='col-sm text-center mt-3'>
            <h3>DAFTAR HAKAKSES</h3>
      </div> 
   </div> 
   <div class="row">
      <div class="col-sm mb-3">
         <button type="button" class="btn btn-danger" onClick="window.location.href='index.asp'">Kembali</button>
      </div>
   </div>
   <div class="row">
      <div class="col-sm-12 mb-3">
         <div class="accordion accordion-flush" id="accordionFlushExample">
            <!-- master -->
            <div class="accordion-item">
               <h2 class="accordion-header" id="flush-1">
                  <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapse1" aria-expanded="true" aria-controls="flush-collapse1">
                  <i class="bi bi-collection" style="padding:10px"></i> Master
                  </button>
               </h2>
               <div id="flush-collapse1" class="accordion-collapse collapse" aria-labelledby="flush-1" data-bs-parent="#accordionFlushExample">
                  <div class="accordion-body">
                     <!-- barang -->
                     <ul>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M1'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M1" id="M1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M1');" >
                           <label for="M1">Barang</label>
                        </li>
                        <ul>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M1A'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M1A" id="M1A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M1A');" >
                           <label for="M1A">Tambah</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M1B'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M1B" id="M1B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M1B');" >
                           <label for="M1B">Update</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M1C'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M1C" id="M1C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M1C');" >
                           <label for="M1C">Delete</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M1D'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M1D" id="M1D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M1D');" >
                           <label for="M1D">Export</label>
                           </li>
                        </ul>
                     </ul>
                     <!-- customer -->
                     <ul>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M2'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M2" id="M2" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M2');" >
                           <label for="M2">Customers</label>
                        </li>
                        <ul>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M2A'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M2A" id="M2A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M2A');" >
                           <label for="M2A">Tambah</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M2B'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M2B" id="M2B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M2B');" >
                           <label for="M2B">Update</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M2C'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M2C" id="M2C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M2C');" >
                           <label for="M2C">Delete</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M2D'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M2D" id="M2D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M2D');" >
                           <label for="M2D">Export</label>
                           </li>
                        </ul>
                     </ul>
                     <!-- jenis -->
                     <ul>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M3'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M3" id="M3" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M3');" >
                           <label for="M3">Jenis</label>
                        </li>
                        <ul>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M3A'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M3A" id="M3A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M3A');" >
                           <label for="M3A">Tambah</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M3B'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M3B" id="M3B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M3B');" >
                           <label for="M3B">Update</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M3C'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M3C" id="M3C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M3C');" >
                           <label for="M3C">Delete</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M3D'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M3D" id="M3D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M3D');" >
                           <label for="M3D">Export</label>
                           </li>
                        </ul>
                     </ul>
                     <!-- kategori -->
                     <ul>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M4'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M4" id="M4" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M4');" >
                           <label for="M4">Kategori</label>
                        </li>
                        <ul>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M4A'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M4A" id="M4A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M4A');" >
                           <label for="M4A">Tambah</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M4B'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M4B" id="M4B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M4B');" >
                           <label for="M4B">Update</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M4C'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M4C" id="M4C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M4C');" >
                           <label for="M4C">Delete</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M4D'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M4D" id="M4D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M4D');" >
                           <label for="M4D">Export</label>
                           </li>
                        </ul>
                     </ul>
                     <!-- Rak -->
                     <ul>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M5'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M5" id="M5" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M5');" >
                           <label for="M5">Kategori</label>
                        </li>
                        <ul>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M5A'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M5A" id="M5A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M5A');" >
                           <label for="M5A">Tambah</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M5B'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M5B" id="M5B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M5B');" >
                           <label for="M5B">Update</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M5C'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M5C" id="M5C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M5C');" >
                           <label for="M5C">Delete</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M5D'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M5D" id="M5D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M5D');" >
                           <label for="M5D">Export</label>
                           </li>
                        </ul>
                     </ul>
                     <!-- satuan barang -->
                     <ul>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M6'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M6" id="M6" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M6');" >
                           <label for="M6">Satuan Barang</label>
                        </li>
                        <ul>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M6A'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M6A" id="M6A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M6A');" >
                           <label for="M6A">Tambah</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M6B'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M6B" id="M6B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M6B');" >
                           <label for="M6B">Update</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M6C'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M6C" id="M6C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M6C');" >
                           <label for="M6C">Delete</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M6D'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M6D" id="M6D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M6D');" >
                           <label for="M6D">Export</label>
                           </li>
                        </ul>
                     </ul>
                     <!-- type barang -->
                     <ul>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M7'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M7" id="M7" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M7');" >
                           <label for="M7">Type Barang</label>
                        </li>
                        <ul>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M7A'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M7A" id="M7A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M7A');" >
                           <label for="M7A">Tambah</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M7B'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M7B" id="M7B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M7B');" >
                           <label for="M7B">Update</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M7C'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M7C" id="M7C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M7C');" >
                           <label for="M7C">Delete</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M7D'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M7D" id="M7D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M7D');" >
                           <label for="M7D">Export</label>
                           </li>
                        </ul>
                     </ul>
                     <!-- vendor -->
                     <ul>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M8'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M8" id="M8" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M8');" >
                           <label for="M8">Vendors</label>
                        </li>
                        <ul>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M8A'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M8A" id="M8A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M8A');" >
                           <label for="M8A">Tambah</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M8B'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M8B" id="M8B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M8B');" >
                           <label for="M8B">Update</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M8C'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M8C" id="M8C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M8C');" >
                           <label for="M8C">Delete</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M8D'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M8D" id="M8D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M8D');" >
                           <label for="M8D">Export</label>
                           </li>
                        </ul>
                     </ul>
                     <!-- Produksi -->
                     <ul>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M9'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M9" id="M9" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M9');" >
                           <label for="M9">Produksi</label>
                        </li>
                        <ul>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M9A'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M9A" id="M9A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M9A');" >
                           <label for="M9A">Tambah</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M9B'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M9B" id="M9B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M9B');" >
                           <label for="M9B">Update</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M9C'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M9C" id="M9C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M9C');" >
                           <label for="M9C">Delete</label>
                           </li>
                           <li>
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'M9D'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="M9D" id="M9D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','M9D');" >
                           <label for="M9D">Export</label>
                           </li>
                        </ul>
                     </ul>
                  </div>
               </div>
            </div>
            <!-- inventory -->
            <div class="accordion-item">
               <h2 class="accordion-header" id="flush-2">
                  <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapse2" aria-expanded="false" aria-controls="flush-collapse2">
                  <i class="bi bi-receipt" style="padding:10px"></i> Inventory
                  </button>
               </h2>
               <div id="flush-collapse2" class="accordion-collapse collapse" aria-labelledby="flush-2" data-bs-parent="#accordionFlushExample">
                  <div class="accordion-body">Placeholder content for this accordion, which is intended to demonstrate the <code>.accordion-flush</code> class. This is the second item's accordion body. Let's imagine this being filled with some actual content.</div>
               </div>
            </div>
            <!-- purchase -->
            <div class="accordion-item">
               <h2 class="accordion-header" id="flush-3">
                  <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapse3" aria-expanded="false" aria-controls="flush-collapse3">
                  <i class="bi bi-wallet2" style="padding:10px;"></i> Purchase
                  </button>
               </h2>
               <div id="flush-collapse3" class="accordion-collapse collapse" aria-labelledby="flush-3" data-bs-parent="#accordionFlushExample">
                  <div class="accordion-body">
                     <ul>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR1'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="PR1" id="PR1" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR1');" >
                           <label for="PR1">Purchase</label>
                        </li>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR2'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="PR2" id="PR2" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR2');" >
                           <label for="PR2">Detail Purchase</label>
                        </li>
                           <ul>
                              <li>
                              <%
                              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR2A'"

                              set app = data_cmd.execute
                              %>
                              <input class="form-check-input" type="checkbox" name="PR2A" id="PR2A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR2A');" >
                              <label for="PR2A">Tambah</label>
                              </li>
                              <li>
                              <%
                              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR2B'"

                              set app = data_cmd.execute
                              %>
                              <input class="form-check-input" type="checkbox" name="PR2B" id="PR2B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR2B');" >
                              <label for="PR2B">Update</label>
                              </li>
                              <li>
                              <%
                              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR2C'"

                              set app = data_cmd.execute
                              %>
                              <input class="form-check-input" type="checkbox" name="PR2C" id="PR2C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR2C');" >
                              <label for="PR2C">Delete</label>
                              </li>
                              <li>
                              <%
                              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR2D'"

                              set app = data_cmd.execute
                              %>
                              <input class="form-check-input" type="checkbox" name="PR2D" id="PR2D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR2D');" >
                              <label for="PR2D">Export</label>
                              </li>
                           </ul>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR3'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="PR3" id="PR3" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR3');" >
                           <label for="PR3">Update Harga memo</label>
                        </li>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR4'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="PR4" id="PR4" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR4');" >
                           <label for="PR4">Faktur Terhutang</label>
                        </li>
                           <ul>
                              <li>
                              <%
                              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR4A'"

                              set app = data_cmd.execute
                              %>
                              <input class="form-check-input" type="checkbox" name="PR4A" id="PR4A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR4A');" >
                              <label for="PR4A">Tambah</label>
                              </li>
                              <li>
                              <%
                              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR4B'"

                              set app = data_cmd.execute
                              %>
                              <input class="form-check-input" type="checkbox" name="PR4B" id="PR4B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR4B');" >
                              <label for="PR4B">Update</label>
                              </li>
                              <li>
                              <%
                              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR4C'"

                              set app = data_cmd.execute
                              %>
                              <input class="form-check-input" type="checkbox" name="PR4C" id="PR4C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR4C');" >
                              <label for="PR4C">Delete</label>
                              </li>
                              <li>
                              <%
                              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR4D'"

                              set app = data_cmd.execute
                              %>
                              <input class="form-check-input" type="checkbox" name="PR4D" id="PR4D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR4D');" >
                              <label for="PR4D">Export</label>
                              </li>
                           </ul>
                        <li id="ckHeaderAkses">
                           <%
                           data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR5'"

                           set app = data_cmd.execute
                           %>
                           <input class="form-check-input" type="checkbox" name="PR5" id="PR5" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR5');" >
                           <label for="PR5">Return Barang</label>
                        </li>
                            <ul>
                              <li>
                              <%
                              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR5A'"

                              set app = data_cmd.execute
                              %>
                              <input class="form-check-input" type="checkbox" name="PR5A" id="PR5A" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR5A');" >
                              <label for="PR5A">Tambah</label>
                              </li>
                              <li>
                              <%
                              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR5B'"

                              set app = data_cmd.execute
                              %>
                              <input class="form-check-input" type="checkbox" name="PR5B" id="PR5B" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR5B');" >
                              <label for="PR5B">Update</label>
                              </li>
                              <li>
                              <%
                              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR5C'"

                              set app = data_cmd.execute
                              %>
                              <input class="form-check-input" type="checkbox" name="PR5C" id="PR5C" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR5C');" >
                              <label for="PR5C">Delete</label>
                              </li>
                              <li>
                              <%
                              data_cmd.commandText = "SELECT AppIDRights FROM DLK_M_AppRight WHERE (Username = '"& data("username") &"') AND (ServerID = '"& data("serverID") &"') and AppIDRights = 'PR5D'"

                              set app = data_cmd.execute
                              %>
                              <input class="form-check-input" type="checkbox" name="PR5D" id="PR5D" <%if app.eof = false then%> checked <%end if%> onClick="updateRights('<%=data("username")%>','<%=data("serverID")%>','PR5D');" >
                              <label for="PR5D">Export</label>
                              </li>
                           </ul>
                     </ul>
                  </div>
               </div>
            </div>
         </div>         
      </div>
   </div>
</div> 
<script>
function updateRights(u,s,p){   
   let user = u
   let serverID = s
   let app = p

   $.ajax({
      method: "post",
      url: "getApps.asp",
      data: { user, serverID, app }
   }).done(function(ms){console.log(ms);
   })
}
</script>
<% server.execute("../footer.asp") %>