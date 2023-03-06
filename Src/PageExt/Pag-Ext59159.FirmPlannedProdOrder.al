pageextension 59159 "MP Firm Planned Prod. Order" extends "Firm Planned Prod. Order"
{
    layout
    {
        addlast(General)
        {
            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
            }
        }
    }
    var
        TPUtilities: Codeunit "TP Utilities";
}
