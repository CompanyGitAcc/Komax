table 50036 "Item PLM To Nav Result"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            Description = 'KMX2009';
        }
        field(5; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            Description = 'KMX2009';
        }
        field(50000; "Base Unit Error"; Boolean)
        {
            Editable = false;
        }
        field(50001; "Base Unit Difference"; Boolean)
        {
            Editable = false;
        }
        field(50002; "Spare Part Difference"; Boolean)
        {
            Editable = false;
        }
        field(50003; "Replishment Difference"; Boolean)
        {
            Editable = false;
        }
        field(50005; "No ABC Parts"; Boolean)
        {
            Editable = false;
        }
        field(50006; "New Create Item"; Boolean)
        {
            Editable = false;
        }
        field(50007; "Posting Group Difference"; Boolean)
        {
            Editable = false;
        }
        field(50010; "Created Date"; Date)
        {
            Editable = false;
        }
        field(50011; "Created Time"; Time)
        {
            Editable = false;
        }
        field(60000; "User ID"; Code[20])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

