tableextension 59034 "TP Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
{
    fields
    {

        field(50001; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }
        field(50002; "Unit of Measure Short Desc."; Code[20])
        {
            Caption = 'Unit of Measure Short Desc.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Unit of Measure"."Short Description" WHERE(Code = FIELD("Unit of Measure Code")));
        }
        field(50003; Remark; text[250])
        {
            Caption = 'Remark';
        }
        // field(50004; "Sales Type"; Code[20])
        // {
        //     Caption = 'Sales Type';
        //     // TableRelation = "Sales Type".Code;
        // }
        field(59021; "Sales Commision (%)"; Decimal)
        {
            Caption = 'Sales Commision (%)';
        }
    }
}
