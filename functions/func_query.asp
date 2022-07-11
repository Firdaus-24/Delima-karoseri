<% 
'Variable declared in the global scope will be available to any procedure
'wishing to use it.
Dim value: value = 0
sub query(e)

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = e
    data_cmd.execute

end sub
%>