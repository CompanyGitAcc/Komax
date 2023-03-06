tableextension 59071 "TP Accounting Period" extends "Accounting Period"
{
    fields
    {
        field(50000; "Work Days"; Decimal)
        {
            Caption = 'Work Days';
        }
        field(50001; "Accounting Period Code"; Code[10])
        {
            Caption = 'Accounting Period Code';
        }
    }

}
