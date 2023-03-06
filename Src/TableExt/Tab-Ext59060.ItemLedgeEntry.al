tableextension 59060 "TP Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        field(50002; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }
        // field(50007; "Prepared By"; Text[100])
        // {
        //     Caption = 'Prepared By';
        // }
        field(50008; "Komax Reason Code"; Code[20])
        {
            Caption = 'Komax Reason Code';
            TableRelation = "Reason Code";
        }
        field(50009; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
        }
        field(50010; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
        }
    }
}
