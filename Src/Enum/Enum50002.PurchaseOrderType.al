enum 50052 "Purchase Order Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Warranty)
    {
        Caption = 'Warranty';
    }
    value(2; Exchange)
    {
        Caption = 'Exchange';
    }
    value(3; "TEMP.OUT")
    {
        Caption = 'TEMP.OUT';
    }
    value(4; Production)
    {
        Caption = 'Production';
    }
    value(5; Standard)
    {
        Caption = 'Standard';
    }
    value(6; "Standard Machine")
    {
        Caption = 'Standard Machine';
    }
    value(7; "Non-production")
    {
        Caption = 'Non-production';
    }
    value(8; "Non-trade")
    {
        Caption = 'Non-trade';
    }
}
