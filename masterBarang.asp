<!--#include file="Connections/cargo.asp"-->
<!--#include file="functions/func_template.asp"-->
<% 
    set data =  Server.CreateObject ("ADODB.Command")
    data.ActiveConnection =  mm_delima_string

    data.commandText = "SELECT * FROM DLK_M_Barang"
    set barang = data.execute
    call header("master barang")
%>
<!--#include file="navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg">
            <h3>MASTER BARANG</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table">
                <thead>
                    <tr>
                    <th scope="col">No</th>
                    <th scope="col">First</th>
                    <th scope="col">Last</th>
                    <th scope="col">Handle</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                    <th scope="row">1</th>
                    <td>Mark</td>
                    <td>Otto</td>
                    <td>@mdo</td>
                    </tr>
                    <tr>
                    <th scope="row">2</th>
                    <td>Jacob</td>
                    <td>Thornton</td>
                    <td>@fat</td>
                    </tr>
                    <tr>
                    <th scope="row">3</th>
                    <td colspan="2">Larry the Bird</td>
                    <td>@twitter</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</div>
<% call footer() %>