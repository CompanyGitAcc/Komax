tableextension 59094 "TP Warehouse Journal Line" extends "Warehouse Journal Line"
{
    fields
    {
        field(50000; "Shelf No"; Code[20])
        {
            Caption = 'Shelf No';
        }
        field(50001; "Replenishment System"; Enum "Replenishment System")
        {
            Caption = 'Replenishment System';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Replenishment System" WHERE("No." = FIELD("Item No.")));
        }
    }

}
