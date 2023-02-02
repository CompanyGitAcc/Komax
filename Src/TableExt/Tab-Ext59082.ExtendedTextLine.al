tableextension 59082 "TP Extended Text Line" extends "Extended Text Line"
{
    fields
    {
        field(50000; "Sheet"; Text[30])
        {
            Caption = 'Sheet';
        }
        field(50001; "Index"; Code[20])
        {
            Caption = 'Index';
        }
        field(50002; "Apply To Order"; Boolean)
        {
            Caption = 'Apply To Order';
        }
    }

}
