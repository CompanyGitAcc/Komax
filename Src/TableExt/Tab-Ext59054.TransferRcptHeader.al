tableextension 59054 "TP Transfer Receipt Header" extends "Transfer Receipt Header"
{
    fields
    {
        // field(50000; "Prepared By"; text[100])
        // {
        //     Caption = 'Prepared By';
        //     TableRelation = Employee;
        // }
        field(50001; "TS No."; Code[20])
        {
            Caption = 'TS No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Transfer Shipment Header"."No." WHERE("Transfer Order No." = FIELD("Transfer Order No.")));
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