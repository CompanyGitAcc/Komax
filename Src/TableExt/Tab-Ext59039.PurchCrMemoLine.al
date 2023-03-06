tableextension 59039 "TP Purch. Cr. Memo Line" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50002; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }
        field(50003; Remark; text[250])
        {
            Caption = 'Remark';
        }
        field(50004; "Unit of Measure Short Desc."; Code[20])
        {
            Caption = 'Unit of Measure Short Desc.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Unit of Measure"."Short Description" WHERE(Code = FIELD("Unit of Measure Code")));
        }
    }

}
