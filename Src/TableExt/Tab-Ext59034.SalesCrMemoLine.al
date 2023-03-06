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
        //以下为Earning Report用的字段
        field(60003; "Sales Amount"; Decimal)
        {
            Caption = 'Sales Amount';
        }
        field(60004; "Cost Of Sales"; Decimal)
        {
            Caption = 'Cost Of Sales';
        }
        field(60005; "Cost ACIE"; Decimal)
        {
            Caption = 'Cost ACIE';
        }
        field(60006; "Item Charge Amount"; Decimal)
        {
            Caption = 'Item Charge Amount';
        }
        field(60007; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
        }
    }
}
