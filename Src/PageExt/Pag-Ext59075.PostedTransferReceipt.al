pageextension 59075 "TP Posted Transfer Receipt" extends "Posted Transfer Receipt"
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
            field("TS No."; Rec."TS No.")
            {
                ApplicationArea = all;
            }
        }
    }
    var
        TPUtilities: Codeunit "TP Utilities";
}
