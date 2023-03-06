tableextension 59108 "TP Gen. Product Posting Group" extends "Gen. Product Posting Group"
{
    fields
    {
        field(50000; "Setup Lines"; Integer)
        {
            Caption = 'Setup Lines';
            FieldClass = FlowField;
            CalcFormula = count("General Posting Setup" WHERE("Gen. Prod. Posting Group" = FIELD("Code")));
        }

    }

}
