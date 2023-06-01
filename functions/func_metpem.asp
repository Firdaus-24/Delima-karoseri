<% 
sub getmetpem(p)
    if p = 1 then
        response.write "Transfer"
    elseIf p = 2 then
        response.write "Cash"
    else
        response.write "PayLater"
    end if
end sub
%>