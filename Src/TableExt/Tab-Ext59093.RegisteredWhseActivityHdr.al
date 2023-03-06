tableextension 59093 "TP Reg. Whse. Activity Hdr." extends "Registered Whse. Activity Hdr."
{
    fields
    {
        field(50000; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Registered Whse. Activity Line"."Source No." WHERE("Activity Type" = FIELD(Type), "No." = FIELD("No.")));
        }
    }

}
