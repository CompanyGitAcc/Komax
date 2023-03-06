pageextension 59024 "TP Sales Return Order" extends "Sales Return Order"
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
        modify("External Document No.")
        {
            ShowMandatory = true;
            Importance = Promoted;
        }
    }

    var
        TPUtilities: Codeunit "TP Utilities";
}
