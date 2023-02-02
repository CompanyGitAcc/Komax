tableextension 59022 "TP Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {

        field(50000; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }
        // field(50014; "Prepared By"; text[100])
        // {
        //     Caption = 'Prepared By';
        //     TableRelation = Employee;
        // }

        //==============================================================================
        //++NAV2009  说明：以下字段是从老系统迁移过来的字段，部分不再使用的字段已注释掉
        //==============================================================================
        field(50015; "Order Type"; Enum "Sales Order Type")
        {
            Caption = 'Order Type';
        }
        // field(50016; "Jinsui Invoice No.s"; Integer)
        // {
        //     Caption = 'Jinsui Invoice No.s';
        //     // FieldClass = FlowField;
        //     // CalcFormula = Count("Jinsui Invoice" WHERE("Navision Doc No." = FIELD("No."), Status = CONST(Normal), "Jinsui Invoice No." = FILTER(<> '')));
        // }
        // field(50017; "Navision Phantom Invoice No.s"; Integer)
        // {
        //     Caption = 'Jinsui Invoice No.s';
        //     // FieldClass = FlowField;
        //     // CalcFormula = Count("Jinsui Invoice" WHERE("Navision Doc No." = FIELD("No."), Status = CONST(Normal)))
        // }
        // field(50018; "Cancelled Invoice No.s"; Integer)
        // {
        //     Caption = 'Cancelled Invoice No.s';
        //     // FieldClass = FlowField;
        //     // CalcFormula = Count("Jinsui Invoice" WHERE("Navision Doc No." = FIELD("No."), Status = CONST(Cancelled)))
        // }
        field(50019; "Bill-to Department"; Option)
        {
            Caption = 'Bill-to Department';
            OptionCaption = ' ,Finance Dept.,Warehouse,Purchase Dept.';
            OptionMembers = " ","Finance Dept.","Warehouse","Purchase Dept.";
        }
        field(50020; "Commision Paid"; Boolean)
        {
            Caption = 'Commision Paid';
            // FieldClass = FlowField;
            // CalcFormula = Exist("Commsion Payment Status" WHERE("Sales Inv. No." = FIELD("No.")))
        }
        field(50021; "Sales Type"; Code[20])
        {
            Caption = 'Sales Type';
            // TableRelation = "Sales Type".Code;
        }
        field(50022; "Sales Commision (%)"; Decimal)
        {
            Caption = 'Sales Commision (%)';
        }
        // field(50023; "Jinsui Invoice No."; Code[20])
        // {
        //     Caption = 'Jinsui Invoice No.';
        //     // FieldClass = FlowField;
        //     // CalcFormula = Lookup("Jinsui Invoice"."Jinsui Invoice No." WHERE("Navision Doc No." = FIELD("No."), Status = CONST(Normal), "Jinsui Invoice No." = FILTER(<> '')))
        // }
        field(50024; "Machine Model"; Code[30])
        {
            Caption = 'Machine Model';
            // TableRelation = "Machine Model";
        }
    }

    procedure GetCreatedByName(): Code[50]
    var
        User: Record User;
    begin
        If User.Get(Rec.SystemCreatedBy) Then
            exit(User."User Name");
    end;
}
