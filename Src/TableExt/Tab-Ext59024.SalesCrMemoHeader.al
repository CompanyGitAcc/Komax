tableextension 59024 "TP Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
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
        field(50019; "Order Type"; Enum "Sales Order Type")
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
        //     Caption = 'Navision Phantom Invoice No.s';
        //     // FieldClass = FlowField;
        //     // CalcFormula = Count("Jinsui Invoice" WHERE("Navision Doc No." = FIELD("No."), Status = CONST(Normal)));
        // }
        // field(50018; "Cancelled Invoice No.s"; Integer)
        // {
        //     Caption = 'Cancelled Invoice No.s';
        //     // FieldClass = FlowField;
        //     // CalcFormula = Count("Jinsui Invoice" WHERE("Navision Doc No." = FIELD("No."), Status = CONST(Cancelled)));
        // }
        field(50020; "Sales Commision (%)"; Decimal)
        {
            Caption = 'Sales Commision (%)';
        }
        field(50039; "Machine Model"; Code[30])
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
