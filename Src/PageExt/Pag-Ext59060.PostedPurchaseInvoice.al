pageextension 59060 "TP Posted Purchase Invoice" extends "Posted Purchase Invoice"
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
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        moveafter(IncomingDocument; Navigate)
    }

    var
        TPUtilities: Codeunit "TP Utilities";
}
