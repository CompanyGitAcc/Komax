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
        field(50007; "Order Type"; Enum "Sales Order Type")
        {
            Caption = 'Order Type';
        }
        field(50008; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
    }
}
