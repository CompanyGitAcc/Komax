tableextension 59110 "TP Whse. Pick Request" extends "Whse. Pick Request"
{
    fields
    {
        field(50000; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Shipment Line"."Source No." where("No." = field("Document No.")));
        }

    }

}
