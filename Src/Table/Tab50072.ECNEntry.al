table 50032 "ECN Record"
{
    DrillDownPageID = "ECN Record";
    LookupPageID = "ECN Record";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item;
        }
        field(3; "Substitute Item No."; Code[20])
        {
            Caption = 'Substitute Item No.';
            NotBlank = true;
            TableRelation = Item;
        }
        field(4; "Substitute Type"; Option)
        {
            Caption = 'Substitute Type';
            OptionMembers = "1:N","N:1";
        }
        field(5; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Closed';
            OptionMembers = "Open","Closed";
        }
        field(6; Inventory; Decimal)
        {
            Caption = 'Inventory';
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = FIELD("Item No.")));
        }
        field(7; "ECN Date"; Date)
        {
            Caption = 'ECN Date';
            NotBlank = true;
        }
        field(8; "New Item Inventory"; Decimal)
        {
            Caption = 'New Item Inventory';
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = FIELD("Substitute Item No.")));
        }
        field(9; "Quantity Per"; Decimal)
        {
            Caption = 'Quantity Per';
        }

        // field(9; Quantity; Decimal)
        // {
        //     Caption = 'Quantity';
        // }
        // field(10; "New Quantity"; Decimal)
        // {
        //     Caption = 'New Quantity';
        // }
    }

    keys
    {
        key(Key1; "No.", "Item No.", "Substitute Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

