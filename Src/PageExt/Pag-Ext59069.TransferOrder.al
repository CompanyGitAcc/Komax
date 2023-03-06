pageextension 59069 "TP Transfer Order" extends "Transfer Order"
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
            field(TransferStatus; Rec.TransferStatus)
            {
                ApplicationArea = all;
            }
        }
    }
    var
        TPUtilities: Codeunit "TP Utilities";
}
