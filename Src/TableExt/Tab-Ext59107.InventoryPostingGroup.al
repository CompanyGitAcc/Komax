tableextension 59107 "TP Inventory Posting Group" extends "Inventory Posting Group"
{
    fields
    {
        field(50000; "Setup Lines"; Integer)
        {
            Caption = 'Setup Lines';
            FieldClass = FlowField;
            CalcFormula = count("Inventory Posting Setup" WHERE("Invt. Posting Group Code" = FIELD("Code")));
        }

    }

}
