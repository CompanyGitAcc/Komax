tableextension 59055 "TP Transfer Line" extends "Transfer Line"
{
    fields
    {
        field(50000; "Unit of Measure Short Desc."; Code[20])
        {
            Caption = 'Unit of Measure Short Desc.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Unit of Measure"."Short Description" WHERE(Code = FIELD("Unit of Measure Code")));
        }
    }
}
