tableextension 59021 "TP Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        //==============================================================================
        //++NAV2009  说明：以下字段是从老系统迁移过来的字段，部分不再使用的字段已注释掉
        //==============================================================================
        field(50019; "Order Type"; Enum "Sales Order Type")
        {
            Caption = 'Order Type';
        }
        field(50035; Remark; text[60])
        {
            Caption = 'Remark';
        }
        field(50032; "Ship-to Phone No."; Text[100])
        {
            Caption = 'Ship-to Phone No.';
        }

        field(60001; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Assigned User ID" where("No." = field("Order No.")));
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
