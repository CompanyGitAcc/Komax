pageextension 59054 "TP Purchase Credit Memo" extends "Purchase Credit Memo"
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
