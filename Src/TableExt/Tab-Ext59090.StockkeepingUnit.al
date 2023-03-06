tableextension 59090 "TP Stockkeeping Unit" extends "Stockkeeping Unit"
{
    fields
    {
        field(50000; "Qty. on Sales Order (Total)"; Decimal)
        {
            Caption = 'Qty. on Sales Order (Total)';
        }
        field(50001; "Inventory on Location"; Decimal)
        {
            Caption = 'Inventory on Location';
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Order), Type = CONST(Item), "No." = FIELD("Item No."), "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Drop Shipment" = FIELD("Drop Shipment Filter"), "Variant Code" = FIELD("Variant Code"), "Shipment Date" = FIELD("Date Filter")));
        }
        field(50002; "Rout Link"; Code[10])
        {
            Caption = 'Rout Link';
        }
        field(50003; "Gen Prod Posting Group"; Code[30])
        {
            Caption = 'Gen Prod Posting Group';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Gen. Prod. Posting Group" WHERE("No." = FIELD("Item No.")));
        }

    }

}
