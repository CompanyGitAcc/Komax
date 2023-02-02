tableextension 59061 "TP Value Entry" extends "Value Entry"
{
    fields
    {
        field(50002; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }

        field(50003; "Add Rate"; Decimal)
        {
            Caption = 'Add Rate';
        }
        field(50004; "Vendor"; Code[20])
        {
            Caption = 'Vendor';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item Ledger Entry"."Source No." WHERE("Source Type" = FILTER(Vendor), "Entry No." = FIELD("Item Ledger Entry No.")));
        }
        field(50005; "Item Ledger Entry PostingDate"; Date)
        {
            Caption = 'Item Ledger Entry PostingDate';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item Ledger Entry"."Posting Date" WHERE("Entry No." = FIELD("Item Ledger Entry No.")));
        }
        field(50006; "Komax Reason Code"; Code[20])
        {
            Caption = 'Komax Reason Code';
            TableRelation = "Reason Code";
        }
    }
}
