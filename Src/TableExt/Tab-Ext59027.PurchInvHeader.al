tableextension 59027 "TP Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        // field(50003; "Prepared By"; text[100])
        // {
        //     Caption = 'Prepared By';
        //     TableRelation = Employee;
        // }
        //==============================================================================
        //++NAV2009  说明：以下字段是从老系统迁移过来的字段，部分不再使用的字段已注释掉
        //==============================================================================             
        field(50004; "Order Type"; Enum "Purchase Order Type")
        {
            Caption = 'Order Type';
        }
        // field(50005; "JinShui Invoice No."; Code[20])
        // {
        //     Caption = 'PJinShui Invoice No.';
        // }
        field(50005; "PO No."; Code[20])
        {
            Caption = 'PO No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Line"."Order No." where("Document No." = field("No."), "Order No." = filter(<> '')));
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
