tableextension 59084 "TP Item Application Entry" extends "Item Application Entry"
{
    fields
    {
        field(50000; "Exist Ledger Entry"; Boolean)
        {
            Caption = 'Exist Ledger Entry';
            FieldClass = FlowField;
            CalcFormula = Exist("Item Ledger Entry" WHERE("Entry No." = FIELD("Item Ledger Entry No.")));
        }

    }

}
