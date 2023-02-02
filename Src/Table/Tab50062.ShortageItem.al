table 50062 "Shortage Item"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; Inventory; Decimal)
        {
        }
        field(5; "Need Qty"; Decimal)
        {
        }
        field(6; BinInventory; Decimal)
        {
        }
        field(7; "Shortage Qty"; Decimal)
        {
        }
        field(8; "Purch Qty"; Decimal)
        {
        }
        field(20; "ABC Parts"; Code[20])
        {
        }
        field(50001; "Flushing Method"; Option)
        {
            Caption = 'Flushing Method';
            OptionCaption = 'Manual,Forward,Backward,Pick + Forward,Pick + Backward';
            OptionMembers = Manual,Forward,Backward,"Pick + Forward","Pick + Backward";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

