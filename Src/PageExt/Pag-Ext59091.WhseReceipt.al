pageextension 59091 "TP Warehouse Receipt" extends "Warehouse Receipt"
{
    layout
    {
        addlast(General)
        {
            field(Barcode; Rec.Barcode)
            { ApplicationArea = all; }
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

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        WarehouseSetup: Record "Warehouse Setup";
    begin
        WarehouseSetup.get();

    end;

    var
        TPUtilities: Codeunit "TP Utilities";

}
