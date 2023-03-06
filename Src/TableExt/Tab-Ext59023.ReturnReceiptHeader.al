tableextension 59023 "TP Return Receipt Header" extends "Return Receipt Header"
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
    }
    procedure GetCreatedByName(): Code[50]
    var
        User: Record User;
    begin
        If User.Get(Rec.SystemCreatedBy) Then
            exit(User."User Name");
    end;
}
