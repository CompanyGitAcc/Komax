tableextension 59088 "TP Prod. Order Line" extends "Prod. Order Line"
{
    fields
    {
        field(50000; "Sorce Line No."; Integer)
        {
            Caption = 'Sorce Line No.';
        }
        field(50001; "Sorce No."; Code[20])
        {
            Caption = 'Sorce No.';
        }
        field(50002; "Machine No."; Text[30])
        {
            Caption = 'Machine No.';
        }

    }

}
