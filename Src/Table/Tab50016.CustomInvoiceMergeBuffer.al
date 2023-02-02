table 50016 "Custom Invoice Merge Buffer"
{
    // #1 2012/05/30 TECTURA-CN Freddie
    //    Add a new table


    fields
    {
        field(1; "Shipment No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Shipment Header";
        }
        field(2; "Shipment Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";
        }
        field(5; "H.S.Code"; Code[20])
        {
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(7; "Net Weight"; Decimal)
        {
        }
        field(8; "Gross Weight"; Decimal)
        {
        }
        field(9; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(10; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
        }
    }

    keys
    {
        key(Key1; "Shipment No.", "Shipment Line No.")
        {
            Clustered = true;
        }
        key(Key2; "H.S.Code")
        {
        }
    }

    fieldgroups
    {
    }
}

