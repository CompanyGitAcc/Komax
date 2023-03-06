table 50011 "BOM PLM To Nav Result"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.';
            NotBlank = true;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Version Code"; Code[20])
        {
            Caption = 'Version Code';
        }
        field(5; "BOM Index"; Code[10])
        {
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item,Production BOM';
            OptionMembers = " ",Item,"Production BOM";
        }
        field(11; "Item No"; Code[20])
        {
        }
        field(12; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(13; Description2; Text[80])
        {
        }
        field(14; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(16; Position; Code[10])
        {
            Caption = 'Position';
        }
        field(10000; "BOM Base Error"; Boolean)
        {
            Editable = false;
        }
        field(10001; "Item Base Error"; Boolean)
        {
            Editable = false;
        }
        field(10002; "New BOM"; Boolean)
        {
            Editable = false;
        }
        field(10003; Deleted; Boolean)
        {
            Editable = false;
        }
        field(10004; Inserted; Boolean)
        {
            Editable = false;
        }
        field(20000; "Create Date"; Date)
        {
            Editable = false;
        }
        field(20001; "Create Time"; Time)
        {
            Editable = false;
        }
        field(60000; "User ID"; Code[50])
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

