tableextension 59070 "TP G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(50000; Any; Integer)
        {
            Caption = 'Any';
        }
        field(50001; "Value Entry Exist"; Boolean)
        {
            Caption = 'Value Entry Exist';
        }
    }

}
