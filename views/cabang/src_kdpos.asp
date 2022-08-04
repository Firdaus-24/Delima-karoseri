<!--#include file="../../init.asp"-->
<% 

    key = Request.QueryString("key")

    set kdpos =  Server.CreateObject ("ADODB.Command")
    kdpos.ActiveConnection = mm_Delima_String

    kdpos.commandText = "SELECT * FROM GLB_M_eKodepos WHERE KotaKabupaten LIKE '%"& key &"%' ORDER BY DesaKelurahan"
    set kdpos = kdpos.execute
%>
    <% if not kdpos.eof then %>
    <div class="cbKdpos">
        <table class="table table-striped">
            <thead class="bg-secondary text-light">
                <tr>
                    <th scope="col">Pilih</th>
                    <th scope="col">Kode Pos</th>
                    <th scope="col">Desa/Kelurahan</th>
                    <th scope="col">Kecamatan</th>
                    <th scope="col">Kota/Kabupaten</th>
                    <th scope="col">Propinsi</th>
                    <th scope="col">Area</th>
                </tr>
            </thead>
            <tbody>
                <% do until kdpos.eof %>
                <tr>
                    <td>
                        <button type="button" class="btn btn-outline-primary btnCbKdpos" style="--bs-btn-padding-y: .20rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .70rem;" id="btnCbKdpos" value="<%= kdpos("kodepos") %>">
                            Pilih
                        </button>
                    </td>
                    <th><%= kdpos("KodePos") %></th>
                    <td><%= kdpos("DesaKelurahan") %></td>
                    <td><%= kdpos("KecamatanDistrik") %></td>
                    <td><%= kdpos("KotaKabupaten") %></td>
                    <td><%= kdpos("Propinsi") %></td>
                    <td><%= kdpos("Area") %></td>
                </tr>
                <% 
                kdpos.movenext
                loop
                %>
            </tbody>
        </table>
    </div>
    <% else %>
        <div class="msgKdpos text-center text-danger">
            <h5>DATA TIDAK DI TEMUKAN</h5>
        </div>
    <% end if %>