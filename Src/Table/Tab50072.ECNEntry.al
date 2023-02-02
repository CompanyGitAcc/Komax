table 50072 "ECN Record"
{
    DrillDownPageID = "ECN Record";
    LookupPageID = "ECN Record";

    fields
    {
        field(1; "Record No."; Code[20])
        {
            Caption = 'Entry No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(3; "New Item No."; Code[20])
        {
            Caption = 'New Item No.';
            TableRelation = Item;
        }
        field(4; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Closed';
            OptionMembers = "Open","Closed";
        }
        field(5; Inventory; Decimal)
        {
            Caption = 'Inventory';
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = FIELD("Item No.")));
        }
        field(6; "ECN Date"; Date)
        {
            Caption = 'ECN Date';
        }
        field(7; "New Item Inventory"; Decimal)
        {
            Caption = 'New Item Inventory';
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = FIELD("New Item No.")));
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(9; "New Quantity"; Decimal)
        {
            Caption = 'New Quantity';
        }
    }

    keys
    {
        key(Key1; "Record No.", "Item No.", "New Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

