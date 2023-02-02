tableextension 59038 "TP Return Shipment Line" extends "Return Shipment Line"
{
    fields
    {
        field(50001; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }

        field(50002; Remark; text[250])
        {
            Caption = 'Remark';
        }
        field(50003; "Unit Of Measure Short Desc."; Code[20])
        {
            Caption = 'Unit Of Measure Short Desc.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Unit of Measure"."Short Description" WHERE(Code = FIELD("Unit of Measure Code")));
        }
    }

}
