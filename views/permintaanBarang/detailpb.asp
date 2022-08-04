<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_permintaanb.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_Memo_H WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set dataH = data_cmd.execute
    ' get satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data_cmd.execute    
%>
<% call header("Detail Permintaan Barang") %>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 mb-3 text-center">
            <h3>DETAIL PERMINTAAN BARANG</h3>
        </div>  
    </div> 
    <div class="row mb-3">
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Nomor :</label>
                </div>
                <div class="col-auto">
                    <label>
                        <b>
                            <%= left(dataH("memoID"),4) %>/<% call getKebutuhan(mid(dataH("memoId"),5,3),"") %>-<% call getAgen(mid(dataH("memoID"),8,3),"") %>/<%= mid(dataH("memoID"),11,4) %>/<%= right(dataH("memoID"),3) %>
                        </b>
                    </label>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Cabang :</label>
                </div>
                <div class="col-auto">
                    <% call getAgen(dataH("memoAgenID"),"p") %>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Hari :</label>
                </div>
                <div class="col-auto">
                    <label><%= weekdayname(weekday(dataH("memoTgl"))) %></label>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Kebutuhan :</label>
                </div>
                <div class="col-auto">
                    <label><% call getKebutuhan(dataH("memoKebID"),"P") %></label>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Tanggal :</label>
                </div>
                <div class="col-auto">
                    <label><%= Cdate(dataH("memoTgl")) %></label>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Divisi :</label>
                </div>
                <div class="col-auto">
                    <label><% call getDivisi(dataH("memoDivID")) %></label>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-6 mb-3">
            <div class="btn-group" role="group" aria-label="Basic example">
                <a href="pb_u.asp?id=<%= dataH("memoID") %>" class="btn btn-primary btn-sm">Update</a>
                <a href="p_barang.asp" class="btn btn-danger btn-sm">Kembali</a>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3">
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">No</th>
                        <th scope="col">Item</th>
                        <th scope="col">Spesification</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Satuan</th>
                        <th scope="col">Harga</th>
                        <th scope="col">Keterangan</th>
                        <th scope="col">Aktif</th>
                        <th scope="col"  class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    data_cmd.commandText = "SELECT * FROM DLK_T_Memo_D WHERE left(MemoID,17) = '"& dataH("MemoID") &"' AND memoAktifYN = 'Y' ORDER BY memoItem ASC"
                    ' response.write data_cmd.commandText
                    set dataD = data_cmd.execute

                    no = 0
                    do while not dataD.eof
                    no = no + 1
                    %>
                        <tr>
                            <th scope="row"><%= no %></th>
                            <td><%= dataD("memoItem") %></td>
                            <td><%= dataD("memoSpect") %></td>
                            <td><%= dataD("memoQtty") %></td>
                            <td><% call getSatBerat(dataD("memoSatuan")) %></td>
                            <td><%= replace(formatCurrency(dataD("memoHarga")),"$","") %></td>
                            <td><%= dataD("memoKeterangan") %></td>
                            <td>
                                <%if dataD("memoAktifYN") = "Y" then%>Aktif <% else %>Off <% end if %>
                            </td>
                            <td  class="text-center">
                                <div class="btn-group" role="group" aria-label="Basic example">
                                    <a href="#" class="btn badge text-bg-primary btnmdludpbarang" data="<%= datad("memoId") %>" data-bs-toggle="modal" data-bs-target="#mdlUdpbarang">Update</a>
                                    <a href="aktif.asp?databrg=<%= dataD("memoID") %>&id=<%= dataH("MemoID") %>" class="btn badge text-bg-danger btn-aktifdpbarang">delete</a>
                                </div>
                            </td>
                        </tr>
                    <% 
                    dataD.movenext
                    loop
                    %>
                </tbody>
            </table>
        </div>
    </div> 
</div>
<!-- Modal -->
<div class="modal fade" id="mdlUdpbarang" tabindex="-1" aria-labelledby="mdlUdpbarangLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="mdlUdpbarangLabel">UPDATE DETAIL BARANG</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
    </div>
    <form action="detailpb.asp?id=<%= id %>" method="post" id="formpbarang">
        <div class="modal-body">
            <div class="row dppermintaan">
                <div class="col-lg-12 mb-3">
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="nbrg" class="col-form-label">Nomor Order</label>
                        </div>
                        <div class="col-sm-9 mb-3">
                            <input type="text" id="nbrg" class="form-control" name="nbrg" autocomplete="off" readonly>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="dbrg" class="col-form-label">Jenis Barang</label>
                        </div>
                        <div class="col-sm-9 mb-3">
                            <input type="text" id="dbrg" class="form-control" name="dbrg" autocomplete="off" maxlength="30" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="dspect" class="col-form-label">Sepesification</label>
                        </div>
                        <div class="col-sm-9 mb-3">
                            <input type="text" id="dspect" class="form-control" name="dspect" autocomplete="off" maxlength="50" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="dqtty" class="col-form-label">Quantity</label>
                        </div>
                        <div class="col-sm-3 mb-3">
                            <input type="number" id="dqtty" class="form-control" name="dqtty" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="dharga" class="col-form-label">Harga Satuan</label>
                        </div>
                        <div class="col-sm-4 mb-3">
                            <input type="number" id="dharga" class="form-control" name="dharga" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="dsatuan" class="col-form-label">Satuan Berat</label>
                        </div>
                        <div class="col-sm-4 mb-3">
                            <select class="form-select" aria-label="Default select example" name="dsatuan" id="dsatuan" required> 
                                <option value="">Pilih</option>
                                <% do while not psatuan.eof %>
                                <option value="<%= psatuan("sat_ID") %>"><%= psatuan("sat_nama") %></option>
                                <%  
                                psatuan.movenext
                                loop
                                %>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="ket" class="col-form-label">Keterangan</label>
                        </div>
                        <div class="col-sm-9 mb-3">
                            <div class="form-floating">
                                <textarea class="form-control" placeholder="detail" id="dket" name="dket" autocomplete="off" maxlength="50"></textarea>
                                <label for="dket">Detail</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-primary">Save</button>
        </div>
    </form>
  </div>
</div>

<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call updateDPbarang()
        if value = 1 then
            call alert("PERMINTAAN BARANG", "berhasil di tambahkan", "success","detailpb.asp?id="& dataH("MemoID")) 
        elseif value = 2 then
            call alert("PERMINTAAN BARANG", "sudah terdaftar", "warning","detailpb.asp?id="& dataH("MemoID"))
        else
            value = 0
        end if
    end if
    call footer()
%>