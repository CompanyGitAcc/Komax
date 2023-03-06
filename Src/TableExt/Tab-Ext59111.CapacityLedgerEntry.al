tableextension 59111 "TP Capacity Ledger Entry" extends "Capacity Ledger Entry"
{
    fields
    {
        field(50000; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Inventory Posting Group" WHERE("No." = FIELD("Item No.")));
        }

    }

}
