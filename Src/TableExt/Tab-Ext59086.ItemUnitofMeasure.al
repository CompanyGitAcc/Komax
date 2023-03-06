tableextension 59086 "TP Item Unit of Measure" extends "Item Unit of Measure"
{
    fields
    {
        field(50000; "Unit of Measure Exist"; Boolean)
        {
            Caption = 'Unit of Measure Exist';
            FieldClass = FlowField;
            CalcFormula = Exist("Unit of Measure" WHERE(Code = FIELD(Code)));
        }
        field(50001; "Base Unit of Measure Exist"; Boolean)
        {
            Caption = 'Base Unit of Measure Exist';
            FieldClass = FlowField;
            CalcFormula = Exist(Item WHERE("Base Unit of Measure" = FIELD(Code), "No." = FIELD("Item No.")));
        }

    }

}
