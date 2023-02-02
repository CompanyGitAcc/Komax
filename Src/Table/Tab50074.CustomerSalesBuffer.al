table 50074 "Customer Item Sales Buffer"
{
    // DrillDownPageID = "Customer Sales Buffer";
    // LookupPageID = "Customer Sales Buffer";

    fields
    {
        field(1; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(2; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(6; "Sales Amount"; Decimal)
        {
            Caption = 'Sales Amount';
        }
        field(7; "Invoiced Quantity"; Decimal)
        {
            Caption = 'Invoiced Quantity';
        }
        field(8; "External Document No."; Text[50])
        {
            Caption = 'External Document No.';
        }
        field(9; "Document Type"; enum "Sales Order Type")
        {
            Caption = 'Document Type';
        }
        field(10; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer Code")));
        }
        field(11; "Golden Tax Invoice No."; Code[20])
        {
            Caption = 'Golden Tax Invoice No.';
        }
        field(12; Description; Text[100])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
        }
        field(13; "Machine Model"; Code[20])
        {
            Caption = 'Machine Model';
            TableRelation = "Machine Model";
        }
    }

    keys
    {
        key(Key1; "Customer Code", "Document No.", "Item No.")
        {
            Clustered = true;
        }
    }


}

