tableextension 59089 "TP Prod. Order Component" extends "Prod. Order Component"
{
    fields
    {
        field(50000; "Scrap Quantity"; Decimal)
        {
            Caption = 'Scrap Quantity';
        }
        field(50001; "Stock"; Decimal)
        {
            Caption = 'Stock';
            FieldClass = FlowField;
            CalcFormula = Sum("Warehouse Entry".Quantity WHERE("Item No." = FIELD("Item No."), "Location Code" = FIELD("Location Code"), "Bin Code" = field("Bin Code")));
        }
        field(50002; "Shelf No."; Code[20])
        {
            Caption = 'Shelf No.';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Shelf No." WHERE("No." = FIELD("Item No.")));
        }
        field(50003; "Rout Link"; Code[10])
        {
            Caption = 'Rout Link';
        }
        field(50004; "Gen Prod Posting Group"; Code[20])
        {
            Caption = 'Gen Prod Posting Group';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Gen. Prod. Posting Group" WHERE("No." = FIELD("Item No.")));
        }
        field(50005; "Trolley No."; Code[20])
        {
            Caption = 'Trolley No.';
        }

    }

    keys
    {
        key(Key12; "Trolley No.")
        {
        }
    }

}
