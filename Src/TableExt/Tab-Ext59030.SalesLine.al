tableextension 59030 "TP Sales Line" extends "Sales Line"
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
        //++期初：标记导入已发货未开票的数据
        // field(59029; "Post Qty"; Decimal)
        // {
        //     Caption = 'Post Qty';
        // }

        //以下字段待确定是否使用
        // field(50004; "Commision(Base)"; Decimal)
        // {
        //     Caption = 'Commision(Base)';
        // }
        field(50005; "Machine No."; Text[30])
        {
            Caption = 'Machine No.';
        }
        // field(59016; "BOM Version"; Text[20])
        // {
        //     Caption = 'BOM Version';
        // }
        // field(59017; "Line Count"; Integer)
        // {
        //     Caption = 'Line Count';
        // }
        // field(59018; "Order Qty"; Decimal)
        // {
        //     Caption = 'Order Qty';
        // }
        // field(59019; "Komax Reason Code"; Code[20])
        // {
        //     Caption = 'Komax Reason Code';
        //     TableRelation = "Return Reason";
        // }
        // field(59020; "Sales Type"; Code[20])
        // {
        //     Caption = 'Sales Type';
        // }
        field(59021; "Sales Commision (%)"; Decimal)
        {
            Caption = 'Sales Commision (%)';
        }
        // field(59022; "Sales Order No"; Code[20])
        // {
        //     Caption = 'Sales Order No';
        // }


        //以下都是Flowfield字段
        field(59026; "Temp Out"; Boolean)
        {
            Caption = 'Temp Out';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Temp Out" where("Document Type" = const(Quote), "No." = field("Document No.")));
        }
        field(59027; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Sell-to Customer Name" where("Document Type" = const(Quote), "No." = field("Document No.")));
        }
        field(59028; "Salesperson Code - Quote"; Code[20])
        {
            Caption = 'Salesperson Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Salesperson Code" where("Document Type" = const(Quote), "No." = field("Document No.")));
        }
        field(59023; "External Document No."; Text[100])
        {
            Caption = 'External Document No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."External Document No." where("Document Type" = const(Quote), "No." = field("Document No.")));
        }
        field(59024; "Document Date"; Date)
        {
            Caption = 'Document Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Document Date" where("Document Type" = const(Quote), "No." = field("Document No.")));
        }
        field(59025; "Your Reference"; Text[100])
        {
            Caption = 'Your Reference';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Your Reference" where("Document Type" = const(Quote), "No." = field("Document No.")));
        }
        //==============================================================================
        //++NAV2009  说明：以下字段是从老系统迁移过来的字段，部分不再使用的字段已注释掉
        //==============================================================================             
        field(59002; OrderStatus; Enum "Sales Document Status")
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header".Status where("Document Type" = const(Order), "No." = field("Document No.")));
        }
        field(59005; "Order Date"; Date)
        {
            Caption = 'Order Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Order Date" where("Document Type" = const(Order), "No." = field("Document No.")));
        }
        field(59006; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Salesperson Code" where("Document Type" = const(Order), "No." = field("Document No.")));
        }
        field(59007; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Sell-to Customer Name" where("Document Type" = const(Order), "No." = field("Document No.")));
        }
        field(59031; "Sell-to Customer Name 2"; Text[100])
        {
            Caption = 'Sell-to Customer Name 2';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Sell-to Customer Name 2" where("Document Type" = const(Order), "No." = field("Document No.")));
        }
        field(59032; "Order Type"; Enum "Sales Order Type")
        {
            Caption = 'Order Type';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Order Type" where("Document Type" = const(Order), "No." = field("Document No.")));
        }
        field(59033; "Machine Model"; Code[30])
        {
            Caption = 'Machine Model';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Machine Model" where("Document Type" = const(Order), "No." = field("Document No.")));
        }

        field(59009; "Unit of Measure Short Desc."; Code[20])
        {
            Caption = 'Unit of Measure Short Desc.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Unit of Measure"."Short Description" WHERE(Code = FIELD("Unit of Measure Code")));
        }
        field(59014; "Inventory"; Decimal)
        {
            Caption = 'Inventory';
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."), "Location Code" = field("Location Code")));
        }
        field(50031; "Posted Sales Inv. No."; Code[20])
        {
            Caption = 'Posted Sales Inv. No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Line"."Document No." where("Order No." = field("Document No."), "Order Line No." = field("Line No.")));
        }
        field(59034; "Sales Person"; Code[20])
        {
            Caption = 'Sales Person';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Sales Person" where("Document Type" = const(Order), "No." = field("Document No.")));
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                if Item.get(Rec."No.") then begin
                    "Description 3" := Item."Description 3";
                end;
            end;
        }
    }

    keys
    {
        key(Key30; "Document No.")
        {
        }
    }

}
