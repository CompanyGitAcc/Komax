enum 50053 "Sales Document Status 2"
{
    Extensible = true;

    value(4; " ")
    {
        Caption = ' ';
    }
    value(0; Open) { Caption = 'Open'; }
    value(1; Released) { Caption = 'Released'; }
    value(2; "Pending Approval") { Caption = 'Pending Approval'; }
    value(3; "Pending Prepayment") { Caption = 'Pending Prepayment'; }
}
