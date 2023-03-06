pageextension 59063 "TP Posted Return Shipment" extends "Posted Return Shipment"
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
