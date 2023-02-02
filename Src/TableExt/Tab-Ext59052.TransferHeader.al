tableextension 59052 "TP Transfer Header" extends "Transfer Header"
{
    fields
    {
        // field(50000; "Prepared By"; text[100])
        // {
        //     Caption = 'Prepared By';
        //     TableRelation = Employee;
        // }
        field(50001; "TransferStatus"; Option)
        {
            Caption = 'TransferStatus';
            OptionCaption = 'Start,Shipment,Pick,RegisterPick,PostShipment,Receipt,PutAway,RegisterPutAway';
            OptionMembers = "Start","Shipment","Pick","RegisterPick","PostShipment","Receipt","PutAway","RegisterPutAway";
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
