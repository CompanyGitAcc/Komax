tableextension 59032 "TP Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(50001; Remark; Text[250])
        {
            Caption = 'Remark';
        }
        field(50002; "Description 3"; Text[100])
        {
            Caption = 'Description 3';
        }

        //以下为Flowfield字段类型
        field(60001; "Sell-to Customer Name"; text[100])
        {
            Caption = 'Sell-to Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
        }
        field(60002; "Unit of Measure Short Desc."; Code[20])
        {
            Caption = 'Unit of Measure Short Desc.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Unit of Measure"."Short Description" WHERE(Code = FIELD("Unit of Measure Code")));
        }
        // field(50003; "Commision"; Decimal)
        // {
        //     Caption = 'Commision';
        // }
        // field(50005; "Drop Vendor No."; Code[20])
        // {
        //     Caption = 'Drop Vendor No.';
        // }
        // field(50006; "Komax Reason Code"; Code[20])
        // {
        //     Caption = 'Komax Reason Code';
        //     TableRelation = "Reason Code";
        // }
        // field(50007; "Sales Type"; Code[20])
        // {
        //     Caption = 'Sales Type';
        //     // TableRelation = "Sales Type".Code;
        // }
        // field(50008; "Sales Commision (%)"; Decimal)
        // {
        //     Caption = 'Sales Commision (%)';
        // }
    }
}
