tableextension 59031 "TP Sales Shipment Line" extends "Sales Shipment Line"
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
        // field(50003; "Commision (Base)"; Decimal)
        // {
        //     Caption = 'Commision (Base)';
        // }

        //==============================================================================
        //++NAV2009  说明：以下字段是从老系统迁移过来的字段，部分不再使用的字段已注释掉
        //==============================================================================      
        field(60001; "Unit of Measure Short Desc."; Code[20])
        {
            Caption = 'Unit of Measure Short Desc.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Unit of Measure"."Short Description" WHERE(Code = FIELD("Unit of Measure Code")));
        }
        field(60002; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Sell-to Customer Name" where("No." = field("Document No.")));
        }
        field(60003; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Salesperson Code" where("No." = field("Order No.")));
        }
        field(60004; "Order Type"; Enum "Sales Order Type")
        {
            Caption = 'Order Type';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Order Type" where("No." = field("Order No.")));
        }
        field(60005; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."External Document No." where("No." = field("Order No.")));
        }
        field(60006; "Posting Date 2"; Date)
        {
            Caption = 'Posting Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Posting Date" where("No." = field("Document No.")));
        }
        field(60007; "Order Date"; Date)
        {
            Caption = 'Order Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Order Date" where("No." = field("Document No.")));
        }
    }
}
