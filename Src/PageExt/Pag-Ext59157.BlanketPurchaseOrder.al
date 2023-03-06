pageextension 59157 "MP Blanket Purchase Order" extends "Blanket Purchase Order"
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
