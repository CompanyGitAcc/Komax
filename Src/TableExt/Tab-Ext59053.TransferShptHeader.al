tableextension 59053 "TP Transfer Shipment Header" extends "Transfer Shipment Header"
{
    fields
    {
        // field(50000; "Prepared By"; text[100])
        // {
        //     Caption = 'Prepared By';
        //     TableRelation = Employee;
        // }
        field(50001; "TR No"; Code[20])
        {
            Caption = 'TR No';
            FieldClass = FlowField;
            CalcFormula = Lookup("Transfer Receipt Header"."No." WHERE("Transfer Order No." = FIELD("Transfer Order No.")));
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